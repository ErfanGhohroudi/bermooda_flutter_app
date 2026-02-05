import 'package:decimal/decimal.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../core/utils/extensions/money_extensions.dart';
import '../../../../../../core/widgets/fields/fields.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../controllers/create_invoice_controller.dart';

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
                  if (ctrl.selectedPaymentTerms.value == PaymentTerms.installment && ctrl.installmentPayments.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInstallmentsTable(context),
                        const SizedBox(height: 16),
                        Text(
                          "«سود اقساط این فاکتور به‌صورت قطعی محاسبه و به‌طور مساوی بین اقساط توزیع شده است.»",
                        ).bodySmall(),
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

  Widget _buildInstallmentsTable(final BuildContext context) {
    final cellsWidth = <double>[
      20, // #
      60, // date
      60, // amount
      60, // interest amount
      170, // total amount
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Scrollbar(
        trackVisibility: true,
        thumbVisibility: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: context.width - 32,
            ),
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: cellsWidth[0],
                            child: const Text("#").bodySmall().alignAtCenter().pSymmetric(vertical: 12),
                          ),
                          const VerticalDivider(),
                          SizedBox(
                            width: cellsWidth[1],
                            child: Text(s.paymentDate).bodySmall().alignAtCenter().pSymmetric(vertical: 12),
                          ),
                          const VerticalDivider(),
                          SizedBox(
                            width: cellsWidth[2],
                            child: Text(s.amount).bodySmall().alignAtCenter().pSymmetric(vertical: 12),
                          ),
                          const VerticalDivider(),
                          SizedBox(
                            width: cellsWidth[3],
                            child: Text("s.profit").bodySmall().alignAtCenter().pSymmetric(vertical: 12),
                          ),
                          const VerticalDivider(),
                          SizedBox(
                            width: cellsWidth[4],
                            child: Row(
                              children: [
                                Text(s.total).bodySmall().bold().expanded(),
                              ],
                            ).pSymmetric(vertical: 12),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// Items List
                  ...ctrl.installmentPayments.asMap().entries.map((final entry) {
                    final index = entry.key;
                    final payment = entry.value;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.grey.shade300)),
                        color: index.isEven ? Colors.white : Colors.grey.shade50,
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: cellsWidth[0],
                              child: Text('${index + 1}').bodySmall().alignAtCenter().pSymmetric(vertical: 10),
                            ),
                            const VerticalDivider(),
                            SizedBox(
                              width: cellsWidth[1],
                              child: Text(
                                payment.dateToPay.formatCompactDate(),
                              ).bodySmall().alignAtCenter().pSymmetric(vertical: 10),
                            ),
                            const VerticalDivider(),
                            SizedBox(
                              width: cellsWidth[2],
                              child: Text(payment.principalAmount.toRialMoney()).bodySmall().pSymmetric(vertical: 10),
                            ),
                            const VerticalDivider(),
                            SizedBox(
                              width: cellsWidth[3],
                              child: Text(payment.profitAmount.toRialMoney()).bodySmall().pSymmetric(vertical: 10),
                            ),
                            const VerticalDivider(),
                            SizedBox(
                              width: cellsWidth[4],
                              child: Row(
                                children: [
                                  Text(payment.totalAmount.toRialMoney()).bodySmall().bold().expanded(),
                                ],
                              ).pSymmetric(vertical: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
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
