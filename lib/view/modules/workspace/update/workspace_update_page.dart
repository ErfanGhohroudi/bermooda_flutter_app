import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/widgets/fields/fields.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../core/widgets/profile_upload_and_show_image.dart';
import '../../../../core/core.dart';
import '../../../../data/data.dart';
import 'workspace_update_controller.dart';

class WorkspaceUpdatePage extends StatefulWidget {
  const WorkspaceUpdatePage({
    required this.workspaceInfo,
    required this.onResponse,
    super.key,
  });

  final WorkspaceInfoReadDto workspaceInfo;
  final Function(WorkspaceInfoReadDto workspaceInfo) onResponse;

  @override
  State<WorkspaceUpdatePage> createState() => _WorkspaceUpdatePageState();
}

class _WorkspaceUpdatePageState extends State<WorkspaceUpdatePage> with WorkspaceUpdateController {
  @override
  void initState() {
    workspaceInfo = widget.workspaceInfo;
    focusNode.addListener(_onFocusChange);
    setValues(workspaceInfo);
    super.initState();
  }

  void _onFocusChange() {
    if (focusNode.hasFocus) {
      jadooNameIsFocus(true);
    } else {
      jadooNameIsFocus(false);
    }
  }

  @override
  void dispose() {
    focusNode.removeListener(_onFocusChange);
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
          title: Text("${s.edit} (${workspaceInfo.title})"),
        ),
        bottomNavigationBar: Obx(
          () {
            if (pageState.isLoaded()) {
              return UElevatedButton(
                title: s.save,
                width: context.width,
                isLoading: buttonState.isLoading(),
                onTap: () => onSubmit(
                  onResponse: (final workspaceInfo) {
                    widget.onResponse(workspaceInfo);
                    UNavigator.back();
                  },
                ),
              ).pOnly(left: 16, right: 16, bottom: 24);
            }
            return const SizedBox.shrink();
          },
        ),
        body: Obx(
          () {
            if (pageState.isInitial() || pageState.isLoading()) {
              return const Center(child: WCircularLoading());
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: itemsSpacing),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: itemsSpacing,
                  children: [
                    /// Logo/profile
                    Row(
                      children: [
                        WProfileUploadAndShowImage(
                          itemWidth: 70,
                          file: avatar,
                          onUploaded: (final file) {
                            avatar = file;
                          },
                          onRemove: (final file) {
                            avatar = null;
                          },
                          uploadStatus: (final value) {
                            isUploadingAvatar = value;
                          },
                        ),
                        const SizedBox(width: 10),
                        Text(s.logo).bodyMedium(fontSize: 14, color: context.theme.primaryColor),
                      ],
                    ).marginOnly(bottom: 8),

                    /// Business Name
                    WTextField(
                      controller: titleController,
                      labelText: s.businessName,
                      required: true,
                      minLength: 3,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),

                    /// Link jadoo Brand Name
                    // Obx(
                    //   () => UTextFormField(
                    //     controller: jadooBrandNameController,
                    //     focusNode: focusNode,
                    //     labelText: s.link,
                    //     hintText: "username",
                    //     autovalidateMode: AutovalidateMode.onUserInteraction,
                    //     validator: validateMinLength(
                    //       3,
                    //       requiredMessage: s.requiredField,
                    //       minLengthMessage: s.isShort("3"),
                    //     ),
                    //     maxLength: 30,
                    //     formatters: [FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9_.]'))],
                    //     suffix: isPersianLang && (jadooNameIsFocus.value || jadooBrandNameController.text != '')
                    //         ? _linkDomainText()
                    //         : null,
                    //     prefix: !isPersianLang && (jadooNameIsFocus.value || jadooBrandNameController.text != '')
                    //         ? _linkDomainText()
                    //         : null,
                    //     textAlign: TextAlign.left,
                    //     textDirection: TextDirection.ltr,
                    //     onChanged: (final value) {
                    //       jadooBrandNameController.text = jadooBrandNameController.text.toLowerCase();
                    //     },
                    //   ),
                    // ),

                    /// Industry
                    Obx(
                      () => WDropDownFormField<DropdownItemReadDto>(
                        labelText: s.industry,
                        value: selectedIndustry.value,
                        deselectable: true,
                        items: getDropDownMenuItemsFromDropDownItemReadDto(menuItems: industries),
                        onChanged: (final value) {
                          selectedIndustry.value = value;
                        },
                      ),
                    ),

                    /// Business Size
                    Obx(
                      () => WDropDownFormField<String>(
                        labelText: s.businessSize,
                        value: selectedBusinessSize.value?.getTitle(),
                        deselectable: true,
                        items: getDropDownMenuItemsFromString(
                          menuItems: BusinessSize.values.map((final e) => e.getTitle()).toList(),
                        ),
                        onChanged: (final value) {
                          selectedBusinessSize.value = BusinessSize.values.firstWhereOrNull((final e) => e.getTitle() == value);
                        },
                      ),
                    ),

                    /// State
                    Obx(
                      () => WDropDownFormField<DropdownItemReadDto>(
                        labelText: s.state,
                        value: selectedState.value,
                        deselectable: true,
                        items: getDropDownMenuItemsFromDropDownItemReadDto(menuItems: states),
                        onChanged: (final value) {
                          selectedState.value = value;
                          selectedCity.value = null;
                          if (selectedState.value == null) return;
                          getCities();
                        },
                      ),
                    ),

                    /// City
                    Obx(
                      () => WDropDownFormField<DropdownItemReadDto>(
                        labelText: citiesState.isLoaded() ? s.city : s.loading,
                        value: selectedCity.value,
                        deselectable: true,
                        items: getDropDownMenuItemsFromDropDownItemReadDto(menuItems: cities),
                        onChanged: (final value) {
                          selectedCity.value = value;
                        },
                      ).marginOnly(bottom: 20),
                    ),

                    /// Verification Text Info
                    RichText(
                      text: TextSpan(
                        style: context.textTheme.bodyMedium,
                        children: [
                          TextSpan(text: '${s.verification}: '),
                          TextSpan(
                            text: s.verificationTextInfo,
                            style: context.textTheme.bodyMedium!.copyWith(color: context.theme.hintColor),
                          ),
                        ],
                      ),
                    ),

                    /// AuthenticationType
                    WRadioGroup<AuthenticationType>(
                      items: AuthenticationType.values,
                      initialValue: authenticationType.value,
                      labelBuilder: (final item) => item.title,
                      onChanged: (final value) {
                        authenticationType(value);
                        if (authenticationType.isPerson() && nationalIDController.text.length > 10) {
                          nationalIDController.text = nationalIDController.text.substring(0, 10);
                        }
                        FocusManager.instance.primaryFocus!.unfocus();
                      },
                    ),
                    _verificationForm(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _verificationForm() => Obx(
    () => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: itemsSpacing,
      children: [
        /// Company Name or Full Name
        WTextField(
          controller: nameController,
          labelText: authenticationType.isPerson() ? s.fullName : s.companyName,
          required: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          minLength: 3,
        ),

        /// National ID / Company National ID
        UTextFormField(
          controller: nationalIDController,
          labelText: authenticationType.isPerson() ? s.nationalID : s.companyNationalID,
          required: true,
          keyboardType: TextInputType.number,
          maxLength: authenticationType.isPerson() ? 10 : 11,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          formatters: [FilteringTextInputFormatter.digitsOnly],
          validator: validateMinLength(
            authenticationType.isPerson() ? 10 : 11,
            requiredMessage: s.requiredField,
            minLengthMessage: s.isShort(authenticationType.isPerson() ? '10' : '11'),
          ),
        ),

        if (authenticationType.isLegal()) ...[
          /// Registration Number
          UTextFormField(
            controller: registrationNumberController,
            labelText: s.registrationNumber,
            required: true,
            keyboardType: TextInputType.number,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            formatters: [FilteringTextInputFormatter.digitsOnly],
            validator: validateMinLength(
              6,
              requiredMessage: s.requiredField,
              minLengthMessage: s.isShort('6'),
            ),
          ),

          /// Economic Number
          UTextFormField(
            controller: economicNumberController,
            labelText: s.economicCode,
            required: true,
            keyboardType: TextInputType.number,
            maxLength: 12,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            formatters: [FilteringTextInputFormatter.digitsOnly],
            validator: validateMinLength(
              12,
              requiredMessage: s.requiredField,
              minLengthMessage: s.isShort('12'),
            ),
          ),

          /// Landline
          if (authenticationType.isLegal())
            WPhoneNumberField(
              controller: landlineController,
              labelText: s.landline,
            ),
        ],

        /// Phone Number
        if (authenticationType.isPerson())
          WPhoneNumberField(
            controller: phoneNumberController,
            required: true,
          ),

        /// Email
        WEmailField(
          controller: emailController,
          required: true,
        ),

        /// Address
        // WAddressField(
        //   controller: addressController,
        //   required: true,
        // ),
      ],
    ).marginOnly(bottom: 40),
  );

  // Widget _linkDomainText() => Text(
  //   AppConstants.websiteBaseURL,
  //   textDirection: TextDirection.ltr,
  // ).titleMedium();
}
