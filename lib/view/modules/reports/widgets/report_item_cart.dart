import 'package:timeline_tile/timeline_tile.dart';
import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/theme.dart';
import '../../../../data/data.dart';

import 'item_cards/base_item_cards.dart';

class ReportItemCart extends StatelessWidget {
  const ReportItemCart({
    required this.reports,
    required this.index,
    this.showTimelineIndicators = true,
    this.canEdit = true,
    super.key,
  });

  final RxList<IReportReadDto> reports;
  final int index;
  final bool showTimelineIndicators;
  final bool canEdit;

  @override
  Widget build(final BuildContext context) {
    final IReportReadDto item = reports[index];

    if (showTimelineIndicators == false) {
      return _getCard(item);
    }

    return TimelineTile(
      isFirst: index == 0,
      isLast: index == reports.length - 1,
      alignment: TimelineAlign.manual,
      // X Position
      lineXY: 0.0,
      afterLineStyle: LineStyle(thickness: 1.5, color: context.theme.dividerColor),
      beforeLineStyle: LineStyle(thickness: 1.5, color: context.theme.dividerColor),
      indicatorStyle: IndicatorStyle(
        width: 45,
        height: item.type != null ? 45 : 0,
        drawGap: true,
        // Y Position
        indicatorXY: 0.0,
        indicator: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: context.theme.cardColor,
            border: item.type != null ? Border.all(width: 1.5, color: context.theme.dividerColor) : null,
            shape: BoxShape.circle,
          ),
          child: item.type != null ? UImage(item.type?.iconString ?? '', color: context.theme.primaryColorDark) : null,
        ),
      ),
      endChild: _getCard(item),
    );
  }

  Widget _getCard(final IReportReadDto item) {
    if (item is ReportUpdateReadDto) {
      return HistoryUpdateCard(model: item, showStartMargin: showTimelineIndicators, canEdit: canEdit);
    } else if (item is ReportSubtaskArchiveReadDto) {
      return HistorySubtaskArchiveCard(model: item, showStartMargin: showTimelineIndicators, canEdit: canEdit);
    } else if (item is ReportFollowupArchiveReadDto) {
      return HistoryFollowupArchiveCard(model: item, showStartMargin: showTimelineIndicators, canEdit: canEdit);
    } else if (item is ReportNoteReadDto) {
      return HistoryNoteCard(model: item, showStartMargin: showTimelineIndicators, canEdit: canEdit);
    } else if (item is ReportInvoiceReadDto) {
      return HistoryInvoiceCard(model: item, showStartMargin: showTimelineIndicators, canEdit: canEdit);
    } else if (item is ReportContractReadDto) {
      return HistoryContractCard(model: item, showStartMargin: showTimelineIndicators, canEdit: canEdit);
    } else {
      return _notSupportedCard();
    }
  }

  Widget _notSupportedCard() {
    return WCard(
      margin: const EdgeInsetsDirectional.only(start: 10, bottom: 16),
      showBorder: true,
      borderColor: AppColors.orange.withValues(alpha: 0.5),
      color: AppColors.orange.withValues(alpha: 0.05),
      child: Text(s.notSupportedItem),
    );
  }
}
