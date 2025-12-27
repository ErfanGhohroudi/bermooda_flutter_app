import 'package:u/utilities.dart';

import '../../../../core/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../data/data.dart';
import 'category_create_update/crm_category_create_update_page.dart';
import 'crm_categories_list_controller.dart';
import 'widgets/category_item_card.dart';

class CrmCategoriesListPage extends StatefulWidget {
  const CrmCategoriesListPage({super.key});

  @override
  State<CrmCategoriesListPage> createState() => _CrmCategoriesListPageState();
}

class _CrmCategoriesListPageState extends State<CrmCategoriesListPage> with CrmCategoriesListController {
  @override
  void initState() {
    initialController();
    super.initState();
  }

  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (final didPop, final result) {
        if (didPop) return;
        if (isReorderEnabled.value) {
          toggleReorder();
        } else {
          UNavigator.back();
        }
      },
      child: UScaffold(
        appBar: AppBar(
          title: Text(s.customers),
          actions: [
            Obx(
              () => IconButton(
                tooltip: isReorderEnabled.value ? s.save : s.reorder,
                icon:
                    isReorderEnabled.value ? const Icon(Icons.check, size: 25, color: Colors.white) : const UImage(AppIcons.arrowSwapVert, size: 25, color: Colors.white),
                onPressed: () {
                  if (isReorderEnabled.value) return updateOrders();
                  toggleReorder();
                },
              ),
            ),
            const SizedBox(width: 6),
          ],
        ),
        floatingActionButtonLocation: isPersianLang ? FloatingActionButtonLocation.startFloat : FloatingActionButtonLocation.endFloat,
        floatingActionButton: haveAdminAccess
            ? FloatingActionButton(
                heroTag: "crmCategoriesFAB",
                onPressed: () {
                  bottomSheet(
                    title: s.newCategory,
                    child: CrmCategoryCreateUpdatePage(
                      onResponse: (final category) {
                        insertCategory(category);
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
              controller: searchController,
              borderRadius: 0,
              height: 50,
              // withFilter: true,
              // haveActivatedFilter: true,
              // filterPageBuilder: (final context) => Container(),
              onChanged: (final value) => onSearch(),
            ),
            Expanded(
              child: Obx(
                () => WSmartRefresher(
                  controller: refreshController,
                  onRefresh: onRefresh,
                  onLoading: loadMore,
                  child: pageState.isLoaded()
                      ? categories.isNotEmpty
                          ? CustomScrollView(
                              slivers: [
                                SliverPadding(
                                  padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: isEndOfList ? 100 : 0),
                                  sliver: SliverReorderableList(
                                    itemCount: categories.length,
                                    onReorder: (final oldIndex, newIndex) {
                                      if (oldIndex < newIndex) {
                                        newIndex -= 1;
                                      }
                                      final CrmCategoryReadDto item = categories.removeAt(oldIndex);
                                      categories.insert(newIndex, item);
                                    },
                                    itemBuilder: (final context, final index) => CategoryItemCard(
                                      key: ValueKey(categories[index].id),
                                      index: index,
                                      category: categories[index],
                                      isReorderEnabled: isReorderEnabled.value,
                                      showMoreIcon: haveAdminAccess,
                                      onEdited: (final project) {
                                        categories[index] = project;
                                        categories.refresh();
                                      },
                                      onDelete: () => deleteCategory(
                                        categories[index],
                                        action: () {
                                          categories.removeAt(index);
                                          categories.refresh();
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
