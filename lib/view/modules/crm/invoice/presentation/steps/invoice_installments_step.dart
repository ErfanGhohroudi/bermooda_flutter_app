import 'package:decimal/decimal.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/utils/extensions/money_extensions.dart';
import '../../../../../../core/widgets/fields/amount_field/amount_currency_field.dart';
import '../../../../../../core/widgets/fields/fields.dart';
import '../../../../../../core/widgets/widgets.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Installments Table (Scoped Obx)
            Obx(
              () {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WInstallmentsTable(
                      installmentPayments: ctrl.installmentPayments,
                      startDate: ctrl.createdDate,
                      onRemove: ctrl.removeInstallment,
                      onUpdate: ctrl.updateInstallment,
                      onAdd: ctrl.addInstallment,
                      principalInvoiceAmount: ctrl.finalPrice,
                      imbalance: ctrl.installmentsImbalance,
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              },
            ),

            Obx(
              () {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 18,
                  children: [
                    // Late Penalty Settings
                    WSwitchForm(
                      value: ctrl.latePenaltyEnabled.value,
                      title: 'جریمه دیرکرد',
                      onChanged: () => ctrl.latePenaltyEnabled(!ctrl.latePenaltyEnabled.value),
                    ),

                    if (ctrl.latePenaltyEnabled.value) ...[
                      WPlusMinusField(
                        defaultValue: ctrl.latePenaltyRate.value,
                        labelText: 'نرخ جریمه روزانه (%)',
                        max: 100,
                        onChanged: (final value) {
                          ctrl.latePenaltyRate(value);
                        },
                      ),
                      WAmountCurrencyField(
                        controller: ctrl.latePenaltyCapController,
                        labelText: 'سقف جریمه',
                        currencyText: s.rial,
                      ),
                    ],
                  ],
                ).marginOnly(bottom: 24);
              },
            ),

            // Summary (Scoped Obx)
            Obx(
              () {
                if (ctrl.installmentPayments.isEmpty) {
                  return const SizedBox.shrink();
                }

                final totalInstallments = ctrl.installmentPayments.fold(
                  Decimal.zero,
                  (final prev, final element) => prev + element.totalAmount,
                );
                return WCard(
                  showBorder: true,
                  margin: EdgeInsets.zero,
                  verPadding: 16,
                  child: Column(
                    children: [
                      _calculationRow(
                        s.totalInstallmentAmount,
                        totalInstallments.toString().toRialMoney(),
                      ),
                      if (ctrl.interestAmount > 0.toDecimal())
                        _calculationRow(
                          "${s.interestRate} (${ctrl.interestPercentage}%)",
                          ctrl.interestAmount.toString().toRialMoney(),
                        ),
                      _calculationRow(
                        s.payable,
                        ctrl.finalPriceWithInterest.toRialMoney(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _calculationRow(final String label, final String value, {final bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label).bodyMedium(),
          Text(value).bodyMedium(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ],
      ),
    );
  }
}
