import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../data/data.dart';
import '../../board/project_board_controller.dart';
import '../../../../../core/widgets/subtask_card/subtask_card_compact.dart';
import '../../task/task_details_page.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    required this.task,
    required this.controller,
    required this.outerScrollController,
    super.key,
  });

  final TaskReadDto task;
  final ProjectBoardController controller;
  final ScrollController outerScrollController;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late final ProjectBoardController ctrl;
  late final ScrollController _scrollController;
  final TaskDatasource _taskDatasource = Get.find<TaskDatasource>();

  @override
  void initState() {
    ctrl = widget.controller;
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant final TaskCard oldWidget) {
    if (oldWidget.task != widget.task) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(final BuildContext context) {
    final task = widget.task;

    return NotificationListener<ScrollNotification>(
      onNotification: (final notification) {
        if (notification.depth != 0) return false;

        // ---- حالت اول: کاربر در حال کشیدن در لبه‌ها است ----
        if (notification is OverscrollNotification) {
          final double newOffset = widget.outerScrollController.position.pixels + notification.overscroll;
          final double clampedOffset = newOffset.clamp(
            widget.outerScrollController.position.minScrollExtent,
            widget.outerScrollController.position.maxScrollExtent,
          );
          if (clampedOffset != widget.outerScrollController.position.pixels) {
            widget.outerScrollController.jumpTo(clampedOffset);
          }
          return true;
        }

        return false;
      },
      child: WCard(
        showBorder: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                WCheckBox(
                  isChecked: task.doneStatus,
                  size: 20,
                  onChanged: (final value) {
                    appShowYesCancelDialog(
                      description: task.doneStatus ? s.changeStatus : s.changeTaskStatusToDone,
                      onYesButtonTap: () {
                        UNavigator.back();
                        _taskDatasource.changeTaskStatusToDone(
                          taskId: task.id,
                          onResponse: (final response) {},
                          onError: (final errorResponse) {},
                        );
                      },
                    );
                  },
                ),
                Text(task.title ?? '').bodyMedium().bold().marginOnly(top: 6).expanded(),
              ],
            ),
            if (!task.subtasks.isNullOrEmpty())
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 150),
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: task.subtasks.length,
                    shrinkWrap: task.subtasks.length <= 3,
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, task.subtasks.length <= 3 ? 0 : 16, 0),
                    itemBuilder: (final context, final index) => WSubtaskCardCompact(
                      subtask: task.subtasks[index],
                      onChangedStatus: (final model) {},
                    ),
                  ),
                ),
              ),
            WLabelProgressBar(
              value: task.taskProgress?.round() ?? 0,
            ),
          ],
        ),
        onTap: () => UNavigator.push(
          TaskDetailsPage(
            projectId: ctrl.project.id ?? '',
            task: task,
            onEdit: (final task) {},
            onDelete: () {},
          ),
        ),
      ),
    );
  }
}
