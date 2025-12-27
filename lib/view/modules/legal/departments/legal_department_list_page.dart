import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/theme.dart';
import '../../../../data/data.dart';
import '../widgets/legal_department_item_card.dart';
import 'legal_department_list_controller.dart';

class LegalDepartmentListPage extends StatefulWidget {
  const LegalDepartmentListPage({super.key});

  @override
  State<LegalDepartmentListPage> createState() => _LegalDepartmentListPageState();
}

class _LegalDepartmentListPageState extends State<LegalDepartmentListPage> {
  late final LegalDepartmentListController ctrl;

  @override
  void initState() {
    ctrl = Get.put(LegalDepartmentListController());
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (final didPop, final result) {
        if (didPop) return;
        if (ctrl.isReorderEnabled.value) {
          ctrl.toggleReorder();
        } else {
          UNavigator.back();
        }
      },
      child: UScaffold(
        appBar: AppBar(
          title: Text(s.legal),
          actions: [
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
        floatingActionButtonLocation: isPersianLang ? FloatingActionButtonLocation.startFloat : FloatingActionButtonLocation.endFloat,
        floatingActionButton: ctrl.haveAdminAccess
            ? FloatingActionButton(
                heroTag: "legalDepartmentsFAB",
                onPressed: ctrl.navigateToCreateDepartmentPage,
                child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
              )
            : null,
        body: Column(
          children: [
            WSearchField(
              controller: ctrl.searchController,
              borderRadius: 0,
              height: 50,
              onChanged: (final value) => ctrl.onSearch(),
            ),
            Expanded(
              child: Obx(
                () => WSmartRefresher(
                  controller: ctrl.refreshController,
                  onRefresh: ctrl.onRefresh,
                  onLoading: ctrl.loadMore,
                  child: ctrl.pageState.isLoaded()
                      ? ctrl.departments.isNotEmpty
                          ? CustomScrollView(
                              slivers: [
                                SliverPadding(
                                  padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: ctrl.isEndOfList ? 100 : 0),
                                  sliver: SliverReorderableList(
                                    itemCount: ctrl.departments.length,
                                    onReorder: (final oldIndex, newIndex) {
                                      if (oldIndex < newIndex) {
                                        newIndex -= 1;
                                      }
                                      final LegalDepartmentReadDto item = ctrl.departments.removeAt(oldIndex);
                                      ctrl.departments.insert(newIndex, item);
                                    },
                                    itemBuilder: (final context, final index) {
                                      return WLegalDepartmentItemCard(
                                        key: ValueKey(ctrl.departments[index].id),
                                        department: ctrl.departments[index],
                                        ctrl: ctrl,
                                        isReorderEnabled: ctrl.isReorderEnabled.value,
                                        index: index,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          : const Center(child: WEmptyWidget())
                      : ListView.builder(
                          itemCount: 10,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (final context, final index) => WCard(
                            child: SizedBox(width: context.width, height: 100),
                          ),
                        ).shimmer(),
                ),
              ).expanded(),
            ),
          ],
        ),
      ),
    );
  }
}
