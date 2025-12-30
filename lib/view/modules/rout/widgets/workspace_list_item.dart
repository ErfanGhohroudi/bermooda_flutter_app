import 'package:u/utilities.dart';

import '../../../../core/utils/enums/enums.dart';
import '../../../../core/core.dart';
import '../../../../core/theme.dart';
import '../../../../data/data.dart';

class WorkspaceListItem extends StatelessWidget {
  const WorkspaceListItem({
    required this.workspace,
    required this.onTap,
    this.isSelected = false,
    super.key,
  });

  final WorkspaceReadDto workspace;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: context.width,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: isSelected ? 12 : 4),
        decoration: BoxDecoration(
          color: isSelected ? context.theme.primaryColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          spacing: 10,
          children: [
            RichText(
              text: TextSpan(
                style: context.textTheme.bodyMedium,
                children: [
                  TextSpan(text: workspace.title ?? ''),
                  if (!workspace.isAccepted && workspace.type.isMember())
                    TextSpan(
                      text: ' (${s.neww})',
                      style: context.textTheme.bodyMedium!.copyWith(color: AppColors.red),
                    ),
                ],
              ),
            ).expanded(),
            if (workspace.type.isOwner()) UImage(AppIcons.crownOutline, size: 20, color: context.theme.primaryColor),
          ],
        ),
      ),
    );
  }
}
