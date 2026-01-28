import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../widgets/project_item_card.dart';
import 'archived_projects_controller.dart';

class ArchivedProjectsPage extends StatefulWidget {
  const ArchivedProjectsPage({
    super.key,
  });

  @override
  State<ArchivedProjectsPage> createState() => _ArchivedProjectsPageState();
}

class _ArchivedProjectsPageState extends State<ArchivedProjectsPage> {
  late final ArchivedProjectsController ctrl;

  @override
  void initState() {
    ctrl = Get.put(ArchivedProjectsController());
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
              final showEmptyWidget = ctrl.pageState.isLoaded() && ctrl.projects.isEmpty;
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
                        itemCount: ctrl.projects.length,
                        padding: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: ctrl.isAtEnd ? 100 : 5),
                        itemBuilder: (final context, final index) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildProjectCard(index),
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

  Widget _buildProjectCard(final int index) {
    final project = ctrl.projects[index];

    return ProjectItemCard(
      project: project,
      index: index,
      isReorderEnabled: false,
      showMoreIcon: ctrl.haveAdminAccess,
      onArchive: () {},
      onEdited: (final updatedProject) {
        ctrl.projects[index] = updatedProject;
        ctrl.projects.refresh();
      },
      onTap: () {},
      // Disable bottom sheet in archive page
      moreButtonBuilder: ctrl.haveAdminAccess
          ? (final context) => WMoreButtonIcon(
              items: [
                WPopupMenuItem(
                  title: s.restore,
                  icon: AppIcons.restore,
                  onTap: () => ctrl.restoreProject(project.id),
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
