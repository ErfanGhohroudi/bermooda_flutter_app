part of 'base_item_cards.dart';

class HistoryInvoiceCard extends StatelessWidget {
  const HistoryInvoiceCard({
    required this.model,
    required this.showStartMargin,
    required this.canEdit,
    super.key,
  });

  final ReportInvoiceReadDto model;
  final bool showStartMargin;
  final bool canEdit;

  @override
  Widget build(final BuildContext context) {
    final InvoiceEntity? invoice = model.invoice;

    return baseCard(
      onTap: invoice != null ? () => UNavigator.push(InvoiceDetailPage(invoiceId: invoice.id)) : null,
      showStartMargin: showStartMargin,
      children: [
        baseHeader(context, model),
        ...[
          buildRowInfo(
            context: context,
            title: s.invoiceId,
            value: Row(
              spacing: 4,
              children: [
                Expanded(child: Text(invoice?.invoiceCode ?? '- -').bodyMedium()),
                if (invoice?.status != null)
                  WLabel(
                    text: invoice?.status!.title,
                    color: invoice?.status!.colorCode.toColor(),
                  ),
              ],
            ),
          ),
          if (invoice?.invoiceType != null)
            buildRowInfo(
              context: context,
              title: s.type,
              value: WLabel(
                text: invoice?.invoiceType.getTitle(),
              ),
            ),
          buildRowInfo(
            context: context,
            title: s.amount,
            value: Text(
              invoice?.factorPrice?.finalPrice ?? '- -',
            ).bodyMedium(),
          ),
        ],
      ],
    );
  }
}
