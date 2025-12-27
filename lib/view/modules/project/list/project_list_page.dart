import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/theme.dart';
import '../../../../data/data.dart';
import 'create_update/project_create_update_page.dart';
import 'project_list_controller.dart';
import 'widgets/project_item_card.dart';

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({
    super.key,
  });

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> with ProjectListController {
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
          title: Text(s.project),
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
                heroTag: "projectListFAB",
                onPressed: () {
                  bottomSheet(
                    title: s.newProject,
                    child: ProjectCreateUpdatePage(
                      onResponse: (final project) => insertProject(project),
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
                      ? projects.isNotEmpty
                          ? CustomScrollView(
                              slivers: [
                                SliverPadding(
                                  padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: isEndOfList ? 100 : 0),
                                  sliver: SliverReorderableList(
                                    itemCount: projects.length,
                                    onReorder: (final oldIndex, newIndex) {
                                      if (oldIndex < newIndex) {
                                        newIndex -= 1;
                                      }
                                      final ProjectReadDto item = projects.removeAt(oldIndex);
                                      projects.insert(newIndex, item);
                                    },
                                    itemBuilder: (final context, final index) => ProjectItemCard(
                                      key: ValueKey(projects[index].id),
                                      index: index,
                                      project: projects[index],
                                      isReorderEnabled: isReorderEnabled.value,
                                      showMoreIcon: haveAdminAccess,
                                      onEdited: (final project) {
                                        projects[index] = project;
                                        projects.refresh();
                                      },
                                      onDelete: () => deleteProject(
                                        projects[index],
                                        action: () {
                                          projects.removeAt(index);
                                          projects.refresh();
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
