import 'package:u/utilities.dart';

import '../theme.dart';

part 'snack_bar.dart';

abstract class AppNavigator {
  static Future<T?> push<T>(
    final Widget page, {
    final bool dialog = false,
    final Transition transition = Transition.cupertino,
    final bool preventDuplicates = true,
    final int milliSecondDelay = 10,
  }) async {
    await Future.delayed(milliSecondDelay.milliseconds);
    return Get.to<T>(
      page,
      fullscreenDialog: dialog,
      popGesture: true,
      opaque: dialog ? false : true,
      transition: transition,
      preventDuplicates: preventDuplicates,
    );
  }

  static Future<T?> dialog<T>(
    final Widget page, {
    final bool barrierDismissible = true,
    final bool useSafeArea = false,
    final VoidCallback? onDismiss,
    final Color? barrierColor,
  }) =>
      Get.dialog<T>(
        page,
        useSafeArea: useSafeArea,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
      ).then(
        (final value) {
          onDismiss?.call();
          return value;
        },
      );

  static void offAll(
    final Widget page, {
    final bool dialog = false,
    final Transition transition = Transition.cupertino,
    final int milliSecondDelay = 10,
  }) => delay(
    milliSecondDelay,
    () => Get.offAll(
      () => page,
      fullscreenDialog: dialog,
      popGesture: true,
      opaque: dialog ? false : true,
      transition: transition,
    ),
  );

  static void off(final Widget page, {final bool preventDuplicates = true}) => delay(
    10,
    () => Get.off(() => page, preventDuplicates: preventDuplicates),
  );

  static void back<T>({final bool closeOverlays = false, final T? result, final bool canPop = true}) => delay(
    10,
    () => Get.back<T>(closeOverlays: closeOverlays, result: result, canPop: canPop),
  );
}
