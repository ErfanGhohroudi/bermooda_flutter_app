import 'package:u/utilities.dart';

import '../../../../../../core/widgets/image_files.dart';
import '../../../../../../core/widgets/fields/amount_field/amount_currency_field.dart';
import '../../../../../../core/widgets/fields/fields.dart';
import '../../../../../../core/widgets/fields/labels_dropdown_new/labels_dropdown_new.dart';
import '../../../../../../core/core.dart';
import 'contract_form_controller.dart';

class ContractForm extends StatelessWidget {
  const ContractForm({
    required this.ctrl,
    super.key,
  });

  final ContractFormController ctrl;

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
            Text("${s.contract}:").titleMedium(color: context.theme.hintColor).marginOnly(top: 18),
            WTextField(
              controller: ctrl.titleCtrl,
              labelText: s.title,
              required: true,
            ),
            WLabelsDropDownFormFieldNew(
              sourceId: ctrl.sourceId ?? '',
              datasource: ctrl.labelDatasource,
              labelText: s.contractType,
              onChanged: (final value) {
                ctrl.selectedContractType = value;
              },
            ),
            Row(
              spacing: 10,
              children: [
                WDatePickerField(
                  labelText: s.startDate,
                  showYearSelector: true,
                  onConfirm: (final date, final compactFormatterDate) {
                    ctrl.selectedStartDate = date;
                  },
                ).expanded(),
                WDatePickerField(
                  labelText: s.endDate,
                  showYearSelector: true,
                  onConfirm: (final date, final compactFormatterDate) {
                    ctrl.selectedEndDate = date;
                  },
                ).expanded(),
              ],
            ),
            WAmountCurrencyField(
              controller: ctrl.amountCtrl,
              labelText: s.amount,
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
