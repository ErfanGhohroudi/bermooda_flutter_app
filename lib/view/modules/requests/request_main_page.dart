import 'package:u/utilities.dart';

import '../../../core/widgets/widgets.dart';
import '../../../core/core.dart';
import 'list/request_list_page.dart';

class RequestMainPage extends StatefulWidget {
  const RequestMainPage({super.key});

  @override
  State<RequestMainPage> createState() => _RequestMainPageState();
}

class _RequestMainPageState extends State<RequestMainPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final List<Tab> _tabs;
  late final List<LazyKeepAliveTabView> _pages;

  @override
  void initState() {
    _initialTabs();
    super.initState();
  }

  void _initialTabs() {
    _tabs = [
      Tab(text: s.myRequests),
      Tab(text: s.myReviews),
      Tab(text: s.archive),
    ];
    _initialPages();
    _tabController = TabController(length: _tabs.length, vsync: this, initialIndex: 0);
  }

  void _initialPages() {
    _pages = [
      LazyKeepAliveTabView(builder: () => RequestListPage(pageType: RequestListPageType.myRequests)),
      LazyKeepAliveTabView(builder: () => RequestListPage(pageType: RequestListPageType.myReviews)),
      LazyKeepAliveTabView(builder: () => RequestListPage(pageType: RequestListPageType.archive)),
    ];
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(
        title: Text(s.requests),
        bottom: WTabBar(
          controller: _tabController,
          tabs: _tabs,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
      ),
      body: WTabBarView(
        controller: _tabController,
        pages: _pages,
      ),
    );
  }
}
