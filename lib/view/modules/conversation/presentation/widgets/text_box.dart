import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/functions/direction_functions.dart';

class WTextBox extends StatefulWidget {
  const WTextBox({
    required this.controller,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final Function(String value) onChanged;

  @override
  State<WTextBox> createState() => _WTextBoxState();
}

class _WTextBoxState extends State<WTextBox> {
  @override
  Widget build(final BuildContext context) {
    return Directionality(
      textDirection: isPersianLang ? TextDirection.rtl : TextDirection.ltr,
      child: UTextFormField(
        borderColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        controller: widget.controller,
        maxLines: widget.controller.text != '' ? 3 : 1,
        minLines: 1,
        keyboardType: TextInputType.multiline,
        hintText: s.writeYourMessage,
        formatters: [NoLeadingSpaceInputFormatter()],
        textDirection: getDirection(widget.controller.text),
        onTapOutside: (final event) {},
        onChanged: (final value) {
          widget.onChanged(widget.controller.text);
        },
      ),
    );
  }
}
