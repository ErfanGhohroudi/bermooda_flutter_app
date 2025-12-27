import 'package:bermooda_business/core/widgets/image_files.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/widgets/fields/amount_field/amount_currency_field.dart';
import '../../../../../../core/widgets/fields/fields.dart';
import '../../../../../../core/widgets/fields/labels_dropdown_new/labels_dropdown_multi_select_new.dart';
import '../../../../../../core/widgets/fields/multi_date_picker_field.dart';
import '../../../../../../core/core.dart';
import '../../../../../../core/utils/enums/enums.dart';
import 'invoice_form_controller.dart';

class InvoiceForm extends StatelessWidget {
  const InvoiceForm({
    required this.ctrl,
    super.key,
  });

  final InvoiceFormController ctrl;

  @override
  Widget build(final BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Form(
        key: ctrl.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 18,
          children: [
            Text("${s.invoice}:").titleMedium(color: context.theme.hintColor).marginOnly(top: 18),
            WDropDownFormField<String>(
              labelText: s.invoiceType,
              value: ctrl.type?.getTitle(),
              required: true,
              showRequiredIcon: false,
              items: getDropDownMenuItemsFromString(menuItems: InvoiceType.values.map((final e) => e.getTitle()).toList()),
              onChanged: (final value) {
                ctrl.type = InvoiceType.values.firstWhereOrNull((final e) => e.getTitle() == value);
              },
            ),
            WDropDownFormField<String>(
              labelText: s.status,
              value: ctrl.status?.getTitle(),
              required: true,
              showRequiredIcon: false,
              items: getDropDownMenuItemsFromString(menuItems: InvoiceStatusType.values.map((final e) => e.getTitle()).toList()),
              onChanged: (final value) {
                ctrl.status = InvoiceStatusType.values.firstWhereOrNull((final e) => e.getTitle() == value);
              },
            ),
            WAmountCurrencyField(
              controller: ctrl.amountCtrl,
              labelText: s.amount,
              required: true,
              showRequired: false,
            ),
            WTextField(
              controller: ctrl.idCtrl,
              labelText: s.invoiceId,
              minLength: 0,
            ),
            WLabelsMultiSelectFormFieldNew(
              sourceId: ctrl.sourceId ?? '',
              datasource: ctrl.labelDatasource,
              onChanged: (final list) {
                ctrl.selectedLabels.assignAll(list);
              },
            ),
            WMultiDatePickerField(
              labelText: s.reminderTime,
              showYearSelector: true,
              initialDates: ctrl.reminderDates,
              onChanged: (final list) => ctrl.reminderDates.assignAll(list),
            ),
            WImageFiles(
              files: ctrl.selectedFiles,
              onFilesUpdated: (final uploadedFiles) => ctrl.selectedFiles = uploadedFiles,
              uploadingFileStatus: (final value) => ctrl.isUploadingFile = value,
            ).marginOnly(bottom: 24),
          ],
        ),
      ),
    );
  }
}
