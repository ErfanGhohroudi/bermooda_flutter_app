import 'package:bermooda_business/view/modules/sms/domain/entity/sms_department.dart';
import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../controllers/department_list_controller.dart';
import '../widgets/department_card.dart';
import 'archived_department_list_page.dart';
import 'department_create_update_page.dart';

class SmsDepartmentListPage extends StatefulWidget {
  const SmsDepartmentListPage({super.key});

  @override
  State<SmsDepartmentListPage> createState() => _SmsDepartmentListPageState();
}

class _SmsDepartmentListPageState extends State<SmsDepartmentListPage> {
  final SmsDepartmentListController ctrl = Get.put(SmsDepartmentListController());

  @override
  Widget build(final BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (final didPop, final result) {
        if (didPop) return;
        if (ctrl.isReorderEnabled.value) {
          ctrl.toggleReorder();
        } else {
          AppNavigator.back();
        }
      },
      child: UScaffold(
        appBar: AppBar(
          title: Text(s.sms),
          actions: [
            Obx(
              () => ctrl.haveAdminAccess && !ctrl.isReorderEnabled.value
                  ? IconButton(
                      tooltip: s.archive,
                      icon: const UImage(AppIcons.archiveOutline, size: 25, color: Colors.white),
                      onPressed: () {
                        AppNavigator.push(const SmsArchivedDepartmentListPage());
                      },
                    )
                  : const SizedBox.shrink(),
            ),
            Obx(
              () => IconButton(
                tooltip: ctrl.isReorderEnabled.value ? s.save : s.reorder,
                icon: ctrl.isReorderEnabled.value
                    ? const Icon(Icons.check, size: 25, color: Colors.white)
                    : const UImage(AppIcons.arrowSwapVert, size: 25, color: Colors.white),
                onPressed: () {
                  if (ctrl.isReorderEnabled.value) return ctrl.updateOrders();
                  ctrl.toggleReorder();
                },
              ),
            ),
            const SizedBox(width: 6),
          ],
        ),
        floatingActionButtonLocation: isPersianLang
            ? FloatingActionButtonLocation.startFloat
            : FloatingActionButtonLocation.endFloat,
        floatingActionButton: ctrl.haveAdminAccess
            ? FloatingActionButton(
                heroTag: "smsDepartmentsFAB",
                onPressed: () {
                  bottomSheet(
                    title: s.newDepartment,
                    child: SmsDepartmentCreateUpdatePage(ctrl: ctrl),
                  );
                },
                child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
              )
            : null,
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
                      if (ctrl.pageState.isInitial() || ctrl.pageState.isLoading()) {
                        return ListView.builder(
                          itemCount: 10,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (final context, final index) => WCard(
                            child: SizedBox(width: context.width, height: 100),
                          ),
                        ).shimmer();
                      }

                      if (ctrl.pageState.isError()) {
                        return const SizedBox.shrink();
                      }

                      return WSmartRefresher(
                        controller: ctrl.refreshController,
                        scrollController: ctrl.scrollController,
                        onRefresh: ctrl.onRefresh,
                        onLoading: ctrl.loadMore,
                        child: CustomScrollView(
                          slivers: [
                            SliverPadding(
                              padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: ctrl.isEndOfList ? 100 : 0),
                              sliver: SliverReorderableList(
                                itemCount: ctrl.departments.length,
                                onReorder: (final oldIndex, newIndex) {
                                  if (oldIndex < newIndex) {
                                    newIndex -= 1;
                                  }
                                  final SmsDepartment item = ctrl.departments.removeAt(oldIndex);
                                  ctrl.departments.insert(newIndex, item);
                                },
                                itemBuilder: (final context, final index) => WSmsDepartmentCard(
                                  key: ValueKey(ctrl.departments[index].id),
                                  ctrl: ctrl,
                                  index: index,
                                  department: ctrl.departments[index],
                                  isReorderEnabled: ctrl.isReorderEnabled.value,
                                  showMoreIcon: ctrl.haveAdminAccess,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ).expanded(),
                ),
              ],
            ),
            WScrollToTopButton(
              scrollController: ctrl.scrollController,
              show: ctrl.showScrollToTop,
              bottomMargin: 90,
            ),
          ],
        ),
      ),
    );
  }
}
