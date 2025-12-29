import 'package:u/utilities.dart';

import '../../../../../core/widgets/image_files.dart';
import '../../../../../core/services/permission_service.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/data.dart';
import '../../../reports/controllers/crm/crm_customer_reports_controller.dart';

mixin CustomerCreateUpdateController {
  final CustomerDatasource _customerDatasource = Get.find<CustomerDatasource>();
  final DropdownDatasource _dropdownDatasource = Get.find<DropdownDatasource>();
  final PermissionService _perService = Get.find();
  CustomerReadDto? customer;
  late String crmCategoryId;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Rx<PageState> buttonState = PageState.loaded.obs;
  bool isUploadingFile = false;
  final Rx<PageState> industryState = PageState.loaded.obs;
  final RxList<DropdownItemReadDto> industries = <DropdownItemReadDto>[].obs;
  final Rx<PageState> statesState = PageState.loaded.obs;
  final Rx<PageState> citiesState = PageState.loaded.obs;
  final RxList<DropdownItemReadDto> states = <DropdownItemReadDto>[].obs;
  final RxList<DropdownItemReadDto> cities = <DropdownItemReadDto>[].obs;

  bool get haveAccess => _perService.haveCRMAccess;

  CrmSectionReadDto? selectedSection;
  MainFileReadDto? avatar;
  final Rx<AuthenticationType> personalType = AuthenticationType.values.first.obs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  // CurrencyUnitReadDto? selectedCurrency;
  final RxInt salesProbability = 0.obs;
  ConnectionType? selectedContactPreference;
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController socialMediaLinkController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  DropdownItemReadDto? selectedCategory;
  List<LabelReadDto> selectedLabels = [];
  final Rx<PageState> categoryState = PageState.loaded.obs;
  final TextEditingController landlineController = TextEditingController();
  final TextEditingController extensionController = TextEditingController();
  DropdownItemReadDto? selectedIndustry;

  /// Agent values
  final TextEditingController agentNameController = TextEditingController();
  final TextEditingController agentPhoneNumberController = TextEditingController();
  final TextEditingController agentLandlineController = TextEditingController();
  final TextEditingController agentLandlineExtController = TextEditingController();
  final TextEditingController agentRoleController = TextEditingController();
  final TextEditingController agentLinkController = TextEditingController();
  final TextEditingController agentEmailController = TextEditingController();

  /// person values
  GenderType? genderType;

  /// Additional Info values
  DropdownItemReadDto? selectedState;
  DropdownItemReadDto? selectedCity;
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController shebaNumberController = TextEditingController();
  final TextEditingController certificateNumberController = TextEditingController();
  String? dateOfBirth;

  /// Legal Info
  final TextEditingController faxController = TextEditingController();
  final TextEditingController nationalIDController = TextEditingController();
  final TextEditingController companyNationalIDController = TextEditingController();
  final TextEditingController economicNumberController = TextEditingController();

  bool get isCreate => customer == null;

  void disposeItems() {
    buttonState.close();
    industries.close();
    statesState.close();
    citiesState.close();
    states.close();
    cities.close();
    //
    personalType.close();
    nameController.dispose();
    amountController.dispose();
    salesProbability.close();
    phoneNumberController.dispose();
    emailController.dispose();
    socialMediaLinkController.dispose();
    linkController.dispose();
    categoryState.close();
    landlineController.dispose();
    extensionController.dispose();
    agentNameController.dispose();
    agentPhoneNumberController.dispose();
    agentLandlineController.dispose();
    agentLandlineExtController.dispose();
    agentRoleController.dispose();
    agentLinkController.dispose();
    agentEmailController.dispose();
    //
    postalCodeController.dispose();
    addressController.dispose();
    shebaNumberController.dispose();
    certificateNumberController.dispose();
    faxController.dispose();
    nationalIDController.dispose();
    companyNationalIDController.dispose();
    economicNumberController.dispose();
  }

  void setValues(final CustomerReadDto? model, final CrmSectionReadDto? section) {
    getIndustrials();
    getStates();
    selectedSection = section ?? model?.section;
    avatar = model?.avatar;
    personalType(model?.personalType);
    genderType = model?.gender;
    selectedIndustry = model?.industrialActivity;
    selectedCategory = model?.industrySubcategory;
    selectedLabels = model?.labels ?? selectedLabels;
    nameController.text = model?.fullNameOrCompanyName ?? '';
    amountController.text = model?.amount ?? '';
    // selectedCurrency = model?.currency;
    salesProbability(model?.salesProbability ?? 0);
    selectedContactPreference = model?.connectionType;
    phoneNumberController.text = model?.phoneNumber ?? '';
    emailController.text = model?.email ?? '';
    socialMediaLinkController.text = model?.socialMediaLink ?? '';
    linkController.text = model?.website ?? '';
    landlineController.text = model?.landline ?? '';
    extensionController.text = model?.extension ?? '';
    agentNameController.text = model?.agentName ?? '';
    agentPhoneNumberController.text = model?.agentPhoneNumber ?? '';
    agentLandlineController.text = model?.agentLandline ?? '';
    agentLandlineExtController.text = model?.agentLandlineExt ?? '';
    agentRoleController.text = model?.agentPosition ?? '';
    agentLinkController.text = model?.agentLink ?? '';
    agentEmailController.text = model?.agentEmail ?? '';
    selectedState = model?.state;
    selectedCity = model?.city;
    postalCodeController.text = model?.postalCode ?? '';
    addressController.text = model?.address ?? '';
    shebaNumberController.text = model?.shebaNumber ?? '';
    certificateNumberController.text = model?.certificateNumber ?? '';
    dateOfBirth = model?.birthday;
    faxController.text = model?.fax ?? '';
    nationalIDController.text = model?.nationalCode ?? '';
    companyNationalIDController.text = model?.companyNationalCode ?? '';
    economicNumberController.text = model?.economicCode ?? '';
  }

  void onSubmit({required final Function(CustomerReadDto model) onResponse}) {
    validateForm(
      key: formKey,
      action: () {
        WImageFiles.checkFileUploading(
          isUploadingFile: isUploadingFile,
          action: () {
            buttonState.loading();
            if (isCreate) {
              create(onResponse: onResponse);
            } else {
              update(onResponse: onResponse);
            }
          },
        );
      },
    );
  }

  void _reloadReports() {
    if (Get.isRegistered<CrmCustomerReportsController>()) {
      Get.find<CrmCustomerReportsController>().onInit();
    }
  }

  void create({required final Function(CustomerReadDto model) onResponse}) {
    _customerDatasource.create(
      dto: CustomerParams(
        crmCategoryId: crmCategoryId,
        avatarId: avatar?.fileId,
        sectionId: selectedSection?.id,
        personalType: personalType.value,
        gender: genderType,
        industry: selectedIndustry,
        industrySubCategory: selectedCategory,
        labels: selectedLabels,
        fullNameOrCompanyName: nameController.text.trim().isNotEmpty ? nameController.text.trim() : null,
        amount: amountController.text.trim().isNotEmpty ? amountController.text.trim() : null,
        // currency: amountController.text.trim().isNotEmpty && selectedCurrency != null ? selectedCurrency : null,
        salesProbability: salesProbability.value,
        connectionType: selectedContactPreference,
        phoneNumber: phoneNumberController.text.trim().isNotEmpty ? phoneNumberController.text.trim() : null,
        email: emailController.text.trim().isNotEmpty ? emailController.text.trim() : null,
        socialMediaLink: socialMediaLinkController.text.trim().isNotEmpty ? socialMediaLinkController.text.trim() : null,
        website: linkController.text.trim().isNotEmpty ? linkController.text.trim() : null,
        landline: landlineController.text.trim().isNotEmpty ? landlineController.text.trim() : null,
        extension: landlineController.text.trim().isNotEmpty && extensionController.text.trim().isNotEmpty
            ? extensionController.text.trim()
            : null,
        state: selectedState,
        city: selectedCity,
        postalCode: postalCodeController.text.trim().isNotEmpty ? postalCodeController.text.trim() : null,
        address: addressController.text.trim().isNotEmpty ? addressController.text.trim() : null,
        shebaNumber: shebaNumberController.text.trim().isNotEmpty ? shebaNumberController.text.trim() : null,
        certificateNumber: personalType.isPerson() && certificateNumberController.text.trim().isNotEmpty
            ? certificateNumberController.text.trim()
            : null,
        birthday: personalType.isPerson() ? dateOfBirth : null,
        fax: faxController.text.trim().isNotEmpty ? faxController.text.trim() : null,
        nationalCode: personalType.isPerson() && nationalIDController.text.trim().isNotEmpty
            ? nationalIDController.text.trim()
            : null,
        companyNationalCode: personalType.isLegal() && companyNationalIDController.text.trim().isNotEmpty
            ? companyNationalIDController.text.trim()
            : null,
        economicCode: personalType.isLegal() && economicNumberController.text.trim().isNotEmpty
            ? economicNumberController.text.trim()
            : null,
        agentName: agentNameController.text.trim().isNotEmpty ? agentNameController.text.trim() : null,
        agentPhoneNumber: agentPhoneNumberController.text.trim().isNotEmpty ? agentPhoneNumberController.text.trim() : null,
        agentLandline: agentLandlineController.text.trim().isNotEmpty ? agentLandlineController.text.trim() : null,
        agentLandlineExt: agentLandlineExtController.text.trim().isNotEmpty ? agentLandlineExtController.text.trim() : null,
        agentPosition: agentRoleController.text.trim().isNotEmpty ? agentRoleController.text.trim() : null,
        agentLink: agentLinkController.text.trim().isNotEmpty ? agentLinkController.text.trim() : null,
        agentEmail: agentEmailController.text.trim().isNotEmpty ? agentEmailController.text.trim() : null,
      ),
      onResponse: (final response) {
        onResponse(response.result!);
        buttonState.loaded();
        _reloadReports();
      },
      onError: (final errorResponse) {
        buttonState.loaded();
      },
      withRetry: true,
    );
  }

  void update({required final Function(CustomerReadDto model) onResponse}) {
    _customerDatasource.update(
      id: customer?.id,
      dto: CustomerParams(
        crmCategoryId: crmCategoryId,
        avatarId: avatar?.fileId,
        sectionId: selectedSection?.id,
        personalType: personalType.value,
        gender: genderType,
        industry: selectedIndustry,
        fullNameOrCompanyName: nameController.text.trim().isNotEmpty ? nameController.text.trim() : null,
        amount: amountController.text.trim().isNotEmpty ? amountController.text.trim() : null,
        // currency: amountController.text.trim().isNotEmpty && selectedCurrency != null ? selectedCurrency : null,
        salesProbability: salesProbability.value,
        connectionType: selectedContactPreference,
        phoneNumber: phoneNumberController.text.trim().isNotEmpty ? phoneNumberController.text : null,
        email: emailController.text.trim().isNotEmpty ? emailController.text.trim() : null,
        socialMediaLink: socialMediaLinkController.text.trim().isNotEmpty ? socialMediaLinkController.text.trim() : null,
        website: linkController.text.trim().isNotEmpty ? linkController.text.trim() : null,
        industrySubCategory: selectedCategory,
        labels: selectedLabels,
        landline: landlineController.text.trim().isNotEmpty ? landlineController.text.trim() : null,
        extension: landlineController.text.trim().isNotEmpty && extensionController.text.trim().isNotEmpty
            ? extensionController.text.trim()
            : null,
        state: selectedState,
        city: selectedCity,
        postalCode: postalCodeController.text.trim().isNotEmpty ? postalCodeController.text.trim() : null,
        address: addressController.text.trim().isNotEmpty ? addressController.text.trim() : null,
        shebaNumber: shebaNumberController.text.trim().isNotEmpty ? shebaNumberController.text.trim() : null,
        certificateNumber: personalType.isPerson() && certificateNumberController.text.trim().isNotEmpty
            ? certificateNumberController.text.trim()
            : null,
        birthday: personalType.isPerson() ? dateOfBirth : null,
        fax: faxController.text.trim().isNotEmpty ? faxController.text.trim() : null,
        nationalCode: personalType.isPerson() && nationalIDController.text.trim().isNotEmpty
            ? nationalIDController.text.trim()
            : null,
        companyNationalCode: personalType.isLegal() && companyNationalIDController.text.trim().isNotEmpty
            ? companyNationalIDController.text.trim()
            : null,
        economicCode: personalType.isLegal() && economicNumberController.text.trim().isNotEmpty
            ? economicNumberController.text.trim()
            : null,
        agentName: agentNameController.text.trim().isNotEmpty ? agentNameController.text.trim() : null,
        agentPhoneNumber: agentPhoneNumberController.text.trim().isNotEmpty ? agentPhoneNumberController.text.trim() : null,
        agentLandline: agentLandlineController.text.trim().isNotEmpty ? agentLandlineController.text.trim() : null,
        agentLandlineExt: agentLandlineExtController.text.trim().isNotEmpty ? agentLandlineExtController.text.trim() : null,
        agentPosition: agentRoleController.text.trim().isNotEmpty ? agentRoleController.text.trim() : null,
        agentLink: agentLinkController.text.trim().isNotEmpty ? agentLinkController.text.trim() : null,
        agentEmail: agentEmailController.text.trim().isNotEmpty ? agentEmailController.text.trim() : null,
      ),
      onResponse: (final response) {
        onResponse(response.result!);
        buttonState.loaded();
        _reloadReports();
      },
      onError: (final errorResponse) {
        buttonState.loaded();
      },
      withRetry: true,
    );
  }

  void getIndustrials() {
    industryState.loading();
    _dropdownDatasource.getIndustrials(
      onResponse: (final response) {
        industries(response.resultList);
        industryState.loaded();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void getStates() {
    statesState.loading();
    _dropdownDatasource.getAllState(
      onResponse: (final response) {
        states(response.resultList);
        if (selectedState != null) {
          getCities();
        }
        statesState.loaded();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void getCities() {
    citiesState.loading();
    _dropdownDatasource.getCitiesByStateId(
      stateId: selectedState?.id,
      onResponse: (final response) {
        cities(response.resultList);
        citiesState.loaded();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }
}
