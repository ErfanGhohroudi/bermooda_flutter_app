import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import 'controllers/interfaces/report_controller.dart';
import 'widgets/report_item_cart.dart';

class ReportTimelinePage extends StatefulWidget {
  const ReportTimelinePage({
    required this.controller,
    super.key,
  });

  final ReportController controller;

  @override
  State<ReportTimelinePage> createState() => _ReportTimelinePageState();
}

class _ReportTimelinePageState extends State<ReportTimelinePage> {
  late final ReportController ctrl;

  @override
  void initState() {
    ctrl = widget.controller;
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      floatingActionButtonLocation: isPersianLang
          ? FloatingActionButtonLocation.startFloat
          : FloatingActionButtonLocation.endFloat,
      floatingActionButton: ctrl.showFloatingActionButton && ctrl.canEdit ? _floatingActionButton() : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (ctrl.showFilters) _buildFilters(),
          Obx(
            () {
              if (ctrl.pageState.isLoading() || ctrl.pageState.isInitial()) {
                return _shimmerList();
              }

              return WSmartRefresher(
                controller: ctrl.refreshController,
                scrollController: ctrl.scrollController,
                onRefresh: ctrl.onRefresh,
                onLoading: ctrl.onLoadMore,
                child: ctrl.histories.isEmpty
                    ? const Center(child: WEmptyWidget())
                    : ListView.builder(
                        itemCount: ctrl.histories.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        itemBuilder: (final context, final index) => ReportItemCart(
                          reports: ctrl.histories,
                          index: index,
                          showTimelineIndicators: ctrl.showTimelineIndicators,
                          canEdit: ctrl.canEdit,
                        ),
                      ),
              );
            },
          ).expanded(),
        ],
      ),
    );
  }

  Widget _buildFilters() => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 6),
    child: Obx(
      () => Row(
        spacing: 6,
        children: ctrl.filterList.map(
          (final filter) {
            final bool selected = ctrl.selectedFilter.value == filter;
            return FilterChip(
              selected: selected,
              label: Text(filter.title).bodyMedium(color: selected ? Colors.white : null),
              onSelected: (final value) => ctrl.setFilter(filter),
            );
          },
        ).toList(),
      ),
    ),
  );

  Widget _floatingActionButton() => FloatingActionButton(
    heroTag: "newReportFAB",
    onPressed: ctrl.showCreateForm,
    child: const Icon(
      Icons.add_rounded,
      color: Colors.white,
      size: 30,
    ),
  );

  Widget _shimmerList() => ListView.separated(
    itemCount: 7,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    separatorBuilder: (final context, final index) => const SizedBox(height: 12),
    itemBuilder: (final context, final index) => const WCard(child: SizedBox(height: 60)),
  ).shimmer();
}
