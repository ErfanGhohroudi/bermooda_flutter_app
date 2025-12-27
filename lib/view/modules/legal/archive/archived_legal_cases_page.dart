import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../widgets/legal_case_card/legal_case_card.dart';
import 'archived_legal_cases_controller.dart';

class ArchivedLegalCasesPage extends StatefulWidget {
  const ArchivedLegalCasesPage({
    required this.legalDepartmentId,
    super.key,
  });

  final int legalDepartmentId;

  @override
  State<ArchivedLegalCasesPage> createState() => _ArchivedLegalCasesPageState();
}

class _ArchivedLegalCasesPageState extends State<ArchivedLegalCasesPage> {
  late final ArchivedLegalCasesController ctrl;

  @override
  void initState() {
    ctrl = Get.put(ArchivedLegalCasesController(legalDepartmentId: widget.legalDepartmentId));
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(title: Text(s.archive)),
      body: Stack(
        children: [
          Obx(
            () {
              final showEmptyWidget = ctrl.pageState.isLoaded() && ctrl.legalCases.isEmpty;
              if (showEmptyWidget) return const Center(child: WEmptyWidget());
              return const SizedBox.shrink();
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WSearchField(
                controller: ctrl.searchCtrl,
                borderRadius: 0,
                height: 50,
                onChanged: (final value) => ctrl.onSearch(),
              ),
              Expanded(
                child: Obx(
                  () => WSmartRefresher(
                    controller: ctrl.refreshController,
                    scrollController: ctrl.scrollController,
                    onRefresh: ctrl.onRefresh,
                    onLoading: ctrl.loadMore,
                    child: ctrl.pageState.isLoading() || ctrl.pageState.isInitial()
                        ? _loadingShimmerList()
                        : ListView.builder(
                            itemCount: ctrl.legalCases.length,
                            padding: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: ctrl.isAtEnd ? 100 : 5),
                            itemBuilder: (final context, final index) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: WLegalCaseCard(
                                legalCase: ctrl.legalCases[index],
                                isArchived: true,
                                onRestore: () => ctrl.restoreCase(ctrl.legalCases[index].id),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
          WScrollToTopButton(
            scrollController: ctrl.scrollController,
            show: ctrl.showScrollToTop,
          ),
        ],
      ),
    );
  }

  Widget _loadingShimmerList() => ListView.builder(
        itemCount: 10,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (final context, final index) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: WCard(
            child: SizedBox(width: context.width, height: 100),
          ),
        ),
      ).shimmer();
}

