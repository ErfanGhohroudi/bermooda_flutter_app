import 'package:flutter/cupertino.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../data/data.dart';

class CreateLegalCaseField extends StatefulWidget {
  const CreateLegalCaseField({
    required this.departmentId,
    required this.sectionSlug,
    required this.onResponse,
    required this.onUnFocus,
    super.key,
  });

  final String departmentId;
  final String sectionSlug;
  final Function(LegalCaseReadDto model) onResponse;
  final VoidCallback onUnFocus;

  @override
  State<CreateLegalCaseField> createState() => _CreateLegalCaseFieldState();
}

class _CreateLegalCaseFieldState extends State<CreateLegalCaseField> {
  final LegalCaseDatasource _datasource = Get.find<LegalCaseDatasource>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (controller.text.isNotEmpty) {
      _createLegalCase();
      return;
    }
    widget.onUnFocus();
  }

  void _createLegalCase() {
    validateForm(
      key: formKey,
      action: () {
        _datasource.create(
          departmentId: widget.departmentId,
          title: controller.text.trim(),
          sectionSlug: widget.sectionSlug,
          onResponse: (final response) {
            widget.onResponse(response.result!);
          },
          onError: (final errorResponse) {},
          withRetry: true,
        );
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Form(
      key: formKey,
      child: UTextFormField(
        controller: controller,
        autofocus: true,
        onEditingComplete: _onSubmit,
        hintText: s.title,
        focusNode: focusNode,
        formatters: [NoLeadingSpaceInputFormatter()],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validateMinLength(3, required: false, minLengthMessage: s.isShort.replaceAll('#', '3')),
        onTapOutside: (final event) => _onSubmit(),
        suffixIcon: Icon(CupertinoIcons.add_circled, size: 30, color: context.theme.primaryColor).onTap(_onSubmit),
      ),
    );
  }
}
