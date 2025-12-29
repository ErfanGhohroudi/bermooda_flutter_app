import 'package:bermooda_business/data/data.dart';
import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../subtask/subtask_card/subtask_card.dart';
import 'my_tasks_controller.dart';

class MyTasksPage extends StatefulWidget {
  const MyTasksPage({
    required this.projectId,
    required this.dataSourceType,
    super.key,
  });

  final String projectId;
  final SubtaskDataSourceType dataSourceType;

  @override
  State<MyTasksPage> createState() => _MyTasksPageState();
}

class _MyTasksPageState extends State<MyTasksPage> with MyTasksController {
  @override
  void initState() {
    initialController(
      projectId: widget.projectId,
      dataSourceType: widget.dataSourceType,
    );
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
      appBar: AppBar(
        title: Text(s.myTasks),
      ),
      body: Stack(
        children: [
          Obx(
            () {
              final showEmptyWidget = pageState.isLoaded() && subtasks.isEmpty;
              if (showEmptyWidget) return const Center(child: WEmptyWidget());
              return const SizedBox.shrink();
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WSearchField(
                controller: searchCtrl,
                borderRadius: 0,
                height: 50,
                onChanged: (final value) => onSearch(),
              ),
              _filters(),
              Expanded(
                child: Obx(
                  () {
                    return WSmartRefresher(
                      controller: refreshController,
                      onRefresh: onRefresh,
                      onLoading: loadMore,
                      child: pageState.isLoading() || pageState.isInitial()
                          ? _loadingShimmerList()
                          : ListView.builder(
                              itemCount: subtasks.length,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              itemBuilder: (final context, final index) => WSubtaskCard(
                                subtask: subtasks[index],
                                showOwner: false,
                                onChangedCheckBoxStatus: (final model) {
                                  subtasks[index] = model;
                                  subtasks.refresh();
                                },
                                onEdited: (final model) {
                                  subtasks[index] = model;
                                  subtasks.refresh();
                                },
                                onDelete: () {
                                  subtasks.removeAt(index);
                                  subtasks.refresh();
                                },
                              ),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filters() => Padding(
    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 2),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => Row(
          spacing: 4,
          children: SubtaskFilter.values.map(
            (final filter) {
              final selected = selectedFilter.value == filter;
              return FilterChip(
                selected: selected,
                label: Text(filter.title).bodyMedium(color: selected ? Colors.white : null),
                onSelected: (final value) => setFilter(filter),
              );
            },
          ).toList(),
        ),
      ),
    ),
  );

  Widget _loadingShimmerList() => ListView.builder(
    itemCount: 10,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (final context, final index) => WCard(
      child: SizedBox(width: context.width, height: 60),
    ),
  ).shimmer();
}
