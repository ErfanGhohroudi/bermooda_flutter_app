import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../controllers/archived_department_list_controller.dart';
import '../widgets/department_card.dart';

class SmsArchivedDepartmentListPage extends StatefulWidget {
  const SmsArchivedDepartmentListPage({super.key});

  @override
  State<SmsArchivedDepartmentListPage> createState() => _SmsArchivedDepartmentListPageState();
}

class _SmsArchivedDepartmentListPageState extends State<SmsArchivedDepartmentListPage> {
  final SmsArchivedDepartmentListController ctrl = Get.put(SmsArchivedDepartmentListController());

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(title: Text(s.archive)),
      body: Stack(
        children: [
          Obx(
                () {
              final showEmptyWidget = ctrl.pageState.isLoaded() && ctrl.departments.isEmpty;
              final showErrorWidget = ctrl.pageState.isError();
              if (showEmptyWidget) return const Center(child: WEmptyWidget());
              if (showErrorWidget) return Center(child: WErrorWidget(onTapButton: ctrl.onTryAgain));
              return const SizedBox.shrink();
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WSearchField(
                controller: ctrl.searchController,
                borderRadius: 0,
                height: 50,
                onChanged: (final value) => ctrl.onSearch(),
              ),
              Expanded(
                child: Obx(
                      () {
                    if (ctrl.pageState.isLoading() || ctrl.pageState.isInitial()) {
                      return _loadingShimmerList();
                    }

                    if (ctrl.pageState.isError()) {
                      return const SizedBox.shrink();
                    }

                    return WSmartRefresher(
                      controller: ctrl.refreshController,
                      scrollController: ctrl.scrollController,
                      onRefresh: ctrl.onRefresh,
                      onLoading: ctrl.loadMore,
                      child: ListView.builder(
                        itemCount: ctrl.departments.length,
                        padding: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: ctrl.isEndOfList ? 100 : 5),
                        itemBuilder: (final context, final index) {
                          final department = ctrl.departments[index];
                          return WSmsDepartmentCard(
                            index: index,
                            department: department,
                            isReorderEnabled: false,
                            showMoreIcon: ctrl.haveAdminAccess,
                            moreButtonItems: [
                              WPopupMenuItem(
                                title: s.restore,
                                icon: AppIcons.restore,
                                onTap: () => ctrl.restoreDepartment(department),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
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

  Widget _loadingShimmerList() =>
      ListView.builder(
        itemCount: 10,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (final context, final index) =>
            WCard(
              child: SizedBox(width: context.width, height: 100),
            ),
      ).shimmer();
}
