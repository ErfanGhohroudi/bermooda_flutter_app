import 'package:u/utilities.dart';

import '../../../../core/widgets/image_files.dart';
import '../../../../core/core.dart';
import '../../../../core/functions/user_functions.dart';
import '../../../../core/navigator/navigator.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../data/data.dart';

mixin WorkspaceUpdateController {
  final core = Get.find<Core>();
  final double itemsSpacing = 18;
  final DropdownDatasource _dropdownDatasource = Get.find<DropdownDatasource>();
  final WorkspaceDatasource _workspaceDatasource = Get.find<WorkspaceDatasource>();
  late WorkspaceInfoReadDto workspaceInfo;
  final FocusNode focusNode = FocusNode();
  final Rx<bool> jadooNameIsFocus = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey();
  final Rx<PageState> pageState = PageState.initial.obs;
  final Rx<PageState> buttonState = PageState.loaded.obs;
  final RxList<DropdownItemReadDto> industries = <DropdownItemReadDto>[].obs;
  final RxList<DropdownItemReadDto> states = <DropdownItemReadDto>[].obs;
  final RxList<DropdownItemReadDto> cities = <DropdownItemReadDto>[].obs;
  final Rx<PageState> citiesState = PageState.loaded.obs;
  bool isUploadingAvatar = false;

  MainFileReadDto? avatar;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController jadooBrandNameController = TextEditingController();
  final Rx<DropdownItemReadDto?> selectedIndustry = Rx(null);
  final Rx<BusinessSize?> selectedBusinessSize = Rx(null);
  final Rx<DropdownItemReadDto?> selectedState = Rx(null);
  final Rx<DropdownItemReadDto?> selectedCity = Rx(null);
  final Rx<AuthenticationType> authenticationType = AuthenticationType.person.obs;
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController nationalIDController = TextEditingController();
  final TextEditingController economicNumberController = TextEditingController();
  final TextEditingController ibanController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController landlineController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController faxController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  MainFileReadDto? nationalIDCardFile;
  MainFileReadDto? businessRegistrationLicenseFile;

  void disposeItems() {
    focusNode.dispose();
    jadooNameIsFocus.close();
    pageState.close();
    buttonState.close();
    industries.close();
    states.close();
    cities.close();
    citiesState.close();
    titleController.dispose();
    jadooBrandNameController.dispose();
    authenticationType.close();
    companyNameController.dispose();
    nationalIDController.dispose();
    economicNumberController.dispose();
    ibanController.dispose();
    postalCodeController.dispose();
    landlineController.dispose();
    phoneNumberController.dispose();
    faxController.dispose();
    emailController.dispose();
    addressController.dispose();
  }

  void setValues(final WorkspaceInfoReadDto model) {
    _getIndustrials(
      action: () {},
    );
    avatar = model.avatar;
    titleController.text = model.title ?? '';
    jadooBrandNameController.text = model.jadooBrandName ?? '';
    authenticationType(model.personType);
    companyNameController.text = model.companyName ?? '';
    nationalIDController.text = model.nationalCode ?? '';
    economicNumberController.text = model.economicNumber ?? '';
    ibanController.text = model.bankNumber ?? '';
    postalCodeController.text = model.postalCode ?? '';
    landlineController.text = model.telNumber ?? '';
    phoneNumberController.text = model.phoneNumber ?? '';
    faxController.text = model.faxNumber ?? '';
    emailController.text = model.email ?? '';
    addressController.text = model.address ?? '';
    nationalIDCardFile = model.nationalCardImage;
    businessRegistrationLicenseFile = model.documentImage;
    selectedIndustry(model.industrialActivity);
    if (model.businessEmployer != null) {
      selectedBusinessSize(model.businessEmployer);
    }
    if (model.state != null && model.stateName != null) {
      selectedState(DropdownItemReadDto(id: model.state, title: model.stateName));
      getCities();
    }
    if (model.city != null && model.cityName != null) {
      selectedCity(DropdownItemReadDto(id: model.city, title: model.cityName));
    }
  }

  void onSubmit({required final Function(WorkspaceInfoReadDto workspaceInfo) onResponse}) {
    validateForm(
      key: formKey,
      action: () {
        _checkImages(
          action: () {
            update(onResponse: onResponse);
          },
        );
      },
    );
  }

  void update({required final Function(WorkspaceInfoReadDto workspaceInfo) onResponse}) {
    buttonState.loading();
    _workspaceDatasource.update(
      id: workspaceInfo.id,
      dto: WorkspaceInfoParams(
        avatarId: avatar?.fileId,
        title: titleController.text,
        jadooBrandName: jadooBrandNameController.text,
        industryId: selectedIndustry.value?.id,
        businessSize: selectedBusinessSize.value,
        stateId: selectedState.value?.id,
        cityId: selectedCity.value?.id,
        authenticationType: authenticationType.value,
        companyName: authenticationType.isLegal() ? companyNameController.text : null,
        nationalCode: nationalIDController.text,
        economicNumber: authenticationType.isLegal() ? economicNumberController.text : null,
        bankNumber: ibanController.text,
        postalCode: postalCodeController.text,
        telNumber: authenticationType.isLegal() && landlineController.text.isNotEmpty ? landlineController.text : null,
        phoneNumber: phoneNumberController.text,
        faxNumber: authenticationType.isLegal() && faxController.text.isNotEmpty ? faxController.text : null,
        email: emailController.text,
        address: addressController.text,
        nationalCardImageId: nationalIDCardFile?.fileId,
        documentImageId: authenticationType.isLegal() ? businessRegistrationLicenseFile?.fileId : null,
      ),
      onResponse: (final response) {
        if (response.result == null) return;
        if (response.result!.id == core.currentWorkspace.value.id) {
          getMyUser(
            action: () {
              onResponse(response.result!);
            },
          );
        }
      },
      onError: (final errorResponse) {
        buttonState.loaded();
      },
      withRetry: true,
    );
  }

  void _checkImages({required final VoidCallback action}) {
    WImageFiles.checkFileUploading(
      isUploadingFile: isUploadingAvatar,
      action: () {
        if (nationalIDCardFile == null) {
          return AppNavigator.snackbarRed(title: s.warning, subtitle: s.uploadNationalIDCardIsRequired);
        }
        if (authenticationType.isLegal() && businessRegistrationLicenseFile == null) {
          return AppNavigator.snackbarRed(title: s.warning, subtitle: s.uploadBusinessRegistrationLicenseIsRequired);
        }
        action();
      },
    );
  }

  void _getIndustrials({required final VoidCallback action}) {
    _dropdownDatasource.getIndustrials(
      onResponse: (final response) {
        industries(response.resultList);
        _getStates(action: action);
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void _getStates({required final VoidCallback action}) {
    _dropdownDatasource.getAllState(
      onResponse: (final response) {
        states(response.resultList);
        action();
        pageState.loaded();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void getCities() {
    citiesState.loading();
    _dropdownDatasource.getCitiesByStateId(
      stateId: selectedState.value?.id,
      onResponse: (final response) {
        cities(response.resultList);
        citiesState.loaded();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }
}
