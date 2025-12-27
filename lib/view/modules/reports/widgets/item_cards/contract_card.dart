part of 'base_item_cards.dart';

class HistoryContractCard extends StatelessWidget {
  const HistoryContractCard({
    required this.model,
    required this.showStartMargin,
    required this.canEdit,
    super.key,
  });

  final ReportContractReadDto model;
  final bool showStartMargin;
  final bool canEdit;

  @override
  Widget build(final BuildContext context) {
    final ContractEntity? contract = model.contract;

    return baseCard(
      showStartMargin: showStartMargin,
      children: [
        baseHeader(context, model),
        ...[
          buildRowInfo(
            context: context,
            title: s.contractTitle,
            value: Text(contract?.title ?? '- -').bodyMedium(),
          ),
          if (contract?.contractType?.title != null)
            buildRowInfo(
              context: context,
              title: s.contractType,
              value: Wrap(
                children: [
                  WLabel(
                    text: contract?.contractType?.title,
                    color: contract?.contractType?.colorCode.toColor(),
                  ),
                ],
              ),
            ),
          buildRowInfo(
            context: context,
            title: s.startDate,
            value: Text(contract?.startDate?.formatCompactDate() ?? '- -').bodyMedium(),
          ),
          buildRowInfo(
            context: context,
            title: s.endDate,
            value: Text(contract?.endDate?.formatCompactDate() ?? '- -').bodyMedium(),
          ),
          if (contract?.amount != null)
            buildRowInfo(
              context: context,
              title: s.amount,
              value: Text(
                (contract?.amount ?? '0').toTomanMoney(),
              ).bodyMedium(),
            ),
          if ((contract?.files ?? []).isNotEmpty)
            WImageFiles(
              files: contract!.files,
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
