import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/widgets/fields/amount_field/amount_currency_field.dart';
import '../../../../../core/widgets/fields/customer_industry_subcategory_dropdown/customer_industry_subcategory_dropdown.dart';
import '../../../../../core/widgets/fields/customer_label_dropdown/customer_labels_dropdown_multi_select.dart';
import '../../../../../core/widgets/fields/fields.dart';
import '../../../../../core/widgets/fields/sections_dropdown/crm_sections_dropdown.dart';
import '../../../../../core/widgets/profile_upload_and_show_image.dart';
import '../../../../../core/core.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/data.dart';
import 'customer_create_update_controller.dart';

class CustomerCreateUpdatePage extends StatefulWidget {
  const CustomerCreateUpdatePage({
    required this.onResponse,
    required this.categoryId,
    this.customer,
    this.section,
    super.key,
  });

  final String categoryId;
  final CustomerReadDto? customer;
  final CrmSectionReadDto? section;
  final Function(CustomerReadDto model) onResponse;

  @override
  State<CustomerCreateUpdatePage> createState() => _CustomerCreateUpdatePageState();
}

class _CustomerCreateUpdatePageState extends State<CustomerCreateUpdatePage> with CustomerCreateUpdateController {
  @override
  void initState() {
    crmCategoryId = widget.categoryId;
    customer = widget.customer;
    setValues(customer, widget.section);
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
          title: Text(customer == null ? s.newCustomer : s.editCustomer),
        ),
        bottomNavigationBar: Obx(
          () => UElevatedButton(
            title: customer == null ? s.submit : s.save,
            isLoading: buttonState.isLoading(),
            onTap: () => onSubmit(
              onResponse: (final model) {
                widget.onResponse(model);
                UNavigator.back();
              },
            ),
          ).pOnly(left: 16, right: 16, bottom: 24),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Form(
            key: formKey,
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 18,
                children: [
                  /// Section of Customer
                  if (customer == null && isCreate)
                    WCrmSectionsDropDownFormField(
                      value: selectedSection,
                      crmCategoryId: crmCategoryId,
                      required: true,
                      onChanged: (final value) {
                        selectedSection = value;
                      },
                    ),

                  /// Avatar
                  Row(
                    spacing: 20,
                    children: [
                      WProfileUploadAndShowImage(
                        file: avatar,
                        onUploaded: (final file) {
                          avatar = file;
                        },
                        onRemove: (final file) {
                          avatar = null;
                        },
                        uploadStatus: (final value) {
                          isUploadingFile = value;
                        },
                      ),
                      Text(s.uploadPhoto).bodyMedium(color: context.theme.hintColor),
                    ],
                  ).marginSymmetric(vertical: 10),

                  /// Person Type
                  WDropDownFormField<String>(
                    labelText: s.type,
                    value: personalType.value.title,
                    items: getDropDownMenuItemsFromString(menuItems: AuthenticationType.values.map((final e) => e.title).toList()),
                    onChanged: (final value) {
                      personalType(AuthenticationType.values.firstWhere((final e) => e.title == value));
                    },
                  ),

                  /// Customer/Company Name
                  WTextField(
                    controller: nameController,
                    labelText: personalType.isPerson() ? s.customerName : s.companyName,
                    required: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),

                  /// Gender
                  if (personalType.isPerson())
                    Row(
                      children: [
                        Text("${s.gender}: ").bodyMedium(),
                        WRadioGroup<GenderType>(
                          initialValue: genderType,
                          items: GenderType.values,
                          labelBuilder: (final item) => item.getTitle(),
                          onChanged: (final value) {
                            genderType = value;
                          },
                        ),
                      ],
                    ),

                  /// Amount & Currency
                  WAmountCurrencyField(
                    controller: amountController,
                    labelText: s.salesForecast,
                    // initialCurrency: selectedCurrency,
                    // onChangedCurrency: (final currency) => selectedCurrency = currency,
                  ),

                  /// Sales Probability
                  Obx(
                    () => Row(
                      children: [
                        Text("${s.salesProbability}: ").bodyMedium(),
                        Slider(
                          value: salesProbability.value.toDouble(),
                          min: 0,
                          max: 100,
                          divisions: 100,
                          label: "${salesProbability.value.round()}%",
                          onChanged: (final value) {
                            salesProbability(value.round());
                          },
                        ).expanded(),
                        SizedBox(
                          width: 40,
                          child: Center(child: Text("${salesProbability.value.round()}%").bodyLarge()),
                        ),
                      ],
                    ),
                  ),

                  /// Contact Preference
                  WDropDownFormField<String>(
                    labelText: s.contactPreference,
                    value: selectedContactPreference?.getTitle(),
                    deselectable: true,
                    items: getDropDownMenuItemsFromString(menuItems: ConnectionType.values.map((final e) => e.getTitle()).toList()),
                    onChanged: (final value) {
                      if (value == null) return selectedContactPreference = null;
                      selectedContactPreference = ConnectionType.values.firstWhereOrNull((final element) => element.getTitle() == value);
                    },
                  ),

                  /// Phone Number
                  WPhoneNumberField(
                    controller: phoneNumberController,
                  ),

                  /// Email
                  WEmailField(
                    controller: emailController,
                  ),

                  /// Social Media link
                  UTextFormField(
                    controller: socialMediaLinkController,
                    labelText: s.socialMediaLink,
                    hintText: "https://profile link",
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.url,
                    formatters: [FilteringTextInputFormatter.deny(RegExp(r'[\s\u200C\n\t]'))],
                  ),

                  /// Landline and Ext
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    textDirection: TextDirection.ltr,
                    children: [
                      WPhoneNumberField(
                        controller: landlineController,
                        labelText: s.landline,
                      ).expanded(flex: 2),
                      UTextFormField(
                        controller: extensionController,
                        labelText: s.extension,
                        keyboardType: TextInputType.phone,
                        formatters: [FilteringTextInputFormatter.digitsOnly],
                      ).expanded(),
                    ],
                  ),

                  /// Fax
                  WPhoneNumberField(
                    controller: faxController,
                    labelText: s.fax,
                  ),

                  /// Website
                  UTextFormField(
                    controller: linkController,
                    labelText: s.website,
                    hintText: "https://example.com",
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.url,
                    formatters: [FilteringTextInputFormatter.deny(RegExp(r'[\s\u200C\n\t]'))],
                    maxLines: 5,
                  ),

                  /// Labels
                  WCustomerLabelsMultiSelectFormField(
                    crmCategoryId: crmCategoryId,
                    initialValues: selectedLabels,
                    onChanged: (final value) {
                      selectedLabels = value;
                    },
                  ),

                  /// Industry
                  WDropDownFormField<DropdownItemReadDto>(
                    labelText: industryState.isLoaded() ? s.industry : s.loading,
                    value: selectedIndustry,
                    deselectable: true,
                    items: getDropDownMenuItemsFromDropDownItemReadDto(menuItems: industries),
                    onChanged: (final value) {
                      selectedIndustry = value;
                      categoryState.refresh();
                    },
                  ),

                  /// Industry Subcategory
                  Obx(
                    () {
                      final i = categoryState.isLoaded();
                      return WCustomerCategoryDropdownFormField(
                        crmCategoryId: crmCategoryId,
                        industry: selectedIndustry,
                        value: selectedCategory,
                        isManager: i && haveAccess,
                        onChanged: (final value) {
                          selectedCategory = value;
                        },
                      );
                    },
                  ),

                  /// Other Forms Buttons
                  Wrap(
                    runSpacing: 10,
                    spacing: 10,
                    children: [
                      WTextButton(
                        text: s.representativeInfo,
                        onPressed: _showAgentInfoBottomSheet,
                      ),
                      WTextButton(
                        text: s.location,
                        onPressed: _showLocationInfoBottomSheet,
                      ),
                      WTextButton(
                        text: s.additionalInfo,
                        onPressed: _showAdditionalInfoBottomSheet,
                      ),
                    ],
                  ).marginOnly(bottom: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAgentInfoBottomSheet() => bottomSheet(
        title: s.representativeInfo,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 18,
          children: [
            WTextField(
              controller: agentNameController,
              labelText: s.representativeName,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            WPhoneNumberField(
              controller: agentPhoneNumberController,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              textDirection: TextDirection.ltr,
              children: [
                WPhoneNumberField(
                  controller: agentLandlineController,
                  labelText: s.landline,
                ).expanded(flex: 2),
                UTextFormField(
                  controller: agentLandlineExtController,
                  labelText: s.extension,
                  keyboardType: TextInputType.phone,
                  formatters: [FilteringTextInputFormatter.digitsOnly],
                ).expanded(),
              ],
            ),
            WTextField(
              controller: agentRoleController,
              labelText: s.role,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            UTextFormField(
              controller: agentLinkController,
              labelText: s.link,
              hintText: "https://example.com",
              textAlign: TextAlign.left,
              keyboardType: TextInputType.url,
              formatters: [FilteringTextInputFormatter.deny(RegExp(r'[\s\u200C\n\t]'))],
              maxLines: 5,
            ),
            WEmailField(
              controller: agentEmailController,
            ).marginOnly(bottom: 100),
          ],
        ),
      );

  void _showLocationInfoBottomSheet() => bottomSheet(
        title: s.location,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 18,
          children: [
            /// state
            Obx(
              () => WDropDownFormField<DropdownItemReadDto>(
                labelText: statesState.isLoaded() ? s.state : s.loading,
                value: selectedState,
                showSearchField: true,
                items: getDropDownMenuItemsFromDropDownItemReadDto(menuItems: states),
                onChanged: (final value) {
                  selectedState = value;
                  selectedCity = null;
                  statesState.refresh();
                  getCities();
                },
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
              maxLines: 5,
            ).marginOnly(bottom: 100),
          ],
        ),
      );

  void _showAdditionalInfoBottomSheet() => bottomSheet(
        title: s.additionalInfo,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 18,
          children: [
            /// Legal Fields
            if (personalType.isLegal()) ...[
              /// Company National ID
              UTextFormField(
                controller: companyNationalIDController,
                labelText: s.companyNationalID,
                keyboardType: TextInputType.number,
                formatters: [FilteringTextInputFormatter.digitsOnly],
              ),

              /// Economic Number
              UTextFormField(
                controller: economicNumberController,
                labelText: s.economicCode,
                keyboardType: TextInputType.number,
                formatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],

            /// Personal Fields
            if (personalType.isPerson()) ...[
              /// National ID
              UTextFormField(
                controller: nationalIDController,
                labelText: s.nationalID,
                keyboardType: TextInputType.number,
                formatters: [FilteringTextInputFormatter.digitsOnly],
              ),

              /// Date of Birth
              WBirthdayDateField(
                initialCompactFormatterJalaliDate: dateOfBirth,
                onChanged: (final date) {
                  dateOfBirth = date;
                },
              ),

              /// Birth Certificate Number
              UTextFormField(
                controller: certificateNumberController,
                labelText: s.birthCertificateNumber,
                keyboardType: TextInputType.number,
                formatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],

            /// Shaba
            WShebaNumberField(
              controller: shebaNumberController,
            ).marginOnly(bottom: 100),
          ],
        ),
      );
}
