import 'package:u/utilities.dart';

import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../data/data.dart';

class WorkspaceListItem extends StatelessWidget {
  const WorkspaceListItem({
    required this.workspace,
    required this.onTap,
    super.key,
  });

  final WorkspaceReadDto workspace;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: context.width,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
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
