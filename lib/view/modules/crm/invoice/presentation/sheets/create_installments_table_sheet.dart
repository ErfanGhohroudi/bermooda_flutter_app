import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../core/widgets/fields/fields.dart';
import '../controllers/create_invoice_controller.dart';

class CreateInstallmentsTableSheet extends StatelessWidget {
  const CreateInstallmentsTableSheet({
    required this.ctrl,
    super.key,
  });

  final CreateInvoiceController ctrl;

  @override
  Widget build(final BuildContext context) {
    return Form(
      key: ctrl.installmentStepFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 18,
        children: [
          // Installment Count
          WPlusMinusField(
            labelText: s.installmentCount,
            defaultValue: ctrl.installmentCount,
            required: true,
            min: 1,
            max: 24,
            onChanged: (final value) {
              ctrl.installmentCount = value;
            },
          ),

          // Interest Percentage
          WPlusMinusField(
            labelText: '${s.interestRate} (%)',
            defaultValue: ctrl.interestPercentage.value,
            max: 100,
            onChanged: (final value) {
              ctrl.interestPercentage(value);
            },
          ),

          // Installment Start Date
          WDatePickerField(
            labelText: 'تاریخ اولین قسط',
            initialValue: ctrl.installmentStartDate,
            required: true,
            startDate: Jalali.now(),
            showYearSelector: true,
            enableClearButton: false,
            onConfirm: (final date) {
              ctrl.installmentStartDate = date;
            },
          ),

          // Installment Period
          WPlusMinusField(
            defaultValue: ctrl.installmentPeriod,
            labelText: '${s.period} (${s.month})',
            min: 1,
            onChanged: (final value) {
              ctrl.installmentPeriod = value;
            },
          ),

          const SizedBox.shrink(),

          UElevatedButton(
            width: context.width,
            title: s.createInstallments,
            backgroundColor: AppColors.green,
            onTap: () {
              final isFormValidate = ctrl.validateInstallmentsForm();
              if (isFormValidate) {
                ctrl.calculateInstallments(generateNew: true);
              }
              Navigator.pop(context, true);
            },
          ),
        ],
      ),
    );
  }
}
