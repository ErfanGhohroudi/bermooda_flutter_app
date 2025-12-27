import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import 'note_form_controller.dart';

class NoteForm extends StatelessWidget {
  const NoteForm({
    required this.ctrl,
    super.key,
  });

  final NoteFormController ctrl;

  @override
  Widget build(final BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Form(
        key: ctrl.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            Text("${s.note}:").titleMedium(color: context.theme.hintColor).marginOnly(top: 18),
            UTextFormField(
              controller: ctrl.noteController,
              validator: validateNotEmpty(requiredMessage: s.requiredField),
              keyboardType: TextInputType.multiline,
              maxLength: 5000,
              minLines: 10,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              maxLines: 10,
              showCounter: true,
              hintText: s.description,
              formatters: [NoLeadingSpaceInputFormatter()],
              onTapOutside: (final event) => FocusManager.instance.primaryFocus?.unfocus(),
            ),
          ],
        ),
      ),
    );
  }
}
