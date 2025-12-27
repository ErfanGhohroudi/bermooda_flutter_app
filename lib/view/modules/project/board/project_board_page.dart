import 'package:u/utilities.dart';

import '../../../../core/utils/extensions/color_extension.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/widgets/kanban_board/kanban_board.dart';
import '../../../../core/core.dart';
import '../../../../core/theme.dart';
import '../../../../data/data.dart';
import '../project_add_member/project_add_member_page.dart';
import 'create_update_section/project_create_update_section_page.dart';
import 'pending_list/project_pending_list_page.dart';
import 'project_board_controller.dart';
import 'widgets/create_task_field/create_task_field.dart';
import 'widgets/task_card.dart';

class ProjectBoardPage extends StatefulWidget {
  const ProjectBoardPage({
    required this.project,
    this.onEdited,
    super.key,
  });

  final ProjectReadDto project;
  final Function(ProjectReadDto model)? onEdited;

  @override
  State<ProjectBoardPage> createState() => _ProjectBoardPageState();
}

class _ProjectBoardPageState extends State<ProjectBoardPage> {
  late final ProjectBoardController ctrl;

  @override
  void initState() {
    ctrl = Get.put(ProjectBoardController(project: widget.project));
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.theme.primaryColorDark),
        title: Obx(
          () => Text("${ctrl.project.title ?? '- -'}${ctrl.isWebSocketConnect.value ? "" : " (${s.connecting})"}").bodyMedium(color: context.theme.primaryColorDark),
        ),
        backgroundColor: context.theme.cardColor,
        actions: [
          Obx(
            () => ctrl.pendingList.value != null ? _pendingListActionButton() : const SizedBox(),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Obx(
        () => ctrl.kanbanController.sections.isEmpty
            ? _kanbanBoardShimmer()
            : WKanbanBoard<ProjectSectionReadDto, TaskReadDto>(
                controller: ctrl.kanbanController,
                headerOfAddNewSectionPage: _addSectionHeaderBuilder(),
                addNewSectionPageBody: _addSectionPage(),
                sectionHeaderBuilder: (final section) => _sectionHeaderBuilder(section),
                itemBuilder: (final section, final item, final outerScrollController) => TaskCard(
                  task: item.data,
                  controller: ctrl,
                  outerScrollController: outerScrollController,
                ),
              ),
      ),
    );
  }

  Widget _pendingListActionButton() => UBadge(
        badgeContent: Text(
          ctrl.pendingList.value!.children.isNotEmpty ? (ctrl.pendingList.value!.children.length).toString() : '',
          style: context.textTheme.bodyMedium!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        showBadge: ctrl.pendingList.value!.children.isNotEmpty,
        animationType: BadgeAnimationType.fade,
        position: const BadgePosition(top: -5, start: -12),
        child: UImage(AppIcons.pendingListOutline, size: 30, color: context.theme.primaryColorDark),
      )
          .withTooltip(
            "${ctrl.pendingList.value!.data?.title}\n${ctrl.pendingList.value!.children.length} ${s.task}",
            textStyle: context.textTheme.bodyMedium!.copyWith(color: Colors.white),
          )
          .onTap(
            () => UNavigator.push(ProjectPendingListPage(controller: ctrl)),
          );

  Widget _sectionBuilder(final Section<ProjectSectionReadDto, TaskReadDto> section) => Container(
        width: context.width,
        color: section.data?.colorCode?.toColor() ?? Colors.grey,
        child: ListTile(
          leading: section.data?.icon != null ? UImage(section.data!.icon!.url ?? '', size: 30, color: Colors.white) : null,
          title: Text(section.data?.title ?? '', maxLines: 2).bodyLarge(color: Colors.white),
          trailing: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(s.edit).bodySmall(color: Colors.white),
          ).onTap(
            () => bottomSheet(
              title: s.editSection,
              child: ProjectCreateUpdateSectionPage(
                project: widget.project,
                controller: ctrl,
                section: section,
              ),
            ),
          ),
        ),
      );

  Widget _sectionHeaderBuilder(final Section<ProjectSectionReadDto, TaskReadDto> section) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _sectionBuilder(section),
          _addTaskButton(section),
        ],
      );

  Widget _addTaskButton(final Section<ProjectSectionReadDto, TaskReadDto> section) {
    if (!ctrl.haveAdminAccess) {
      return const SizedBox();
    }

    return Obx(() {
      final bool showNewTaskField = ctrl.sectionIdWithOpenField.value == section.slug;

      return showNewTaskField
          ? Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
              child: CreateTaskField(
                key: ValueKey(section.slug),
                projectId: ctrl.project.id ?? '',
                section: section.data,
                onResponse: (final task) => ctrl.hideOpenField(),
                onUnFocus: () => ctrl.hideOpenField(),
              ),
            )
          : Container(
              width: context.width,
              height: 40,
              margin: const EdgeInsets.only(left: 16, right: 16, top: 10),
              decoration: BoxDecoration(
                color: context.theme.hintColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_rounded, size: 25, color: Colors.white),
                  Text(s.newTask).bodyMedium(color: Colors.white),
                ],
              ),
            ).onTap(() => ctrl.showFieldFor(section.slug));
    });
  }

  Widget? _addSectionPage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 24,
      children: [
        const SizedBox(height: 100),
        UImage(AppImages.team, size: 200, color: context.theme.hintColor),
        UElevatedButton(
          width: 200,
          title: s.addMember,
          backgroundColor: AppColors.green,
          onTap: () => bottomSheet(
            title: s.addMember,
            child: ProjectAddMemberPage(
              project: ctrl.project,
              onResponse: (final project) {
                ctrl.project = project;
                widget.onEdited?.call(project);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _addSectionHeaderBuilder() => Container(
        width: context.width,
        margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: const Icon(Icons.add, size: 30, color: Colors.white),
          title: Text(s.newSection).bodyLarge(color: Colors.white),
          onTap: () {
            bottomSheet(
              title: s.newSection,
              child: ProjectCreateUpdateSectionPage(
                project: widget.project,
                controller: ctrl,
              ),
            );
          },
        ),
      );

  Widget _kanbanBoardShimmer() => SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              height: 60,
              color: Colors.grey,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: 3,
              separatorBuilder: (final context, final index) => const SizedBox(height: 10),
              itemBuilder: (final context, final index) => Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 12,
                  children: [
                    Row(
                      spacing: 15,
                      children: [
                        WCheckBox(
                          isChecked: false,
                          size: 20,
                          onChanged: (final value) {},
                        ),
                        Container(
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey,
                          ),
                        ).expanded(),
                      ],
                    ),
                    ListView.separated(
                      itemCount: 2,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (final context, final index) => const SizedBox(height: 5),
                      itemBuilder: (final context, final index) => Container(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          spacing: 15,
                          children: [
                            WCheckBox(
                              isChecked: false,
                              size: 20,
                              onChanged: (final value) {},
                            ),
                            Container(
                              height: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey,
                              ),
                            ).expanded(),
                            const CircleAvatar(radius: 15),
                          ],
                        ),
                      ),
                    ),
                    const WLabelProgressBar(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ).shimmer();
}
