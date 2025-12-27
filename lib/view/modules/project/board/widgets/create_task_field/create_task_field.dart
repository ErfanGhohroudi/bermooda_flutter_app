import 'package:flutter/cupertino.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../data/data.dart';

class CreateTaskField extends StatefulWidget {
  const CreateTaskField({
    required this.projectId,
    required this.section,
    required this.onResponse,
    required this.onUnFocus,
    super.key,
  });

  final String projectId;
  final ProjectSectionReadDto? section;
  final Function(TaskReadDto model) onResponse;
  final VoidCallback onUnFocus;

  @override
  State<CreateTaskField> createState() => _CreateTaskFieldState();
}

class _CreateTaskFieldState extends State<CreateTaskField> {
  final TaskDatasource _taskDatasource = Get.find<TaskDatasource>();
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
      _createTask();
      return;
    }
    widget.onUnFocus();
  }

  void _createTask() {
    validateForm(
      key: formKey,
      action: () {
        _taskDatasource.create(
          dto: TaskParams(
            title: controller.text.trim(),
            subtasks: [],
            projectId: widget.projectId,
            sectionId: widget.section?.id,
          ),
          onResponse: (final response) {
            widget.onResponse(response.result!);
          },
          onError: (final errorResponse) {},
          withRetry: true,
          withLoading: true,
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
