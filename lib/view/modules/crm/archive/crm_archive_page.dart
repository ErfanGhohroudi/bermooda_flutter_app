import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../core/theme.dart';
import '../board/widgets/customer_card/customer_card.dart';
import 'crm_archive_controller.dart';

class CrmArchivePage extends StatefulWidget {
  const CrmArchivePage({
    required this.categoryId,
    super.key,
  });

  final String categoryId;

  @override
  State<CrmArchivePage> createState() => _CrmArchivePageState();
}

class _CrmArchivePageState extends State<CrmArchivePage> {
  late final CrmArchiveController ctrl;

  @override
  void initState() {
    ctrl = Get.put(CrmArchiveController(categoryId: widget.categoryId));
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
              final showEmptyWidget = ctrl.pageState.isLoaded() && ctrl.customers.isEmpty;
              if (showEmptyWidget) return const Center(child: WEmptyWidget());
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
              _filters(),
              Expanded(
                child: Obx(
                  () => WSmartRefresher(
                    controller: ctrl.refreshController,
                    scrollController: ctrl.scrollController,
                    onRefresh: ctrl.onRefresh,
                    onLoading: ctrl.loadMore,
                    child: ctrl.pageState.isLoading() || ctrl.pageState.isInitial()
                        ? _loadingShimmerList()
                        : ListView.builder(
                            itemCount: ctrl.customers.length,
                            padding: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: ctrl.isAtEnd ? 100 : 5),
                            itemBuilder: (final context, final index) => WCustomerCard(
                              customer: ctrl.customers[index],
                              canEdit: false,
                              outerScrollController: ctrl.scrollController,
                              onChangedCheckBox: (final customer) {},
                              onStepChanged: (final customer) {},
                              onEdit: (final model) {
                                ctrl.customers[index] = model;
                                ctrl.customers.refresh();
                              },
                              onDelete: (final model) {
                                ctrl.customers.removeAt(index);
                                ctrl.customers.refresh();
                              },
                              moreButtonBuilder: (final context) => WMoreButtonIcon(
                                items: [
                                  WPopupMenuItem(
                                    title: s.restore,
                                    icon: AppIcons.restore,
                                    onTap: () => ctrl.restoreCustomer(ctrl.customers[index].id),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
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

  Widget _filters() {
    return Obx(
      () {
        Widget filterChip(final bool filter) {
          final selected = ctrl.currentFilter.value == filter;
          return FilterChip(
            selected: selected,
            label: Text(filter == false ? s.archiveRemoved : s.closedWon).bodyMedium(color: selected ? Colors.white : null),
            onSelected: (final value) => ctrl.setFilter(filter),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 2),
          child: Wrap(
            spacing: 8,
            children: [
              filterChip(false),
              filterChip(true),
            ],
          ),
        );
      },
    );
  }

  Widget _loadingShimmerList() => ListView.builder(
        itemCount: 10,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (final context, final index) => WCard(
          child: SizedBox(width: context.width, height: 60),
        ),
      ).shimmer();
}
