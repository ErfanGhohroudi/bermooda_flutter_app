import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/utils/extensions/money_extensions.dart';
import '../../../../../../data/data.dart';

class WInstallmentsTable extends StatelessWidget {
  const WInstallmentsTable({
    required this.installmentPayments,
    this.editable = true,
    super.key,
  });

  final List<InstallmentResult> installmentPayments;
  final bool editable;

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
                    flex: 3,
                    child: Row(
                      children: [
                        Text("${s.amount} (${s.rial})").bodySmall().expanded(),
                      ],
                    ).pSymmetric(vertical: 12),
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
                      flex: 3,
                      child: Row(
                        children: [
                          Text(payment.totalAmount.toRialMoney()).bodySmall().expanded(),
                        ],
                      ).pSymmetric(vertical: 10),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
