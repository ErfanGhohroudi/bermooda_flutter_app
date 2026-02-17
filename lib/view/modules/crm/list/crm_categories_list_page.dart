import 'package:u/utilities.dart';

import '../../../../core/navigator/navigator.dart';
import '../../../../core/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../data/data.dart';
import '../archive/categories/archived_crm_categories_page.dart';
import 'category_create_update/crm_category_create_update_page.dart';
import 'crm_categories_list_controller.dart';
import '../widgets/category_item_card.dart';

class CrmCategoriesListPage extends StatefulWidget {
  const CrmCategoriesListPage({super.key});

  @override
  State<CrmCategoriesListPage> createState() => _CrmCategoriesListPageState();
}

class _CrmCategoriesListPageState extends State<CrmCategoriesListPage> {
  late final CrmCategoriesListController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.put(CrmCategoriesListController());
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
          AppNavigator.back();
        }
      },
      child: UScaffold(
        appBar: AppBar(
          title: Text(s.customers),
          actions: [
            Obx(
              () => ctrl.haveAdminAccess && !ctrl.isReorderEnabled.value
                  ? IconButton(
                      tooltip: s.archive,
                      icon: const UImage(AppIcons.archiveOutline, size: 25, color: Colors.white),
                      onPressed: () {
                        AppNavigator.push(const ArchivedCrmCategoriesPage());
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
                heroTag: "crmCategoriesFAB",
                onPressed: () {
                  bottomSheet(
                    title: s.newCategory,
                    child: CrmCategoryCreateUpdatePage(
                      onResponse: (final category) {
                        ctrl.insertCategory(category);
                      },
                    ),
                  );
                },
                child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
              )
            : null,
        body: Column(
          children: [
            WSearchField(
              controller: ctrl.searchController,
              borderRadius: 0,
              height: 50,
              // withFilter: true,
              // haveActivatedFilter: true,
              // filterPageBuilder: (final context) => Container(),
              onChanged: (final value) => ctrl.onSearch(),
            ),
            Expanded(
              child: Obx(
                () => WSmartRefresher(
                  controller: ctrl.refreshController,
                  onRefresh: ctrl.onRefresh,
                  onLoading: ctrl.loadMore,
                  child: ctrl.pageState.isLoaded()
                      ? ctrl.categories.isNotEmpty
                            ? CustomScrollView(
                                slivers: [
                                  SliverPadding(
                                    padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: ctrl.isEndOfList ? 100 : 0),
                                    sliver: SliverReorderableList(
                                      itemCount: ctrl.categories.length,
                                      onReorder: (final oldIndex, newIndex) {
                                        if (oldIndex < newIndex) {
                                          newIndex -= 1;
                                        }
                                        final CrmCategoryReadDto item = ctrl.categories.removeAt(oldIndex);
                                        ctrl.categories.insert(newIndex, item);
                                      },
                                      itemBuilder: (final context, final index) => CategoryItemCard(
                                        key: ValueKey(ctrl.categories[index].id),
                                        index: index,
                                        category: ctrl.categories[index],
                                        isReorderEnabled: ctrl.isReorderEnabled.value,
                                        showMoreIcon: ctrl.haveAdminAccess,
                                        onEdited: (final category) {
                                          ctrl.categories[index] = category;
                                          ctrl.categories.refresh();
                                        },
                                        onArchive: () => ctrl.archiveCategory(
                                          ctrl.categories[index],
                                          action: () {
                                            ctrl.categories.removeAt(index);
                                            ctrl.categories.refresh();
                                          },
                                        ),
                                      ),
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
