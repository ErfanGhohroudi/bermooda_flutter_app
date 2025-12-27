import 'package:bermooda_business/core/core.dart';
import 'package:bermooda_business/core/widgets/widgets.dart';
import 'package:u/utilities.dart';

import '../../../../../core/widgets/follow_up_card/follow_up_card.dart';
import 'legal_case_followup_list_controller.dart';

class LegalCaseFollowupListPage extends StatefulWidget {
  const LegalCaseFollowupListPage({
    required this.legalCaseId,
    required this.canEdit,
    super.key,
  });

  final int legalCaseId;
  final bool canEdit;

  @override
  State<LegalCaseFollowupListPage> createState() => _LegalCaseFollowupListPageState();
}

class _LegalCaseFollowupListPageState extends State<LegalCaseFollowupListPage> {
  late final LegalCaseFollowupListController ctrl;

  @override
  void initState() {
    ctrl = Get.put(
      LegalCaseFollowupListController(
        caseId: widget.legalCaseId,
        canEdit: widget.canEdit,
      ),
    );
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      floatingActionButtonLocation: isPersianLang
          ? FloatingActionButtonLocation.startFloat
          : FloatingActionButtonLocation.endFloat,
      floatingActionButton: ctrl.haveAdminAccess
          ? FloatingActionButton(
              heroTag: "createLegalFollowupFAB",
              tooltip: s.newFollowUp,
              onPressed: ctrl.createFollowUp,
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
            )
          : null,
      body: Stack(
        children: [
          Obx(
            () {
              if (ctrl.pageState.isLoaded() && ctrl.followups.isEmpty) {
                return const Center(child: WEmptyWidget());
              }
              return const SizedBox.shrink();
            },
          ),
          Obx(
            () {
              if (ctrl.pageState.isLoading() || ctrl.pageState.isInitial()) {
                return _loadingShimmerList();
              }

              if (ctrl.pageState.isError()) {
                return Center(child: WErrorWidget(onTapButton: ctrl.onTryAgain));
              }

              return WSmartRefresher(
                controller: ctrl.refreshController,
                onRefresh: ctrl.onRefresh,
                enablePullUp: false,
                child: ListView.builder(
                  itemCount: ctrl.followups.length,
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 100),
                  itemBuilder: (final context, final index) {
                    final followup = ctrl.followups[index];
                    return WFollowUpCard(
                      followUp: followup,
                      onChanged: ctrl.addOrUpdateFollowUp,
                      onDelete: () => ctrl.deleteFollowUp(followup),
                      showSourceData: false,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _loadingShimmerList() => ListView.builder(
    itemCount: 10,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (final context, final index) => WCard(
      child: SizedBox(width: context.width, height: 70),
    ),
  ).shimmer();
}
