import 'package:u/utilities.dart';

class ReactionPickerWidget extends StatelessWidget {
  const ReactionPickerWidget({
    required this.onReactionSelected,
    super.key,
  });

  final Function(String emoji) onReactionSelected;

  static const List<String> defaultReactions = ['👍', '❤️', '😂', '😮', '😢', '🙏', '👏', '🔥'];

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      constraints: const BoxConstraints(maxWidth: 250),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Scrollbar(
        thumbVisibility: true,
        trackVisibility: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: defaultReactions.map((final emoji) {
              return GestureDetector(
                onTap: () => onReactionSelected(emoji),
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              );
            }).toList(),
          ).pOnly(bottom: 6),
        ),
      ),
    );
  }
}

