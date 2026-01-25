import 'package:bermooda_business/core/utils/extensions/color_extension.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../domain/entities/invoice.dart';
import '../pages/invoice_detail_page.dart';

class WInvoiceCard extends StatelessWidget {
  const WInvoiceCard({
    required this.invoice,
    super.key,
  });

  final InvoiceEntity invoice;

  @override
  Widget build(final BuildContext context) {
    return WCard(
      onTap: () => UNavigator.push(InvoiceDetailPage(invoiceId: invoice.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          buildRowInfo(
            context: context,
            title: s.invoiceId,
            value: Row(
              spacing: 4,
              children: [
                Expanded(child: Text(invoice.invoiceCode).bodyMedium()),
                if (invoice.status != null)
                  WLabel(
                    text: invoice.status!.title,
                    color: invoice.status!.colorCode.toColor(),
                  ),
              ],
            ),
          ),
          buildRowInfo(
            context: context,
            title: s.type,
            value: WLabel(
              text: invoice.invoiceType.getTitle(),
            ),
          ),
          buildRowInfo(
            context: context,
            title: s.amount,
            value: Text(
              invoice.factorPrice?.finalPrice ?? '- -',
            ).bodyMedium(),
          ),
          Text('${s.date}: ${invoice.createdDatePersian}').bodySmall(color: context.theme.hintColor),
        ],
      ),
    );
  }

  Widget buildRowInfo({
    required final BuildContext context,
    required final String title,
    required final Widget value,
  }) => Row(
    children: [
      Text("$title: ").bodyMedium(color: context.theme.hintColor),
      value.expanded(),
    ],
  );
}
