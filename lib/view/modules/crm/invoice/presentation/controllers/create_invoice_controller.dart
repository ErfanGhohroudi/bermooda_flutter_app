import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../data/data.dart';
import '../../data/repositories/invoice_repository_impl.dart';
import '../../domain/usecases/get_invoice_code.dart';
import '../../domain/usecases/create_invoice.dart';
import '../../domain/entities/invoice.dart';

class CreateInvoiceController extends GetxController {
  CreateInvoiceController({required this.customerId});

  final int customerId;
  final InvoiceRepositoryImpl _repository = InvoiceRepositoryImpl();
  final DropdownDatasource _dropdownDatasource = Get.find<DropdownDatasource>();
  final CustomerDatasource _customerDatasource = Get.find<CustomerDatasource>();
  final WorkspaceDatasource _workspaceDatasource = Get.find<WorkspaceDatasource>();
  final Core _core = Get.find<Core>();

  late final GetInvoiceCodeUseCase _getInvoiceCodeUseCase = GetInvoiceCodeUseCase(_repository);
  late final CreateInvoiceUseCase _createInvoiceUseCase = CreateInvoiceUseCase(_repository);

  final Rx<PageState> pageState = PageState.initial.obs;
  final RxString invoiceCode = ''.obs;
  final RxBool isLoading = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> step1FormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> step2FormKey = GlobalKey<FormState>();

  // Stepper
  final RxInt currentStep = 0.obs;
  final steps = ['اطلاعات خریدار و فروشنده', 'اطلاعات فاکتور', 'پیش‌نمایش'];

  // Form fields - Step 1: Buyer Information
  final TextEditingController buyerNameController = TextEditingController();
  final TextEditingController buyerPhoneController = TextEditingController();
  final TextEditingController buyerAddressController = TextEditingController();
  Jalali? createdDate;
  Jalali? validityDate;
  final Rxn<DropdownItemReadDto> selectedState = Rxn<DropdownItemReadDto>(null);
  final Rxn<DropdownItemReadDto> selectedCity = Rxn<DropdownItemReadDto>(null);

  // State/City management
  final Rx<PageState> statesState = PageState.loaded.obs;
  final Rx<PageState> citiesState = PageState.loaded.obs;
  final RxList<DropdownItemReadDto> states = <DropdownItemReadDto>[].obs;
  final RxList<DropdownItemReadDto> cities = <DropdownItemReadDto>[].obs;

  // Seller Information (from workspace)
  final Rx<WorkspaceInfoReadDto?> workspaceInfo = Rxn<WorkspaceInfoReadDto?>(null);
  final Rx<PageState> workspaceInfoState = PageState.initial.obs;

  // Form fields - Step 2: Invoice Details
  final TextEditingController invoiceCodeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController taxesController = TextEditingController();
  final TextEditingController shippingCostController = TextEditingController();
  final TextEditingController interestPercentageController = TextEditingController();

  final Rxn<InvoiceType> selectedInvoiceType = Rxn<InvoiceType>(null);
  final Rxn<PaymentType> selectedPaymentType = Rxn<PaymentType>(null);
  final RxList<InvoiceProduct> products = <InvoiceProduct>[].obs;
  final RxInt expandedProductIndex = (-1).obs;

  // Installment fields
  int installmentCount = 1;
  Jalali? installmentStartDate;
  int installmentPeriod = 10; // 10, 20, or 30 days
  final RxList<Map<String, dynamic>> installmentPayments = <Map<String, dynamic>>[].obs;

  // Dates
  Jalali? dateToPay;

  @override
  void onInit() {
    super.onInit();
    createdDate = Jalali.now();
    loadInvoiceCode();
    loadStates();
    loadCustomerInfo();
    loadWorkspaceInfo();
  }

  @override
  void onClose() {
    pageState.close();
    invoiceCode.close();
    isLoading.close();
    currentStep.close();
    statesState.close();
    citiesState.close();
    states.close();
    cities.close();
    workspaceInfo.close();
    workspaceInfoState.close();
    installmentPayments.close();
    selectedState.close();
    selectedCity.close();
    selectedInvoiceType.close();
    selectedPaymentType.close();
    expandedProductIndex.close();

    buyerNameController.dispose();
    buyerPhoneController.dispose();
    buyerAddressController.dispose();
    invoiceCodeController.dispose();
    descriptionController.dispose();
    discountController.dispose();
    taxesController.dispose();
    shippingCostController.dispose();
    interestPercentageController.dispose();
    products.close();
    super.onClose();
  }

  CustomerReadDto? _customerData;

  Future<void> loadCustomerInfo() async {
    try {
      _customerDatasource.getCustomer(
        customerId: customerId,
        onResponse: (final response) {
          if (response.result == null) return;
          _customerData = response.result!;
          final customer = response.result!;

          // Fill buyer information from customer
          buyerNameController.text = customer.fullNameOrCompanyName ?? '';
          buyerPhoneController.text = customer.phoneNumber ?? '';
          buyerAddressController.text = customer.address ?? '';

          // Set state and city if states are already loaded
          if (states.isNotEmpty) {
            _setCustomerStateAndCity();
          }
        },
        onError: (final errorResponse) {
          // Silently fail - user can fill manually
        },
        withRetry: true,
      );
    } catch (e) {
      // Silently fail - user can fill manually
    }
  }

  void _setCustomerStateAndCity() {
    if (_customerData == null) return;
    final customer = _customerData!;

    // Set state if available
    if (customer.state?.id != null && states.isNotEmpty) {
      final customerStateId = customer.state!.id;
      final matchingState = states.firstWhereOrNull(
        (final s) => s.id != null && s.id == customerStateId,
      );
      if (matchingState != null) {
        selectedState.value = matchingState;
        loadCities();
      }
    }
  }

  Future<void> loadWorkspaceInfo() async {
    try {
      workspaceInfoState.loading();
      final workspaceId = _core.currentWorkspace.value.id;
      if (workspaceId.isEmpty) {
        workspaceInfoState.loaded();
        return;
      }

      _workspaceDatasource.getAllWorkspaceWithInfo(
        onResponse: (final workspaceList) {
          if (workspaceInfoState.subject.isClosed) return;
          if (workspaceList.isNotEmpty) {
            workspaceInfo(workspaceList.first);
          }
          workspaceInfoState.loaded();
        },
        onError: (final errorResponse) {
          if (workspaceInfoState.subject.isClosed) return;
          workspaceInfoState.error();
        },
        withRetry: true,
      );
    } catch (e) {
      if (workspaceInfoState.subject.isClosed) return;
      workspaceInfoState.error();
    }
  }

  Future<void> loadInvoiceCode() async {
    try {
      pageState.loading();
      final code = await _getInvoiceCodeUseCase();
      if (pageState.subject.isClosed) return;
      invoiceCode(code);
      invoiceCodeController.text = code;
      pageState.loaded();
    } catch (e) {
      if (pageState.subject.isClosed) return;
      pageState.error();
    }
  }

  Future<void> loadStates() async {
    statesState.loading();
    _dropdownDatasource.getAllState(
      onResponse: (final response) {
        states(response.resultList);
        statesState.loaded();
        // After states are loaded, try to set customer's state/city
        _setCustomerStateAndCity();
      },
      onError: (final errorResponse) {
        statesState.error();
      },
      withRetry: true,
    );
  }

  void loadCities() {
    if (selectedState.value == null) return;
    citiesState.loading();
    _dropdownDatasource.getCitiesByStateId(
      stateId: selectedState.value?.id,
      onResponse: (final response) {
        cities(response.resultList);
        citiesState.loaded();
        // After cities are loaded, try to set customer's city
        if (_customerData != null) {
          _setCustomerCity();
        }
      },
      onError: (final errorResponse) {
        citiesState.error();
      },
      withRetry: true,
    );
  }

  void _setCustomerCity() {
    if (_customerData == null || cities.isEmpty) return;
    final customer = _customerData!;

    if (customer.city?.id != null) {
      final customerCityId = customer.city!.id;
      final matchingCity = cities.firstWhereOrNull(
        (final c) => c.id != null && c.id == customerCityId,
      );
      if (matchingCity != null) {
        selectedCity.value = matchingCity;
      }
    }
  }

  // Navigation
  void nextStep() {
    if (currentStep.value == 0) {
      if (!validateStep1()) return;
    } else if (currentStep.value == 1) {
      if (!validateStep2()) return;
    }

    if (currentStep.value < steps.length - 1) {
      currentStep(currentStep.value + 1);
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep(currentStep.value - 1);
    }
  }

  bool canGoToNextStep() {
    if (currentStep.value == 0) {
      return validateStep1();
    } else if (currentStep.value == 1) {
      return validateStep2();
    }
    return true;
  }

  // Validation
  bool validateStep1() {
    if (!step1FormKey.currentState!.validate()) {
      return false;
    }

    if (buyerNameController.text.trim().isEmpty) {
      AppNavigator.snackbarRed(
        title: s.error,
        subtitle: 'نام مشتری الزامی است',
      );
      return false;
    }

    if (buyerNameController.text.trim().length > 150) {
      AppNavigator.snackbarRed(
        title: s.error,
        subtitle: 'نام مشتری نباید بیشتر از 150 کاراکتر باشد',
      );
      return false;
    }

    if (buyerPhoneController.text.trim().isEmpty) {
      AppNavigator.snackbarRed(
        title: s.error,
        subtitle: 'شماره تماس الزامی است',
      );
      return false;
    }

    // Validate phone format: 09xxxxxxxxx
    final phoneRegex = RegExp(r'^09\d{9}$');
    if (!phoneRegex.hasMatch(buyerPhoneController.text.trim())) {
      AppNavigator.snackbarRed(
        title: s.error,
        subtitle: 'شماره تماس باید به فرمت 09xxxxxxxxx باشد',
      );
      return false;
    }

    if (createdDate == null) {
      AppNavigator.snackbarRed(
        title: s.error,
        subtitle: 'تاریخ ثبت الزامی است',
      );
      return false;
    }

    if (selectedState.value == null) {
      AppNavigator.snackbarRed(
        title: s.error,
        subtitle: 'انتخاب استان الزامی است',
      );
      return false;
    }

    if (selectedCity.value == null) {
      AppNavigator.snackbarRed(
        title: s.error,
        subtitle: 'انتخاب شهر الزامی است',
      );
      return false;
    }

    if (buyerAddressController.text.trim().length > 200) {
      AppNavigator.snackbarRed(
        title: s.error,
        subtitle: 'آدرس نباید بیشتر از 200 کاراکتر باشد',
      );
      return false;
    }

    return true;
  }

  bool validateStep2() {
    if (!step2FormKey.currentState!.validate()) {
      return false;
    }

    if (selectedInvoiceType.value == null) {
      AppNavigator.snackbarRed(
        title: s.error,
        subtitle: 'انتخاب نوع فاکتور الزامی است',
      );
      return false;
    }

    if (selectedPaymentType.value == null) {
      AppNavigator.snackbarRed(
        title: s.error,
        subtitle: 'انتخاب نوع پرداخت الزامی است',
      );
      return false;
    }

    if (products.isEmpty) {
      AppNavigator.snackbarRed(
        title: s.error,
        subtitle: s.pleaseAddAtLeastOneProduct,
      );
      return false;
    }

    if (selectedPaymentType.value == PaymentType.installment) {
      if (installmentCount < 1 || installmentCount > 24) {
        AppNavigator.snackbarRed(
          title: s.error,
          subtitle: 'تعداد اقساط باید بین 1 تا 24 باشد',
        );
        return false;
      }

      if (installmentStartDate == null) {
        AppNavigator.snackbarRed(
          title: s.error,
          subtitle: 'تاریخ شروع اقساط الزامی است',
        );
        return false;
      }

      if (interestPercentageController.text.trim().isEmpty) {
        AppNavigator.snackbarRed(
          title: s.error,
          subtitle: 'نرخ بهره الزامی است',
        );
        return false;
      }
    }

    return true;
  }

  // Calculations
  int get totalProductsPrice {
    int total = 0;
    for (final product in products) {
      final price = int.tryParse(product.price.numericOnly()) ?? 0;
      total += price * product.count;
    }
    return total;
  }

  int get discountAmount {
    if (discountController.text.trim().isEmpty) return 0;
    final discount = int.tryParse(discountController.text.numericOnly()) ?? 0;
    // If discount is less than 100, treat as percentage
    if (discount < 100) {
      return (totalProductsPrice * (discount / 100)).toInt();
    }
    return discount;
  }

  int get taxAmount {
    if (taxesController.text.trim().isEmpty) return 0;
    final tax = int.tryParse(taxesController.text.numericOnly()) ?? 0;
    // If tax is less than 100, treat as percentage
    if (tax < 100) {
      return ((totalProductsPrice - discountAmount) * (tax / 100)).toInt();
    }
    return tax;
  }

  int get shippingCostAmount {
    if (shippingCostController.text.trim().isEmpty) return 0;
    return int.tryParse(shippingCostController.text.numericOnly()) ?? 0;
  }

  int get interestAmount {
    if (selectedPaymentType.value != PaymentType.installment) return 0;
    if (interestPercentageController.text.trim().isEmpty) return 0;
    final interest = int.tryParse(interestPercentageController.text.numericOnly()) ?? 0;
    final baseAmount = totalProductsPrice - discountAmount + taxAmount + shippingCostAmount;
    return (baseAmount * (interest / 100)).toInt();
  }

  int get finalPrice {
    final baseAmount = totalProductsPrice - discountAmount + taxAmount + shippingCostAmount;
    if (selectedPaymentType.value == PaymentType.installment) {
      return baseAmount + interestAmount;
    }
    return baseAmount;
  }

  // Installment calculation
  void calculateInstallments() {
    if (selectedPaymentType.value != PaymentType.installment) {
      installmentPayments.clear();
      return;
    }

    if (installmentCount < 1 || installmentCount > 24) return;
    if (installmentStartDate == null) return;

    final installmentAmount = finalPrice / installmentCount;
    final payments = <Map<String, dynamic>>[];

    var currentDate = installmentStartDate!;
    for (int i = 0; i < installmentCount; i++) {
      payments.add({
        'price': installmentAmount.toStringAsFixed(0),
        'date_to_pay': currentDate.formatCompactDate(),
      });

      // Add period days
      currentDate = currentDate.addDays(installmentPeriod);
    }

    installmentPayments.assignAll(payments);
  }

  // Watch for changes that affect installments
  void onInstallmentFieldsChanged() {
    if (selectedPaymentType.value == PaymentType.installment) {
      calculateInstallments();
    }
  }

  void addProduct(final InvoiceProduct product) {
    products.add(product);
    onInstallmentFieldsChanged();
  }

  void removeProduct(final int index) {
    if (index >= 0 && index < products.length) {
      products.removeAt(index);
      if (expandedProductIndex.value == index) {
        expandedProductIndex.value = -1;
      } else if (expandedProductIndex.value > index) {
        expandedProductIndex.value = expandedProductIndex.value - 1;
      }
      onInstallmentFieldsChanged();
    }
  }

  void updateProduct(final int index, final InvoiceProduct product) {
    if (index >= 0 && index < products.length) {
      products[index] = product;
      onInstallmentFieldsChanged();
    }
  }

  Future<void> submitInvoice() async {
    if (!validateStep1() || !validateStep2()) return;

    try {
      isLoading(true);

      // Build seller_information_data (buyer info for invoice)
      final sellerInfoData = <String, dynamic>{
        'fullname_or_company_name': buyerNameController.text.trim(),
        'phone_number': buyerPhoneController.text.trim(),
        'state': selectedState.value?.id,
        'city': selectedCity.value?.id,
        'address': buyerAddressController.text.trim(),
      };

      final params = <String, dynamic>{
        'customer_id': customerId,
        'invoice_type': selectedInvoiceType.value?.name,
        'payment_type': selectedPaymentType.value?.name,
        'invoice_code': invoiceCodeController.text.trim(),
        'seller_information_data': sellerInfoData,
        'product_list': products
            .map(
              (final p) => {
                'title': p.title,
                'count': p.count,
                'price': p.price.replaceAll(',', ''),
                if (p.code != null) 'code': p.code,
                if (p.unit != null) 'unit': p.unit,
              },
            )
            .toList(),
        'created_date': createdDate!.toDateTime().toIso8601String(),
        if (validityDate != null) 'validity_date': validityDate!.toDateTime().toIso8601String(),
        if (dateToPay != null) 'date_to_pay_jalali': dateToPay!.formatCompactDate(),
        if (descriptionController.text.trim().isNotEmpty) 'description': descriptionController.text.trim(),
        if (discountController.text.trim().isNotEmpty)
          'discount': int.tryParse(discountController.text.trim().replaceAll(',', '')) ?? 0,
        if (taxesController.text.trim().isNotEmpty) 'taxes': int.tryParse(taxesController.text.trim().replaceAll(',', '')) ?? 0,
        if (selectedPaymentType.value == PaymentType.installment) ...{
          if (interestPercentageController.text.trim().isNotEmpty)
            'interest_percentage': int.tryParse(interestPercentageController.text.trim().replaceAll(',', '')) ?? 0,
          if (installmentPayments.isNotEmpty) 'installment_payments': installmentPayments,
        },
      };

      final result = await _createInvoiceUseCase(params);
      isLoading(false);

      AppNavigator.snackbarGreen(
        title: s.success,
        subtitle: 'فاکتور با موفقیت ثبت شد',
      );

      Get.back(result: result);
    } catch (e) {
      isLoading(false);
      AppNavigator.snackbarRed(
        title: s.error,
        subtitle: e.toString(),
      );
    }
  }

  void resetForm() {
    buyerNameController.clear();
    buyerPhoneController.clear();
    buyerAddressController.clear();
    invoiceCodeController.text = invoiceCode.value;
    descriptionController.clear();
    discountController.clear();
    taxesController.clear();
    shippingCostController.clear();
    interestPercentageController.clear();
    selectedInvoiceType.value = null;
    selectedPaymentType.value = null;
    products.clear();
    createdDate = Jalali.now();
    validityDate = null;
    dateToPay = null;
    selectedState.value = null;
    selectedCity.value = null;
    cities.clear();
    installmentCount = 1;
    installmentStartDate = null;
    installmentPeriod = 10;
    installmentPayments.clear();
    currentStep(0);
  }
}
