import 'package:u/utilities.dart';

import '../../../../../core/core.dart';

class TypingIndicatorWidget extends StatelessWidget {
  const TypingIndicatorWidget({
    required this.isTyping,
    required this.isGroup,
    this.typingUsers = const [],
    super.key,
  });

  final bool isTyping;
  final bool isGroup;
  final List<String> typingUsers;

  @override
  Widget build(final BuildContext context) {
    if (!isTyping || typingUsers.isEmpty) {
      return const SizedBox.shrink();
    }

    String statusText = '';

    if (isGroup) {
      statusText = isPersianLang ? '${typingUsers.length} نفر در حال تایپ...' : '${typingUsers.length} typing...';
    } else {
      statusText = isPersianLang ? 'در حال تایپ...' : 'typing...';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        SizedBox(
          width: 10,
          height: 10,
          child: CircularProgressIndicator(strokeWidth: 2, color: context.theme.hintColor),
        ),
        Flexible(child: Text(statusText).bodySmall(color: context.theme.hintColor)),
      ],
    );
  }
}
