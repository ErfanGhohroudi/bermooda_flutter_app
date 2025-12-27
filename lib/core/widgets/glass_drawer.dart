part of 'widgets.dart';

class WGlassDrawer extends StatelessWidget {
  const WGlassDrawer({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(final BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: isPersianLang ? const Radius.circular(0) : const Radius.circular(20),
        bottomRight: isPersianLang ? const Radius.circular(0) : const Radius.circular(20),
        topLeft: isPersianLang ? const Radius.circular(20) : const Radius.circular(0),
        bottomLeft: isPersianLang ? const Radius.circular(20) : const Radius.circular(0),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30), // Blur effect
        child: Container(
          width: 300, // Drawer width
          height: MediaQuery.of(context).size.height, // Drawer height
          color: Colors.white.withAlpha(30), // Semi-transparent white background
          child: child,
        ),
      ),
    ).safeArea();
  }
}
