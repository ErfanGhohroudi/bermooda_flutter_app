import 'package:u/utilities.dart';

import '../../../../../core/services/permission_service.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/utils/extensions/date_extensions.dart';
import '../../../../../core/core.dart';
import '../../../../../data/data.dart';
import '../card/home_card.dart';

class WNotices extends StatefulWidget {
  const WNotices({
    required this.notices,
    required this.listState,
    required this.onPressedAddButton,
    super.key,
  });

  final RxList<NoticeReadDto> notices;
  final Rx<PageState> listState;
  final VoidCallback onPressedAddButton;

  @override
  State<WNotices> createState() => _WNoticesState();
}

class _WNoticesState extends State<WNotices> {
  final PermissionService _perService = Get.find();
  final int _displayItemLimit = 4;
  final RxBool _isExpanded = false.obs;

  bool get haveManageAccess => _perService.haveAnyManagerAccess;

  RxList<NoticeReadDto> get notices => widget.notices;

  int get displayItemLimit => (notices.length < _displayItemLimit) ? notices.length : _displayItemLimit;

  @override
  void dispose() {
    _isExpanded.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return HomeCard(
      title: s.notice,
      actionButton: haveManageAccess
          ? IconButton(
              onPressed: widget.onPressedAddButton,
              icon: Icon(
                Icons.add_circle_outline_rounded,
                color: context.theme.primaryColor,
                size: 30,
              ),
            )
          : null,
      child: Obx(
        () {
          if (widget.listState.isLoading() || widget.listState.isInitial()) {
            return const WCircularLoading().marginOnly(bottom: 30);
          }

          if (widget.listState.isError()) {
            return Text(s.error).bodyMedium(color: AppColors.red).marginOnly(bottom: 30);
          }

          return Column(
            spacing: 12,
            children: [
              Obx(
                () {
                  if (notices.isEmpty) {
                    return const WEmptyWidget().marginOnly(bottom: 30);
                  }

                  return ListView.separated(
                    itemCount: _isExpanded.value ? notices.length : displayItemLimit,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (final context, final index) => const Divider(height: 24),
                    itemBuilder: (final context, final index) => Row(
                      spacing: 12,
                      children: [
                        Container(
                          width: 75,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: context.theme.dividerColor),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(notices[index].notifDate.toJalali()?.weekDay.jalaliMonthName.getJalaliMonthNameFaEn() ?? '')
                                  .bodySmall(color: context.theme.primaryColor),
                              const Divider(height: 10),
                              Text(notices[index].notifDate.toJalali()?.day.toString().padLeft(2, "0") ?? '').bodyLarge(color: context.theme.hintColor),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(notices[index].title ?? '', maxLines: 1).bodySmall(overflow: TextOverflow.ellipsis).bold(),
                            ),
                            Flexible(
                              child: Text(notices[index].description ?? '', maxLines: 1).bodySmall(overflow: TextOverflow.ellipsis, height: 2),
                            ),
                          ],
                        ).expanded(),
                      ],
                    ),
                  );
                },
              ),
              if (widget.notices.length > displayItemLimit)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  color: Colors.transparent,
                  child: Obx(
                    () => Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 5,
                      children: [
                        Text(_isExpanded.value ? s.less : s.more).bodyMedium(color: context.theme.primaryColor),
                        Icon(
                          _isExpanded.value ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                          color: context.theme.primaryColor,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ).onTap(() {
                  _isExpanded(!_isExpanded.value);
                }),
            ],
          );
        },
      ),
    );
  }
}
