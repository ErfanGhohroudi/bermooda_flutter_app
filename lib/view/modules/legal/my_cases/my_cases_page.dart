import 'package:u/utilities.dart';

import '../../../../core/core.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../data/data.dart';
import '../../followup/follow_up_card/follow_up_card.dart';
import '../../subtask/subtask_card/subtask_card.dart';
import 'enums/filter_enum.dart';
import 'my_cases_controller.dart';
import 'widgets/my_contract_filter_sheet.dart';

class MyCasesPage extends StatefulWidget {
  const MyCasesPage({
    required this.legalDepartmentId,
    super.key,
  });

  final int legalDepartmentId;

  @override
  State<MyCasesPage> createState() => _MyCasesPageState();
}

class _MyCasesPageState extends State<MyCasesPage> {
  late final MyCasesController ctrl;

  @override
  void initState() {
    ctrl = Get.put(MyCasesController(legalDepartmentId: widget.legalDepartmentId));
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(title: Text(s.myCase)),
      body: Stack(
        children: [
          Obx(
            () {
              if (ctrl.pageState.isLoaded() && ctrl.items.isEmpty) {
                return const Center(child: WEmptyWidget());
              }
              if (ctrl.pageState.isError()) {
                return Center(child: WErrorWidget(onTapButton: ctrl.onTryAgain));
              }
              return const SizedBox.shrink();
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () {
                  if (!ctrl.pageState.isEmpty()) {
                    return WSearchField(
                      controller: ctrl.searchCtrl,
                      borderRadius: 0,
                      height: 50,
                      withFilter: true,
                      haveActivatedFilter: ctrl.hasActiveFilters,
                      filterPageBuilder: (final context) => MyContractFilterSheet(controller: ctrl),
                      onChanged: (final value) => ctrl.onSearch(),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              _filters(),
              Obx(
                () {
                  if (ctrl.pageState.isLoading() || ctrl.pageState.isInitial()) {
                    return _loadingShimmerList();
                  }

                  if (ctrl.pageState.isError()) {
                    return const SizedBox.shrink();
                  }

                  return WSmartRefresher(
                    controller: ctrl.refreshController,
                    onRefresh: ctrl.onRefresh,
                    onLoading: ctrl.onLoadMore,
                    child: ListView.builder(
                      itemCount: ctrl.items.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      itemBuilder: (final context, final index) {
                        final item = ctrl.items[index];
                        if (item is FollowUpReadDto) {
                          return WFollowUpCard(
                            followUp: item,
                            onChanged: (final model) {
                              ctrl.updateItem(model);
                              ctrl.items.refresh();
                            },
                            onDelete: () {
                              ctrl.removeItem(item);
                              ctrl.items.refresh();
                            },
                          );
                        } else if (item is SubtaskReadDto) {
                          return WSubtaskCard(
                            subtask: item,
                            showOwner: false,
                            onChangedCheckBoxStatus: (final model) {
                              ctrl.updateItem(model);
                              ctrl.items.refresh();
                            },
                            onEdited: (final model) {
                              ctrl.updateItem(model);
                              ctrl.items.refresh();
                            },
                            onDelete: () {
                              ctrl.removeItem(item);
                              ctrl.items.refresh();
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  );
                },
              ).expanded(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filters() {
    return Obx(
      () {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 2),
          child: Row(
            spacing: 6,
            children: MyContractFilterType.values.map(
              (final filter) {
                final selected = ctrl.selectedFilter.value == filter;
                return FilterChip(
                  selected: selected,
                  label: Text(filter.title).bodyMedium(color: selected ? Colors.white : null),
                  onSelected: (final value) => ctrl.setFilter(filter),
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }

  Widget _loadingShimmerList() => ListView.builder(
    itemCount: 10,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (final context, final index) => WCard(
      child: SizedBox(width: context.width, height: 70),
    ),
  ).shimmer();
}
