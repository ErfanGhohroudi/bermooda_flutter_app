import 'package:action_slider/action_slider.dart';
import 'package:u/utilities.dart';

import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/services/subscription_service.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../data/data.dart';
import 'attendance_controller.dart';
import 'widgets/timer/working_timer.dart';

void showAttendanceBottomSheet() async {
  final subService = Get.find<SubscriptionService>();

  if (subService.hrModuleIsActive) {
    return bottomSheet(
      title: s.attendance,
      enableDrag: false,
      isDismissible: true,
      child: const AttendancePage(),
    );
  }
  AppNavigator.snackbarRed(title: s.error, subtitle: s.hRModuleIsRequired);
}

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> with AttendanceController {
  @override
  void initState() {
    initialController();
    super.initState();
  }

  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 10,
      children: [
        Obx(
          () {
            if (pageState.isInitial() || pageState.isLoading()) {
              return const SizedBox(height: 200, child: Center(child: WCircularLoading()));
            }
            if (pageState.isError()) {
              return SizedBox(height: 200, child: Center(child: WErrorWidget(onTapButton: onRefreshWithLoading)));
            }

            if (shiftStatus is NoData) {
              return const SizedBox.shrink();
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                Row(
                  children: [
                    _buildShiftWorkTime(showColumn: isCheckOut).expanded(),
                    if (isCheckOut) _buildWorkedTimeToday().expanded(),
                  ],
                ),
                if (isCheckIn && timeStatus != null) _buildTimeStatus(),
              ],
            );
          },
        ),
        _buildSliderAction(),
      ],
    );
  }

  Widget _buildShiftWorkTime({required final bool showColumn}) {
    List<Widget> children = [
      Text(s.workingHours).bodyMedium(color: context.theme.hintColor),
      Text(shiftWorkTime).titleMedium(),
    ];

    return WCard(
      showBorder: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 70),
        child: showColumn
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 10,
                children: children,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 10,
                children: children.map((final e) => Flexible(child: e)).toList(),
              ),
      ),
    );
  }

  Widget _buildWorkedTimeToday() {
    return WCard(
      showBorder: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 10,
          children: [
            Text(s.timeWorkedToday).bodyMedium(color: context.theme.hintColor),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 5,
              children: [
                UImage(AppIcons.timerOutline, size: 25, color: context.theme.hintColor),
                WorkingTimer(
                  elapsedSeconds: (shiftStatus as CheckOutModal).activeAttendance?.elapsedSeconds,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontSize: 21,
                    color: AppColors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeStatus() {
    return Builder(
      builder: (final context) {
        final Color color;
        final String icon;
        final String text;

        switch (timeStatus!) {
          case AttendanceTimeStatus.on_time:
            color = AppColors.green;
            icon = AppIcons.tickCircleOutline;
            text = s.youAreOnTime;
          case AttendanceTimeStatus.early:
            color = AppColors.blue;
            icon = AppIcons.clockOutline;
            text = s.youAreEarly.replaceAll("#", minutesDifferenceFormatted);
          case AttendanceTimeStatus.late:
            color = AppColors.red;
            icon = AppIcons.info;
            text = s.youAreLate.replaceAll("#", minutesDifferenceFormatted);
        }

        return WCard(
          color: color.withValues(alpha: 0.1),
          borderColor: color,
          showBorder: true,
          child: SizedBox(
            width: double.infinity,
            child: Row(
              spacing: 10,
              children: [
                UImage(icon, size: 25, color: color),
                Flexible(child: Text(text).bodyMedium(color: color)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSliderAction() {
    return Obx(
      () {
        if (pageState.isError()) {
          return const SizedBox.shrink();
        }

        if (shiftStatus.isCheckInOrCheckOut == false) {
          if (shiftStatus.message == null) return const SizedBox.shrink();

          return Container(
            constraints: const BoxConstraints(minHeight: 70, minWidth: double.infinity),
            margin: const EdgeInsetsDirectional.all(24),
            padding: const EdgeInsetsDirectional.all(12),
            decoration: BoxDecoration(
              color: context.theme.hintColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              widthFactor: 1,
              heightFactor: 1,
              child: Text(shiftStatus.message ?? '', textAlign: TextAlign.center).titleMedium(color: Colors.white),
            ),
          );
        }

        final buttonTitle = shiftStatus.modalType?.title ?? '';

        return Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Theme(
              data: ThemeData(
                iconTheme: IconThemeData(color: isCheckIn ? AppColors.green : AppColors.red),
              ),
              child: ActionSlider.standard(
                controller: actionSliderController,
                sliderBehavior: SliderBehavior.stretch,
                backgroundColor: isCheckIn ? AppColors.green : AppColors.red,
                toggleColor: Colors.white,
                width: 300.0,
                icon: const Icon(Icons.arrow_forward_ios_rounded),
                failureIcon: const Icon(Icons.close_rounded, size: 30, color: AppColors.red),
                successIcon: Icon(Icons.check_rounded, size: 30, color: context.theme.primaryColor),
                loadingIcon: const WCircularLoading(),
                action: (final controller) {
                  attendanceRegistration(context);
                  // actionSliderController.loading(); //starts loading animation
                  // await Future.delayed(const Duration(seconds: 3));
                  // actionSliderController.success(); //starts success animation
                  // await Future.delayed(const Duration(seconds: 1));
                  // actionSliderController.reset(); //resets the slider
                },
                child: Text(buttonTitle).bodyLarge(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}
