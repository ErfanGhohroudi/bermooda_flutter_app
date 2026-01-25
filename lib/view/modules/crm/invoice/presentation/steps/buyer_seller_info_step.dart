import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
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
    return Form(
      key: ctrl.step1FormKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 24,
            children: [
              // Buyer Information Section
          WCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 18,
              children: [
                const Text('مشخصات خریدار').titleMedium(),
                const Divider(),

                // Customer Name
                WTextField(
                  controller: ctrl.buyerNameController,
                  labelText: 'نام مشتری',
                  required: true,
                  maxLength: 150,
                ),

                // Phone Number
                WPhoneNumberField(
                  controller: ctrl.buyerPhoneController,
                  labelText: 'شماره تماس',
                  required: true,
                  startWith: '09',
                  minLength: 11,
                  maxLength: 11,
                ),

                // Created Date
                WDatePickerField(
                  labelText: 'تاریخ ثبت',
                  required: true,
                  initialValue: ctrl.createdDate?.formatCompactDate(),
                  onConfirm: (final date, final formattedDate) {
                    ctrl.createdDate = date;
                  },
                ),

                // Validity Date
                WDatePickerField(
                  labelText: 'تاریخ اعتبار',
                  initialValue: ctrl.validityDate?.formatCompactDate(),
                  onConfirm: (final date, final formattedDate) {
                    ctrl.validityDate = date;
                  },
                ),

                // State
                Obx(
                  () => WDropDownFormField<DropdownItemReadDto>(
                    labelText: ctrl.statesState.isLoaded() ? s.state : s.loading,
                    value: ctrl.selectedState.value,
                    showSearchField: true,
                    required: true,
                    items: getDropDownMenuItemsFromDropDownItemReadDto(menuItems: ctrl.states),
                    onChanged: (final value) {
                      ctrl.selectedState.value = value;
                      ctrl.selectedCity.value = null;
                      ctrl.cities.clear();
                      ctrl.loadCities();
                    },
                  ),
                ),

                // City
                Obx(
                  () => WDropDownFormField<DropdownItemReadDto>(
                    enable: ctrl.selectedState.value != null,
                    labelText: ctrl.citiesState.isLoaded() ? s.city : s.loading,
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
                WTextField(
                  controller: ctrl.buyerAddressController,
                  labelText: s.address,
                  maxLines: 3,
                  maxLength: 200,
                ),
              ],
            ),
          ),

          // Seller Information Section
          WCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                const Text('مشخصات فروشنده').titleMedium(),
                const Divider(),
                Obx(
                  () {
                    if (ctrl.workspaceInfoState.isLoading()) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: WCircularLoading(),
                        ),
                      );
                    }

                    if (ctrl.workspaceInfoState.isError() || ctrl.workspaceInfo.value == null) {
                      return const Text('اطلاعات workspace در دسترس نیست').bodyMedium(
                        color: context.theme.hintColor,
                      );
                    }

                    final wsInfo = ctrl.workspaceInfo.value!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        _infoRow(context, 'نام شخص حقیقی/حقوقی', wsInfo.name ?? wsInfo.title ?? '-'),
                        if (wsInfo.stateName != null)
                          _infoRow(context, 'استان', wsInfo.stateName!),
                        if (wsInfo.cityName != null)
                          _infoRow(context, 'شهر', wsInfo.cityName!),
                        if (wsInfo.address != null && wsInfo.address!.isNotEmpty)
                          _infoRow(context, 'آدرس', wsInfo.address!),
                        if (wsInfo.phoneNumber != null && wsInfo.phoneNumber!.isNotEmpty)
                          _infoRow(context, 'شماره تماس', wsInfo.phoneNumber!),
                        if (wsInfo.email != null && wsInfo.email!.isNotEmpty)
                          _infoRow(context, 'ایمیل', wsInfo.email!),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _infoRow(final BuildContext context, final String label, final String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(label).bodyMedium(color: context.theme.hintColor),
        ),
        Expanded(
          child: Text(value.isEmpty ? '-' : value).bodyMedium(),
        ),
      ],
    );
  }
}
