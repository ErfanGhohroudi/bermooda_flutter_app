import 'package:decimal/decimal.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../core/utils/extensions/money_extensions.dart';
import '../../../../../../core/widgets/fields/fields.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../controllers/create_invoice_controller.dart';
import '../widgets/installments_table.dart';

class InvoiceInstallmentsStep extends StatelessWidget {
  const InvoiceInstallmentsStep({
    required this.ctrl,
    super.key,
  });

  final CreateInvoiceController ctrl;

  @override
  Widget build(final BuildContext context) {
    return Form(
      key: ctrl.installmentStepFormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10, bottom: 100),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Installment Fields
              Obx(
                () {
                  if (ctrl.selectedPaymentTerms.value != PaymentTerms.installment) {
                    return const SizedBox.shrink();
                  }

                  return Column(
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
                        labelText: 'شروع اقساط از',
                        initialValue: ctrl.installmentStartDate?.formatCompactDate(),
                        required: true,
                        startDate: Jalali.now(),
                        showYearSelector: true,
                        enableClearButton: false,
                        onConfirm: (final date, final formattedDate) {
                          ctrl.installmentStartDate = date;
                        },
                      ),

                      // Installment Period
                      WPlusMinusField(
                        defaultValue: ctrl.installmentPeriod,
                        labelText: '${s.period} (${s.day})',
                        min: 1,
                        onChanged: (final value) {
                          ctrl.installmentPeriod = value;
                        },
                      ),

                      UElevatedButton(
                        width: context.width,
                        title: "s.createInstallments",
                        backgroundColor: AppColors.green,
                        onTap: () {
                          final isFormValidate = ctrl.validateInstallmentsForm();
                          if (isFormValidate) {
                            ctrl.calculateInstallments(generateNew: true);
                          }
                        },
                      ),
                    ],
                  ).marginOnly(bottom: 24);
                },
              ),

              // // Date to Pay
              // WDatePickerField(
              //   labelText: s.paymentDate,
              //   initialValue: ctrl.dateToPay?.formatCompactDate(),
              //   onConfirm: (final date, final formattedDate) {
              //     ctrl.dateToPay = date;
              //   },
              // ),

              // Installments (if applicable)
              Obx(
                () {
                  if (ctrl.installmentPayments.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WInstallmentsTable(
                          installmentPayments: ctrl.installmentPayments,
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              // Interest (if installment)
              if (ctrl.interestAmount > 0.toDecimal())
                _calculationRow(
                  s.interestRate, // Interest Rate
                  ctrl.interestAmount.toString().toRialMoney(),
                ),
              _calculationRow(
                s.payable,
                ctrl.finalPriceWithInterest.toRialMoney(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _calculationRow(final String label, final String value, {final bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label).bodyMedium(),
        Text(value).bodyMedium(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
      ],
    );
  }
}
