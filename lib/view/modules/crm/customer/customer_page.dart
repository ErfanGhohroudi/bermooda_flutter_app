import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../data/data.dart';
import '../../followup/list/followup_list_page.dart';
import '../../reports/controllers/crm/crm_customer_notes_controller.dart';
import '../../reports/controllers/crm/crm_customer_reports_controller.dart';
import '../../reports/report_timeline_page.dart';
import 'customer_info/customer_info_page.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({
    required this.customer,
    required this.onEdit,
    required this.onDelete,
    this.scrollToFollowupSlug,
    this.canEdit = true,
    super.key,
  });

  final CustomerReadDto customer;
  final Function(CustomerReadDto customer) onEdit;
  final Function(CustomerReadDto customer) onDelete;
  final String? scrollToFollowupSlug;
  final bool canEdit;

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final List<Tab> _tabs;
  late final List<LazyKeepAliveTabView> _pages;
  final RxString _customerName = '- -'.obs;

  bool get canEdit => widget.canEdit;

  @override
  void initState() {
    _customerName(widget.customer.fullNameOrCompanyName);

    _tabs = [
      Tab(text: s.customerProfile),
      Tab(text: s.followUps),
      Tab(text: s.note),
      Tab(text: s.reports),
    ];

    final notesCtrl = Get.put(
      CrmCustomerNotesController(
        sourceId: widget.customer.id,
        canEdit: canEdit,
      ),
    );

    final reportsCtrl = Get.put(
      CrmCustomerReportsController(
        sourceId: widget.customer.id,
        canEdit: canEdit,
      ),
    );

    _pages = [
      LazyKeepAliveTabView(
        builder: () => CustomerInfoPage(
          customerId: widget.customer.id,
          canEdit: canEdit,
          onEdit: (final customer) {
            _customerName(customer.fullNameOrCompanyName);
            widget.onEdit(customer);
          },
          onDelete: widget.onDelete,
        ),
      ),
      LazyKeepAliveTabView(
        builder: () => FollowupListPage(
          datasource: Get.find<CustomerFollowUpDatasource>(),
          sourceId: widget.customer.id ?? 0,
          scrollToFollowupSlug: widget.scrollToFollowupSlug,
          canEdit: canEdit,
        ),
      ),
      LazyKeepAliveTabView(builder: () => ReportTimelinePage(controller: notesCtrl)),
      LazyKeepAliveTabView(builder: () => ReportTimelinePage(controller: reportsCtrl)),
    ];

    _tabController = TabController(
      initialIndex: widget.scrollToFollowupSlug != null
          ? 2
          : 0,
      length: _tabs.length,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<CrmCustomerReportsController>();
    Get.delete<CrmCustomerNotesController>();
    _tabController.dispose();
    _customerName.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(
        title: Obx(() => Text(_customerName.value)),
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
