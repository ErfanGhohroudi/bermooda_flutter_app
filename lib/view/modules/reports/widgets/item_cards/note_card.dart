part of 'base_item_cards.dart';

class HistoryNoteCard extends StatelessWidget {
  const HistoryNoteCard({
    required this.model,
    required this.showStartMargin,
    required this.canEdit,
    super.key,
  });

  final ReportNoteReadDto model;
  final bool showStartMargin;
  final bool canEdit;

  @override
  Widget build(final BuildContext context) {
    return baseCard(
      showStartMargin: showStartMargin,
      children: [
        baseHeader(context, model),
        baseBodyText(context, model),
      ],
    );
  }
}
