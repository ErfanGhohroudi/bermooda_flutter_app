import 'package:decimal/decimal.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../data/data.dart';
import '../../data/repositories/invoice_repository_impl.dart';
import '../../domain/usecases/get_invoice_buyer_seller_info.dart';
import '../../domain/usecases/get_invoice_code.dart';
import '../../domain/usecases/create_invoice.dart';
import '../../domain/entities/invoice.dart';
import '../helpers/murabaha_installment_calculator.dart';

class CreateInvoiceController extends GetxController {
  CreateInvoiceController({required this.customerId});

  final int customerId;
  final InvoiceRepositoryImpl _repository = InvoiceRepositoryImpl();
  final DropdownDatasource _dropdownDatasource = Get.find<DropdownDatasource>();
  final UpdateInvoiceInfoDatasource _updateInvoiceInfoDatasource = Get.find<UpdateInvoiceInfoDatasource>();

  late final GetInvoiceCodeUseCase _getInvoiceCodeUseCase = GetInvoiceCodeUseCase(_repository);
  late final GetInvoiceBuyerSellerInfoUseCase _getInvoiceBuyerSellerInfoUseCase = GetInvoiceBuyerSellerInfoUseCase(_repository);
  late final CreateInvoiceUseCase _createInvoiceUseCase = CreateInvoiceUseCase(_repository);

  final Rx<PageState> pageState = PageState.initial.obs;
  final RxString invoiceCode = ''.obs;
  final RxBool isLoading = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> buyerSellerStepFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> detailsStepFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> installmentStepFormKey = GlobalKey<FormState>();

  // Stepper
  final RxInt currentStep = 0.obs;

  bool get isInstallmentPaymentTerms => selectedPaymentTerms.value == PaymentTerms.installment;

  List<String> get steps =>
      [
        s.invoiceDetailsStep,
        if (isInstallmentPaymentTerms) s.invoiceInstallmentsStep,
        "${s.buyer}/${s.seller}",
        s.previewStep,
      ];

  // Form fields - Step 1: Buyer Information
  BuyerInfo? _buyerInfo;
  final TextEditingController buyerNameController = TextEditingController();
  final TextEditingController buyerPhoneController = TextEditingController();
  final TextEditingController buyerAddressController = TextEditingController();
  final TextEditingController buyerNationalCodeController = TextEditingController();
  final TextEditingController buyerEconomicCodeController = TextEditingController();
  Jalali? createdDate;
  Jalali? validityDate;
  final Rxn<DropdownItemReadDto> selectedState = Rxn<DropdownItemReadDto>(null);
  final Rxn<DropdownItemReadDto> selectedCity = Rxn<DropdownItemReadDto>(null);

  // State/City management for buyer
  final Rx<PageState> statesState = PageState.loaded.obs;
  final Rx<PageState> citiesState = PageState.loaded.obs;
  final RxList<DropdownItemReadDto> states = <DropdownItemReadDto>[].obs;
  final RxList<DropdownItemReadDto> cities = <DropdownItemReadDto>[].obs;

  // Form fields - Step 1: Seller (Workspace) Information
  final TextEditingController sellerFullnameController = TextEditingController();
  final Rx<AuthenticationType> sellerPersonalType = AuthenticationType.person.obs;
  final TextEditingController sellerEconomicNumberController = TextEditingController();
  final TextEditingController sellerNationalCodeController = TextEditingController();
  final TextEditingController sellerRegistrationNumberController = TextEditingController();
  final TextEditingController sellerPostalCodeController = TextEditingController();
  final TextEditingController sellerAddressController = TextEditingController();
  final TextEditingController sellerPhoneController = TextEditingController();
  final TextEditingController sellerFaxController = TextEditingController();
  final TextEditingController sellerEmailController = TextEditingController();
  final TextEditingController sellerShebaController = TextEditingController();
  final Rxn<DropdownItemReadDto> sellerState = Rxn<DropdownItemReadDto>(null);
  final Rxn<DropdownItemReadDto> sellerCity = Rxn<DropdownItemReadDto>(null);

  // State/City management for seller
  final Rx<PageState> sellerStatesState = PageState.loaded.obs;
  final Rx<PageState> sellerCitiesState = PageState.loaded.obs;
  final RxList<DropdownItemReadDto> sellerStates = <DropdownItemReadDto>[].obs;
  final RxList<DropdownItemReadDto> sellerCities = <DropdownItemReadDto>[].obs;

  // Seller Information (from workspace)
  final Rx<SellerInfo?> sellerInfo = Rxn<SellerInfo?>(null);

  bool get isWorkspaceInfoCompleted => sellerInfo.value?.personalInformationStatus ?? false;

  // Form fields - Step 2: Invoice Details
  final TextEditingController invoiceCodeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final RxInt discountPercentage = 0.obs;
  final RxInt taxesPercentage = 0.obs;
  final RxBool shipping = false.obs;
  final RxInt shippingCostAmount = 0.obs;
  final TextEditingController shippingCostController = TextEditingController();
  final RxInt interestPercentage = 0.obs;

  final Rxn<InvoiceType> selectedInvoiceType = Rxn<InvoiceType>(null);
  final Rx<PaymentTerms> selectedPaymentTerms = PaymentTerms.values.first.obs;
  final RxList<InvoiceProduct> products = <InvoiceProduct>[].obs;
  final RxInt expandedProductIndex = (-1).obs;

  // Installment fields
  int installmentCount = 1;
  Jalali? installmentStartDate;
  int installmentPeriod = 10; // 10, 20, or 30 days
  final RxList<InstallmentResult> installmentPayments = <InstallmentResult>[].obs;

  // Dates
  Jalali? dateToPay;

  @override
  void onInit() {
    super.onInit();
    createdDate = Jalali.now();
    _loadBuyerStates();
    _loadSellerStates();
    loadInvoiceCodeAndBuyerSellerInfo();
  }

  @override
  void onClose() {
    buyerNameController.dispose();
    buyerPhoneController.dispose();
    buyerAddressController.dispose();
    buyerNationalCodeController.dispose();
    buyerEconomicCodeController.dispose();
    sellerFullnameController.dispose();
    sellerEconomicNumberController.dispose();
    sellerNationalCodeController.dispose();
    sellerRegistrationNumberController.dispose();
    sellerPostalCodeController.dispose();
    sellerAddressController.dispose();
    sellerPhoneController.dispose();
    sellerFaxController.dispose();
    sellerEmailController.dispose();
    sellerShebaController.dispose();
    invoiceCodeController.dispose();
    descriptionController.dispose();
    shippingCostController.dispose();
    super.onClose();
  }

  void _setBuyerStateAndCity() {
    if (_buyerInfo == null) return;
    final customer = _buyerInfo!;

    // Set state if available
    if (customer.state?.id != null && states.isNotEmpty) {
      final customerStateId = customer.state!.id;
      final matchingState = states.firstWhereOrNull(
            (final s) => s.id != null && s.id == customerStateId,
      );
      if (matchingState != null) {
        selectedState.value = matchingState;
        _loadBuyerCities();
      }
    }
  }

  Future<void> loadInvoiceCodeAndBuyerSellerInfo() async {
    try {
      pageState.loading();
      final results = await Future.wait([
        _getInvoiceCodeUseCase(),
        _getInvoiceBuyerSellerInfoUseCase(customerId),
      ]);
      if (pageState.subject.isClosed) return;
      final code = results[0] as String;
      final buyerSellerInfo = results[1] as InvoiceBuyerSellerInfo;
      await _setInvoiceCode(code);
      await _setBuyerSellerInfo(buyerSellerInfo);
      pageState.loaded();
    } catch (e) {
      if (pageState.subject.isClosed) return;
      pageState.error();
    }
  }

  Future<void> _setInvoiceCode(final String code) async {
    invoiceCode(code);
    invoiceCodeController.text = code;
  }

  Future<void> _setBuyerSellerInfo(final InvoiceBuyerSellerInfo result) async {
    _buyerInfo = result.buyerInfo;
    final customer = result.buyerInfo;
    // Fill buyer information from customer
    buyerNameController.text = customer.name;
    buyerNationalCodeController.text = customer.nationalCode ?? '';
    buyerEconomicCodeController.text = customer.economicCode ?? '';
    buyerAddressController.text = customer.address;
    buyerPhoneController.text = customer.phoneNumber;

    // Set state and city if states are already loaded
    if (states.isNotEmpty) {
      _setBuyerStateAndCity();
    }

    final wsInfo = result.sellerInfo;
    sellerInfo(wsInfo);

    // Fill seller information from workspace
    sellerPersonalType.value = wsInfo.normalizedPersonalType;
    sellerFullnameController.text = wsInfo.name;
    sellerEconomicNumberController.text = wsInfo.economicNumber ?? '';
    sellerNationalCodeController.text = wsInfo.nationalCode ?? '';
    sellerRegistrationNumberController.text = wsInfo.registrationNumber ?? '';
    sellerAddressController.text = wsInfo.address;
    sellerPhoneController.text = wsInfo.phoneNumber;
    sellerPostalCodeController.text = wsInfo.postalCode ?? '';
    sellerFaxController.text = wsInfo.faxNumber ?? '';
    sellerEmailController.text = wsInfo.email ?? '';
    sellerShebaController.text = wsInfo.shebaNumber ?? '';

    // Set seller state and city if states are already loaded
    if (sellerStates.isNotEmpty) {
      _setSellerStateAndCity(wsInfo);
    }
  }

  Future<void> _loadBuyerStates() async {
    statesState.loading();
    _dropdownDatasource.getAllState(
      onResponse: (final response) {
        states(response.resultList);
        statesState.loaded();
        // After states are loaded, try to set customer's state/city
        _setBuyerStateAndCity();
      },
      onError: (final errorResponse) {
        statesState.error();
      },
      withRetry: true,
    );
  }

  void _loadBuyerCities() {
    if (selectedState.value == null) return;
    citiesState.loading();
    _dropdownDatasource.getCitiesByStateId(
      stateId: selectedState.value?.id,
      onResponse: (final response) {
        cities(response.resultList);
        citiesState.loaded();
        // After cities are loaded, try to set customer's city
        if (_buyerInfo != null) {
          _setCustomerCity();
        }
      },
      onError: (final errorResponse) {
        citiesState.error();
      },
      withRetry: true,
    );
  }

  void onSelectBuyerState(final DropdownItemReadDto? value) {
    selectedState.value = value;
    selectedCity.value = null;
    cities.clear();
    _loadBuyerCities();
  }

  void _setCustomerCity() {
    if (_buyerInfo == null || cities.isEmpty) return;
    final customer = _buyerInfo!;

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

  void _loadSellerStates() {
    sellerStatesState.loading();
    _dropdownDatasource.getAllState(
      onResponse: (final response) {
        sellerStates(response.resultList);
        sellerStatesState.loaded();
        // After seller states are loaded, try to set workspace's state/city
        if (sellerInfo.value != null) {
          _setSellerStateAndCity(sellerInfo.value!);
        }
      },
      onError: (final errorResponse) {
        sellerStatesState.error();
      },
      withRetry: true,
    );
  }

  void _loadSellerCities() {
    if (sellerState.value == null) return;
    sellerCitiesState.loading();
    _dropdownDatasource.getCitiesByStateId(
      stateId: sellerState.value?.id,
      onResponse: (final response) {
        sellerCities(response.resultList);
        sellerCitiesState.loaded();
        // After seller cities are loaded, try to set workspace's city
        if (sellerInfo.value != null) {
          _setSellerCity(sellerInfo.value!);
        }
      },
      onError: (final errorResponse) {
        sellerCitiesState.error();
      },
      withRetry: true,
    );
  }

  void onSelectSellerState(final DropdownItemReadDto? value) {
    sellerState.value = value;
    sellerCity.value = null;
    sellerCities.clear();
    _loadSellerCities();
  }

  void _setSellerStateAndCity(final SellerInfo wsInfo) {
    // Set seller state if available
    if (wsInfo.state != null && sellerStates.isNotEmpty) {
      final matchingState = sellerStates.firstWhereOrNull(
            (final s) => s.id != null && s.id == wsInfo.state?.id,
      );
      if (matchingState != null) {
        sellerState.value = matchingState;
        _loadSellerCities();
      }
    }
  }

  void _setSellerCity(final SellerInfo wsInfo) {
    if (sellerCities.isEmpty) return;

    // Set seller city if available
    if (wsInfo.city != null) {
      final matchingCity = sellerCities.firstWhereOrNull(
            (final c) => c.id != null && c.id == wsInfo.city?.id,
      );
      if (matchingCity != null) {
        sellerCity.value = matchingCity;
      }
    }
  }

  // Navigation
  void nextStep() {
    if (currentStep.value == 0) {
      if (!validateDetailsForm()) return;
    } else if (currentStep.value == 1) {
      if (!validateInstallmentsForm()) return;
    } else if (isInstallmentPaymentTerms && currentStep.value == 2) {
      if (!validateBuyerSellerForm()) return;
      // Call API before proceeding to next step
      updateInvoiceInfo(
        onSuccess: () {
          if (currentStep.value < steps.length - 1) {
            currentStep(currentStep.value + 1);
          }
        },
      );
      return;
    }

    if (currentStep.value < steps.length - 1) {
      currentStep(currentStep.value + 1);
    }
  }

  Future<void> updateInvoiceInfo({required final VoidCallback onSuccess}) async {
    try {
      // Build customer_data
      final customerData = UpdateInvoiceInfoCustomerData(
        fullnameOrCompanyName: buyerNameController.text.trim(),
        nationalCode: buyerNationalCodeController.text.trim(),
        economicCode: buyerEconomicCodeController.text.trim(),
        stateId: selectedState.value?.id,
        cityId: selectedCity.value?.id,
        address: buyerAddressController.text.trim(),
        phoneNumber: buyerPhoneController.text.trim(),
      );

      // Build workspace_data only if personalInformationStatus is false
      UpdateInvoiceInfoWorkspaceData? workspaceData;
      if (!isWorkspaceInfoCompleted) {
        workspaceData = UpdateInvoiceInfoWorkspaceData(
          fullname: sellerFullnameController.text.trim(),
          normalizedPersonalType: sellerPersonalType.value,
          registrationNumber: sellerRegistrationNumberController.text.trim(),
          nationalCode: sellerNationalCodeController.text.trim(),
          email: sellerEmailController.text.trim(),
          postalCode: sellerPostalCodeController.text.trim(),
          phoneNumber: sellerPhoneController.text.trim(),
          faxNumber: sellerFaxController.text.trim(),
          economicNumber: sellerEconomicNumberController.text.trim(),
          address: sellerAddressController.text.trim(),
          cityId: sellerCity.value?.id,
          stateId: sellerState.value?.id,
          shebaNumber: sellerShebaController.text.trim(),
        );
      }

      // Build request params
      final params = UpdateInvoiceInfoParams(
        customerData: customerData,
        workspaceData: workspaceData,
      );

      _updateInvoiceInfoDatasource.updateInvoiceInfo(
        customerId: customerId,
        params: params,
        onResponse: () {
          onSuccess();
        },
        onError: (final errorResponse) {
          AppNavigator.snackbarRed(
            title: s.error,
            subtitle: errorResponse.message.isNotEmpty ? errorResponse.message : s.updateInvoiceInfoError,
          );
        },
        withLoading: true,
      );
    } catch (e) {
      AppNavigator.snackbarRed(
        title: s.error,
        subtitle: e.toString(),
      );
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep(currentStep.value - 1);
      // stepperScrollController.jumpTo(0);
    }
  }

  // Validation
  bool validateBuyerSellerForm() {
    if (!buyerSellerStepFormKey.currentState!.validate()) {
      AppNavigator.snackbarRed(
        title: s.error,
        subtitle: s.completeRequiredFields,
      );
      return false;
    }

    // Validate phone format: 09xxxxxxxxx
    final phoneRegex = RegExp(r'^09\d{9}$');
    if (!phoneRegex.hasMatch(buyerPhoneController.text.trim())) {
      AppNavigator.snackbarRed(
        title: s.error,
        subtitle: s.buyerPhoneFormat,
      );
      return false;
    }

    return true;
  }

  bool validateDetailsForm() {
    if (!detailsStepFormKey.currentState!.validate()) {
      AppNavigator.snackbarRed(
        title: s.error,
        subtitle: s.completeRequiredFields,
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

    return true;
  }

  bool validateInstallmentsForm() {
    if (!installmentStepFormKey.currentState!.validate()) {
      return false;
    }

    if (selectedPaymentTerms.value == PaymentTerms.installment) {
      if (installmentStartDate == null) {
        AppNavigator.snackbarRed(
          title: s.error,
          subtitle: s.installmentStartDateRequired,
        );
        return false;
      }
    }

    return true;
  }

  // Calculations
  Decimal get totalProductsPrice {
    Decimal total = 0.toDecimal();
    for (final product in products) {
      final price = Decimal.tryParse(product.price.numericOnly()) ?? 0.toDecimal();
      total += price * product.count.toDecimal();
    }
    return total;
  }

  Decimal get discountAmount {
    if (discountPercentage.value == 0) return 0.toDecimal();
    final discount = discountPercentage.value;
    final discountRate = Decimal.parse((discount / 100).toString());
    final amount = (totalProductsPrice * discountRate);
    return amount;
  }

  Decimal get taxAmount {
    if (taxesPercentage.value == 0) return 0.toDecimal();
    final tax = taxesPercentage.value;
    final taxRate = Decimal.parse((tax / 100).toString());
    final amount = (totalProductsPrice - discountAmount) * taxRate;
    final decimalAmount = Decimal.parse(amount.toString());
    return decimalAmount;
  }

  Decimal get interestAmount {
    if (selectedPaymentTerms.value != PaymentTerms.installment) return 0.toDecimal();
    if (interestPercentage.value == 0) return 0.toDecimal();

    final dueDates = [
      installmentStartDate!,
      for (int i = 1; i < installmentCount; i++)
        installmentStartDate!.addDays(installmentPeriod * i),
    ];

    final calc = MurabahaInstallmentCalculator(
      principalAmount: finalPrice,
      annualRate: interestPercentage.value.toDecimal(),
      invoiceDate: createdDate!,
      dueDates: dueDates,
    );
    return calc.getTotalInterestAmount();
  }

  Decimal get finalPrice {
    final totalPrice = totalProductsPrice - discountAmount;
    final baseAmount = totalPrice + taxAmount + shippingCostAmount.value.toDecimal();
    return baseAmount;
  }

  Decimal get finalPriceWithInterest {
    if (installmentPayments.isEmpty) return finalPrice;

    List<Jalali> dueDates = [];

    if (installmentPayments.isNotEmpty) {
      for (final payment in installmentPayments) {
        dueDates.add(payment.dateToPay);
      }
    }

    final calc = MurabahaInstallmentCalculator(
      principalAmount: finalPrice,
      annualRate: interestPercentage.value.toDecimal(),
      invoiceDate: createdDate!,
      dueDates: dueDates,
    );

    final amount = calc.getFinalAmountWithInterest();

    return amount;
  }

  // Installment calculation
  void calculateInstallments({final bool generateNew = false}) {
    if (selectedPaymentTerms.value != PaymentTerms.installment) {
      installmentPayments.clear();
      return;
    }

    if (installmentCount < 1) return;
    if (installmentStartDate == null) return;
    if (createdDate == null) return;

    List<Jalali> dueDates = [];

    if (installmentPayments.isNotEmpty && generateNew == false) {
      for (final payment in installmentPayments) {
        dueDates.add(payment.dateToPay);
      }
    } else {
      dueDates = [
        installmentStartDate!,
        for (int i = 1; i < installmentCount; i++)
          installmentStartDate!.addDays(installmentPeriod * i),
      ];
    }

    final calc = MurabahaInstallmentCalculator(
      principalAmount: finalPrice,
      annualRate: interestPercentage.value.toDecimal(),
      invoiceDate: createdDate!,
      dueDates: dueDates,
    );

    final payments = calc.calculate();

    // Sort by date to pay
    payments.sort(
          (final a, final b) {
        final aDateToPay = a.dateToPay;
        final bDateToPay = b.dateToPay;
        return aDateToPay.compareTo(bDateToPay);
      },
    );

    installmentPayments.assignAll(payments);
  }

  void onShippingCostFieldChanged() {
    if (shipping.value == false) {
      shippingCostAmount(0);
      return;
    }

    if (shippingCostController.text
        .trim()
        .isEmpty) {
      shippingCostAmount(0);
      return;
    }

    final amount = int.tryParse(shippingCostController.text.numericOnly()) ?? 0;
    shippingCostAmount(amount);
  }

  // Watch for changes that affect installments
  void onFinancialFieldsChanged() {
    if (selectedPaymentTerms.value == PaymentTerms.installment) {
      if (installmentPayments.isNotEmpty) {
        calculateInstallments();
      }
    } else {
      if (installmentPayments.isNotEmpty) {
        installmentPayments.clear();
      }
    }
  }

  void addProduct(final InvoiceProduct product) {
    products.add(product);
    onFinancialFieldsChanged();
  }

  void removeProduct(final int index) {
    if (index >= 0 && index < products.length) {
      products.removeAt(index);
      if (expandedProductIndex.value == index) {
        expandedProductIndex.value = -1;
      } else if (expandedProductIndex.value > index) {
        expandedProductIndex.value = expandedProductIndex.value - 1;
      }
      onFinancialFieldsChanged();
    }
  }

  void updateProduct(final int index, final InvoiceProduct product) {
    if (index >= 0 && index < products.length) {
      products[index] = product;
      onFinancialFieldsChanged();
    }
  }

  Future<void> submitInvoice(final BuildContext context) async {
    if (!validateBuyerSellerForm() || !validateDetailsForm() || !validateInstallmentsForm()) return;

    try {
      isLoading(true);

      // Build seller_information_data (buyer info for invoice)
      final sellerInfoData = SellerInformationData(
        fullnameOrCompanyName: buyerNameController.text.trim(),
        phoneNumber: buyerPhoneController.text.trim(),
        state: selectedState.value?.id,
        city: selectedCity.value?.id,
        address: buyerAddressController.text.trim(),
      );

      // Build product list
      final productList = products
          .map(
            (final p) =>
            InvoiceProductItem(
              title: p.title,
              count: p.count,
              price: p.price.replaceAll(',', ''),
              code: p.code,
              unit: p.unit,
            ),
      )
          .toList();

      // Build params object
      final params = InvoiceParams(
        customerId: customerId,
        invoiceType: selectedInvoiceType.value,
        paymentType: selectedPaymentTerms.value,
        invoiceCode: invoiceCodeController.text.trim(),
        sellerInformationData: sellerInfoData,
        productList: productList,
        createdDate: createdDate!.toDateTime().toIso8601String(),
        validityDate: validityDate?.toDateTime().toIso8601String(),
        dateToPayJalali: dateToPay?.formatCompactDate(),
        description: descriptionController.text
            .trim()
            .isNotEmpty ? descriptionController.text.trim() : null,
        discount: discountPercentage.value,
        taxes: taxesPercentage.value,
        interestPercentage: interestPercentage.value,
        installmentPayments: selectedPaymentTerms.value == PaymentTerms.installment && installmentPayments.isNotEmpty
            ? installmentPayments.toList()
            : null,
      );

      final result = await _createInvoiceUseCase(params);
      isLoading(false);

      AppNavigator.snackbarGreen(title: s.done, subtitle: '');

      if (context.mounted) {
        Navigator.pop(context, result);
      }
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
    discountPercentage(0);
    taxesPercentage(0);
    shippingCostController.clear();
    shippingCostAmount(0);
    interestPercentage(0);
    selectedInvoiceType.value = null;
    selectedPaymentTerms.value = PaymentTerms.values.first;
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
