import 'package:flutter/cupertino.dart';
import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/filter_sheet_buttons.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../domain/entity/sms.dart';
import '../../domain/enums/enums.dart';
import '../controllers/sms_list_controller.dart';
import '../sheets/send_sms_sheet.dart';
import '../sheets/sms_detail_sheet.dart';

class SmsListPage extends StatefulWidget {
  const SmsListPage({
    required this.departmentId,
    super.key,
  });

  final int departmentId;

  @override
  State<SmsListPage> createState() => _SmsListPageState();
}

class _SmsListPageState extends State<SmsListPage> {
  late final SmsListController ctrl;

  @override
  void initState() {
    ctrl = Get.put(SmsListController(departmentId: widget.departmentId));
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(title: Text(s.sentMessages)),
      floatingActionButtonLocation: isPersianLang
          ? FloatingActionButtonLocation.startFloat
          : FloatingActionButtonLocation.endFloat,
      floatingActionButton: ctrl.haveAccess
          ? FloatingActionButton(
              heroTag: "send-SMS-FAB",
              tooltip: s.sendSMS,
              onPressed: () {
                bottomSheet(
                  title: s.sendSMS,
                  child: SendSmsSheet(departmentId: ctrl.departmentId),
                );
              },
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
            )
          : null,
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
                        itemCount: ctrl.smsList.length,
                        padding: EdgeInsets.only(
                          top: 10,
                          left: 16,
                          right: 16,
                          bottom: ctrl.isEndOfList ? 100 : 10,
                        ),
                        itemBuilder: (final context, final index) {
                          final item = ctrl.smsList[index];
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
        WDropDownFormField<SMSStatus>(
          labelText: s.status,
          value: ctrl.selectedStatus.value,
          deselectable: true,
          items: ctrl.statusFiltersList.map((final SMSStatus status) {
            return DropdownMenuItem<SMSStatus>(
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

  Widget _buildItemCard(final SmsEntity item) {
    final canCancel = item.status == SMSStatus.pending || item.status == SMSStatus.scheduled;

    return WCard(
      showBorder: true,
      onTap: () {
        bottomSheet(
          title: item.recipient ?? '- -',
          child: SmsDetailSheet(item: item),
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
              Expanded(child: Text(item.recipient ?? '- -').bodyLarge()),
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
              if (item.sentByUser != null)
                _buildRowInfoWidget(
                  s.sentBy,
                  WCircleAvatar(
                    user: item.sentByUser,
                    size: 25,
                    showFullName: true,
                    bodySmall: true,
                    imageFontSize: 9,
                  ).pSymmetric(vertical: 4),
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
        ],
      ),
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
