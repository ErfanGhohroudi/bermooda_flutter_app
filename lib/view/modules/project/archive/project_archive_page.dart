import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/theme.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../data/data.dart';
import 'project_archive_controller.dart';

class ProjectArchivePage extends StatefulWidget {
  const ProjectArchivePage({
    required this.projectId,
    super.key,
  });

  final String projectId;

  @override
  State<ProjectArchivePage> createState() => _ProjectArchivePageState();
}

class _ProjectArchivePageState extends State<ProjectArchivePage> with ProjectArchiveController {
  @override
  void initState() {
    initialController(widget.projectId);
    super.initState();
  }

  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(title: Text(s.archive)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilters(),
          Obx(
            () {
              if (pageState.isInitial() || pageState.isLoading()) {
                return _buildLoadingShimmer();
              }

              return Stack(
                children: [
                  if (tasks.isEmpty) const Center(child: WEmptyWidget()),
                  WSmartRefresher(
                    controller: refreshController,
                    scrollController: scrollController,
                    onRefresh: onRefresh,
                    onLoading: loadMore,
                    child: tasks.isEmpty
                        ? const Center(child: WEmptyWidget())
                        : ListView.builder(
                            itemCount: tasks.length,
                            padding: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: isAtEnd ? 100 : 5),
                            itemBuilder: (final context, final index) => _taskItem(index),
                          ),
                  ),
                  WScrollToTopButton(
                    scrollController: scrollController,
                    show: showScrollToTop,
                  ),
                ],
              );
            },
          ).expanded(),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Obx(
        () => Row(
          spacing: 4,
          children: ProjectArchiveFilter.values.map(
            (final filter) {
              final selected = selectedFilter.value == filter;
              return FilterChip(
                label: Text(filter.title).bodyMedium(color: selected ? Colors.white : null),
                selected: selected,
                onSelected: (final value) => setFilter(filter),
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  Widget _taskItem(final int index) {
    final task = tasks[index];

    Widget item({
      required final String title,
      required final Widget value,
      final Widget? icon,
      final CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    }) =>
        Row(
          crossAxisAlignment: crossAxisAlignment,
          spacing: 10,
          children: [
            SizedBox(
              width: context.width / 3.5,
              child: Row(
                spacing: 10,
                children: [
                  if (icon != null) icon,
                  Flexible(
                    child: Text(title).bodyMedium(color: context.theme.hintColor),
                  ),
                ],
              ),
            ),
            value.expanded(),
          ],
        );

    return WCard(
      onTap: () {},
      showBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          Row(
            spacing: 10,
            children: [
              WCheckBox(
                isChecked: task.doneStatus,
                onChanged: (final value) {},
              ),
              Text(
                task.title ?? '',
                maxLines: 1,
              ).bodyMedium(overflow: TextOverflow.ellipsis).bold().expanded(),
              WMoreButtonIcon(
                items: [
                  WPopupMenuItem(
                    title: s.restore,
                    icon: AppIcons.restore,
                    onTap: () => restoreTask(task.id),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 0),
          item(title: s.title, value: Text(task.title ?? '- -').bodyMedium(), crossAxisAlignment: CrossAxisAlignment.start),
          item(title: s.description, value: Text(task.description ?? '- -').bodyMedium(), crossAxisAlignment: CrossAxisAlignment.start),
          item(
            title: s.subtasks,
            value: Row(
              spacing: 10,
              children: [
                Text(task.subtasks.length.toString()).bodyMedium(),
                if (task.subtasks.isNotEmpty)
                  WTextButton(
                    text: s.details,
                    onPressed: () {
                      bottomSheet(
                        title: s.subtasks,
                        child: Column(
                          children: task.subtasks.map((final subtask) => _subtaskCard(subtask)).toList(),
                        ).marginOnly(bottom: 24),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _subtaskCard(final SubtaskReadDto subtask) => WCard(
        showBorder: true,
        padding: 6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                /// CheckBox
                WCheckBox(
                  isChecked: subtask.isCompleted, // Current checked state
                  onChanged: (final value) {},
                ),

                /// Title
                Text(
                  subtask.title ?? '',
                  textAlign: TextAlign.justify,
                  maxLines: 1,
                  style: context.textTheme.bodySmall!.copyWith(
                    decoration: subtask.isCompleted ? TextDecoration.combine([TextDecoration.lineThrough]) : null,
                    decorationColor: subtask.isCompleted ? context.theme.primaryColorDark.withAlpha(150) : null,
                  ),
                ).bold().marginOnly(top: 2).expanded(),

                /// Avatar
                WCircleAvatar(
                  user: subtask.responsibleForDoing,
                  size: 30,
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buildLoadingShimmer() => ListView.builder(
        itemCount: 10,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        itemBuilder: (final context, final index) => const WCard(child: SizedBox(height: 100)),
      ).shimmer();
}
