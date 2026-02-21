import 'package:flutter/cupertino.dart';
import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/utils/extensions/money_extensions.dart';
import '../../../../../core/widgets/filter_sheet_buttons.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../domain/entity/group_sms.dart';
import '../../domain/enums/enums.dart';
import '../controllers/group_sms_list_controller.dart';
import '../sheets/group_sms_detail_sheet.dart';
import 'send_group_sms/send_group_sms_page.dart';

class GroupSmsListPage extends StatefulWidget {
  const GroupSmsListPage({
    required this.departmentId,
    super.key,
  });

  final int departmentId;

  @override
  State<GroupSmsListPage> createState() => _GroupSmsListPageState();
}

class _GroupSmsListPageState extends State<GroupSmsListPage> {
  late final GroupSmsListController ctrl;

  @override
  void initState() {
    ctrl = Get.put(GroupSmsListController(departmentId: widget.departmentId));
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(title: Text(s.groupMessages)),
      floatingActionButtonLocation: isPersianLang
          ? FloatingActionButtonLocation.startFloat
          : FloatingActionButtonLocation.endFloat,
      floatingActionButton: ctrl.haveAccess
          ? FloatingActionButton(
              heroTag: "send-group-SMS-FAB",
              tooltip: s.sendSMS,
              onPressed: () async {
                final result = await AppNavigator.push<GroupSmsEntity>(
                  SendGroupSmsPage(departmentId: ctrl.departmentId),
                );
                if (result != null) {
                  ctrl.insertItem(result);
                }
              },
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
            )
          : null,
      body: Stack(
        children: [
          Obx(
            () {
              final showEmptyWidget = ctrl.pageState.isLoaded() && ctrl.groupSmsList.isEmpty;
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
                  filterPageBuilder: _buildFilterSheet,
                  haveActivatedFilter: ctrl.isFilterActive,
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
                      child: ListView.builder(
                        itemCount: ctrl.groupSmsList.length,
                        padding: EdgeInsets.only(
                          top: 10,
                          left: 16,
                          right: 16,
                          bottom: ctrl.isEndOfList ? 100 : 10,
                        ),
                        itemBuilder: (final context, final index) {
                          final item = ctrl.groupSmsList[index];
                          return _buildItemCard(item);
                        },
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
            bottomMargin: 90,
          ),
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
        WDropDownFormField<GroupSMSStatus>(
          labelText: s.status,
          value: ctrl.selectedStatus.value,
          deselectable: true,
          items: ctrl.statusFiltersList.map((final GroupSMSStatus status) {
            return DropdownMenuItem<GroupSMSStatus>(
              value: status,
              child: WDropdownItemText(text: status.title),
            );
          }).toList(),
          onChanged: (final val) => ctrl.selectedStatus.value = val,
        ),
        WFilterSheetButtons(
          onTapClear: ctrl.onClearFilter,
          onTapApply: ctrl.onApplyFilter,
        ).marginOnly(top: 100),
      ],
    );
  }

  Widget _buildItemCard(final GroupSmsEntity item) {
    final canCancel = item.status == GroupSMSStatus.sending || item.status == GroupSMSStatus.scheduled;

    return WCard(
      showBorder: true,
      onTap: () {
        bottomSheet(
          title: item.title,
          child: GroupSmsDetailSheet(item: item),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          Row(
            spacing: 8,
            children: [
              Expanded(child: Text(item.title).titleMedium()),
              if (canCancel)
                WMoreButtonIcon(
                  items: [
                    WPopupMenuItem(
                      title: s.cancelSend,
                      icon: '',
                      iconData: CupertinoIcons.clear_circled,
                      titleColor: AppColors.red,
                      iconColor: AppColors.red,
                      onTap: () => ctrl.cancelSend(item.id),
                    ),
                  ],
                ),
              Icon(Icons.arrow_forward_ios_rounded, size: 18, color: context.theme.hintColor),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              _buildRowInfoWidget(
                s.sentBy,
                item.sentByUser != null
                    ? WCircleAvatar(
                        user: item.sentByUser,
                        size: 25,
                        showFullName: true,
                        bodySmall: true,
                        imageFontSize: 9,
                      ).pSymmetric(vertical: 4)
                    : null,
              ).expanded(),
              _buildRowInfoWidget(
                s.status,
                item.status != null
                    ? WLabel(
                        text: item.status!.title,
                        color: item.status!.color,
                      ).pSymmetric(vertical: 4)
                    : null,
              ).expanded(),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              _buildRowInfo(s.recipients, item.totalRecipients.toString().separateNumbers3By3()).expanded(),
              _buildRowInfo(s.sent, item.sentCount.toString().separateNumbers3By3()).expanded(),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              _buildRowInfo(s.delivered, item.deliveredCount.toString().separateNumbers3By3()).expanded(),
              _buildRowInfo(s.failed, item.failedCount.toString().separateNumbers3By3()).expanded(),
            ],
          ),
          _buildRowInfo(s.success, "${item.successRate.percentageFormatted}%"),
        ],
      ),
    );
  }

  Widget _buildRowInfo(final String title, final String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title).bodySmall(color: context.theme.hintColor),
        Text(value).bodySmall().bold(),
      ],
    );
  }

  Widget _buildRowInfoWidget(final String title, final Widget? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title).bodySmall(color: context.theme.hintColor),
        if (value != null) value,
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
