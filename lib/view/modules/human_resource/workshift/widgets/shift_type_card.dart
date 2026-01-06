import 'package:u/utilities.dart';

import '../../../../../core/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../data/data.dart';
import '../detail/workshift_detail_controller.dart';

class ShiftTypeCard extends StatelessWidget {
  const ShiftTypeCard({
    required this.shiftType,
    required this.controller,
    super.key,
  });

  final ShiftTypeReadDto shiftType;
  final WorkshiftDetailController controller;

  @override
  Widget build(final BuildContext context) {
    return WCard(
      showBorder: true,
      horPadding: 12,
      verPadding: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shiftType.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ).titleMedium().bold(),
                    Text(
                      '${shiftType.startTime} - ${shiftType.endTime}',
                      maxLines: 1,
                    ).bodySmall(color: context.theme.hintColor).marginOnly(top: 4),
                  ],
                ),
              ),
              if (controller.haveAdminAccess) ...[
                IconButton(
                  onPressed: () => controller.deleteShiftTypeFromServer(shiftType),
                  icon: const UImage(AppIcons.delete, color: Colors.red, size: 20),
                  tooltip: s.delete,
                ),
              ],
            ],
          ),
          if (shiftType.breakStartTime != null && shiftType.breakEndTime != null) ...[
            const SizedBox(height: 8),
            Text(
              '${s.breakText}: ${shiftType.breakStartTime} - ${shiftType.breakEndTime}',
              maxLines: 1,
            ).bodySmall(color: context.theme.hintColor),
          ],
        ],
      ),
    );
  }
}

