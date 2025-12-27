import 'package:u/utilities.dart';

import '../../../core/widgets/widgets.dart';
import '../../../core/core.dart';
import 'calendar/calendar_page.dart';
import 'reports/dashboard_reports_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<Tab> _tabs = [
    Tab(text: s.calendar),
    Tab(text: s.reports),
  ];
  final List<Widget> _pages = [
    const CalendarPage(),
    const DashboardReportsPage(),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
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
      body: Column(
        children: [
          WStyledTabBar(
            controller: _tabController,
            tabs: _tabs,
          ).pSymmetric(horizontal: 16, vertical: 10),
          Expanded(
            child: WTabBarView(
              controller: _tabController,
              pages: _pages.map((final page) => LazyKeepAliveTabView(builder: () => page)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
