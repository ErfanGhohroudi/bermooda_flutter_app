import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../widgets/category_item_card.dart';
import 'archived_crm_categories_controller.dart';

class ArchivedCrmCategoriesPage extends StatefulWidget {
  const ArchivedCrmCategoriesPage({
    super.key,
  });

  @override
  State<ArchivedCrmCategoriesPage> createState() => _ArchivedCrmCategoriesPageState();
}

class _ArchivedCrmCategoriesPageState extends State<ArchivedCrmCategoriesPage> {
  late final ArchivedCrmCategoriesController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.put(ArchivedCrmCategoriesController());
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(title: Text(s.archive)),
      body: Stack(
        children: [
          Obx(
            () {
              final showEmptyWidget = ctrl.pageState.isLoaded() && ctrl.categories.isEmpty;
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
                        itemCount: ctrl.categories.length,
                        padding: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: ctrl.isAtEnd ? 100 : 5),
                        itemBuilder: (final context, final index) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildCategoryCard(index),
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

  Widget _buildCategoryCard(final int index) {
    final category = ctrl.categories[index];

    return CategoryItemCard(
      category: category,
      index: index,
      isReorderEnabled: false,
      showMoreIcon: ctrl.haveAdminAccess,
      onArchive: () {},
      onEdited: (final updatedCategory) {
        ctrl.categories[index] = updatedCategory;
        ctrl.categories.refresh();
      },
      onTap: () {},
      // Disable bottom sheet in archive page
      moreButtonBuilder: ctrl.haveAdminAccess
          ? (final context) => WMoreButtonIcon(
              items: [
                WPopupMenuItem(
                  title: s.restore,
                  icon: AppIcons.restore,
                  onTap: () => ctrl.restoreCategory(category.id),
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
