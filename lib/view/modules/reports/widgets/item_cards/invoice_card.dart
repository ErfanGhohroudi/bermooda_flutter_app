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
      showStartMargin: showStartMargin,
      children: [
        baseHeader(context, model),
        ...[
          buildRowInfo(
            context: context,
            title: s.invoiceId,
            value: Text(invoice?.invoiceId ?? '- -').bodyMedium(),
          ),
          buildRowInfo(
            context: context,
            title: s.amount,
            value: Text(
              (invoice?.amount ?? '0').toTomanMoney(),
            ).bodyMedium(),
          ),
          buildRowInfo(
            context: context,
            title: s.type,
            value: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                if (invoice?.type != null)
                  WLabel(
                    text: invoice?.type?.getTitle(),
                  ),
                if (invoice?.status != null)
                  WLabel(
                    text: invoice?.status?.getTitle(),
                  ),
              ],
            ),
          ),
          if ((invoice?.files ?? []).isNotEmpty)
            WImageFiles(
              files: invoice!.files,
              removable: false,
              showUploadWidget: false,
              itemsSize: 50,
              onFilesUpdated: (final uploadedFiles) {},
              uploadingFileStatus: (final value) {},
            ),
        ],
      ],
    );
  }
}
