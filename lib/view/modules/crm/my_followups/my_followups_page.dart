import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/widgets/follow_up_card/follow_up_card.dart';
import 'enums/filter_enum.dart';
import 'my_followups_controller.dart';

class MyFollowupsPage extends StatefulWidget {
  const MyFollowupsPage({
    required this.categoryId,
    super.key,
  });

  final String categoryId;

  @override
  State<MyFollowupsPage> createState() => _MyFollowupsPageState();
}

class _MyFollowupsPageState extends State<MyFollowupsPage> {
  late final MyFollowupsController ctrl;

  @override
  void initState() {
    ctrl = Get.put(MyFollowupsController(categoryId: widget.categoryId));
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(
        title: Text(s.myFollowups),
      ),
      body: Stack(
        children: [
          Obx(
            () {
              if (ctrl.pageState.isLoaded() && ctrl.followups.isEmpty) {
                return const Center(child: WEmptyWidget());
              }
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
                hintText: "${s.search} ${s.customerName}",
                onChanged: (final value) => ctrl.onSearch(),
              ),
              _filters(),
              Obx(
                () {
                  if (ctrl.pageState.isLoading() || ctrl.pageState.isInitial()) {
                    return _loadingShimmerList();
                  }

                  return WSmartRefresher(
                    controller: ctrl.refreshController,
                    onRefresh: ctrl.onRefresh,
                    onLoading: ctrl.onLoadMore,
                    child: ListView.builder(
                      itemCount: ctrl.followups.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      itemBuilder: (final context, final index) {
                        return WFollowUpCard(
                          followUp: ctrl.followups[index],
                          onChanged: (final model) {
                            ctrl.followups[index] = model;
                            ctrl.followups.refresh();
                          },
                          onDelete: () {
                            ctrl.followups.removeAt(index);
                            ctrl.followups.refresh();
                          },
                        );
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
            children: FollowUpFilterType.values.map(
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
