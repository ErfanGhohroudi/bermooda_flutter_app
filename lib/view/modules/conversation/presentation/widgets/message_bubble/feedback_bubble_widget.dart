import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/functions/direction_functions.dart';
import '../../../../../../core/utils/extensions/time_extensions.dart';
import '../../../../../../view/modules/conversation/data/dto/conversation_dtos.dart';

class FeedbackBubbleWidget extends StatefulWidget {
  const FeedbackBubbleWidget({
    required this.message,
    super.key,
  });

  final FeedbackDto message;

  @override
  State<FeedbackBubbleWidget> createState() => _FeedbackBubbleWidgetState();
}

class _FeedbackBubbleWidgetState extends State<FeedbackBubbleWidget> {
  late FeedbackDto _message;

  @override
  void initState() {
    super.initState();
    _message = widget.message;
  }

  @override
  void didUpdateWidget(covariant final FeedbackBubbleWidget oldWidget) {
    if (oldWidget.message != widget.message) {
      if (mounted) {
        setState(() {
          _message = widget.message;
        });
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(final BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ChatBubble(
        clipper: ChatBubbleClipper5(type: BubbleType.receiverBubble),
        alignment: Alignment.centerLeft,
        backGroundColor: context.theme.cardColor,
        shadowColor: context.theme.shadowColor,
        child: Container(
          constraints: BoxConstraints(
            minWidth: 40,
            maxWidth: context.width / 1.4,
          ),
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Sub-category
              if (_message.subcategory != null)
                Text(_message.subcategory?.displayTitle ?? '').bodySmall(color: context.theme.hintColor).marginOnly(bottom: 5),

              /// Body
              if (_message.text != null && _message.text!.isNotEmpty)
                Text(
                  _message.text!,
                  textDirection: getDirection(_message.text!),
                ).bodyMedium().marginOnly(bottom: 7),

              /// Time & Priority
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 10,
                children: [
                  Text(widget.message.createdAt.toJalali().formatToHHMM).bodySmall(color: context.theme.hintColor),
                  WLabel(
                    text: _message.priority.getTitle(),
                    color: _message.priority.color,
                    verticalPadding: 1,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
