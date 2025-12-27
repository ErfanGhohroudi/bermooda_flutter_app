import 'package:u/utilities.dart';

import '../../../../core/widgets/image_files.dart';
import '../../../../core/core.dart';
import '../../../../core/navigator/navigator.dart';
import '../../../../core/utils/enums/request_enums.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../data/data.dart';

mixin CreateRequestController {
  final EmployeeRequestDatasource _employeeRequestDatasource = Get.find<EmployeeRequestDatasource>();
  final GlobalKey<FormState> formKey = GlobalKey();
  final Rx<RequestCategoryType> categoryType = RequestCategoryType.values.first.obs;
  final Rx<PageState> buttonState = PageState.loaded.obs;
  Jalali? startDateTimeJalali;
  Jalali? endDateTimeJalali;

  /// Common fields
  UserReadDto? requestingUser;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  final TextEditingController descriptionController = TextEditingController();
  List<MainFileReadDto> files = [];
  bool isUploadingFile = false;
  final TextEditingController amountController = TextEditingController();

  /// Leave fields
  final Rx<LeaveType> leaveType = LeaveType.values.first.obs;
  final Rx<SickLeaveType> sickLeaveType = SickLeaveType.values.first.obs;
  final Rx<HourlyLeaveReason> hourlyLeaveReason = HourlyLeaveReason.values.first.obs;
  final Rx<CeremonialLeaveType> ceremonialLeaveType = CeremonialLeaveType.values.first.obs;
  final TextEditingController replacementEmployee = TextEditingController();
  final TextEditingController hospitalName = TextEditingController();
  String? doctorName;
  final TextEditingController relationship = TextEditingController();

  /// Mission fields
  final Rx<MissionType> missionType = MissionType.out_of_city_mission.obs;
  final Rx<MissionPurpose> missionPurpose = MissionPurpose.values.first.obs;
  final Rx<TransportationType> transportationType = TransportationType.values.first.obs;
  final Rx<AccommodationType> accommodationType = AccommodationType.values.first.obs;
  final Rx<ExpenseType> expenseType = ExpenseType.values.first.obs;
  final Rx<PaymentMethod> paymentMethod = PaymentMethod.values.first.obs;
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController exactLocationController = TextEditingController();
  final TextEditingController companionNamesController = TextEditingController();
  final TextEditingController missionNumberController = TextEditingController();
  final RxBool needsAccommodation = false.obs;

  /// Welfare fields
  final Rx<WelfareType> welfareType = WelfareType.values.first.obs;
  final Rx<LoanType> loanType = LoanType.values.first.obs;
  final Rx<RepaymentType> repaymentType = RepaymentType.values.first.obs;
  final Rx<InsuranceRequestType> insuranceType = InsuranceRequestType.values.first.obs;
  final Rx<AllowanceType> allowanceType = AllowanceType.values.first.obs;
  final Rx<AllowancePeriod> allowancePeriod = AllowancePeriod.values.first.obs;
  final TextEditingController bankAccountController = TextEditingController();
  final TextEditingController familyMembersController = TextEditingController();

  /// Support fields
  final Rx<SupportType> supportType = SupportType.values.first.obs;
  final Rx<EquipmentType> equipmentType = EquipmentType.values.first.obs;
  final Rx<UrgencyLevel> urgencyLevel = UrgencyLevel.values.first.obs;
  final TextEditingController officeSupplyTypeController = TextEditingController();
  final Rx<RepairType> repairType = RepairType.values.first.obs;
  final TextEditingController equipmentNameController = TextEditingController();
  final TextEditingController equipmentModelController = TextEditingController();
  int quantity = 0;
  final TextEditingController problemDescriptionController = TextEditingController();

  /// Employment fields
  final Rx<EmploymentCooperationType> cooperationType = EmploymentCooperationType.values.first.obs;
  WorkloadType workloadType = WorkloadType.values.first;
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController organizationalUnitController = TextEditingController();
  final Rx<EmploymentWorkLocation> workLocation = EmploymentWorkLocation.values.first.obs;
  int requiredPersonnelCount = 1;
  final TextEditingController jobSummaryController = TextEditingController();
  final RxList<String> mainResponsibilitiesList = <String>[].obs;
  final TextEditingController responsibilityController = TextEditingController();
  final TextEditingController reportingToController = TextEditingController();
  final Rx<EducationType> requiredEducation = EducationType.values.first.obs;
  final TextEditingController preferredFieldOfStudyController = TextEditingController();
  int minimumWorkExperience = 0;
  final RxList<String> technicalSkillsList = <String>[].obs;
  final TextEditingController technicalSkillController = TextEditingController();
  final RxList<String> softSkillsList = <String>[].obs;
  final TextEditingController softSkillController = TextEditingController();
  final RxList<String> requiredForeignLanguageList = <String>[].obs;
  final TextEditingController requiredForeignLanguageController = TextEditingController();

  /// General fields
  final Rx<GeneralType> generalType = GeneralType.values.first.obs;
  final Rx<PersonalInfoType> personalInfoType = PersonalInfoType.values.first.obs;
  final TextEditingController certificatePurposeController = TextEditingController();
  final Rx<CertificateLanguage> certificateLanguage = CertificateLanguage.values.first.obs;
  final TextEditingController currentValueController = TextEditingController();
  final TextEditingController newValueController = TextEditingController();
  final TextEditingController organizationNameController = TextEditingController();
  final TextEditingController organizationAddressController = TextEditingController();
  final TextEditingController introductionSubjectController = TextEditingController();
  final TextEditingController specialDetailsController = TextEditingController();
  final RxBool includeSalary = false.obs;
  final RxBool includePosition = false.obs;

  /// Overtime fields
  final Rx<OvertimeType> overtimeType = OvertimeType.values.first.obs;

  void disposeItems() {
    categoryType.close();
    buttonState.close();

    // Leave fields
    leaveType.close();
    sickLeaveType.close();
    hourlyLeaveReason.close();
    ceremonialLeaveType.close();
    replacementEmployee.dispose();
    hospitalName.dispose();
    relationship.dispose();

    // Mission fields
    missionType.close();
    missionPurpose.close();
    transportationType.close();
    accommodationType.close();
    expenseType.close();
    paymentMethod.close();
    needsAccommodation.close();

    // Welfare fields
    welfareType.close();
    loanType.close();
    repaymentType.close();
    insuranceType.close();
    allowanceType.close();
    allowancePeriod.close();

    // Support fields
    supportType.close();
    equipmentType.close();
    urgencyLevel.close();
    repairType.close();

    // Employment fields
    cooperationType.close();
    workLocation.close();
    mainResponsibilitiesList.close();
    requiredEducation.close();
    technicalSkillsList.close();
    softSkillsList.close();
    requiredForeignLanguageList.close();

    // General fields
    generalType.close();
    personalInfoType.close();
    certificateLanguage.close();
    includeSalary.close();
    includePosition.close();

    // Controllers
    descriptionController.dispose();
    destinationController.dispose();
    exactLocationController.dispose();
    companionNamesController.dispose();
    missionNumberController.dispose();
    amountController.dispose();
    bankAccountController.dispose();
    familyMembersController.dispose();
    officeSupplyTypeController.dispose();
    equipmentNameController.dispose();
    equipmentModelController.dispose();
    problemDescriptionController.dispose();
    jobTitleController.dispose();
    organizationalUnitController.dispose();
    jobSummaryController.dispose();
    responsibilityController.dispose();
    reportingToController.dispose();
    preferredFieldOfStudyController.dispose();
    technicalSkillController.dispose();
    softSkillController.dispose();
    requiredForeignLanguageController.dispose();
    certificatePurposeController.dispose();
    currentValueController.dispose();
    newValueController.dispose();
    organizationNameController.dispose();
    organizationAddressController.dispose();
    introductionSubjectController.dispose();
    specialDetailsController.dispose();
  }

  void onSubmit({required final Function(IRequestReadDto request) onResponse}) {
    validateForm(
      key: formKey,
      action: () {
        WImageFiles.checkFileUploading(
          isUploadingFile: isUploadingFile,
          action: () {
            if (((categoryType.value == RequestCategoryType.leave_attendance && leaveType.value == LeaveType.hourly_leave) ||
                    (categoryType.value == RequestCategoryType.leave_attendance && leaveType.value == LeaveType.hourly_leave)) &&
                (startTime!.numericOnly().toInt() - endTime!.numericOnly().toInt()) >= 0) {
              AppNavigator.snackbarRed(title: s.error, subtitle: s.endTimeMustBeAfterStartTime);
              return;
            } else if (endDateTimeJalali != null && startDateTimeJalali!.isAfter(endDateTimeJalali!)) {
              AppNavigator.snackbarRed(title: s.error, subtitle: s.endTimeMustBeAfterStartTime);
              return;
            }

            if (leaveType.value == LeaveType.sick_leave && files.isEmpty) {
              AppNavigator.snackbarRed(title: s.warning, subtitle: s.requiredMedicalCertificate);
              return;
            }

            _create(onResponse: onResponse);
          },
        );
      },
    );
  }

  void _create({required final Function(IRequestReadDto request) onResponse}) {
    buttonState.loading();
    final IRequestCreateParams requestParams = _buildRequestParams();

    _employeeRequestDatasource.create(
      dto: requestParams,
      onResponse: (final response) {
        buttonState.loaded();
        if (response.result == null) return;
        onResponse(response.result!);
      },
      onError: (final errorResponse) {
        buttonState.loaded();
      },
      withRetry: true,
    );
  }

  IRequestCreateParams _buildRequestParams() {
    IRequestCreateParams model;

    switch (categoryType.value) {
      case RequestCategoryType.leave_attendance:
        model = LeaveAttendanceRequestParams(
          requestingUserId: requestingUser?.id.toInt(),
          categoryType: categoryType.value,
          description: descriptionController.text.trim(),
          leaveType: leaveType.value,
          startDate: startDate,
          endDate: endDate,
          startTime: startTime,
          endTime: endTime,
          hospitalName: hospitalName.text.trim(),
          sickLeaveType: sickLeaveType.value,
          leaveReason: hourlyLeaveReason.value,
          occasionType: ceremonialLeaveType.value,
          occasionRelation: relationship.text.trim(),
          replacementEmployee: replacementEmployee.text.trim(),
          files: files,
        );
        break;

      case RequestCategoryType.missions_work:
        model = MissionWorkRequestParams(
          requestingUserId: requestingUser?.id.toInt(),
          categoryType: categoryType.value,
          description: descriptionController.text.trim(),
          missionType: missionType.value,
          relatedMissionNumber: missionNumberController.text.trim(),
          destination: destinationController.text.trim(),
          exactLocation: exactLocationController.text.trim(),
          startDate: startDate,
          endDate: endDate,
          startTime: startTime,
          endTime: endTime,
          needsAccommodation: needsAccommodation.value,
          accommodationType: accommodationType.value,
          companionNames: companionNamesController.text.trim(),
          expenseAmount: amountController.text.trim(),
          expenseType: expenseType.value,
          missionPurpose: missionPurpose.value,
          paymentMethod: paymentMethod.value,
          transportationType: transportationType.value,
          files: files,
        );
        break;

      case RequestCategoryType.welfare_financial:
        model = WelfareFinancialRequestParams(
          requestingUserId: requestingUser?.id.toInt(),
          categoryType: categoryType.value,
          description: descriptionController.text.trim(),
          welfareType: welfareType.value,
          requestTypeFinancial: loanType.value,
          amount: amountController.text.trim(),
          allowanceType: allowanceType.value,
          allowancePeriod: allowancePeriod.value,
          bankAccountNumber: bankAccountController.text.trim(),
          date: startDate,
          coveredPersonDetails: familyMembersController.text.trim(),
          insuranceRequestType: insuranceType.value,
          repaymentMethod: repaymentType.value,
          files: files,
        );
        break;

      case RequestCategoryType.support_logistics:
        model = SupportProcurementRequestParams(
          requestingUserId: requestingUser?.id.toInt(),
          categoryType: categoryType.value,
          description: descriptionController.text.trim(),
          supportType: supportType.value,
          equipmentType: equipmentType.value,
          supplyType: officeSupplyTypeController.text.trim(),
          suggestedModel: equipmentModelController.text.trim(),
          quantity: quantity,
          currentEquipment: equipmentNameController.text.trim(),
          problemDescription: problemDescriptionController.text.trim(),
          problemDate: startDate,
          repairType: repairType.value,
          urgencyLevel: urgencyLevel.value,
          files: files,
        );
        break;

      case RequestCategoryType.employment:
        model = EmploymentRequestParams(
          requestingUserId: requestingUser?.id.toInt(),
          categoryType: categoryType.value,
          description: descriptionController.text.trim(),
          workloadType: workloadType,
          jobTitle: jobTitleController.text.trim(),
          organizationalUnit: organizationalUnitController.text.trim(),
          cooperationType: cooperationType.value,
          workLocation: workLocation.value,
          requiredPersonnelCount: requiredPersonnelCount,
          jobSummary: jobSummaryController.text.trim(),
          mainResponsibilities: mainResponsibilitiesList,
          reportsTo: reportingToController.text.trim(),
          requiredEducation: requiredEducation.value,
          preferredFieldOfStudy: preferredFieldOfStudyController.text.trim(),
          minimumExperience: minimumWorkExperience,
          technicalSkills: technicalSkillsList,
          softSkills: softSkillsList,
          requiredLanguages: requiredForeignLanguageList,
        );
        break;

      case RequestCategoryType.general_requests:
        model = GeneralRequestParams(
          requestingUserId: requestingUser?.id.toInt(),
          categoryType: categoryType.value,
          description: descriptionController.text.trim(),
          generalType: generalType.value,
          personalInfoType: personalInfoType.value,
          currentValue: currentValueController.text.trim(),
          newValue: newValueController.text.trim(),
          certificatePurpose: certificatePurposeController.text.trim(),
          certificateLanguage: certificateLanguage.value,
          date: startDate,
          includeSalary: includeSalary.value,
          includePosition: includePosition.value,
          targetOrganizationName: organizationNameController.text.trim(),
          targetOrganizationAddress: organizationAddressController.text.trim(),
          introductionSubject: introductionSubjectController.text.trim(),
          specialDetails: specialDetailsController.text.trim(),
          files: files,
        );
        break;

      case RequestCategoryType.overtime:
        model = OvertimeRequestParams(
          requestingUserId: requestingUser?.id.toInt(),
          categoryType: categoryType.value,
          description: descriptionController.text.trim(),
          overtimeType: overtimeType.value,
          date: startDate,
          startTime: startTime,
          endTime: endTime,
        );
        break;
    }

    return model;
  }

  // Employment Skills methods
  void onEnteredResponsibility() {
    if (responsibilityController.text.trim() != '') {
      final i = mainResponsibilitiesList.indexOf(responsibilityController.text.trim());
      if (i != -1) {
        return AppNavigator.snackbarRed(title: s.warning, subtitle: s.thisIsExist.replaceAll('#', s.responsibility));
      }
      mainResponsibilitiesList.add(responsibilityController.text.trim());
      responsibilityController.clear();
    } else if (responsibilityController.text == '') {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  void removeResponsibility(final String value) {
    final i = mainResponsibilitiesList.indexOf(value);
    if (i != -1) {
      mainResponsibilitiesList.remove(value);
    }
  }

  void onEnteredTechnicalSkill() {
    if (technicalSkillController.text.trim() != '') {
      final i = technicalSkillsList.indexOf(technicalSkillController.text.trim());
      if (i != -1) {
        return AppNavigator.snackbarRed(title: s.warning, subtitle: s.thisIsExist.replaceAll('#', s.skill));
      }
      technicalSkillsList.add(technicalSkillController.text.trim());
      technicalSkillController.clear();
    } else if (technicalSkillController.text == '') {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  void removeTechnicalSkill(final String value) {
    final i = technicalSkillsList.indexOf(value);
    if (i != -1) {
      technicalSkillsList.remove(value);
    }
  }

  void onEnteredSoftSkill() {
    if (softSkillController.text.trim() != '') {
      final i = softSkillsList.indexOf(softSkillController.text.trim());
      if (i != -1) {
        return AppNavigator.snackbarRed(title: s.warning, subtitle: s.thisIsExist.replaceAll('#', s.skill));
      }
      softSkillsList.add(softSkillController.text.trim());
      softSkillController.clear();
    } else if (softSkillController.text == '') {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  void removeSoftSkill(final String value) {
    final i = softSkillsList.indexOf(value);
    if (i != -1) {
      softSkillsList.remove(value);
    }
  }

  void onEnteredLanguage() {
    if (requiredForeignLanguageController.text.trim() != '') {
      final i = softSkillsList.indexOf(requiredForeignLanguageController.text.trim());
      if (i != -1) {
        return AppNavigator.snackbarRed(title: s.warning, subtitle: s.thisIsExist.replaceAll('#', s.language));
      }
      softSkillsList.add(requiredForeignLanguageController.text.trim());
      requiredForeignLanguageController.clear();
    } else if (requiredForeignLanguageController.text == '') {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  void removeLanguage(final String value) {
    final i = requiredForeignLanguageList.indexOf(value);
    if (i != -1) {
      requiredForeignLanguageList.remove(value);
    }
  }
}
