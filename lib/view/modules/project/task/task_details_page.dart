import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../data/data.dart';
import '../../reports/controllers/project/project_task_notes_controller.dart';
import '../../reports/controllers/project/project_task_reports_controller.dart';
import '../../reports/report_timeline_page.dart';
import 'create_update/create_update_task_page.dart';

class TaskDetailsPage extends StatefulWidget {
  const TaskDetailsPage({
    required this.task,
    required this.projectId,
    required this.onEdit,
    required this.onDelete,
    this.scrollToSubtaskId,
    super.key,
  });

  final TaskReadDto task;
  final String projectId;
  final Function(TaskReadDto customer) onEdit;
  final VoidCallback onDelete;
  final String? scrollToSubtaskId;

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final List<Tab> _tabs;
  late final List<LazyKeepAliveTabView> _pages;

  @override
  void initState() {
    _tabs = [
      Tab(text: s.details),
      Tab(text: s.note),
      Tab(text: s.reports),
    ];

    final notesCtrl = Get.put(
      ProjectTaskNotesController(
        sourceId: widget.task.id,
        // canEdit: canEdit,
      ),
    );

    final reportsCtrl = Get.put(
      ProjectTaskReportsController(
        sourceId: widget.task.id,
        // canEdit: canEdit,
      ),
    );

    _pages = [
      LazyKeepAliveTabView(
        builder: () => CreateUpdateTaskPage(
          model: widget.task,
          projectId: widget.projectId,
          scrollToSubtaskId: widget.scrollToSubtaskId,
          canChangeStatus: true,
          onResponse: widget.onEdit,
          onDelete: (final model) => widget.onDelete(),
        ),
      ),
      LazyKeepAliveTabView(builder: () => ReportTimelinePage(controller: notesCtrl)),
      LazyKeepAliveTabView(builder: () => ReportTimelinePage(controller: reportsCtrl)),
    ];

    _tabController = TabController(length: _tabs.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ProjectTaskReportsController>();
    Get.delete<ProjectTaskNotesController>();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(
        title: Text(s.task),
        bottom: WTabBar(
          controller: _tabController,
          tabs: _tabs,
          isScrollable: true,
          horizontalPadding: 12,
          horizontalLabelPadding: 12,
        ),
      ),
      body: WTabBarView(
        controller: _tabController,
        pages: _pages,
      ),
    );
  }
}
