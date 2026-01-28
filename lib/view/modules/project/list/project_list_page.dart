import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/theme.dart';
import '../../../../data/data.dart';
import '../archive/projects/archived_projects_page.dart';
import 'create_update/project_create_update_page.dart';
import 'project_list_controller.dart';
import '../widgets/project_item_card.dart';

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({
    super.key,
  });

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  late final ProjectListController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.put(ProjectListController());
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
          title: Text(s.project),
          actions: [
            Obx(
              () => ctrl.haveAdminAccess && !ctrl.isReorderEnabled.value
                  ? IconButton(
                      tooltip: s.archive,
                      icon: const UImage(AppIcons.archiveOutline, size: 25, color: Colors.white),
                      onPressed: () {
                        UNavigator.push(const ArchivedProjectsPage());
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
                heroTag: "projectListFAB",
                onPressed: () {
                  bottomSheet(
                    title: s.newProject,
                    child: ProjectCreateUpdatePage(
                      onResponse: (final project) => ctrl.insertProject(project),
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
                      ? ctrl.projects.isNotEmpty
                            ? CustomScrollView(
                                slivers: [
                                  SliverPadding(
                                    padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: ctrl.isEndOfList ? 100 : 0),
                                    sliver: SliverReorderableList(
                                      itemCount: ctrl.projects.length,
                                      onReorder: (final oldIndex, newIndex) {
                                        if (oldIndex < newIndex) {
                                          newIndex -= 1;
                                        }
                                        final ProjectReadDto item = ctrl.projects.removeAt(oldIndex);
                                        ctrl.projects.insert(newIndex, item);
                                      },
                                      itemBuilder: (final context, final index) => ProjectItemCard(
                                        key: ValueKey(ctrl.projects[index].id),
                                        index: index,
                                        project: ctrl.projects[index],
                                        isReorderEnabled: ctrl.isReorderEnabled.value,
                                        showMoreIcon: ctrl.haveAdminAccess,
                                        onEdited: (final project) {
                                          ctrl.projects[index] = project;
                                          ctrl.projects.refresh();
                                        },
                                        onArchive: () => ctrl.archiveProject(
                                          ctrl.projects[index],
                                          action: () {
                                            ctrl.projects.removeAt(index);
                                            ctrl.projects.refresh();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const Center(child: WEmptyWidget())
                      : ListView.separated(
                          itemCount: 10,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (final context, final index) => const SizedBox(height: 5),
                          itemBuilder: (final context, final index) => WCard(child: SizedBox(width: context.width, height: 100)),
                        ).shimmer(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
