import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/widgets/fields/fields.dart';
import '../../../../../core/widgets/fields/sections_dropdown/project_sections_dropdown.dart';
import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../data/data.dart';
import 'create_update_task_controller.dart';

/// set [canChangeStatus] true if you want to hide AppBar and show checkbox.
/// for use for create and Edit task set [canChangeStatus] false.
class CreateUpdateTaskPage extends StatefulWidget {
  const CreateUpdateTaskPage({
    required this.projectId,
    required this.onResponse,
    required this.onDelete,
    this.model,
    this.section,
    this.onSubtasksChanged,
    this.canChangeStatus = false,
    super.key,
  });

  final String projectId;
  final Function(TaskReadDto model) onResponse;
  final Function(TaskReadDto model) onDelete;
  final TaskReadDto? model;
  final ProjectSectionReadDto? section;
  final Function(List<SubtaskReadDto> list)? onSubtasksChanged;
  final bool canChangeStatus;

  @override
  State<CreateUpdateTaskPage> createState() => _CreateUpdateTaskPageState();
}

class _CreateUpdateTaskPageState extends State<CreateUpdateTaskPage> {
  late final CreateUpdateTaskController ctrl;

  @override
  void initState() {
    ctrl = Get.put(CreateUpdateTaskController(
      projectId: widget.projectId,
      task: widget.model,
      selectedSection: widget.section,
    ));
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (final didPop, final result) {
        if (didPop) return;
        if (!ctrl.isChanged || !ctrl.pageState.isLoaded()) return UNavigator.back();

        appShowYesCancelDialog(
          description: s.exitPage,
          onYesButtonTap: () {
            UNavigator.back();
            widget.onSubtasksChanged?.call(ctrl.subtasks);
            Future.delayed(const Duration(milliseconds: 10), () {
              UNavigator.back();
            });
          },
        );
      },
      child: UScaffold(
        appBar: widget.canChangeStatus ? null : AppBar(title: Text(ctrl.isCreate ? s.newTask : s.editTask)),
        bottomNavigationBar: Obx(
          () => ctrl.pageState.isLoaded() && ctrl.haveAccess && !ctrl.task!.isDeleted
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (ctrl.isUpdate && ctrl.haveAdminAccess)
                      WTextButton(
                        text: "${s.delete} ${s.task}",
                        textStyle: context.textTheme.bodyMedium!.copyWith(color: AppColors.red, fontWeight: FontWeight.bold, fontSize: 14),
                        onPressed: () => ctrl.delete(
                          action: () {
                            widget.onDelete(ctrl.task!);
                            UNavigator.back();
                          },
                        ),
                      ).marginOnly(bottom: 6),
                    Obx(
                      () => UElevatedButton(
                        enable: ctrl.isChanged,
                        title: s.save,
                        width: context.width,
                        isLoading: ctrl.buttonState.isLoading(),
                        onTap: () => ctrl.onSubmit(
                          onResponse: (final model) {
                            widget.onResponse(model);
                            UNavigator.back();
                          },
                        ),
                      ).pOnly(left: 16, right: 16, bottom: 24),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        body: Obx(
          () {
            if (ctrl.pageState.isError()) {
              return Center(child: WErrorWidget(onTapButton: ctrl.getTask));
            }

            return ctrl.pageState.isLoaded()
                ? SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    child: Form(
                      key: ctrl.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 18,
                        children: [
                          Obx(
                            () => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              spacing: 18,
                              children: [
                                if (ctrl.isCreate && widget.section == null)
                                  WProjectSectionsDropDownFormField(
                                    value: ctrl.selectedSection,
                                    projectId: ctrl.projectId,
                                    required: true,
                                    onChanged: (final value) {
                                      ctrl.selectedSection = value;
                                    },
                                  ),
                                WTextField(
                                  enabled: ctrl.haveAccess && !ctrl.task!.isDeleted,
                                  controller: ctrl.titleController,
                                  labelText: s.title,
                                  required: true,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                ),
                                WTextField(
                                  enabled: ctrl.haveAccess && !ctrl.task!.isDeleted,
                                  controller: ctrl.descriptionController,
                                  labelText: s.description,
                                  multiLine: true,
                                  showCounter: true,
                                  maxLength: 2000,
                                  maxLines: 20,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                ),
                                WCard(
                                  showBorder: true,
                                  margin: EdgeInsets.zero,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 10,
                                    children: [
                                      Text(s.progressStatus).titleMedium(),
                                      WLabelProgressBar(
                                        value: ctrl.task?.taskProgress?.round() ?? 0,
                                        backgroundColor: context.theme.dividerColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const Center(child: WCircularLoading());
          },
        ),
      ),
    );
  }
}
