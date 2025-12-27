import 'package:u/utilities.dart';

import '../../../../../core/utils/extensions/color_extension.dart';
import '../widgets/customer_card/customer_card.dart';
import '../crm_board_controller.dart';

class CrmPendingListPage extends StatefulWidget {
  const CrmPendingListPage({
    required this.controller,
    super.key,
  });

  final CrmBoardController controller;

  @override
  State<CrmPendingListPage> createState() => _CrmPendingListPageState();
}

class _CrmPendingListPageState extends State<CrmPendingListPage> {
  late final CrmBoardController ctrl;
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

          return WCustomerCard(
            customer: item.data,
            outerScrollController: _scrollController,
            onChangedCheckBox: (final customer) {},
            onStepChanged: (final customer) {},
            onEdit: (final customer) {},
            onDelete: (final customer) {},
          );
        },
      ),
    );
  }
}
