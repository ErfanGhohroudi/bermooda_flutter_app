import 'package:u/utilities.dart';

import '../../../../../core/utils/extensions/color_extension.dart';
import '../legal_board_controller.dart';
import '../../widgets/legal_case_card/legal_case_card.dart';

class LegalPendingListPage extends StatefulWidget {
  const LegalPendingListPage({
    required this.controller,
    super.key,
  });

  final LegalBoardController controller;

  @override
  State<LegalPendingListPage> createState() => _LegalPendingListPageState();
}

class _LegalPendingListPageState extends State<LegalPendingListPage> {
  late final LegalBoardController ctrl;
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

          return WLegalCaseCard(legalCase: item.data);
        },
      ),
    );
  }
}
