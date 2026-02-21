import 'package:u/utilities.dart';

import '../core.dart';

class WFilterSheetButtons extends StatelessWidget {
  const WFilterSheetButtons({
    required this.onTapClear,
    required this.onTapApply,
    super.key,
  });

  final VoidCallback onTapClear;
  final VoidCallback onTapApply;

  @override
  Widget build(final BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Expanded(
          child: UElevatedButton(
            title: s.clear,
            backgroundColor: context.theme.hintColor,
            onTap: onTapClear,
          ),
        ),
        Expanded(
          child: UElevatedButton(
            title: s.applyFilter,
            onTap: onTapApply,
          ),
        ),
      ],
    );
  }
}
