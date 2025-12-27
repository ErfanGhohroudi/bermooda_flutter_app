import 'package:u/utilities.dart';

import '../../../../../core/utils/extensions/color_extension.dart';
import '../hr_board_controller.dart';
import '../widgets/hr_task_card/hr_employee_card.dart';

class HRPendingListPage extends StatefulWidget {
  const HRPendingListPage({
    required this.controller,
    super.key,
  });

  final HRBoardController controller;

  @override
  State<HRPendingListPage> createState() => _HRPendingListPageState();
}

class _HRPendingListPageState extends State<HRPendingListPage> {
  late final HRBoardController ctrl;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    ctrl = widget.controller;
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(
        title: Text(ctrl.pendingList.value!.data?.title ?? ''),
        backgroundColor: ctrl.pendingList.value!.data?.colorCode.toColor(),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: ctrl.pendingList.value!.children.length,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        itemBuilder: (final context, final index) {
          final item = ctrl.pendingList.value!.children[index];

          return WHREmployeeCard(member: item.data);
        },
      ),
    );
  }
}
