import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../widgets/department_item_card.dart';
import 'archived_hr_departments_controller.dart';

class ArchivedHrDepartmentsPage extends StatefulWidget {
  const ArchivedHrDepartmentsPage({
    super.key,
  });

  @override
  State<ArchivedHrDepartmentsPage> createState() => _ArchivedHrDepartmentsPageState();
}

class _ArchivedHrDepartmentsPageState extends State<ArchivedHrDepartmentsPage> {
  late final ArchivedHrDepartmentsController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.put(ArchivedHrDepartmentsController());
  }

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
                controller: ctrl.searchCtrl,
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
                        padding: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: ctrl.isAtEnd ? 100 : 5),
                        itemBuilder: (final context, final index) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildDepartmentCard(index),
                        ),
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

  Widget _buildDepartmentCard(final int index) {
    final department = ctrl.departments[index];

    return WDepartmentItemCard(
      department: department,
      ctrl: null,
      isReorderEnabled: false,
      showMoreIcon: ctrl.haveAdminAccess,
      index: index,
      onTap: () {},
      // Disable bottom sheet in archive page
      moreButtonBuilder: ctrl.haveAdminAccess
          ? (final context) => WMoreButtonIcon(
              items: [
                WPopupMenuItem(
                  title: s.restore,
                  icon: AppIcons.restore,
                  onTap: () => ctrl.restoreDepartment(department.slug),
                ),
              ],
            )
          : null,
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
