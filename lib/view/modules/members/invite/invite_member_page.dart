import 'package:u/utilities.dart';

import '../../../../core/widgets/profile_upload_and_show_image.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/widgets/fields/fields.dart';
import '../../../../core/theme.dart';
import '../components/access_levels/access_levels_selection.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../core/core.dart';
import '../../../../data/data.dart';
import 'invite_member_controller.dart';

class InviteMemberPage extends StatefulWidget {
  const InviteMemberPage({
    required this.department,
    required this.onResponse,
    this.showDepartmentField = false,
    this.member,
    super.key,
  });

  final MemberReadDto? member;
  final bool showDepartmentField;
  final HRDepartmentReadDto? department;
  final Function(MemberReadDto member) onResponse;

  @override
  State<InviteMemberPage> createState() => _InviteMemberPageState();
}

class _InviteMemberPageState extends State<InviteMemberPage> with InviteMemberController {
  @override
  void initState() {
    initialController(
      showDepartmentField: widget.showDepartmentField,
      member: widget.member,
      department: widget.department,
    );
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
        appBar: AppBar(
          title: Text(actionApiType.isCreate() ? s.newMember : s.editMember),
        ),
        bottomNavigationBar: Obx(
          () => UElevatedButton(
            title: actionApiType.isCreate() ? s.sendInvitation : s.save,
            isLoading: buttonState.isLoading(),
            onTap: () {
              callApi(
                onResponse: (final member) {
                  widget.onResponse(member);
                  UNavigator.back();
                },
              );
            },
          ).pOnly(right: 16, left: 16, bottom: 24, top: 8),
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 18,
              children: [
                WTextField(
                  required: true,
                  controller: firstNameController,
                  labelText: s.firstName,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                WTextField(
                  required: true,
                  controller: lastNameController,
                  labelText: s.lastName,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                WPhoneNumberField(
                  required: true,
                  enabled: actionApiType.isCreate(),
                  controller: phoneNumberController,
                ),
                if (showAccessLevels)
                  WAccessLevelsSelection(
                    permissions: permissions,
                    onConfirmed: (final list) {
                      permissions = list;
                    },
                  ),
                if (showDepartmentField)
                  Obx(
                    () => WDropDownFormField<DropdownItemReadDto>(
                      enable: hrModuleIsActive,
                      labelText: departmentsState.isLoaded() ? s.department : s.loading,
                      value: department,
                      required: hrModuleIsActive,
                      showSearchField: true,
                      items: getDropDownMenuItemsFromDropDownItemReadDto(menuItems: departments),
                      onChanged: setNewDepartment,
                    ),
                  ),
                Obx(
                  () => WDropDownFormField<DropdownItemReadDto>(
                    enable: hrModuleIsActive,
                    labelText: workShiftsState.isLoaded() ? s.workShift : s.loading,
                    value: selectedWorkShift,
                    showSearchField: true,
                    items: getDropDownMenuItemsFromDropDownItemReadDto(menuItems: workShifts),
                    onChanged: (final value) => selectedWorkShift = value,
                  ),
                ),
                Obx(
                  () => WSwitchForm(
                    value: additionalInfo.value,
                    title: s.additionalInfo,
                    onChanged: toggleAdditionalInfoSwitch,
                  ),
                ),
                Obx(
                  () => additionalInfo.value ? _additionalForm() : const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _additionalForm() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          /// National ID
          UTextFormField(
            controller: nationalIDController,
            labelText: s.nationalID,
            keyboardType: TextInputType.number,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLength: 10,
            formatters: [FilteringTextInputFormatter.digitsOnly],
            validator: validateMinLength(
              10,
              required: false,
              requiredMessage: s.requiredField,
              minLengthMessage: s.isShort.replaceAll('#', '10'),
            ),
          ),

          /// Birth Certificate Number
          UTextFormField(
            controller: birthCertificateNumberController,
            labelText: s.birthCertificateNumber,
            keyboardType: TextInputType.number,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            formatters: [FilteringTextInputFormatter.digitsOnly],
            validator: validateMinLength(
              3,
              required: false,
              requiredMessage: s.requiredField,
              minLengthMessage: s.isShort.replaceAll('#', '3'),
            ),
          ),

          /// Date of Birth
          WBirthdayDateField(
            initialCompactFormatterJalaliDate: dateOfBirth,
            onChanged: (final date) {
              dateOfBirth = date;
            },
          ),

          /// Gender
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(s.gender).bodyMedium(fontSize: context.textTheme.bodyMedium!.fontSize! + 2, color: context.theme.hintColor),
              WRadioGroup<GenderType>(
                initialValue: gender.value,
                items: GenderType.values,
                labelBuilder: (final item) => item.getTitle(),
                onChanged: (final value) {
                  gender(value);
                },
              ),
            ],
          ),

          /// Military Status
          Obx(
            () => WDropDownFormField<String>(
              enable: gender.value == GenderType.male,
              labelText: s.militaryStatus,
              value: militaryStatus?.getTitle(),
              items: getDropDownMenuItemsFromString(menuItems: MilitaryStatus.values.map((final e) => e.getTitle()).toList()),
              onChanged: (final value) {
                militaryStatus = MilitaryStatus.values.firstWhereOrNull((final e) => e.getTitle() == value);
              },
            ),
          ),

          /// Marital Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(s.maritalStatus).bodyMedium(fontSize: context.textTheme.bodyMedium!.fontSize! + 2, color: context.theme.hintColor),
              WRadioGroup<bool>(
                initialValue: marriage.value,
                items: const [false, true],
                labelBuilder: (final item) => item ? s.married : s.single,
                onChanged: (final value) {
                  marriage(value);
                },
              ),
            ],
          ),

          /// Number of Children
          WPlusMinusField(
            labelText: s.numberOfChildren,
            defaultValue: numberOfChildren,
            onChanged: (final value) {
              numberOfChildren = value;
            },
          ),

          /// Email
          WEmailField(
            controller: emailController,
          ),

          WDropDownFormField<String>(
            labelText: s.educationalDegree,
            value: educationType?.getTitle(),
            items: getDropDownMenuItemsFromString(menuItems: EducationType.values.map((final e) => e.getTitle()).toList()),
            onChanged: (final value) {
              educationType = EducationType.values.firstWhereOrNull((final e) => e.getTitle() == value);
            },
          ),

          /// Field of Study
          Obx(
            () => WDropDownFormField<DropdownItemReadDto>(
              labelText: studyCategoriesState.isLoaded() ? s.fieldOfStudy : s.loading,
              value: selectedStudyCategory,
              showSearchField: true,
              items: getDropDownMenuItemsFromDropDownItemReadDto(menuItems: studyCategories),
              onChanged: (final value) {
                selectedStudyCategory = value;
                studyCategoriesState.refresh();
              },
            ),
          ),

          /// State
          Obx(
            () => WDropDownFormField<DropdownItemReadDto>(
              labelText: statesState.isLoaded() ? s.state : s.loading,
              value: selectedState,
              showSearchField: true,
              items: getDropDownMenuItemsFromDropDownItemReadDto(menuItems: states),
              onChanged: setProvince,
            ),
          ),

          /// City
          Obx(
            () => WDropDownFormField<DropdownItemReadDto>(
              enable: selectedState != null,
              labelText: citiesState.isLoaded() ? s.city : s.loading,
              value: selectedCity,
              showSearchField: true,
              items: getDropDownMenuItemsFromDropDownItemReadDto(menuItems: cities),
              onChanged: (final value) {
                selectedCity = value;
                citiesState.refresh();
              },
            ),
          ),

          /// Postal Code
          UTextFormField(
            controller: postalCodeController,
            labelText: s.postalCode,
            keyboardType: TextInputType.number,
            maxLength: 10,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            formatters: [FilteringTextInputFormatter.digitsOnly],
            validator: validateMinLength(
              10,
              required: false,
              requiredMessage: s.requiredField,
              minLengthMessage: s.isShort.replaceAll('#', '10'),
            ),
          ),

          /// Address
          WAddressField(
            controller: addressController,
          ),

          /// Work Information
          Container(
            width: context.width,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(color: context.theme.hintColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: WExpansionTile(
              value: employmentInfo,
              title: s.employmentInfo,
              icon: AppIcons.briefcaseOutline,
              scrollController: scrollController,
              child: _workInfoForm(),
              onChanged: (final value) {
                employmentInfo = value;
              },
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Obx(
                () => WSwitchForm(
                  value: emergencyInformation.value,
                  title: s.emergencyInformation,
                  onChanged: () {
                    emergencyInformation(!emergencyInformation.value);

                    if (emergencyInformation.value) {
                      WidgetsBinding.instance.addPostFrameCallback((final _) {
                        if (scrollController.hasClients) {
                          scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: 1.seconds,
                            curve: Curves.ease,
                          );
                        }
                      });
                    }
                  },
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  UImage(AppIcons.info, color: context.theme.hintColor, size: 20),
                  Flexible(child: Text(s.emergencyInfoText).bodyMedium(color: context.theme.hintColor)),
                ],
              ),
            ],
          ),
          Obx(
            () => emergencyInformation.value ? _emergencyInfoForm() : const SizedBox(),
          ),
        ],
      );

  Widget _workInfoForm() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          /// Employment Role
          WTextField(
            controller: employmentRoleController,
            labelText: s.employmentRole,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),

          /// Personal Code
          if (actionApiType.isUpdate())
            WTextField(
              enabled: false,
              controller: personnelCodeController,
              labelText: s.personnelCode,
              minLength: 0,
            ),

          /// Employment Type
          WDropDownFormField<String>(
            labelText: s.employmentType,
            value: employmentType?.getTitle(),
            items: getDropDownMenuItemsFromString(menuItems: EmploymentType.values.map((final e) => e.getTitle()).toList()),
            onChanged: (final value) {
              employmentType = EmploymentType.values.firstWhereOrNull((final e) => e.getTitle() == value);
            },
          ),

          /// Salary Type
          WDropDownFormField<String>(
            labelText: s.salaryType,
            value: salaryType?.getTitle(),
            items: getDropDownMenuItemsFromString(menuItems: SalaryType.values.map((final e) => e.getTitle()).toList()),
            onChanged: (final value) {
              salaryType = SalaryType.values.firstWhereOrNull((final e) => e.getTitle() == value);
            },
          ),

          /// Insurance Type
          WDropDownFormField<String>(
            labelText: s.insurance,
            value: insuranceType?.getTitle(),
            items: getDropDownMenuItemsFromString(menuItems: InsuranceType.values.map((final e) => e.getTitle()).toList()),
            onChanged: (final value) {
              insuranceType = InsuranceType.values.firstWhereOrNull((final e) => e.getTitle() == value);
            },
          ),

          /// Contract Start Date
          WDatePickerField(
            labelText: s.contractStartDate,
            showYearSelector: true,
            initialValue: startContractDate,
            onConfirm: (final date, final compactFormatterDate) {
              startContractDate = compactFormatterDate;
            },
          ),

          /// Contract End Date
          WDatePickerField(
            labelText: s.contractEndDate,
            showYearSelector: true,
            initialValue: endContractDate,
            onConfirm: (final date, final compactFormatterDate) {
              endContractDate = compactFormatterDate;
            },
          ),

          /// Sheba number
          WShebaNumberField(
            controller: ibanController,
          ),

          /// Favorites
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                WTextField(
                  controller: favoriteController,
                  labelText: s.favorites,
                  helperText: s.tapEnterToAdd,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onEditingComplete: onEnteredFavorite,
                ),
                if (favoritesList.isNotEmpty)
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List<Widget>.generate(
                      favoritesList.length,
                      (final index) => FilterChip(
                        label: Text(favoritesList[index]),
                        onSelected: (final value) {},
                        onDeleted: () => removeFavorite(favoritesList[index]),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          /// Skills
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                WTextField(
                  controller: skillController,
                  labelText: s.skills,
                  helperText: s.tapEnterToAdd,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  minLength: 1,
                  onEditingComplete: onEnteredSkill,
                ),
                if (skillsList.isNotEmpty)
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List<Widget>.generate(
                      skillsList.length,
                      (final index) => FilterChip(
                        label: Text(skillsList[index]),
                        onSelected: (final value) {},
                        onDeleted: () => removeSkill(skillsList[index]),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          /// Criminal Record
          Row(
            children: [
              WProfileUploadAndShowImage(
                itemWidth: 3 * 35,
                itemHeight: 4 * 35,
                file: criminalRecord,
                borderRadius: 15,
                showImageFullScreen: true,
                color: context.theme.hintColor,
                onUploaded: (final file) {
                  criminalRecord = file;
                },
                onRemove: (final file) {
                  criminalRecord = null;
                },
                uploadStatus: (final value) {
                  isUploadingFile = value;
                },
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(s.uploadCriminalRecordClearanceCertificate).bodyMedium(color: context.theme.hintColor),
              ),
            ],
          ),
        ],
      ).pOnly(left: 15, right: 15, bottom: 18);

  Widget _emergencyInfoForm() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          WTextField(
            controller: emergencyFirstNameController,
            labelText: s.firstName,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          WTextField(
            controller: emergencyLastNameController,
            labelText: s.lastName,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          WPhoneNumberField(
            controller: emergencyPhoneNumberController,
          ),
          WTextField(
            controller: emergencyRelationshipController,
            labelText: s.relationship,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            minLength: 0,
          ),
        ],
      );
}
