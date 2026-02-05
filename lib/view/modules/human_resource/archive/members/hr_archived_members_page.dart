import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../data/data.dart';
import '../../removed_list/removed_members_list_page.dart';

class HRArchivedMembersPage extends StatelessWidget {
  const HRArchivedMembersPage({
    required this.department,
    super.key,
  });

  final HRDepartmentReadDto department;

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(title: Text(s.archive)),
      body: RemovedMembersListPage(
        department: department,
      ),
    );
  }
}
