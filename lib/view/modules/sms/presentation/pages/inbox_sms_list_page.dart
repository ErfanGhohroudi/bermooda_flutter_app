import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/utils/extensions/date_extensions.dart';
import '../../../../../core/widgets/fields/fields.dart';
import '../../../../../core/widgets/filter_sheet_buttons.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../domain/entity/received_sms_entity.dart';
import '../../domain/entity/sms_panel_number.dart';
import '../controllers/inbox_sms_list_controller.dart';

class InboxSmsListPage extends StatefulWidget {
  const InboxSmsListPage({
    required this.departmentId,
    super.key,
  });

  final int departmentId;

  @override
  State<InboxSmsListPage> createState() => _InboxSmsListPageState();
}

class _InboxSmsListPageState extends State<InboxSmsListPage> {
  late final InboxSmsListController ctrl;

  @override
  void initState() {
    ctrl = Get.put(InboxSmsListController(departmentId: widget.departmentId));
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(title: Text(s.inbox)),
      body: Stack(
        children: [
          Obx(
            () {
              final showEmptyWidget = ctrl.pageState.isLoaded() && ctrl.smsList.isEmpty;
              final showErrorWidget = ctrl.pageState.isError();
              if (showEmptyWidget) return const Center(child: WEmptyWidget());
              if (showErrorWidget) return Center(child: WErrorWidget(onTapButton: ctrl.onTryAgain));
              return const SizedBox.shrink();
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => WSearchField(
                  controller: ctrl.searchCtrl,
                  borderRadius: 0,
                  height: 50,
                  onChanged: (final value) => ctrl.onSearch(),
                  withFilter: true,
                  haveActivatedFilter: ctrl.isFilterActive,
                  filterPageBuilder: (final context) => _buildFilterSheet(context),
                ),
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
                      child: CustomScrollView(
                        slivers: [
                          if (ctrl.smsList.isNotEmpty)
                            SliverToBoxAdapter(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                margin: const EdgeInsets.only(left: 21, right: 21, top: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.green.withValues(alpha: 0.1),
                                  border: Border.all(color: AppColors.green.withValues(alpha: 0.3)),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  spacing: 5,
                                  children: [
                                    Text(
                                      ctrl.isFilterActive ? s.exportFilteredListToExcel : s.exportAllRecordsToExcel,
                                    ).bodyMedium(color: AppColors.green).expanded(),
                                    UElevatedButton(
                                      width: 80,
                                      title: s.export,
                                      backgroundColor: AppColors.green,
                                      onTap: ctrl.onExportExcel,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          SliverPadding(
                            padding: EdgeInsets.only(
                              top: 10,
                              left: 16,
                              right: 16,
                              bottom: ctrl.isEndOfList ? 100 : 10,
                            ),
                            sliver: SliverList.builder(
                              itemCount: ctrl.smsList.length,
                              itemBuilder: (final context, final index) {
                                final item = ctrl.smsList[index];
                                return _buildItemCard(item);
                              },
                            ),
                          ),
                        ],
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
            bottomMargin: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(final ReceivedSmsEntity item) {
    return WCard(
      showBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            spacing: 8,
            children: [
              Expanded(child: Text(item.senderPhone).titleMedium()),
              if (item.date != null) Text(item.date!.toDateTimeString).bodySmall(color: context.theme.hintColor),
            ],
          ),
          const Divider(),
          Text(item.content).bodyMedium(),
          if (item.receivePhone != null)
            Row(
              children: [
                Text('${s.receivedBy}: ').bodySmall(color: context.theme.hintColor),
                Text("${item.receivePhone!.title} (${item.receivePhone!.number})").bodySmall().bold(),
              ],
            ).marginOnly(top: 8),
        ],
      ),
    );
  }

  Widget _buildFilterSheet(final BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 18,
      children: [
        // Date Filter
        Row(
          spacing: 10,
          children: [
            WDatePickerField(
              labelText: "${s.from} ${s.date}",
              initialValue: ctrl.startDate.value,
              onConfirm: (final date) => ctrl.startDate.value = date,
            ).expanded(),
            WDatePickerField(
              labelText: "${s.to} ${s.date}",
              initialValue: ctrl.endDate.value,
              onConfirm: (final date) => ctrl.endDate.value = date,
            ).expanded(),
          ],
        ),

        // Phone Number Filter
        if (ctrl.availableNumbers.isNotEmpty)
          WDropDownFormField<SmsPanelNumber>(
            labelText: s.recipient,
            value: ctrl.selectedPhone.value,
            deselectable: true,
            items: ctrl.availableNumbers.map(
              (final SmsPanelNumber num) {
                final number = num.number;
                final providerName = num.title;
                return DropdownMenuItem<SmsPanelNumber>(
                  value: num,
                  child: WDropdownItemText(text: "$providerName ($number)"),
                );
              },
            ).toList(),
            onChanged: (final val) => ctrl.selectedPhone.value = val,
          ),

        // Buttons
        WFilterSheetButtons(
          onTapClear: ctrl.onClearFilter,
          onTapApply: ctrl.onApplyFilter,
        ).marginOnly(top: 100),
      ],
    );
  }

  Widget _loadingShimmerList() => ListView.builder(
    itemCount: 10,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (final context, final index) => WCard(
      child: SizedBox(width: context.width, height: 100),
    ),
  ).shimmer();
}
