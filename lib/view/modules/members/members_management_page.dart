import 'package:u/utilities.dart';

import '../../../core/widgets/widgets.dart';
import '../../../view/modules/human_resource/removed_list/removed_members_list_page.dart';
import '../../../view/modules/members/list/members_list_page.dart';
import '../../../core/core.dart';

class MembersManagementPage extends StatefulWidget {
  const MembersManagementPage({super.key});

  @override
  State<MembersManagementPage> createState() => _MembersManagementPageState();
}

class _MembersManagementPageState extends State<MembersManagementPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(
        title: Text(s.staffManagement),
        bottom: WTabBar(
          controller: _tabController,
          tabs: [
            Tab(text: s.membersList),
            Tab(text: s.removedMembers),
          ],
        ),
      ),
      body: WTabBarView(
        controller: _tabController,
        pages: [
          LazyKeepAliveTabView(builder: () => const MembersListPage(department: null)),
          LazyKeepAliveTabView(builder: () => const RemovedMembersListPage()),
        ],
      ),
    );
  }
}
