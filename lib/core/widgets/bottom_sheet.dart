part of 'widgets.dart';

/// Must use one of [child] or [childBuilder]
Future<T?> bottomSheet<T>({
  final Widget? child,
  final Widget Function(BuildContext context)? childBuilder,
  final bool isDismissible = true,
  final bool withBottomKeyboardPadding = true,
  final String title = '',
  final double horizontalPadding = 16,
  final double minHeight = 0.0,
  final double? maxHeight,
  final Color? backgroundColor,
  final bool enableDrag = true,
}) {
  // ✅ ۲. تضمین می‌کنیم که فقط child یا childBuilder مقداردهی شده باشد
  assert(child != null || childBuilder != null, 'Either child or childBuilder must be provided.');
  assert(child == null || childBuilder == null, 'Cannot provide both child and childBuilder.');

  return showModalBottomSheet<T>(
    context: navigatorKey.currentContext!,
    backgroundColor: Theme.of(navigatorKey.currentContext!).colorScheme.surface,
    isDismissible: isDismissible,
    isScrollControlled: true,
    enableDrag: enableDrag,
    useSafeArea: true,
    constraints: BoxConstraints(
      minHeight: minHeight,
      maxHeight: maxHeight ?? MediaQuery.sizeOf(navigatorKey.currentContext!).height * 0.8,
      // maxHeight: maxHeight ?? MediaQuery.sizeOf(navigatorKey.currentContext!).height - 100,
    ),
    builder: (final BuildContext context) => Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: backgroundColor ?? navigatorKey.currentContext!.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: horizontalPadding,
          right: horizontalPadding,
          bottom: (withBottomKeyboardPadding ? MediaQuery.of(navigatorKey.currentContext!).viewInsets.bottom : 0) + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: navigatorKey.currentContext!.width, height: 16),
            const DragHandler(),
            if (title != '')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title).bodyMedium(),
                  const Divider(),
                ],
              ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 12),
                child: Builder(
                  builder: childBuilder ?? (final context) => child ?? const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Must use one of [child] or [childBuilder]
Future<T?> bottomSheetWithNoScroll<T>({
  final Widget? child,
  final Widget Function(BuildContext context)? childBuilder,
  final bool isDismissible = true,
  final bool withBottomKeyboardPadding = true,
  final String title = '',
  final EdgeInsets padding = const EdgeInsets.all(16),
  final double? maxHeight,
  final Color? backgroundColor,
  final bool enableDrag = true,
}) {
  // ✅ ۲. تضمین می‌کنیم که فقط child یا childBuilder مقداردهی شده باشد
  assert(child != null || childBuilder != null, 'Either child or childBuilder must be provided.');
  assert(child == null || childBuilder == null, 'Cannot provide both child and childBuilder.');

  return showModalBottomSheet<T>(
    context: navigatorKey.currentContext!,
    backgroundColor: Theme.of(navigatorKey.currentContext!).colorScheme.surface,
    isDismissible: isDismissible,
    isScrollControlled: true,
    enableDrag: enableDrag,
    useSafeArea: true,
    constraints: BoxConstraints(
      maxHeight: maxHeight ?? MediaQuery.sizeOf(navigatorKey.currentContext!).height * 0.8,
      // maxHeight: maxHeight ?? MediaQuery.sizeOf(navigatorKey.currentContext!).height - 100,
    ),
    builder: (final BuildContext context) => Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: backgroundColor ?? navigatorKey.currentContext!.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: padding,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: withBottomKeyboardPadding ? MediaQuery.of(navigatorKey.currentContext!).viewInsets.bottom : 0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: navigatorKey.currentContext!.width),
            const DragHandler(),
            if (title != '')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title).bodyMedium(),
                  const Divider(),
                ],
              ),
            Flexible(
              child: Builder(
                builder: childBuilder ?? (final context) => child ?? const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class DragHandler extends StatelessWidget {
  const DragHandler({super.key});

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: 70,
      height: 5,
      decoration: BoxDecoration(
        color: context.theme.hintColor,
        borderRadius: BorderRadius.circular(20),
      ),
    ).marginOnly(bottom: 12);
  }
}
