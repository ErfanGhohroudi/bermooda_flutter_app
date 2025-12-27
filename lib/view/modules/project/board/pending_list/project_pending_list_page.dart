import 'package:u/utilities.dart';

import '../../../../../core/utils/extensions/color_extension.dart';
import '../project_board_controller.dart';
import '../widgets/task_card.dart';

class ProjectPendingListPage extends StatefulWidget {
  const ProjectPendingListPage({
    required this.controller,
    super.key,
  });

  final ProjectBoardController controller;

  @override
  State<ProjectPendingListPage> createState() => _ProjectPendingListPageState();
}

class _ProjectPendingListPageState extends State<ProjectPendingListPage> {
  late final ProjectBoardController ctrl;
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

          return TaskCard(
            task: item.data,
            controller: ctrl,
            outerScrollController: _scrollController,
          );
        },
      ),
    );
  }
}
