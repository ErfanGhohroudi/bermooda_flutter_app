import 'package:bermooda_business/core/utils/enums/enums.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/widgets/fields/fields.dart';
import '../../../../../../data/data.dart';
import '../controllers/create_invoice_controller.dart';

class BuyerSellerInfoStep extends StatelessWidget {
  const BuyerSellerInfoStep({
    required this.ctrl,
    super.key,
  });

  final CreateInvoiceController ctrl;

  @override
  Widget build(final BuildContext context) {
    return Obx(() {
      if (ctrl.pageState.isLoading()) {
        return const WCard(
          margin: EdgeInsets.zero,
          showBorder: true,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: WCircularLoading(),
            ),
          ),
        );
      }

      if (ctrl.pageState.isError() || ctrl.sellerInfo.value == null) {
        return WErrorWidget(onTapButton: ctrl.loadInvoiceCodeAndBuyerSellerInfo);
      }

      return Form(
        key: ctrl.buyerSellerStepFormKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 10, bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 24,
            children: [
              // Seller Information Section
              WCard(
                margin: EdgeInsets.zero,
                elevation: 0,
                color: AppColors.blue.withValues(alpha: 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.sellerInfo).titleMedium(),
                    const Divider(),
                    if (ctrl.isWorkspaceInfoCompleted) _sellerInfo(context) else _sellerForm(),
                  ],
                ),
              ),

              // Buyer Information Section
              WCard(
                margin: EdgeInsets.zero,
                elevation: 0,
                color: AppColors.green.withValues(alpha: 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.buyerInfo).titleMedium(),
                    const Divider(),
                    _buyerForm(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _sellerForm() {
    return Obx(
      () {
        final isLegal = ctrl.sellerPersonalType.value == AuthenticationType.legal;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 18,
          children: [
            // Personal Type
            WDropDownFormField<String>(
              labelText: s.type,
              value: ctrl.sellerPersonalType.value.title,
              items: getDropDownMenuItemsFromString(
                menuItems: AuthenticationType.values.map((final e) => e.title).toList(),
              ),
              onChanged: (final value) {
                ctrl.sellerPersonalType(AuthenticationType.values.firstWhere((final e) => e.title == value));
              },
            ),

            // Fullname
            WTextField(
              controller: ctrl.sellerFullnameController,
              labelText: switch (ctrl.sellerPersonalType.value) {
                AuthenticationType.person => s.fullName,
                AuthenticationType.legal => s.companyName,
              },
              required: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),

            // Economic Number
            if (isLegal)
              WTextField(
                controller: ctrl.sellerEconomicNumberController,
                labelText: s.economicCode,
                required: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),

            // National Code
            UTextFormField(
              controller: ctrl.sellerNationalCodeController,
              labelText: switch (ctrl.sellerPersonalType.value) {
                AuthenticationType.person => s.nationalID,
                AuthenticationType.legal => s.companyNationalID,
              },
              required: true,
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              formatters: [FilteringTextInputFormatter.digitsOnly],
              validator: validateNotEmpty(requiredMessage: s.requiredField),
            ),

            // Registration Number
            UTextFormField(
              controller: ctrl.sellerRegistrationNumberController,
              labelText: s.registrationNumber,
              required: isLegal,
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              formatters: [FilteringTextInputFormatter.digitsOnly],
              validator: isLegal ? validateNotEmpty(requiredMessage: s.requiredField) : null,
            ),

            // Postal Code
            UTextFormField(
              controller: ctrl.sellerPostalCodeController,
              labelText: s.postalCode,
              keyboardType: TextInputType.number,
              maxLength: 10,
              required: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              formatters: [FilteringTextInputFormatter.digitsOnly],
              validator: validateMinLength(
                10,
                required: true,
                requiredMessage: s.requiredField,
                minLengthMessage: s.isShort('10'),
              ),
            ),

            // State
            Obx(
              () => WDropDownFormField<DropdownItemReadDto>(
                labelText: ctrl.sellerStatesState.isLoaded() ? s.state : s.loading,
                value: ctrl.sellerState.value,
                showSearchField: true,
                required: true,
                items: getDropDownMenuItemsFromDropDownItemReadDto(menuItems: ctrl.sellerStates),
                onChanged: ctrl.onSelectSellerState,
              ),
            ),

            // City
            Obx(
              () => WDropDownFormField<DropdownItemReadDto>(
                enable: ctrl.sellerState.value != null,
                labelText: ctrl.sellerCitiesState.isLoaded() ? s.city : s.loading,
                value: ctrl.sellerCity.value,
                showSearchField: true,
                required: true,
                items: getDropDownMenuItemsFromDropDownItemReadDto(menuItems: ctrl.sellerCities),
                onChanged: (final value) {
                  ctrl.sellerCity.value = value;
                },
              ),
            ),

            // Address
            WAddressField(
              controller: ctrl.sellerAddressController,
              required: true,
            ),

            // Phone Number
            WPhoneNumberField(
              controller: ctrl.sellerPhoneController,
            ),

            // Fax
            WPhoneNumberField(
              controller: ctrl.sellerFaxController,
              labelText: s.fax,
            ),

            // Email
            WEmailField(
              controller: ctrl.sellerEmailController,
            ),

            // Sheba Number
            WShebaNumberField(
              controller: ctrl.sellerShebaController,
              required: true,
            ),
          ],
        );
      },
    ).pOnly(top: 10);
  }

  Widget _sellerInfo(final BuildContext context) => Obx(
    () {
      final wsInfo = ctrl.sellerInfo.value;

      if (wsInfo == null) {
        return Text(s.noData).alignAtCenter();
      }

      final isLegal = wsInfo.normalizedPersonalType == AuthenticationType.legal;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          _infoRow(
            context,
            title: s.name,
            value: wsInfo.name,
          ),
          _infoRow(
            context,
            title: s.type,
            value: wsInfo.normalizedPersonalType.title,
          ),
          if (isLegal && wsInfo.economicNumber != null)
            _infoRow(
              context,
              title: s.economicCode,
              value: wsInfo.economicNumber!,
            ),
          if (wsInfo.nationalCode != null)
            _infoRow(
              context,
              title: switch (wsInfo.normalizedPersonalType) {
                AuthenticationType.person => s.nationalID,
                AuthenticationType.legal => s.companyNationalID,
              },
              value: wsInfo.nationalCode!,
            ),
          if (isLegal && wsInfo.registrationNumber != null)
            _infoRow(
              context,
              title: s.registrationNumber,
              value: wsInfo.registrationNumber!,
            ),
          if (wsInfo.postalCode != null)
            _infoRow(
              context,
              title: s.postalCode,
              value: wsInfo.postalCode!,
            ),
          _infoRow(
            context,
            title: s.location,
            value: "${wsInfo.state?.title ?? ''} - ${wsInfo.city?.title ?? ''}",
          ),
          if (wsInfo.address.isNotEmpty)
            _infoRow(
              context,
              title: s.address,
              value: wsInfo.address,
            ),
          _infoRow(
            context,
            title: s.phoneNumber,
            value: wsInfo.phoneNumber,
          ),
          if (wsInfo.faxNumber != null)
            _infoRow(
              context,
              title: s.fax,
              value: wsInfo.faxNumber!,
            ),
          if (wsInfo.email != null)
            _infoRow(
              context,
              title: s.email,
              value: wsInfo.email!,
            ),
          // if (wsInfo.sheba != null)
          //   _infoRow(
          //     context,
          //     title: s.iban,
          //     value: wsInfo.!,
          //   ),
        ],
      );
    },
  );

  Widget _infoRow(
    final BuildContext context, {
    required final String title,
    required final String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text("$title:").bodyMedium(color: context.theme.hintColor),
        Text(value).bodyMedium(),
      ],
    );
  }

  Widget _buyerForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 18,
      children: [
        const SizedBox.shrink(),

        // Buyer Name
        WTextField(
          controller: ctrl.buyerNameController,
          labelText: s.buyerName,
          required: true,
          maxLength: 150,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),

        // National Code
        UTextFormField(
          controller: ctrl.buyerNationalCodeController,
          labelText: s.nationalCodeOrIdBuyer,
          required: true,
          keyboardType: TextInputType.number,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          formatters: [FilteringTextInputFormatter.digitsOnly],
          validator: validateNotEmpty(requiredMessage: s.requiredField),
        ),

        // Economic Code
        UTextFormField(
          controller: ctrl.buyerEconomicCodeController,
          labelText: s.economicCode,
          keyboardType: TextInputType.number,
          formatters: [FilteringTextInputFormatter.digitsOnly],
        ),

        // State
        Obx(
          () => WDropDownFormField<DropdownItemReadDto>(
            labelText: ctrl.buyerStatesState.isLoaded() ? s.state : s.loading,
            value: ctrl.selectedState.value,
            showSearchField: true,
            required: true,
            items: getDropDownMenuItemsFromDropDownItemReadDto(menuItems: ctrl.buyerStates),
            onChanged: ctrl.onSelectBuyerState,
          ),
        ),

        // City
        Obx(
          () => WDropDownFormField<DropdownItemReadDto>(
            enable: ctrl.selectedState.value != null,
            labelText: ctrl.buyerCitiesState.isLoaded() ? s.city : s.loading,
            value: ctrl.selectedCity.value,
            showSearchField: true,
            required: true,
            items: getDropDownMenuItemsFromDropDownItemReadDto(menuItems: ctrl.cities),
            onChanged: (final value) {
              ctrl.selectedCity.value = value;
            },
          ),
        ),

        // Address
        WAddressField(
          controller: ctrl.buyerAddressController,
          required: true,
        ),

        // Phone Number
        WPhoneNumberField(
          controller: ctrl.buyerPhoneController,
          labelText: s.phoneNumber,
          required: true,
          startWith: '09',
          minLength: 11,
          maxLength: 11,
        ),
      ],
    ).pOnly(top: 10);
  }
}
