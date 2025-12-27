import 'package:u/utilities.dart';

import '../../../../core/widgets/fields/amount_field/amount_field.dart';
import '../../../../core/utils/enums/request_enums_extensions.dart';
import '../../../../core/widgets/fields/fields.dart';
import '../../../../core/widgets/image_files.dart';
import '../../../../core/functions/date_picker_functions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/utils/enums/request_enums.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../data/data.dart';
import 'create_request_controller.dart';

class CreateRequestPage extends StatefulWidget {
  const CreateRequestPage({
    required this.onResponse,
    this.requestingUser,
    super.key,
  });

  final UserReadDto? requestingUser;
  final Function(IRequestReadDto request) onResponse;

  @override
  State<CreateRequestPage> createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends State<CreateRequestPage> with CreateRequestController {
  @override
  void initState() {
    requestingUser = widget.requestingUser;
    super.initState();
  }

  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (final didPop, final result) {
        if (didPop) return;
        appShowYesCancelDialog(
          description: s.exitPage,
          onYesButtonTap: () {
            UNavigator.back();
            UNavigator.back();
          },
        );
      },
      child: UScaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: Text(s.submitRequest)),
        bottomNavigationBar: Obx(
          () => UElevatedButton(
            title: s.submit,
            isLoading: buttonState.isLoading(),
            onTap: () => onSubmit(
              onResponse: (final request) {
                widget.onResponse(request);
                UNavigator.back();
              },
            ),
          ).pOnly(left: 16, right: 16, bottom: 24),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 18,
              children: [
                /// Request Category Type
                WDropDownFormField<String>(
                  labelText: s.category,
                  value: categoryType.value.getTitle(),
                  required: true,
                  items: getDropDownMenuItemsFromString(menuItems: RequestCategoryType.values.map((final e) => e.getTitle()).toList()),
                  onChanged: (final value) {
                    categoryType(RequestCategoryType.values.firstWhereOrNull((final e) => e.getTitle() == value));
                  },
                ),
                Obx(
                  () => _buildRequestForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestForm() {
    switch (categoryType.value) {
      case RequestCategoryType.leave_attendance:
        return _leaveForm();
      case RequestCategoryType.missions_work:
        return _missionForm();
      case RequestCategoryType.welfare_financial:
        return _welfareForm();
      case RequestCategoryType.support_logistics:
        return _supportForm();
      case RequestCategoryType.employment:
        return _employmentForm();
      case RequestCategoryType.general_requests:
        return _generalForm();
      case RequestCategoryType.overtime:
        return _overtimeForm();
    }
  }

  Widget _leaveForm() => Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 18,
          children: [
            /// Leave Type
            WDropDownFormField<String>(
              value: leaveType.value.getTitle(),
              labelText: s.requestType,
              required: true,
              items: getDropDownMenuItemsFromString(menuItems: LeaveType.values.map((final e) => e.getTitle()).toList()),
              onChanged: (final value) {
                leaveType(LeaveType.values.firstWhereOrNull((final e) => e.getTitle() == value));
              },
            ),

            /// Leave specific fields based on type
            if (leaveType.value == LeaveType.entitlement_leave) _entitledLeaveFields(),
            if (leaveType.value == LeaveType.sick_leave) _sickLeaveFields(),
            if (leaveType.value == LeaveType.unpaid_leave) _unpaidLeaveFields(),
            if (leaveType.value == LeaveType.hourly_leave) _hourlyLeaveFields(),
            if (leaveType.value == LeaveType.special_occasion_leave) _ceremonialLeaveFields(),

            /// Common fields
            WTextField(
              controller: descriptionController,
              labelText: s.requestDescription,
              required: true,
              maxLength: 2000,
              multiLine: true,
              showCounter: true,
              maxLines: 5,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ],
        ),
      );

  Widget _missionForm() => Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 18,
          children: [
            /// Mission Type
            WDropDownFormField<String>(
              labelText: s.requestType,
              value: missionType.value.getTitle(),
              required: true,
              items: getDropDownMenuItemsFromString(menuItems: MissionType.values.map((final e) => e.getTitle()).toList()),
              onChanged: (final value) {
                missionType(MissionType.values.firstWhere((final e) => e.getTitle() == value));
              },
            ),

            /// Mission specific fields
            if (missionType.value == MissionType.out_of_city_mission) _outOfCityMissionFields(),
            if (missionType.value == MissionType.in_city_mission) _inCityMissionFields(),
            if (missionType.value == MissionType.mission_expense_payment) _expensePaymentFields(),

            /// Common fields
            WTextField(
              controller: descriptionController,
              labelText: s.requestDescription,
              maxLength: 2000,
              multiLine: true,
              maxLines: 5,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ],
        ),
      );

  // Leave form methods
  Widget _entitledLeaveFields() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          WDatePickerField(
            labelText: s.startDate,
            initialValue: startDate,
            required: true,
            onConfirm: (final date, final compactFormatterDate) {
              startDate = compactFormatterDate;
              startDateTimeJalali = date;
            },
          ),
          WDatePickerField(
            labelText: s.endDate,
            initialValue: endDate,
            required: true,
            onConfirm: (final date, final compactFormatterDate) {
              endDate = compactFormatterDate;
              endDateTimeJalali = date;
            },
          ),
          WTextField(
            controller: replacementEmployee,
            labelText: s.replacementEmployeeOptional,
          ),
        ],
      );

  Widget _sickLeaveFields() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          WDatePickerField(
            labelText: s.startDate,
            initialValue: startDate,
            required: true,
            onConfirm: (final date, final compactFormatterDate) {
              startDate = compactFormatterDate;
              startDateTimeJalali = date;
            },
          ),
          WDatePickerField(
            labelText: s.endDate,
            initialValue: endDate,
            required: true,
            onConfirm: (final date, final compactFormatterDate) {
              endDate = compactFormatterDate;
              endDateTimeJalali = date;
            },
          ),
          WDropDownFormField<String>(
            labelText: s.diseaseType,
            value: sickLeaveType.value.getTitle(),
            required: true,
            items: getDropDownMenuItemsFromString(menuItems: SickLeaveType.values.map((final e) => e.getTitle()).toList()),
            onChanged: (final value) {
              sickLeaveType(SickLeaveType.values.firstWhereOrNull((final e) => e.getTitle() == value));
            },
          ),
          WTextField(
            controller: hospitalName,
            labelText: s.hospitalOrDoctor,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Text(s.medicalCertificateRequired).bodyMedium(color: context.theme.hintColor),
              WImageFiles(
                files: files,
                onFilesUpdated: (final list) => files = list,
                uploadingFileStatus: (final value) => isUploadingFile = value,
              ),
            ],
          ),
        ],
      );

  Widget _unpaidLeaveFields() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          WDatePickerField(
            labelText: s.startDate,
            initialValue: startDate,
            required: true,
            onConfirm: (final date, final compactFormatterDate) {
              startDate = compactFormatterDate;
              startDateTimeJalali = date;
            },
          ),
          WDatePickerField(
            labelText: s.endDate,
            initialValue: endDate,
            required: true,
            onConfirm: (final date, final compactFormatterDate) {
              endDate = compactFormatterDate;
              endDateTimeJalali = date;
            },
          ),
          WTextField(
            controller: replacementEmployee,
            labelText: s.replacementEmployee,
          ),
        ],
      );

  Widget _hourlyLeaveFields() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          WDatePickerField(
            initialValue: startDate,
            required: true,
            labelText: s.leaveDate,
            onConfirm: (final date, final compactFormatterDate) {
              startDateTimeJalali = date;
              startDate = compactFormatterDate;
            },
          ),
          Row(
            spacing: 10,
            children: [
              WDropDownFormField<String>(
                labelText: s.startTime,
                value: startTime,
                required: true,
                items: getDropDownMenuItemsFromString(menuItems: DateAndTimeFunctions.generateTimeSlots(intervalInMinutes: 15)),
                onChanged: (final value) => startTime = value,
              ).expanded(),
              WDropDownFormField<String>(
                labelText: s.endTime,
                value: endTime,
                required: true,
                items: getDropDownMenuItemsFromString(menuItems: DateAndTimeFunctions.generateTimeSlots(intervalInMinutes: 15)),
                onChanged: (final value) => endTime = value,
              ).expanded(),
            ],
          ),
          WDropDownFormField<String>(
            value: hourlyLeaveReason.value.getTitle(),
            labelText: s.requestReason,
            required: true,
            items: getDropDownMenuItemsFromString(menuItems: HourlyLeaveReason.values.map((final e) => e.getTitle()).toList()),
            onChanged: (final value) {
              hourlyLeaveReason(HourlyLeaveReason.values.firstWhereOrNull((final e) => e.getTitle() == value));
            },
          ),
        ],
      );

  Widget _ceremonialLeaveFields() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          WDatePickerField(
            initialValue: startDate,
            required: true,
            labelText: s.leaveDate,
            onConfirm: (final date, final compactFormatterDate) {
              startDateTimeJalali = date;
              startDate = compactFormatterDate;
            },
          ),
          WDropDownFormField<String>(
            labelText: s.occasionType,
            value: ceremonialLeaveType.value.getTitle(),
            required: true,
            items: getDropDownMenuItemsFromString(menuItems: CeremonialLeaveType.values.map((final e) => e.getTitle()).toList()),
            onChanged: (final value) {
              ceremonialLeaveType(CeremonialLeaveType.values.firstWhereOrNull((final e) => e.getTitle() == value));
            },
          ),
          WTextField(
            controller: relationship,
            labelText: s.relationship,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Text(s.proofDocument).bodyMedium(color: context.theme.hintColor),
              WImageFiles(
                files: files,
                onFilesUpdated: (final list) => files = list,
                uploadingFileStatus: (final value) => isUploadingFile = value,
              ),
            ],
          ),
        ],
      );

  // Mission form methods
  Widget _outOfCityMissionFields() => Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 18,
          children: [
            WTextField(
              controller: destinationController,
              labelText: s.missionDestination,
              required: true,
            ),
            WTextField(
              controller: exactLocationController,
              labelText: s.exactLocation,
              required: true,
            ),
            Row(
              spacing: 10,
              children: [
                WDatePickerField(
                  initialValue: startDate,
                  required: true,
                  labelText: s.departureDate,
                  onConfirm: (final date, final compactFormatterDate) {
                    startDateTimeJalali = date;
                    startDate = compactFormatterDate;
                  },
                ).expanded(),
                WDropDownFormField<String>(
                  labelText: s.departureTime,
                  value: startTime,
                  required: true,
                  items: getDropDownMenuItemsFromString(menuItems: DateAndTimeFunctions.generateTimeSlots(intervalInMinutes: 15)),
                  onChanged: (final value) => startTime = value,
                ).expanded(),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                WDatePickerField(
                  initialValue: endDate,
                  required: true,
                  labelText: s.returnDate,
                  onConfirm: (final date, final compactFormatterDate) {
                    endDateTimeJalali = date;
                    endDate = compactFormatterDate;
                  },
                ).expanded(),
                WDropDownFormField<String>(
                  labelText: s.returnTime,
                  value: endTime,
                  required: true,
                  items: getDropDownMenuItemsFromString(menuItems: DateAndTimeFunctions.generateTimeSlots(intervalInMinutes: 15)),
                  onChanged: (final value) => endTime = value,
                ).expanded(),
              ],
            ),
            WDropDownFormField<String>(
              labelText: s.missionPurpose,
              value: missionPurpose.value.getTitle(),
              required: true,
              items: getDropDownMenuItemsFromString(menuItems: MissionPurpose.values.map((final e) => e.getTitle()).toList()),
              onChanged: (final value) {
                missionPurpose(MissionPurpose.values.firstWhereOrNull((final e) => e.getTitle() == value));
              },
            ),
            WDropDownFormField<String>(
              labelText: s.transportationType,
              value: transportationType.value.getTitle(),
              required: true,
              items: getDropDownMenuItemsFromString(menuItems: TransportationType.values.map((final e) => e.getTitle()).toList()),
              onChanged: (final value) {
                transportationType(TransportationType.values.firstWhereOrNull((final e) => e.getTitle() == value));
              },
            ),
            WSwitchForm(
              value: needsAccommodation.value,
              title: s.needsAccommodation,
              onChanged: () {
                needsAccommodation(!needsAccommodation.value);
              },
            ),
            if (needsAccommodation.value)
              WDropDownFormField<String>(
                labelText: s.accommodationType,
                value: accommodationType.value.getTitle(),
                required: true,
                items: getDropDownMenuItemsFromString(menuItems: AccommodationType.values.map((final e) => e.getTitle()).toList()),
                onChanged: (final value) {
                  accommodationType(AccommodationType.values.firstWhereOrNull((final e) => e.getTitle() == value));
                },
              ),
            WTextField(
              controller: companionNamesController,
              labelText: s.companionsLabel,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                Text(s.invitation).bodyMedium(color: context.theme.hintColor),
                WImageFiles(
                  files: files,
                  onFilesUpdated: (final list) => files = list,
                  uploadingFileStatus: (final value) => isUploadingFile = value,
                ),
              ],
            ),
          ],
        ),
      );

  Widget _inCityMissionFields() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          WTextField(
            controller: exactLocationController,
            labelText: s.exactAddress,
            required: true,
          ),
          Row(
            spacing: 10,
            children: [
              WDatePickerField(
                initialValue: startDate,
                required: true,
                labelText: s.startDate,
                onConfirm: (final date, final compactFormatterDate) {
                  startDateTimeJalali = date;
                  startDate = compactFormatterDate;
                },
              ).expanded(),
              WDropDownFormField<String>(
                labelText: s.startTime,
                value: startTime,
                required: true,
                items: getDropDownMenuItemsFromString(menuItems: DateAndTimeFunctions.generateTimeSlots(intervalInMinutes: 15)),
                onChanged: (final value) => startTime = value,
              ).expanded(),
            ],
          ),
          Row(
            spacing: 10,
            children: [
              WDatePickerField(
                initialValue: endDate,
                required: true,
                labelText: s.endDate,
                onConfirm: (final date, final compactFormatterDate) {
                  endDateTimeJalali = date;
                  endDate = compactFormatterDate;
                },
              ).expanded(),
              WDropDownFormField<String>(
                labelText: s.endTime,
                value: endTime,
                required: true,
                items: getDropDownMenuItemsFromString(menuItems: DateAndTimeFunctions.generateTimeSlots(intervalInMinutes: 15)),
                onChanged: (final value) => endTime = value,
              ).expanded(),
            ],
          ),
          WDropDownFormField<String>(
            labelText: s.missionPurpose,
            value: missionPurpose.value.getTitle(),
            required: true,
            items: getDropDownMenuItemsFromString(menuItems: MissionPurpose.values.map((final e) => e.getTitle()).toList()),
            onChanged: (final value) {
              missionPurpose(MissionPurpose.values.firstWhereOrNull((final e) => e.getTitle() == value));
            },
          ),
          WDropDownFormField<String>(
            labelText: s.transportationType,
            value: transportationType.value.getTitle(),
            required: true,
            items: getDropDownMenuItemsFromString(menuItems: TransportationType.values.map((final e) => e.getTitle()).toList()),
            onChanged: (final value) {
              transportationType(TransportationType.values.firstWhereOrNull((final e) => e.getTitle() == value));
            },
          ),
        ],
      );

  Widget _expensePaymentFields() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          WTextField(
            controller: missionNumberController,
            labelText: s.relatedMissionNumber,
            required: true,
          ),
          WDropDownFormField<String>(
            labelText: s.expenseType,
            value: expenseType.value.getTitle(),
            required: true,
            items: getDropDownMenuItemsFromString(menuItems: ExpenseType.values.map((final e) => e.getTitle()).toList()),
            onChanged: (final value) {
              expenseType(ExpenseType.values.firstWhereOrNull((final e) => e.getTitle() == value));
            },
          ),
          WDatePickerField(
            initialValue: startDate,
            required: true,
            labelText: s.expenseDate,
            onConfirm: (final date, final compactFormatterDate) {
              startDateTimeJalali = date;
              startDate = compactFormatterDate;
            },
          ),
          WAmountField(
            controller: amountController,
            labelText: s.expenseAmount,
            currencyText: s.toman,
            required: true,
          ),
          WDropDownFormField<String>(
            labelText: s.paymentMethodLabel,
            value: paymentMethod.value.getTitle(),
            required: true,
            items: getDropDownMenuItemsFromString(menuItems: PaymentMethod.values.map((final e) => e.getTitle()).toList()),
            onChanged: (final value) {
              paymentMethod(PaymentMethod.values.firstWhereOrNull((final e) => e.getTitle() == value));
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Text(s.uploadInvoiceReceipt).bodyMedium(color: context.theme.hintColor),
              WImageFiles(
                files: files,
                onFilesUpdated: (final list) => files = list,
                uploadingFileStatus: (final value) => isUploadingFile = value,
              ),
            ],
          ),
        ],
      );

  // Welfare form methods
  Widget _welfareForm() => Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 18,
          children: [
            /// Welfare Type
            WDropDownFormField<String>(
              labelText: s.welfareType,
              value: welfareType.value.getTitle(),
              required: true,
              items: getDropDownMenuItemsFromString(menuItems: WelfareType.values.map((final e) => e.getTitle()).toList()),
              onChanged: (final value) {
                welfareType(WelfareType.values.firstWhereOrNull((final e) => e.getTitle() == value));
              },
            ),

            /// Welfare specific fields
            if (welfareType.value == WelfareType.loan_advance) _loanFields(),
            if (welfareType.value == WelfareType.supplementary_insurance) _insuranceFields(),
            if (welfareType.value == WelfareType.allowances) _allowanceFields(),
            if (welfareType.value == WelfareType.other_welfare_services) _otherWelfareFields(),

            /// Common fields
            WTextField(
              controller: descriptionController,
              labelText: s.requestDescription,
              maxLength: 2000,
              multiLine: true,
              showCounter: true,
              maxLines: 5,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ],
        ),
      );

  Widget _loanFields() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          WDropDownFormField<String>(
            labelText: s.requestType,
            value: loanType.value.getTitle(),
            required: true,
            items: getDropDownMenuItemsFromString(menuItems: LoanType.values.map((final e) => e.getTitle()).toList()),
            onChanged: (final value) {
              loanType(LoanType.values.firstWhereOrNull((final e) => e.getTitle() == value));
            },
          ),
          WAmountField(
            controller: amountController,
            labelText: s.requestedAmount,
            currencyText: s.toman,
            required: true,
          ),
          WShebaNumberField(
            controller: bankAccountController,
            required: true,
          ),
          WDatePickerField(
            initialValue: startDate,
            required: true,
            labelText: s.requiredPaymentDate,
            onConfirm: (final date, final compactFormatterDate) {
              startDate = compactFormatterDate;
            },
          ),
          WDropDownFormField<String>(
            labelText: s.repaymentConditions,
            value: repaymentType.value.getTitle(),
            required: true,
            items: getDropDownMenuItemsFromString(menuItems: RepaymentType.values.map((final e) => e.getTitle()).toList()),
            onChanged: (final value) {
              repaymentType(RepaymentType.values.firstWhereOrNull((final e) => e.getTitle() == value));
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Text(s.guaranteeDocuments).bodyMedium(color: context.theme.hintColor),
              WImageFiles(
                files: files,
                onFilesUpdated: (final list) => files = list,
                uploadingFileStatus: (final value) => isUploadingFile = value,
              ),
            ],
          ),
        ],
      );

  Widget _insuranceFields() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          WDropDownFormField<String>(
            labelText: s.requestType,
            value: insuranceType.value.getTitle(),
            required: true,
            items: getDropDownMenuItemsFromString(menuItems: InsuranceRequestType.values.map((final e) => e.getTitle()).toList()),
            onChanged: (final value) {
              insuranceType(InsuranceRequestType.values.firstWhereOrNull((final e) => e.getTitle() == value));
            },
          ),
          WTextField(
            controller: familyMembersController,
            labelText: s.coveredPersonsInfo,
            required: true,
            multiLine: true,
            maxLines: 3,
          ),
          WDatePickerField(
            initialValue: startDate,
            required: true,
            labelText: s.coverageStartDate,
            onConfirm: (final date, final compactFormatterDate) {
              startDate = compactFormatterDate;
            },
          ),
          WAmountField(
            controller: amountController,
            labelText: s.treatmentAmount,
            currencyText: s.toman,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Text(s.medicalDocuments).bodyMedium(color: context.theme.hintColor),
              WImageFiles(
                files: files,
                onFilesUpdated: (final list) => files = list,
                uploadingFileStatus: (final value) => isUploadingFile = value,
              ),
            ],
          ),
        ],
      );

  Widget _allowanceFields() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          WDropDownFormField<String>(
            labelText: s.allowanceType,
            value: allowanceType.value.getTitle(),
            required: true,
            items: getDropDownMenuItemsFromString(menuItems: AllowanceType.values.map((final e) => e.getTitle()).toList()),
            onChanged: (final value) {
              allowanceType(AllowanceType.values.firstWhereOrNull((final e) => e.getTitle() == value));
            },
          ),
          WDropDownFormField<String>(
            labelText: s.period,
            value: allowancePeriod.value.getTitle(),
            required: true,
            items: getDropDownMenuItemsFromString(menuItems: AllowancePeriod.values.map((final e) => e.getTitle()).toList()),
            onChanged: (final value) {
              allowancePeriod(AllowancePeriod.values.firstWhereOrNull((final e) => e.getTitle() == value));
            },
          ),
          WAmountField(
            controller: amountController,
            labelText: s.requestedAmountLabel,
            currencyText: s.toman,
            required: true,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Text(s.supportingDocuments).bodyMedium(color: context.theme.hintColor),
              WImageFiles(
                files: files,
                onFilesUpdated: (final list) => files = list,
                uploadingFileStatus: (final value) => isUploadingFile = value,
              ),
            ],
          ),
        ],
      );

  Widget _otherWelfareFields() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Text(s.optionalAttachments).bodyMedium(color: context.theme.hintColor),
              WImageFiles(
                files: files,
                onFilesUpdated: (final list) => files = list,
                uploadingFileStatus: (final value) => isUploadingFile = value,
              ),
            ],
          ),
        ],
      );

  // Support form methods
  Widget _supportForm() => Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 18,
          children: [
            /// Support Type
            WDropDownFormField<String>(
              labelText: s.requestType,
              value: supportType.value.getTitle(),
              required: true,
              items: getDropDownMenuItemsFromString(menuItems: SupportType.values.map((final e) => e.getTitle()).toList()),
              onChanged: (final value) {
                supportType(SupportType.values.firstWhereOrNull((final e) => e.getTitle() == value));
              },
            ),

            /// Support specific fields
            if (supportType.value == SupportType.equipment_purchase) _equipmentPurchaseFields(),
            if (supportType.value == SupportType.office_supplies) _officeSuppliesFields(),
            if (supportType.value == SupportType.equipment_repair) _equipmentRepairFields(),

            /// Common fields
            WTextField(
              controller: descriptionController,
              labelText: s.requestDescription,
              maxLength: 2000,
              multiLine: true,
              showCounter: true,
              maxLines: 5,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ],
        ),
      );

  Widget _equipmentPurchaseFields() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          WDropDownFormField<String>(
            labelText: s.equipmentType,
            value: equipmentType.value.getTitle(),
            required: true,
            items: getDropDownMenuItemsFromString(menuItems: EquipmentType.values.map((final e) => e.getTitle()).toList()),
            onChanged: (final value) {
              equipmentType(EquipmentType.values.firstWhereOrNull((final e) => e.getTitle() == value));
            },
          ),
          WPlusMinusField(
            defaultValue: quantity,
            labelText: s.quantity,
            required: true,
            onChanged: (final value) => quantity = value,
          ),
          WTextField(
            controller: equipmentModelController,
            labelText: s.suggestedModelLabel,
          ),
          WDropDownFormField<String>(
            labelText: s.urgency,
            value: urgencyLevel.value.getTitle(),
            required: true,
            items: getDropDownMenuItemsFromString(menuItems: UrgencyLevel.values.map((final e) => e.getTitle()).toList()),
            onChanged: (final value) {
              urgencyLevel(UrgencyLevel.values.firstWhereOrNull((final e) => e.getTitle() == value));
            },
          ),
        ],
      );

  Widget _officeSuppliesFields() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          WTextField(
            controller: officeSupplyTypeController,
            labelText: s.itemType,
            required: true,
          ),
          WPlusMinusField(
            defaultValue: quantity,
            labelText: s.requiredQuantity,
            required: true,
            onChanged: (final value) => quantity = value,
          ),
        ],
      );

  Widget _equipmentRepairFields() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          WTextField(
            controller: equipmentNameController,
            labelText: s.currentEquipmentLabel,
            required: true,
          ),
          WTextField(
            controller: problemDescriptionController,
            labelText: s.exactProblem,
            required: true,
            multiLine: true,
            showCounter: true,
            maxLength: 2000,
            maxLines: 3,
          ),
          WDatePickerField(
            initialValue: startDate,
            required: true,
            labelText: s.problemDate,
            onConfirm: (final date, final compactFormatterDate) {
              startDate = compactFormatterDate;
            },
          ),
          WDropDownFormField<String>(
            labelText: s.need,
            value: repairType.value.getTitle(),
            required: true,
            items: getDropDownMenuItemsFromString(menuItems: RepairType.values.map((final e) => e.getTitle()).toList()),
            onChanged: (final value) {
              repairType(RepairType.values.firstWhereOrNull((final e) => e.getTitle() == value));
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Text(s.optionalProblemPhoto).bodyMedium(color: context.theme.hintColor),
              WImageFiles(
                files: files,
                onFilesUpdated: (final list) => files = list,
                uploadingFileStatus: (final value) => isUploadingFile = value,
              ),
            ],
          ),
        ],
      );

  // Employment form methods
  Widget _employmentForm() => Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 18,
          children: [
            /// Request Type (Cooperation Type)
            WDropDownFormField<String>(
              labelText: s.requestType,
              value: cooperationType.value.getTitle(),
              required: true,
              items: getDropDownMenuItemsFromString(menuItems: EmploymentCooperationType.values.map((final e) => e.getTitle()).toList()),
              onChanged: (final value) {
                cooperationType(EmploymentCooperationType.values.firstWhereOrNull((final e) => e.getTitle() == value));
              },
            ),

            /// Workload Type
            if (cooperationType.value != EmploymentCooperationType.outsourcing)
              WDropDownFormField<String>(
              labelText: s.workload,
              value: workloadType.getTitle(),
              required: true,
              items: getDropDownMenuItemsFromString(menuItems: WorkloadType.values.map((final e) => e.getTitle()).toList()),
              onChanged: (final value) {
                workloadType = WorkloadType.values.firstWhere((final e) => e.getTitle() == value);
              },
            ),

            /// Job Specifications Section
            Text(
              s.jobSpecifications,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.theme.primaryColor,
              ),
            ),

            WTextField(
              controller: jobTitleController,
              labelText: s.jobTitle,
              required: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),

            WTextField(
              controller: organizationalUnitController,
              labelText: s.organizationalUnit,
              hintText: s.unitExample,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),

            WDropDownFormField<String>(
              labelText: s.workLocation,
              value: workLocation.value.getTitle(),
              required: true,
              items: getDropDownMenuItemsFromString(menuItems: EmploymentWorkLocation.values.map((final e) => e.getTitle()).toList()),
              onChanged: (final value) {
                workLocation(EmploymentWorkLocation.values.firstWhereOrNull((final e) => e.getTitle() == value));
              },
            ),

            WPlusMinusField(
              labelText: s.requiredPersonnelCount,
              defaultValue: requiredPersonnelCount,
              required: true,
              enableTyping: true,
              onChanged: (final value) {
                requiredPersonnelCount = value;
              },
            ),

            const SizedBox(height: 24),

            /// Job Description Section
            Text(
              s.jobDescriptionAndResponsibilities,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.theme.primaryColor,
              ),
            ),

            WTextField(
              controller: jobSummaryController,
              labelText: s.jobSummary,
              multiLine: true,
              minLines: 3,
              maxLines: 5,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),

            /// Main Responsibilities
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  WTextField(
                    controller: responsibilityController,
                    labelText: s.mainResponsibilities,
                    helperText: s.tapEnterToAdd,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    minLength: 1,
                    onEditingComplete: onEnteredResponsibility,
                  ),
                  if (mainResponsibilitiesList.isNotEmpty)
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List<Widget>.generate(
                        mainResponsibilitiesList.length,
                        (final index) => FilterChip(
                          label: Text(mainResponsibilitiesList[index]),
                          onSelected: (final value) {},
                          onDeleted: () => removeResponsibility(mainResponsibilitiesList[index]),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            WTextField(
              controller: reportingToController,
              labelText: s.reportsTo,
              hintText: s.reportsToExample,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),

            const SizedBox(height: 24),

            /// Requirements Section
            Text(
              s.requirementsAndConditions,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.theme.primaryColor,
              ),
            ),

            WDropDownFormField<String>(
              labelText: s.requiredEducation,
              value: requiredEducation.value.getTitle(),
              required: true,
              items: getDropDownMenuItemsFromString(menuItems: EducationType.values.map((final e) => e.getTitle()).toList()),
              onChanged: (final value) {
                requiredEducation(EducationType.values.firstWhereOrNull((final e) => e.getTitle() == value));
              },
            ),

            WTextField(
              controller: preferredFieldOfStudyController,
              labelText: s.preferredFieldOfStudy,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),

            WPlusMinusField(
              labelText: s.minimumWorkExperience,
              required: true,
              defaultValue: minimumWorkExperience,
              onChanged: (final value) {
                minimumWorkExperience = value;
              },
            ),

            /// Technical Skills
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  WTextField(
                    controller: technicalSkillController,
                    labelText: s.technicalSkills,
                    helperText: s.tapEnterToAdd,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    minLength: 1,
                    onEditingComplete: onEnteredTechnicalSkill,
                  ),
                  if (technicalSkillsList.isNotEmpty)
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List<Widget>.generate(
                        technicalSkillsList.length,
                        (final index) => FilterChip(
                          label: Text(technicalSkillsList[index]),
                          onSelected: (final value) {},
                          onDeleted: () => removeTechnicalSkill(technicalSkillsList[index]),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            /// Soft Skills
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  WTextField(
                    controller: softSkillController,
                    labelText: s.softSkills,
                    helperText: s.tapEnterToAdd,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    minLength: 1,
                    onEditingComplete: onEnteredSoftSkill,
                  ),
                  if (softSkillsList.isNotEmpty)
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List<Widget>.generate(
                        softSkillsList.length,
                        (final index) => FilterChip(
                          label: Text(softSkillsList[index]),
                          onSelected: (final value) {},
                          onDeleted: () => removeSoftSkill(softSkillsList[index]),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  WTextField(
                    controller: requiredForeignLanguageController,
                    labelText: s.requiredForeignLanguages,
                    helperText: s.tapEnterToAdd,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    minLength: 1,
                    onEditingComplete: onEnteredLanguage,
                  ),
                  if (requiredForeignLanguageList.isNotEmpty)
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List<Widget>.generate(
                        requiredForeignLanguageList.length,
                        (final index) => FilterChip(
                          label: Text(requiredForeignLanguageList[index]),
                          onSelected: (final value) {},
                          onDeleted: () => removeLanguage(requiredForeignLanguageList[index]),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            /// Common fields
            WTextField(
              controller: descriptionController,
              labelText: s.requestDescription,
              maxLength: 2000,
              multiLine: true,
              showCounter: true,
              maxLines: 5,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ],
        ),
      );

  // General form methods
  Widget _generalForm() => Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 18,
          children: [
            /// General Type
            WDropDownFormField<String>(
              labelText: s.requestType,
              value: generalType.value.getTitle(),
              required: true,
              items: getDropDownMenuItemsFromString(menuItems: GeneralType.values.map((final e) => e.getTitle()).toList()),
              onChanged: (final value) {
                generalType(GeneralType.values.firstWhereOrNull((final e) => e.getTitle() == value));
              },
            ),

            /// General specific fields
            if (generalType.value == GeneralType.personal_info_change) _personalInfoChangeFields(),
            if (generalType.value == GeneralType.employment_certificate) _employmentCertificateFields(),
            if (generalType.value == GeneralType.introduction_letter) _introductionLetterFields(),

            /// Common fields
            WTextField(
              controller: descriptionController,
              labelText: s.requestDescription,
              maxLength: 2000,
              multiLine: true,
              showCounter: true,
              maxLines: 5,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ],
        ),
      );

  Widget _personalInfoChangeFields() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          WDropDownFormField<String>(
            labelText: s.informationType,
            value: personalInfoType.value.getTitle(),
            required: true,
            items: getDropDownMenuItemsFromString(menuItems: PersonalInfoType.values.map((final e) => e.getTitle()).toList()),
            onChanged: (final value) {
              personalInfoType(PersonalInfoType.values.firstWhereOrNull((final e) => e.getTitle() == value));
            },
          ),
          WTextField(
            controller: currentValueController,
            labelText: s.currentValue,
            required: true,
          ),
          WTextField(
            controller: newValueController,
            labelText: s.newValue,
            required: true,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Text(s.supportingDocumentsPersonal).bodyMedium(color: context.theme.hintColor),
              WImageFiles(
                files: files,
                onFilesUpdated: (final list) => files = list,
                uploadingFileStatus: (final value) => isUploadingFile = value,
              ),
            ],
          ),
        ],
      );

  Widget _employmentCertificateFields() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          WTextField(
            controller: certificatePurposeController,
            labelText: s.certificatePurpose,
            required: true,
          ),
          WDropDownFormField<String>(
            labelText: s.requiredLanguage,
            value: certificateLanguage.value.getTitle(),
            required: true,
            items: getDropDownMenuItemsFromString(menuItems: CertificateLanguage.values.map((final e) => e.getTitle()).toList()),
            onChanged: (final value) {
              certificateLanguage(CertificateLanguage.values.firstWhereOrNull((final e) => e.getTitle() == value));
            },
          ),
          WDatePickerField(
            initialValue: startDate,
            required: true,
            labelText: s.requiredIssueDate,
            onConfirm: (final date, final compactFormatterDate) {
              startDate = compactFormatterDate;
            },
          ),
          Obx(
            () => WSwitchForm(
              value: includeSalary.value,
              title: s.includeSalary,
              onChanged: () {
                includeSalary(!includeSalary.value);
              },
            ),
          ),
          Obx(
            () => WSwitchForm(
              value: includePosition.value,
              title: s.includePosition,
              onChanged: () {
                includePosition(!includePosition.value);
              },
            ),
          ),
        ],
      );

  Widget _introductionLetterFields() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          WTextField(
            controller: organizationNameController,
            labelText: s.destinationOrganization,
            required: true,
          ),
          WTextField(
            controller: organizationAddressController,
            labelText: s.organizationAddress,
            required: true,
            multiLine: true,
            maxLines: 3,
          ),
          WTextField(
            controller: introductionSubjectController,
            labelText: s.introductionSubject,
            required: true,
          ),
          WDatePickerField(
            initialValue: startDate,
            required: true,
            labelText: s.requiredIssueDate,
            onConfirm: (final date, final compactFormatterDate) {
              startDateTimeJalali = date;
              startDate = compactFormatterDate;
            },
          ),
          WTextField(
            controller: specialDetailsController,
            labelText: s.specialSpecificationsLabel,
          ),
        ],
      );

  // Overtime form methods
  Widget _overtimeForm() => Obx(
        () => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 18,
      children: [
        /// General Type
        WDropDownFormField<String>(
          labelText: s.requestType,
          value: overtimeType.value.getTitle(),
          required: true,
          items: getDropDownMenuItemsFromString(menuItems: OvertimeType.values.map((final e) => e.getTitle()).toList()),
          onChanged: (final value) {
            overtimeType(OvertimeType.values.firstWhereOrNull((final e) => e.getTitle() == value));
          },
        ),

        /// General specific fields
        WDatePickerField(
          initialValue: startDate,
          required: true,
          labelText: s.date,
          onConfirm: (final date, final compactFormatterDate) {
            startDateTimeJalali = date;
            startDate = compactFormatterDate;
          },
        ),
        Row(
          spacing: 10,
          children: [
            WDropDownFormField<String>(
              labelText: s.startTime,
              value: startTime,
              required: true,
              items: getDropDownMenuItemsFromString(menuItems: DateAndTimeFunctions.generateTimeSlots(intervalInMinutes: 15)),
              onChanged: (final value) => startTime = value,
            ).expanded(),
            WDropDownFormField<String>(
              labelText: s.endTime,
              value: endTime,
              required: true,
              items: getDropDownMenuItemsFromString(menuItems: DateAndTimeFunctions.generateTimeSlots(intervalInMinutes: 15)),
              onChanged: (final value) => endTime = value,
            ).expanded(),
          ],
        ),

        /// Common fields
        WTextField(
          controller: descriptionController,
          labelText: s.requestDescription,
          maxLength: 2000,
          multiLine: true,
          showCounter: true,
          maxLines: 5,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    ),
  );
}
