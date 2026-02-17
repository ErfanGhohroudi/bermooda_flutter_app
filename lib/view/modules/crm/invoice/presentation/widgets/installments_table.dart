import 'package:decimal/decimal.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../core/utils/extensions/money_extensions.dart';
import '../../../../../../core/widgets/fields/amount_field/amount_currency_field.dart';
import '../../../../../../core/widgets/fields/fields.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../data/models/invoice_params.dart';

class WInstallmentsTable extends StatelessWidget {
  WInstallmentsTable({
    required this.installmentPayments,
    this.editable = true,
    this.startDate,
    this.onRemove,
    this.onUpdate,
    this.onAdd,
    this.initialBalancingValue,
    final Decimal? principalInvoiceAmount,
    this.imbalance,
    super.key,
  }) : principalInvoiceAmount = principalInvoiceAmount ?? Decimal.zero;

  final List<InstallmentParams> installmentPayments;
  final bool editable;
  final Jalali? startDate;
  final Function(int)? onRemove;
  final Function(int, Decimal, Jalali, bool)? onUpdate;
  final Function(Decimal, Jalali, bool)? onAdd;
  final bool? initialBalancingValue;
  final Decimal principalInvoiceAmount;
  final Decimal? imbalance;

  @override
  Widget build(final BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
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
                    width: 20,
                    child: const Text("#").bodySmall().alignAtCenter().pSymmetric(vertical: 12),
                  ),
                  const VerticalDivider(),
                  Expanded(
                    flex: 2,
                    child: Text(s.paymentDate).bodySmall().alignAtCenter().pSymmetric(vertical: 12),
                  ),
                  const VerticalDivider(),
                  Expanded(
                    flex: 5,
                    child: Text(
                      "${s.amount} (${s.rial})",
                      textAlign: editable ? null : TextAlign.center,
                    ).bodySmall().pSymmetric(vertical: 12),
                  ),
                ],
              ),
            ),
          ),

          /// Items List
          ...installmentPayments.asMap().entries.map((final entry) {
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
                  children: [
                    SizedBox(
                      width: 20,
                      child: Text('${index + 1}').bodySmall().alignAtCenter().pSymmetric(vertical: 10),
                    ),
                    const VerticalDivider(),
                    Expanded(
                      flex: 2,
                      child: Text(
                        payment.dateToPay.formatCompactDate(),
                      ).bodySmall().alignAtCenter().pSymmetric(vertical: 10),
                    ),
                    const VerticalDivider(),
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          Text(
                            payment.totalAmount.toRialMoney(),
                            textAlign: editable ? null : TextAlign.center,
                          ).bodySmall().expanded(),
                          if (editable)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => _showInstallmentBottomSheet(
                                    context,
                                    index: index,
                                    initialAmount: payment.totalAmount,
                                    initialDate: payment.dateToPay,
                                  ),
                                  icon: const UImage(AppIcons.editOutline, color: AppColors.green, size: 20),
                                  tooltip: s.edit,
                                  style: IconButton.styleFrom(
                                    padding: const EdgeInsets.all(5),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => onRemove?.call(index),
                                  icon: const UImage(AppIcons.delete, color: AppColors.red, size: 20),
                                  tooltip: s.remove,
                                  style: IconButton.styleFrom(
                                    padding: const EdgeInsets.all(5),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ).pSymmetric(vertical: 10),
                    ),
                  ],
                ),
              ),
            );
          }),

          /// Footer (Add Row)
          if (editable)
            InkWell(
              onTap: () => _showInstallmentBottomSheet(context),
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                  color: context.theme.primaryColor.withValues(alpha: 0.05),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline, size: 18, color: context.theme.primaryColor),
                    const SizedBox(width: 8),
                    Text(s.addRow, style: TextStyle(color: context.theme.primaryColor)).bodySmall(),
                  ],
                ),
              ),
            ),

          if (editable && imbalance != null && imbalance != Decimal.zero)
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: imbalance! > Decimal.zero ? AppColors.red.withValues(alpha: 0.1) : AppColors.green.withValues(alpha: 0.1),
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                children: [
                  UImage(
                    imbalance! > Decimal.zero ? AppIcons.warningOutline : AppIcons.info,
                    size: 16,
                    color: imbalance! > Decimal.zero ? AppColors.red : AppColors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(
                        imbalance! > Decimal.zero ? s.remainingAmountToBalance : s.extraAmountToBalance,
                      )
                      .bodySmall(
                        color: imbalance! > Decimal.zero ? AppColors.red : AppColors.green,
                        fontWeight: FontWeight.bold,
                      )
                      .expanded(),
                  Text(
                    imbalance!.abs().toRialMoney(),
                  ).bodySmall(
                    color: imbalance! > Decimal.zero ? AppColors.red : AppColors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showInstallmentBottomSheet(
    final BuildContext context, {
    final int? index,
    final Decimal? initialAmount,
    final Jalali? initialDate,
  }) {
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController(text: initialAmount?.toString() ?? '');
    Jalali? selectedDate = initialDate;
    final balancing = (initialBalancingValue ?? true).obs;

    bottomSheet(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 18,
          children: [
            Text(
              index == null ? s.addRow : s.edit,
              style: context.textTheme.titleLarge,
            ),
            WAmountCurrencyField(
              controller: amountController,
              labelText: s.amount,
              currencyText: s.rial,
              required: true,
            ),
            WDatePickerField(
              labelText: s.paymentDate,
              initialValue: selectedDate?.formatCompactDate(),
              required: true,
              startDate: startDate ?? Jalali.now(),
              onConfirm: (final date, final _) {
                selectedDate = date;
              },
            ),
            Obx(
              () => WSwitchForm(
                value: balancing.value,
                title: s.balancingRemainingInstallments,
                onChanged: () => balancing(!balancing.value),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              spacing: 12,
              children: [
                UElevatedButton(
                  title: s.cancel,
                  backgroundColor: context.theme.hintColor,
                  onTap: () => AppNavigator.back(),
                ).expanded(),
                UElevatedButton(
                  title: s.save,
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      if (selectedDate == null) {
                        AppSnackBar.snackbarRed(title: s.error, subtitle: s.installmentStartDateRequired);
                        return;
                      }
                      final amount = Decimal.parse(amountController.text.numericOnly());
                      if (amount > principalInvoiceAmount) {
                        AppSnackBar.snackbarRed(title: s.error, subtitle: 'مبلغ قسط از مبلق فاکتور بیشتر است.');
                        return;
                      }
                      if (index == null) {
                        onAdd?.call(amount, selectedDate!, balancing.value);
                      } else {
                        onUpdate?.call(index, amount, selectedDate!, balancing.value);
                      }
                      AppNavigator.back();
                    }
                  },
                ).expanded(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
