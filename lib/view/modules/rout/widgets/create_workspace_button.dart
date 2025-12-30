import 'package:u/utilities.dart';

import '../../../../core/core.dart';
import '../../../../core/theme.dart';

class CreateWorkspaceButton extends StatelessWidget {
  const CreateWorkspaceButton({
    required this.onTap,
    super.key,
  });

  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: context.width,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Text(s.newWorkspace, style: context.textTheme.bodyMedium),
            const Spacer(),
            UImage(AppIcons.addSquareOutline, size: 25, color: context.theme.primaryColorDark),
          ],
        ),
      ),
    ).marginOnly(top: 2);
  }
}
