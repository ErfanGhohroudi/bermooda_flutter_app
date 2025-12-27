import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import 'attendance/attendance_page.dart';

class AttendanceTabsPage extends StatefulWidget {
  const AttendanceTabsPage({super.key});

  @override
  State<AttendanceTabsPage> createState() => _AttendanceTabsPageState();
}

class _AttendanceTabsPageState extends State<AttendanceTabsPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<Tab> _tabs = [
    Tab(text: s.attendance),
    // Tab(text: s.timesheet),
  ];

  List<LazyKeepAliveTabView> pages = [
        LazyKeepAliveTabView(builder: () => const AttendancePage()),
        // LazyKeepAliveTabView(builder: () => const TimesheetPage()),
      ];

  @override
  void initState() {
    _tabController = TabController(length: _tabs.length, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(
        title: Text(s.attendance),
        bottom: _tabs.length > 1 ? WTabBar(controller: _tabController, tabs: _tabs) : null,
      ),
      body: WTabBarView(controller: _tabController, pages: pages),
    );
  }
}
