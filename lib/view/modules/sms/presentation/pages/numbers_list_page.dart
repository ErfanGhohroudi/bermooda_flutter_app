import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/utils/extensions/money_extensions.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../domain/entity/sms_panel_number.dart';
import '../controllers/numbers_list_controller.dart';
import '../sheets/add_sms_panel_number_sheet.dart';

class SmsNumbersListPage extends StatefulWidget {
  const SmsNumbersListPage({
    required this.departmentId,
    super.key,
  });

  final int departmentId;

  @override
  State<SmsNumbersListPage> createState() => _SmsNumbersListPageState();
}

class _SmsNumbersListPageState extends State<SmsNumbersListPage> {
  late final SmsNumbersListController ctrl;

  @override
  void initState() {
    ctrl = Get.put(SmsNumbersListController(departmentId: widget.departmentId));
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(title: Text(s.numberManagement)),
      floatingActionButtonLocation: isPersianLang
          ? FloatingActionButtonLocation.startFloat
          : FloatingActionButtonLocation.endFloat,
      floatingActionButton: ctrl.haveAdminAccess
          ? FloatingActionButton(
              heroTag: "addSMSPanelCardSimFAB",
              onPressed: () {
                bottomSheet(
                  title: "${s.addText} ${s.number}",
                  child: AddSmsPanelNumberSheet(ctrl: ctrl),
                );
              },
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
            )
          : null,
      body: Stack(
        children: [
          Obx(
            () {
              final showEmptyWidget = ctrl.pageState.isLoaded() && ctrl.numbers.isEmpty;
              final showErrorWidget = ctrl.pageState.isError();
              if (showEmptyWidget) return const Center(child: WEmptyWidget());
              if (showErrorWidget) return Center(child: WErrorWidget(onTapButton: ctrl.onTryAgain));
              return const SizedBox.shrink();
            },
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
                    itemCount: ctrl.numbers.length,
                    padding: EdgeInsets.only(
                      top: 10,
                      left: 16,
                      right: 16,
                      bottom: ctrl.isEndOfList ? 100 : 10,
                    ),
                    itemBuilder: (final context, final index) {
                      final number = ctrl.numbers[index];
                      return _buildNumberCard(number);
                    },
                  ),
                );
              },
            ),
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

  Widget _buildNumberCard(final SmsPanelNumber number) {
    return WCard(
      showBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              UImage(AppIcons.cardSimOutline, size: 20, color: context.theme.hintColor),
              Expanded(child: Text(number.number ?? '- -').bodyLarge()),
              WMoreButtonIcon(
                items: [
                  WPopupMenuItem(
                    title: s.delete,
                    icon: AppIcons.delete,
                    titleColor: AppColors.red,
                    iconColor: AppColors.red,
                    onTap: () => ctrl.deleteNumber(number),
                  ),
                ],
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              _buildRowInfo(s.title, number.title ?? '- -').expanded(),
              _buildRowInfo(s.usedThisMonth, number.usedThisMonth?.toString() ?? '- -').expanded(),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              _buildRowInfo(s.monthlyLimit, number.monthlyLimit?.toString() ?? '- -').expanded(),
              _buildRowInfo(s.dailyLimit, number.dailyLimit?.toString() ?? '- -').expanded(),
            ],
          ),
          _buildRowInfo(s.balance, number.balance?.toTomanMoney() ?? '- -'),
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

  Widget _loadingShimmerList() => ListView.builder(
    itemCount: 10,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (final context, final index) => WCard(
      child: SizedBox(width: context.width, height: 100),
    ),
  ).shimmer();
}
