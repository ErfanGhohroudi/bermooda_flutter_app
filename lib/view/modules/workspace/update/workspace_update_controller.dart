import 'package:u/utilities.dart';

import '../../../../core/widgets/image_files.dart';
import '../../../../core/core.dart';
import '../../../../core/functions/user_functions.dart';
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
  final Rxn<DropdownItemReadDto> selectedIndustry = Rxn(null);
  final Rxn<BusinessSize> selectedBusinessSize = Rxn(null);
  final Rxn<DropdownItemReadDto> selectedState = Rxn(null);
  final Rxn<DropdownItemReadDto> selectedCity = Rxn(null);

  // Authentication
  final Rx<AuthenticationType> authenticationType = AuthenticationType.person.obs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nationalIDController = TextEditingController();
  final TextEditingController economicNumberController = TextEditingController();
  final TextEditingController registrationNumberController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController landlineController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

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
    authenticationType.close();
    nameController.dispose();
    nationalIDController.dispose();
    economicNumberController.dispose();
    registrationNumberController.dispose();
    phoneNumberController.dispose();
    landlineController.dispose();
    emailController.dispose();
    addressController.dispose();
  }

  void setValues(final WorkspaceInfoReadDto model) {
    _getIndustrials(
      action: () {},
    );
    avatar = model.avatar;
    titleController.text = model.title ?? '';
    authenticationType(model.personType);
    nameController.text = model.name ?? '';
    nationalIDController.text = model.nationalCode ?? '';
    economicNumberController.text = model.economicNumber ?? '';
    registrationNumberController.text = model.registrationNumber ?? '';
    phoneNumberController.text = model.phoneNumber ?? '';
    landlineController.text = model.telNumber ?? '';
    emailController.text = model.email ?? '';
    addressController.text = model.address ?? '';
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
    WorkspaceInfoParams getDto() => WorkspaceInfoParams(
      avatarId: avatar?.fileId,
      title: titleController.text.trim(),
      industryId: selectedIndustry.value?.id,
      businessSize: selectedBusinessSize.value,
      stateId: selectedState.value?.id,
      cityId: selectedCity.value?.id,
      authenticationType: authenticationType.value,
      companyName: nameController.text.trim(),
      nationalCode: nationalIDController.text.trim(),
      economicNumber: economicNumberController.text.trim(),
      phoneNumber: phoneNumberController.text.trim(),
      telNumber: landlineController.text.trim(),
      email: emailController.text.trim().isNotEmpty ? emailController.text.trim() : null,
      address: addressController.text.trim().isNotEmpty ? addressController.text.trim() : null,
    );

    IWorkspaceRequiredInfoParams getAuthDto() {
      switch (authenticationType.value) {
        case AuthenticationType.person:
          return PersonWorkspaceRequiredInfoParams(
            authenticationType: authenticationType.value,
            fullName: nameController.text.trim(),
            nationalId: nationalIDController.text.trim(),
            phoneNumber: phoneNumberController.text.trim(),
            email: emailController.text.trim().isNotEmpty ? emailController.text.trim() : null,
          );
        case AuthenticationType.legal:
          return LegalWorkspaceRequiredInfoParams(
            authenticationType: authenticationType.value,
            organizationName: nameController.text.trim(),
            nationalId: nationalIDController.text.trim(),
            registrationNumber: registrationNumberController.text.trim(),
            economicCode: economicNumberController.text.trim(),
            landline: landlineController.text.trim(),
            email: emailController.text.trim().isNotEmpty ? emailController.text.trim() : null,
          );
      }
    }

    buttonState.loading();
    _workspaceDatasource.update(
      id: workspaceInfo.id,
      dto: getDto(),
      authDto: getAuthDto(),
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
      action: action,
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
