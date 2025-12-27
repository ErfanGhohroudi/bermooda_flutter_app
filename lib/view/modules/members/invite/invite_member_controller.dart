import 'package:u/utilities.dart';

import '../../../../core/widgets/image_files.dart';
import '../../../../core/core.dart';
import '../../../../core/navigator/navigator.dart';
import '../../../../core/services/subscription_service.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../data/data.dart';

mixin InviteMemberController {
  late final bool showDepartmentField;
  final _subService = Get.find<SubscriptionService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();
  final MemberDatasource _memberDatasource = Get.find<MemberDatasource>();
  final HumanResourceDatasource _humanResourceDatasource = Get.find<HumanResourceDatasource>();
  final WorkShiftDatasource _workShiftsDatasource = Get.find<WorkShiftDatasource>();
  final DropdownDatasource _dropdownDatasource = Get.find<DropdownDatasource>();
  MemberReadDto? member;
  final Rx<ActionApiType> actionApiType = ActionApiType.create.obs;
  final Rx<PageState> buttonState = PageState.loaded.obs;
  final RxList<DropdownItemReadDto> departments = <DropdownItemReadDto>[].obs;
  final RxList<DropdownItemReadDto> workShifts = <DropdownItemReadDto>[].obs;
  final RxList<DropdownItemReadDto> states = <DropdownItemReadDto>[].obs;
  final RxList<DropdownItemReadDto> cities = <DropdownItemReadDto>[].obs;
  final RxList<DropdownItemReadDto> studyCategories = <DropdownItemReadDto>[].obs;
  final Rx<PageState> departmentsState = PageState.loading.obs;
  final Rx<PageState> workShiftsState = PageState.loading.obs;
  final Rx<PageState> statesState = PageState.loaded.obs;
  final Rx<PageState> citiesState = PageState.loaded.obs;
  final Rx<PageState> studyCategoriesState = PageState.loaded.obs;
  final TextEditingController favoriteController = TextEditingController();
  final TextEditingController skillController = TextEditingController();
  bool isUploadingFile = false;

  ///
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  List<PermissionReadDto> permissions = <PermissionReadDto>[];
  late DropdownItemReadDto? department;
  DropdownItemReadDto? selectedWorkShift;

  ///
  final Rx<bool> additionalInfo = false.obs;
  final TextEditingController nationalIDController = TextEditingController();
  final TextEditingController birthCertificateNumberController = TextEditingController();
  String? dateOfBirth;
  final Rx<GenderType> gender = GenderType.male.obs;
  MilitaryStatus? militaryStatus;
  final Rx<bool> marriage = false.obs;
  int numberOfChildren = 0;
  final TextEditingController emailController = TextEditingController();
  EducationType? educationType;
  DropdownItemReadDto? selectedStudyCategory;
  DropdownItemReadDto? selectedState;
  DropdownItemReadDto? selectedCity;
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  ///
  bool employmentInfo = false;
  final TextEditingController employmentRoleController = TextEditingController();
  final TextEditingController personnelCodeController = TextEditingController();
  EmploymentType? employmentType;
  SalaryType? salaryType;
  InsuranceType? insuranceType;
  String? startContractDate;
  String? endContractDate;
  final TextEditingController ibanController = TextEditingController();
  final RxList<String> favoritesList = <String>[].obs;
  final RxList<String> skillsList = <String>[].obs;
  MainFileReadDto? criminalRecord;

  ///
  final Rx<bool> emergencyInformation = false.obs;
  final TextEditingController emergencyFirstNameController = TextEditingController();
  final TextEditingController emergencyLastNameController = TextEditingController();
  final TextEditingController emergencyPhoneNumberController = TextEditingController();
  final TextEditingController emergencyRelationshipController = TextEditingController();

  bool get hrModuleIsActive => _subService.hrModuleIsActive;

  bool get showAccessLevels => member != null && (member?.type.isMember() ?? false);

  bool get employmentInfoStatus =>
      employmentRoleController.text.isNotEmpty ||
      employmentType != null ||
      salaryType != null ||
      insuranceType != null ||
      startContractDate != null ||
      endContractDate != null ||
      ibanController.text.isNotEmpty ||
      favoritesList.isNotEmpty ||
      skillsList.isNotEmpty ||
      criminalRecord != null;

  void disposeItems() {
    scrollController.dispose();
    actionApiType.close();
    buttonState.close();
    departments.close();
    workShifts.close();
    states.close();
    cities.close();
    studyCategories.close();
    departmentsState.close();
    workShiftsState.close();
    statesState.close();
    citiesState.close();
    studyCategoriesState.close();
    favoriteController.dispose();
    skillController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    additionalInfo.close();
    nationalIDController.dispose();
    birthCertificateNumberController.dispose();
    gender.close();
    marriage.close();
    emailController.dispose();
    postalCodeController.dispose();
    addressController.dispose();
    employmentRoleController.dispose();
    personnelCodeController.dispose();
    ibanController.dispose();
    favoritesList.close();
    skillsList.close();
    emergencyInformation.close();
    emergencyFirstNameController.dispose();
    emergencyLastNameController.dispose();
    emergencyPhoneNumberController.dispose();
    emergencyRelationshipController.dispose();
  }

  void initialController({
    required final bool showDepartmentField,
    final MemberReadDto? member,
    final HRDepartmentReadDto? department,
  }) {
    this.showDepartmentField = showDepartmentField;
    this.member = member;
    this.department = department == null ? null : DropdownItemReadDto(title: department.title, slug: department.slug);
    if (this.member != null) {
      actionApiType.toUpdate();
      _setValues();
    }
    _getDepartments();
    _getWorkShifts();
  }

  void _setValues() {
    firstNameController.text = member?.firstName ?? '';
    lastNameController.text = member?.lastName ?? '';
    phoneNumberController.text = member?.userAccount?.phoneNumber ?? '';
    permissions = member?.permissions?.reversed.toList() ?? [];
    if (member?.workShift != null && hrModuleIsActive) {
      selectedWorkShift = DropdownItemReadDto(
        slug: member?.workShift?.slug,
        title: member?.workShift?.title,
      );
    }
    additionalInfo(member?.moreInformation);
    if (additionalInfo.value) {
      _getStates();
      _getStudyCategories();
      nationalIDController.text = member?.nationalCode ?? '';
      birthCertificateNumberController.text = member?.certificateNumber ?? '';
      dateOfBirth = member?.dateOfBirthPersian;
      gender(member?.gender);
      militaryStatus = member?.militaryStatus;
      marriage(member?.marriage);
      numberOfChildren = member?.numberOfChildren ?? 0;
      emailController.text = member?.email ?? '';
      educationType = member?.educationType;
      postalCodeController.text = member?.postalCode ?? '';
      addressController.text = member?.address ?? '';
      selectedState = member?.state;
      selectedCity = member?.city;
      selectedStudyCategory = member?.studyCategory;
      employmentRoleController.text = member?.jobPosition ?? '';
      personnelCodeController.text = member?.personnelCode ?? '';
      employmentType = member?.employmentType;
      salaryType = member?.salaryType;
      insuranceType = member?.insuranceType;
      startContractDate = member?.dateOfStartToWorkPersian;
      endContractDate = member?.contractEndDatePersian;
      ibanController.text = member?.shabaNumber ?? '';
      favoritesList(member?.favorites);
      skillsList(member?.skills);
      criminalRecord = member?.badRecord;
      emergencyInformation(member?.isEmergencyInformation);
      emergencyFirstNameController.text = member?.emergencyFirstName ?? '';
      emergencyLastNameController.text = member?.emergencyLastName ?? '';
      emergencyPhoneNumberController.text = member?.emergencyPhoneNumber ?? '';
      emergencyRelationshipController.text = member?.emergencyRelationship ?? '';
      employmentInfo = employmentInfoStatus;
    }
  }

  void callApi({required final Function(MemberReadDto member) onResponse}) {
    validateForm(
      key: formKey,
      action: () {
        WImageFiles.checkFileUploading(
          isUploadingFile: isUploadingFile,
          action: () {
            buttonState.loading();
            switch (actionApiType.value) {
              case ActionApiType.create:
                _create(onResponse: onResponse);
                break;
              case ActionApiType.update:
                _update(onResponse: onResponse);
                break;
              default:
                buttonState.loaded();
                break;
            }
          },
        );
      },
    );
  }

  void setNewDepartment(final DropdownItemReadDto? newValue) {
    if (newValue != null && department?.slug != newValue.slug) {
      department = newValue;
      selectedWorkShift = null;
      _getWorkShifts();
    }
  }

  void toggleAdditionalInfoSwitch() {
    additionalInfo(!additionalInfo.value);
    if (additionalInfo.value && states.isEmpty && statesState.isLoaded()) {
      _getStates();
    }
    if (additionalInfo.value && studyCategories.isEmpty && studyCategoriesState.isLoaded()) {
      _getStudyCategories();
    }
  }

  void setProvince(final DropdownItemReadDto? value) {
    selectedState = value;
    selectedCity = null;
    statesState.refresh();
    _getCities();
  }

  void onEnteredFavorite() {
    if (favoriteController.text.trim() != '' && favoriteController.text.trim().length >= 3) {
      final i = favoritesList.indexOf(favoriteController.text.trim());
      if (i != -1) {
        return AppNavigator.snackbarRed(title: s.warning, subtitle: s.thisIsExist.replaceAll('#', s.favorite));
      }
      favoritesList.add(favoriteController.text.trim());
      favoriteController.clear();
    } else if (favoriteController.text == '') {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  void removeFavorite(final String value) {
    final i = favoritesList.indexOf(value);
    if (i != -1) {
      favoritesList.remove(value);
    }
  }

  void onEnteredSkill() {
    if (skillController.text.trim() != '') {
      final i = skillsList.indexOf(skillController.text.trim());
      if (i != -1) {
        return AppNavigator.snackbarRed(title: s.warning, subtitle: s.thisIsExist.replaceAll('#', s.skill));
      }
      skillsList.add(skillController.text.trim());
      skillController.clear();
    } else if (skillController.text == '') {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  void removeSkill(final String value) {
    final i = skillsList.indexOf(value);
    if (i != -1) {
      skillsList.remove(value);
    }
  }

  //---------------------------------------------------------------------
  // Call APIs
  //---------------------------------------------------------------------

  void _getDepartments() {
    if (hrModuleIsActive == false || showDepartmentField == false) {
      departmentsState.loaded();
      return;
    }

    _humanResourceDatasource.getAllDepartmentsForDropdown(
      onResponse: (final response) {
        if (departments.subject.isClosed || departmentsState.subject.isClosed) return;
        departments(response.resultList);
        departmentsState.loaded();
      },
      onError: (final errorResponse) {
        if (departmentsState.subject.isClosed) return;
        departmentsState.loaded();
      },
      withRetry: true,
    );
  }

  void _getWorkShifts() {
    if (hrModuleIsActive == false) {
      workShiftsState.loaded();
      return;
    }

    if (department?.slug == null) {
      workShiftsState.loading();
      workShiftsState.loaded();
      return;
    }
    workShiftsState.loading();
    _workShiftsDatasource.getAllWorkShiftsForDropdown(
      slug: department?.slug,
      onResponse: (final response) {
        workShifts(response.resultList);
        workShiftsState.loaded();
      },
      onError: (final errorResponse) => workShiftsState.loaded(),
      withRetry: true,
    );
  }

  void _getStudyCategories() {
    studyCategoriesState.loading();
    _dropdownDatasource.getStudyCategories(
      onResponse: (final response) {
        studyCategories(response.resultList);
        studyCategoriesState.loaded();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void _getStates() {
    statesState.loading();
    _dropdownDatasource.getAllState(
      onResponse: (final response) {
        states(response.resultList);
        if (selectedState != null) {
          _getCities();
        }
        statesState.loaded();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void _getCities() {
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

  void _create({required final Function(MemberReadDto member) onResponse}) {
    _memberDatasource.create(
      dto: CreateMemberParams(
        folderSlug: department?.slug,
        workShiftSlug: selectedWorkShift?.slug,
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        phoneNumber: phoneNumberController.text,
        permissions: permissions,
        //
        moreInformation: additionalInfo.value,
        nationalCode: nationalIDController.text.isNotEmpty ? nationalIDController.text : null,
        certificateNumber: birthCertificateNumberController.text.isNotEmpty ? birthCertificateNumberController.text : null,
        dateOfBirthJalali: dateOfBirth,
        gender: gender.value,
        militaryStatus: militaryStatus,
        marriage: marriage.value,
        numberOfChildren: numberOfChildren,
        email: emailController.text.isNotEmpty ? emailController.text.trim() : null,
        educationType: educationType,
        studyCategoryId: selectedStudyCategory?.id,
        stateId: selectedState?.id,
        cityId: selectedCity?.id,
        postalCode: postalCodeController.text.isNotEmpty ? postalCodeController.text : null,
        address: addressController.text.isNotEmpty ? addressController.text.trim() : null,
        //
        jobPosition: employmentRoleController.text.isNotEmpty ? employmentRoleController.text.trim() : null,
        employmentType: employmentType,
        salaryType: salaryType,
        insuranceType: insuranceType,
        dateOfStartToWorkJalali: startContractDate,
        contractEndDateJalali: endContractDate,
        shabaNumber: ibanController.text.isNotEmpty ? ibanController.text : null,
        favorites: favoritesList,
        skills: skillsList,
        badRecordId: additionalInfo.value ? criminalRecord?.fileId : null,
        //
        isEmergencyInformation: emergencyInformation.value,
        emergencyFirstName: emergencyFirstNameController.text.isNotEmpty ? emergencyFirstNameController.text.trim() : null,
        emergencyLastName: emergencyLastNameController.text.isNotEmpty ? emergencyLastNameController.text.trim() : null,
        emergencyPhoneNumber: emergencyPhoneNumberController.text.isNotEmpty ? emergencyPhoneNumberController.text : null,
        emergencyRelationship: emergencyRelationshipController.text.isNotEmpty
            ? emergencyRelationshipController.text.trim()
            : null,
      ),
      onResponse: (final response) {
        onResponse(response.result!);
      },
      onError: (final errorResponse) {
        buttonState.loaded();
      },
      withRetry: true,
    );
  }

  void _update({required final Function(MemberReadDto member) onResponse}) {
    if (member?.id != null) {
      _memberDatasource.update(
        id: member!.id!,
        dto: CreateMemberParams(
          folderSlug: department?.slug,
          workShiftSlug: selectedWorkShift?.slug,
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          phoneNumber: phoneNumberController.text,
          permissions: permissions,
          //
          moreInformation: additionalInfo.value,
          nationalCode: nationalIDController.text.isNotEmpty ? nationalIDController.text : null,
          certificateNumber: birthCertificateNumberController.text.isNotEmpty ? birthCertificateNumberController.text : null,
          dateOfBirthJalali: dateOfBirth,
          gender: gender.value,
          militaryStatus: militaryStatus,
          marriage: marriage.value,
          numberOfChildren: numberOfChildren,
          email: emailController.text.isNotEmpty ? emailController.text.trim() : null,
          educationType: educationType,
          studyCategoryId: selectedStudyCategory?.id,
          stateId: selectedState?.id,
          cityId: selectedCity?.id,
          postalCode: postalCodeController.text.isNotEmpty ? postalCodeController.text : null,
          address: addressController.text.isNotEmpty ? addressController.text.trim() : null,
          //
          jobPosition: employmentRoleController.text.isNotEmpty ? employmentRoleController.text.trim() : null,
          employmentType: employmentType,
          salaryType: salaryType,
          insuranceType: insuranceType,
          dateOfStartToWorkJalali: startContractDate,
          contractEndDateJalali: endContractDate,
          shabaNumber: ibanController.text.isNotEmpty ? ibanController.text : null,
          favorites: favoritesList,
          skills: skillsList,
          badRecordId: additionalInfo.value ? criminalRecord?.fileId : null,
          //
          isEmergencyInformation: emergencyInformation.value,
          emergencyFirstName: emergencyFirstNameController.text.isNotEmpty ? emergencyFirstNameController.text.trim() : null,
          emergencyLastName: emergencyLastNameController.text.isNotEmpty ? emergencyLastNameController.text.trim() : null,
          emergencyPhoneNumber: emergencyPhoneNumberController.text.isNotEmpty ? emergencyPhoneNumberController.text : null,
          emergencyRelationship: emergencyRelationshipController.text.isNotEmpty
              ? emergencyRelationshipController.text.trim()
              : null,
        ),
        onResponse: (final response) {
          onResponse(response.result!);
        },
        onError: (final errorResponse) {
          buttonState.loaded();
        },
        withRetry: true,
      );
    }
  }
}
