import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:u/utilities.dart';

import '../../../../core/core.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../data/data.dart';
import '../follow_up_card/follow_up_card.dart';
import 'followup_list_controller.dart';

class FollowupListPage extends StatefulWidget {
  const FollowupListPage({
    required this.datasource,
    required this.sourceId,
    required this.scrollToFollowupSlug,
    required this.canEdit,
    super.key,
  });

  final IFollowUpDatasource datasource;
  final int sourceId;
  final String? scrollToFollowupSlug;
  final bool canEdit;

  @override
  State<FollowupListPage> createState() => _FollowupListPageState();
}

class _FollowupListPageState extends State<FollowupListPage> {
  late final FollowupListController ctrl;

  @override
  void initState() {
    ctrl = Get.put(
      FollowupListController(
        datasource: widget.datasource,
        sourceId: widget.sourceId,
        scrollToFollowupSlug: widget.scrollToFollowupSlug,
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
                  controller: ctrl.scrollController,
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 100),
                  itemBuilder: (final context, final index) {
                    final followup = ctrl.followups[index];

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: AutoScrollTag(
                        key: ValueKey(ctrl.followups[index].slug),
                        controller: ctrl.scrollController,
                        index: index,
                        highlightColor: context.theme.primaryColor.withValues(alpha: 0.5),
                        child: WFollowUpCard(
                          followUp: followup,
                          onChanged: ctrl.addOrUpdateFollowUp,
                          onDelete: () => ctrl.deleteFollowUp(followup),
                          showSourceData: false,
                        ),
                      ),
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
