import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../data/data.dart';
import '../../followup/list/followup_list_page.dart';
import '../../reports/controllers/legal/legal_case_notes_controller.dart';
import '../../reports/report_timeline_page.dart';
import '../../subtask/list/subtask_list_page.dart';
import '../contract/contract_page.dart';
import '../../reports/controllers/legal/legal_case_reports_controller.dart';
import 'details/legal_case_details_page.dart';

class LegalCasePage extends StatefulWidget {
  const LegalCasePage({
    required this.legalCase,
    required this.canEdit,
    this.scrollToSubtaskId,
    this.scrollToFollowupSlug,
    super.key,
  });

  final LegalCaseReadDto legalCase;
  final bool canEdit;
  final String? scrollToSubtaskId;
  final String? scrollToFollowupSlug;

  @override
  State<LegalCasePage> createState() => _LegalCasePageState();
}

class _LegalCasePageState extends State<LegalCasePage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final List<Tab> _tabs;
  late final List<LazyKeepAliveTabView> _pages;

  bool get canEdit => widget.canEdit;

  @override
  void initState() {
    _tabs = [
      Tab(text: s.details),
      Tab(text: s.contract),
      Tab(text: s.tasks),
      Tab(text: s.followUps),
      Tab(text: s.note),
      Tab(text: s.reports),
    ];

    final notesCtrl = Get.put(
      LegalCaseNotesController(
        sourceId: widget.legalCase.id,
        canEdit: canEdit,
      ),
    );

    final reportsCtrl = Get.put(
      LegalCaseReportsController(
        sourceId: widget.legalCase.id,
        canEdit: canEdit,
      ),
    );

    _pages = [
      LazyKeepAliveTabView(
        builder: () => LegalCaseDetailsPage(
          legalCaseId: widget.legalCase.id,
          canEdit: canEdit,
        ),
      ),
      LazyKeepAliveTabView(
        builder: () => ContractPage(
          legalCaseId: widget.legalCase.id,
          canEdit: canEdit,
        ),
      ),
      LazyKeepAliveTabView(
        builder: () => SubtaskListPage(
          dataSourceType: SubtaskDataSourceType.legal,
          mainSourceId: widget.legalCase.departmentId?.toString() ?? "0",
          sourceId: widget.legalCase.id,
          scrollToSubtaskId: widget.scrollToSubtaskId,
          canEdit: canEdit,
        ),
      ),
      LazyKeepAliveTabView(
        builder: () => FollowupListPage(
          datasource: Get.find<LegalFollowUpDatasource>(),
          sourceId: widget.legalCase.id,
          scrollToFollowupSlug: widget.scrollToFollowupSlug,
          canEdit: canEdit,
        ),
      ),
      LazyKeepAliveTabView(builder: () => ReportTimelinePage(controller: notesCtrl)),
      LazyKeepAliveTabView(builder: () => ReportTimelinePage(controller: reportsCtrl)),
    ];

    _tabController = TabController(
      initialIndex: widget.scrollToSubtaskId != null
          ? 2
          : widget.scrollToFollowupSlug != null
          ? 3
          : 0,
      length: _tabs.length,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<LegalCaseReportsController>();
    Get.delete<LegalCaseNotesController>();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(
        title: Text(s.legalCase),
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
