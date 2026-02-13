import 'package:decimal/decimal.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/loading/loading.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../core/utils/extensions/date_extensions.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../data/data.dart';
import '../../data/params/invoice_params.dart';
import '../../data/repositories/invoice_repository_impl.dart';
import '../../domain/usecases/get_invoice_buyer_seller_info.dart';
import '../../domain/usecases/get_invoice_code.dart';
import '../../domain/usecases/create_invoice.dart';
import '../../domain/entities/invoice.dart';
import '../helpers/murabaha_installment_calculator.dart';
import '../sheets/create_installments_table_sheet.dart';
import 'invoice_list_controller.dart';

enum InvoiceStepType { details, installments, buyerSeller, preview }

class CreateInvoiceController extends GetxController {
  CreateInvoiceController({
    required this.customerId,
    this.invoice,
  });

  final int customerId;
  final InvoiceEntity? invoice;

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

  List<InvoiceStepType> get stepTypes => [
    InvoiceStepType.details,
    if (isInstallmentPaymentTerms) InvoiceStepType.installments,
    if (!isWorkspaceInfoCompleted || !isBuyerInfoCompleted) InvoiceStepType.buyerSeller,
    InvoiceStepType.preview,
  ];

  List<String> get steps => stepTypes.map((final type) {
    switch (type) {
      case InvoiceStepType.details:
        return s.invoiceDetailsStep;
      case InvoiceStepType.installments:
        return s.invoiceInstallmentsStep;
      case InvoiceStepType.buyerSeller:
        return "${s.buyer}/${s.seller}";
      case InvoiceStepType.preview:
        return s.previewStep;
    }
  }).toList();

  // Form fields - Buyer Information
  BuyerInfo? buyerInfo;
  final TextEditingController buyerNameController = TextEditingController();
  final TextEditingController buyerPhoneController = TextEditingController();
  final TextEditingController buyerAddressController = TextEditingController();
  final TextEditingController buyerNationalCodeController = TextEditingController();
  final TextEditingController buyerEconomicCodeController = TextEditingController();
  final Rxn<DropdownItemReadDto> buyerState = Rxn<DropdownItemReadDto>(null);
  final Rxn<DropdownItemReadDto> buyerCity = Rxn<DropdownItemReadDto>(null);

  // State/City management for buyer
  final Rx<PageState> buyerStatesState = PageState.loaded.obs;
  final Rx<PageState> buyerCitiesState = PageState.loaded.obs;
  final RxList<DropdownItemReadDto> buyerStates = <DropdownItemReadDto>[].obs;
  final RxList<DropdownItemReadDto> cities = <DropdownItemReadDto>[].obs;

  // Form fields - Seller (Workspace) Information
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

  bool get isBuyerInfoCompleted =>
      buyerInfo != null &&
      buyerInfo!.name.isNotEmpty &&
      (buyerInfo!.nationalCode ?? '').isNotEmpty &&
      buyerInfo!.state != null &&
      buyerInfo!.city != null &&
      buyerInfo!.address.isNotEmpty &&
      buyerInfo!.phoneNumber.isNotEmpty;

  // Form fields - Invoice Details
  Jalali? createdDate;
  Jalali? validityDate;
  final TextEditingController invoiceCodeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final RxInt discountPercentage = 0.obs;
  final RxInt taxesPercentage = 0.obs;
  final RxBool shipping = false.obs;
  final RxInt shippingCostAmount = 0.obs;
  final FocusNode shippingCostFocusNode = FocusNode();
  final TextEditingController shippingCostController = TextEditingController();
  final RxInt interestPercentage = 0.obs;

  final Rxn<InvoiceType> selectedInvoiceType = Rxn<InvoiceType>(null);
  final Rx<PaymentTerms> selectedPaymentTerms = PaymentTerms.values.first.obs;
  final RxList<InvoiceProduct> products = <InvoiceProduct>[].obs;
  final RxInt _expandedProductIndex = (-1).obs;

  // Installment fields
  int installmentCount = 1;
  Jalali? installmentStartDate;
  int installmentPeriod = 1; // 1, 2, or 3 months
  final RxList<InstallmentParams> installmentPayments = <InstallmentParams>[].obs;

  // Late Penalty fields
  final RxBool latePenaltyEnabled = false.obs;
  final RxInt latePenaltyRate = 0.obs;
  final TextEditingController latePenaltyCapController = TextEditingController();

  final Rxn<MainFileReadDto> signatureFile = Rxn<MainFileReadDto>(null);

  @override
  void onInit() {
    createdDate = Jalali.now();
    if (invoice != null) {
      _setValuesFromInvoice(invoice!);
    }
    _loadBuyerStates();
    _loadSellerStates();
    loadInvoiceCodeAndBuyerSellerInfo();
    super.onInit();
  }

  void _setValuesFromInvoice(final InvoiceEntity invoice) {
    createdDate = invoice.invoiceDate.toJalali();
    validityDate = invoice.validityDatePersian.toJalali();
    descriptionController.text = invoice.description ?? '';
    discountPercentage(invoice.discountPercentage);
    taxesPercentage(invoice.taxesPercentage);

    shipping(invoice.shippingCost > 0);
    shippingCostAmount(invoice.shippingCost);
    shippingCostController.text = invoice.shippingCost.toString();
    interestPercentage(invoice.interestPercentage);
    selectedInvoiceType(invoice.invoiceType);
    selectedPaymentTerms(invoice.paymentType);
    products(invoice.products);
    installmentCount = invoice.installments.length;
    installmentStartDate = invoice.installments.firstOrNull?.dateToPay;
    if (invoice.installments.isNotEmpty) {
      final installmentList = invoice.installments.map((final e) {
        if (e.dateToPay == null) {
          return InstallmentParams(dateToPay: e.dateToPay!, totalAmount: e.price);
        }
        return null;
      }).whereType<InstallmentParams>().toList();
      installmentPayments(installmentList);
    }
    latePenaltyEnabled(invoice.latePenaltyEnabled);
    latePenaltyRate(invoice.latePenaltyRate);
    latePenaltyCapController.text = invoice.latePenaltyCap.toString();
    signatureFile.value = invoice.signatureFile;
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
    shippingCostFocusNode.dispose();
    latePenaltyCapController.dispose();
    super.onClose();
  }

  void _setBuyerStateAndCity() {
    if (buyerInfo == null) return;
    final customer = buyerInfo!;

    // Set state if available
    if (customer.state?.id != null && buyerStates.isNotEmpty) {
      final customerStateId = customer.state!.id;
      final matchingState = buyerStates.firstWhereOrNull(
        (final s) => s.id != null && s.id == customerStateId,
      );
      if (matchingState != null) {
        buyerState.value = matchingState;
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
    buyerInfo = result.buyerInfo;
    final customer = result.buyerInfo;
    // Fill buyer information from customer
    buyerNameController.text = customer.name;
    buyerNationalCodeController.text = customer.nationalCode ?? '';
    buyerEconomicCodeController.text = customer.economicCode ?? '';
    buyerAddressController.text = customer.address;
    buyerPhoneController.text = customer.phoneNumber;

    // Set state and city if states are already loaded
    if (buyerStates.isNotEmpty) {
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
    buyerStatesState.loading();
    _dropdownDatasource.getAllState(
      onResponse: (final response) {
        buyerStates(response.resultList);
        buyerStatesState.loaded();
        // After states are loaded, try to set customer's state/city
        _setBuyerStateAndCity();
      },
      onError: (final errorResponse) {
        buyerStatesState.error();
      },
      withRetry: true,
    );
  }

  void _loadBuyerCities() {
    if (buyerState.value == null) return;
    buyerCitiesState.loading();
    _dropdownDatasource.getCitiesByStateId(
      stateId: buyerState.value?.id,
      onResponse: (final response) {
        cities(response.resultList);
        buyerCitiesState.loaded();
        // After cities are loaded, try to set customer's city
        if (buyerInfo != null) {
          _setCustomerCity();
        }
      },
      onError: (final errorResponse) {
        buyerCitiesState.error();
      },
      withRetry: true,
    );
  }

  void onSelectBuyerState(final DropdownItemReadDto? value) {
    buyerState.value = value;
    buyerCity.value = null;
    cities.clear();
    _loadBuyerCities();
  }

  void _setCustomerCity() {
    if (buyerInfo == null || cities.isEmpty) return;
    final customer = buyerInfo!;

    if (customer.city?.id != null) {
      final customerCityId = customer.city!.id;
      final matchingCity = cities.firstWhereOrNull(
        (final c) => c.id != null && c.id == customerCityId,
      );
      if (matchingCity != null) {
        buyerCity.value = matchingCity;
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
  void nextStep() async {
    final currentType = stepTypes[currentStep.value];

    switch (currentType) {
      case InvoiceStepType.details:
        if (!validateDetailsForm()) return;
        if (isInstallmentPaymentTerms && installmentPayments.isEmpty) {
          final isValid = await _createInstallmentsTable();
          if (isValid == false) return;
        }
      case InvoiceStepType.installments:
        if (!validateInstallmentsForm()) return;
        if (installmentPayments.isEmpty) {
          AppSnackBar.snackbarRed(title: s.error, subtitle: s.pleaseAddAtLeastOne(s.installment.toLowerCase()));
          return;
        }
      case InvoiceStepType.buyerSeller:
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
      case InvoiceStepType.preview:
        // No next step for preview
        return;
    }

    if (currentStep.value < steps.length - 1) {
      currentStep(currentStep.value + 1);
    }
  }

  Future<void> updateInvoiceInfo({required final VoidCallback onSuccess}) async {
    try {
      // Build customer_data
      final customerData = UpdateInvoiceInfoCustomerDataParams(
        fullnameOrCompanyName: buyerNameController.text.trim(),
        nationalCode: buyerNationalCodeController.text.trim(),
        economicCode: buyerEconomicCodeController.text.trim().isNotEmpty ? buyerEconomicCodeController.text.trim() : null,
        stateId: buyerState.value?.id,
        cityId: buyerCity.value?.id,
        address: buyerAddressController.text.trim(),
        phoneNumber: buyerPhoneController.text.trim(),
      );

      // Build workspace_data only if personalInformationStatus is false
      UpdateInvoiceInfoWorkspaceDataParams? workspaceData;
      if (!isWorkspaceInfoCompleted) {
        workspaceData = UpdateInvoiceInfoWorkspaceDataParams(
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
        onResponse: () async {
          try {
            AppLoading.showLoading();
            final buyerSellerInfo = await _getInvoiceBuyerSellerInfoUseCase(customerId);
            AppLoading.dismissLoading();
            await _setBuyerSellerInfo(buyerSellerInfo);
            onSuccess();
          } catch (e) {
            AppSnackBar.snackbarRed(title: s.error, subtitle: s.updateInvoiceInfoError);
          }
        },
        onError: (final errorResponse) {
          AppSnackBar.snackbarRed(
            title: s.error,
            subtitle: errorResponse.message.isNotEmpty ? errorResponse.message : s.updateInvoiceInfoError,
          );
        },
        withLoading: true,
      );
    } catch (e) {
      AppSnackBar.snackbarRed(
        title: s.error,
        subtitle: e.toString(),
      );
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep(currentStep.value - 1);
    }
  }

  // Validation
  bool validateBuyerSellerForm() {
    if (isWorkspaceInfoCompleted) return true;
    if (!buyerSellerStepFormKey.currentState!.validate()) {
      AppSnackBar.snackbarRed(
        title: s.error,
        subtitle: s.completeRequiredFields,
      );
      return false;
    }

    // Validate phone format: 09xxxxxxxxx
    final phoneRegex = RegExp(r'^09\d{9}$');
    if (!phoneRegex.hasMatch(buyerPhoneController.text.trim())) {
      AppSnackBar.snackbarRed(
        title: s.error,
        subtitle: s.buyerPhoneFormat,
      );
      return false;
    }

    return true;
  }

  bool validateDetailsForm() {
    if (!detailsStepFormKey.currentState!.validate()) {
      AppSnackBar.snackbarRed(
        title: s.error,
        subtitle: s.completeRequiredFields,
      );
      return false;
    }

    if (products.isEmpty) {
      AppSnackBar.snackbarRed(
        title: s.error,
        subtitle: s.pleaseAddAtLeastOne(s.product.toLowerCase()),
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
        AppSnackBar.snackbarRed(
          title: s.error,
          subtitle: s.installmentStartDateRequired,
        );
        return false;
      }

      if (latePenaltyEnabled.value && latePenaltyRate.value == 0) {
        AppSnackBar.snackbarRed(
          title: s.error,
          subtitle: s.penaltyRateCannotBeZero,
        );
        return false;
      }

      // Check if total installments match final price (optional but recommended)
      if (installmentPayments.isNotEmpty && installmentsImbalance != Decimal.zero) {
        // We might just show a warning or auto-adjust the last installment
        AppSnackBar.snackbarRed(title: s.error, subtitle: s.sumOfInstallmentsIsNotEqualToInvoicePrice);
        return false;
      }
    }

    return true;
  }

  bool validateSignatureImage() {
    if (selectedInvoiceType.value == InvoiceType.finalinvoice && signatureFile.value == null) {
      AppSnackBar.snackbarRed(title: s.error, subtitle: s.isRequired(s.signatureImage));
      return false;
    }

    return true;
  }

  Future<bool> _createInstallmentsTable() async {
    final created = await bottomSheet<bool>(
      child: CreateInstallmentsTableSheet(ctrl: this),
    );

    return created == true;
  }

  // Calculations
  Decimal get totalProductsPriceBeforeDiscount {
    Decimal total = Decimal.zero;
    for (final product in products) {
      final price = Decimal.tryParse(product.price.numericOnly()) ?? Decimal.zero;
      total += (price * product.count.toDecimal());
    }
    return total;
  }

  Decimal get totalProductsPriceAfterDiscount {
    Decimal total = Decimal.zero;
    for (final product in products) {
      final price = Decimal.tryParse(product.price.numericOnly()) ?? Decimal.zero;
      final discount = Decimal.tryParse(product.discount?.numericOnly() ?? '0') ?? Decimal.zero;
      total += (price * product.count.toDecimal()) - discount;
    }
    return total;
  }

  Decimal get totalProductsDiscountAmount {
    Decimal total = Decimal.zero;
    for (final InvoiceProduct product in products) {
      final discount = Decimal.tryParse(product.discount?.numericOnly() ?? '0') ?? Decimal.zero;
      total += discount;
    }
    return total;
  }

  Decimal get discountAmount {
    if (discountPercentage.value == 0) return Decimal.zero;
    final discount = discountPercentage.value;
    final discountRate = Decimal.parse((discount / 100).toString());
    final amount = (totalProductsPriceAfterDiscount * discountRate);
    return amount;
  }

  Decimal get taxAmount {
    if (taxesPercentage.value == 0) return Decimal.zero;
    final tax = taxesPercentage.value;
    final taxRate = Decimal.parse((tax / 100).toString());
    final amount = (totalProductsPriceAfterDiscount - discountAmount) * taxRate;
    final decimalAmount = Decimal.parse(amount.toString());
    return decimalAmount;
  }

  Decimal get interestAmount {
    if (selectedPaymentTerms.value != PaymentTerms.installment) return Decimal.zero;
    if (interestPercentage.value == 0) return Decimal.zero;
    if (installmentStartDate == null) return Decimal.zero;
    if (createdDate == null) return Decimal.zero;

    List<Jalali> dueDates = [];

    if (installmentPayments.isNotEmpty) {
      final instalments = List<InstallmentParams>.from(installmentPayments);
      instalments.sort((final a, final b) => a.dateToPay.compareTo(b.dateToPay));
      for (final payment in instalments) {
        dueDates.add(payment.dateToPay);
      }
    } else {
      dueDates = [
        installmentStartDate!,
        for (int i = 1; i < installmentCount; i++) installmentStartDate!.addMonths(installmentPeriod * i),
      ];
    }

    final calc = MurabahaInstallmentCalculator(
      principalAmount: finalPrice,
      annualRate: interestPercentage.value.toDecimal(),
      invoiceDate: createdDate!,
      dueDates: dueDates,
    );
    return calc.getTotalInterestAmount();
  }

  Decimal get finalPrice {
    final totalPrice = totalProductsPriceAfterDiscount - discountAmount;
    final baseAmount = totalPrice + taxAmount + shippingCostAmount.value.toDecimal();
    return baseAmount;
  }

  Decimal get finalPriceWithInterest {
    if (installmentPayments.isEmpty) return finalPrice;
    if (createdDate == null) return finalPrice;

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

  Decimal get installmentsImbalance {
    if (installmentPayments.isEmpty) return Decimal.zero;
    final totalInstallments = installmentPayments.fold(
      Decimal.zero,
      (final prev, final element) => prev + element.totalAmount,
    );
    return finalPriceWithInterest - totalInstallments;
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
        for (int i = 1; i < installmentCount; i++) installmentStartDate!.addMonths(installmentPeriod * i),
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

  void addInstallment(final Decimal amount, final Jalali date, [final bool balancing = true]) {
    final newInstallment = InstallmentParams(
      totalAmount: amount,
      dateToPay: date,
    );
    installmentPayments.add(newInstallment);

    _sortInstallments();

    if (balancing && installmentPayments.length > 1) {
      final index = installmentPayments.indexOf(newInstallment);
      _balanceAfterEdit(index, amount);
    }
  }

  void _sortInstallments() {
    installmentPayments.sort((final a, final b) => a.dateToPay.compareTo(b.dateToPay));
  }

  void removeInstallment(final int index) {
    if (index >= 0 && index < installmentPayments.length) {
      installmentPayments.removeAt(index);

      _sortInstallments();

      // طبق مستند: سرشکن کردن مبلغ قسط حذف شده به تمام اقساط باقیمانده به طور مساوی
      if (installmentPayments.isNotEmpty) {
        final currentTotal = installmentPayments.fold(Decimal.zero, (final sum, final e) => sum + e.totalAmount);
        final diff = currentTotal - finalPriceWithInterest;
        final share = (diff / installmentPayments.length.toDecimal()).toDecimal(scaleOnInfinitePrecision: 0);

        Decimal distributed = Decimal.zero;

        for (int i = 0; i < installmentPayments.length; i++) {
          final bool isLast = i == installmentPayments.length - 1;
          final amountToSubtract = isLast ? (diff - distributed) : share;

          final current = installmentPayments[i];
          installmentPayments[i] = current.copyWith(
            totalAmount: current.totalAmount - amountToSubtract,
          );
          distributed += amountToSubtract;
        }
      }
    }
  }

  void updateInstallment(final int index, final Decimal amount, final Jalali date, [final bool balancing = true]) {
    if (index >= 0 && index < installmentPayments.length) {
      final updated = installmentPayments[index].copyWith(
        totalAmount: amount,
        dateToPay: date,
      );
      installmentPayments[index] = updated;

      _sortInstallments();

      if (balancing && installmentPayments.length > 1) {
        final newIndex = installmentPayments.indexOf(updated);
        _balanceAfterEdit(newIndex, amount);
      }
    }
  }

  void _balanceAfterEdit(final int editedIndex, final Decimal newAmount) {
    final otherCount = installmentPayments.length - 1;
    if (otherCount <= 0) return;

    // مبلغ باقیمانده کل (مبلغ کل قابل پرداخت منهای مبلغ جدید قسط ویرایش شده)
    final remainingTotal = finalPriceWithInterest - newAmount;
    // تقسیم بر تعداد سایر اقساط
    final share = (remainingTotal / otherCount.toDecimal()).toDecimal(scaleOnInfinitePrecision: 0);

    Decimal distributed = Decimal.zero;
    for (int i = 0; i < installmentPayments.length; i++) {
      if (i == editedIndex) continue;

      final bool isLastOther = (editedIndex == installmentPayments.length - 1)
          ? (i == installmentPayments.length - 2)
          : (i == installmentPayments.length - 1);

      final amountToSet = isLastOther ? (remainingTotal - distributed) : share;

      final current = installmentPayments[i];
      installmentPayments[i] = current.copyWith(totalAmount: amountToSet);
      distributed += amountToSet;
    }
  }

  void onShippingCostFieldChanged() {
    if (shipping.value == false) {
      shippingCostAmount(0);
      return;
    }

    if (shippingCostController.text.trim().isEmpty) {
      shippingCostAmount(0);
      return;
    }

    final amount = int.tryParse(shippingCostController.text.numericOnly()) ?? 0;
    shippingCostAmount(amount);
  }

  // Watch for changes that affect installments
  void onFinancialFieldsChanged() {
    if (selectedPaymentTerms.value != PaymentTerms.installment && installmentPayments.isNotEmpty) {
      installmentPayments.clear();
    }
  }

  void addProduct(final InvoiceProduct product) {
    products.add(product);
    onFinancialFieldsChanged();
  }

  void removeProduct(final int index) {
    if (index >= 0 && index < products.length) {
      products.removeAt(index);
      if (_expandedProductIndex.value == index) {
        _expandedProductIndex.value = -1;
      } else if (_expandedProductIndex.value > index) {
        _expandedProductIndex.value = _expandedProductIndex.value - 1;
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

  Future<void> submitInvoice() async {
    if (!validateSignatureImage()) return;

    await appShowYesCancelDialog(
      title: s.issueInvoice,
      description: s.issueInvoiceConfirmation,
      onYesButtonTap: () async {
        AppNavigator.back();
        try {
          isLoading(true);

          // Build product list
          final productList = products
              .map(
                (final InvoiceProduct p) => InvoiceProductParams(
                  title: p.title,
                  count: p.count,
                  price: p.price.replaceAll(',', ''),
                  discount: p.discount?.replaceAll(',', ''),
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
            productList: productList,
            createdDate: createdDate!.toDateTime().toIso8601String(),
            validityDate: validityDate?.toDateTime().toIso8601String(),
            signatureId: signatureFile.value?.fileId,
            description: descriptionController.text.trim().isNotEmpty ? descriptionController.text.trim() : null,
            discount: discountPercentage.value,
            taxes: taxesPercentage.value,
            shipping: shipping.value,
            shippingCost: shippingCostAmount.value,
            interestPercentage: interestPercentage.value,
            latePenaltyEnabled: latePenaltyEnabled.value,
            latePenaltyRate: latePenaltyRate.value,
            latePenaltyCap: latePenaltyCapController.text.trim().replaceAll(',', '').isNotEmpty
                ? latePenaltyCapController.text.trim().replaceAll(',', '')
                : null,
            installmentPayments: selectedPaymentTerms.value == PaymentTerms.installment && installmentPayments.isNotEmpty
                ? installmentPayments.toList()
                : null,
          );

          final result = await _createInvoiceUseCase(params);
          isLoading(false);

          if (Get.isRegistered<InvoiceListController>()) {
            Get.find<InvoiceListController>().addInvoice(result);
          }

          AppNavigator.back();
          AppSnackBar.snackbarGreen(title: s.done, subtitle: '');
        } catch (e) {
          isLoading(false);
          AppSnackBar.snackbarRed(
            title: s.error,
            subtitle: e.toString(),
          );
        }
      },
    );
  }
}
