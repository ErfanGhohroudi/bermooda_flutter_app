import 'package:u/utilities.dart';

import '../../core.dart';
import '../widgets.dart';

class ExpansionItem extends StatelessWidget {
  const ExpansionItem({
    required this.title,
    required this.child,
    required this.isExpanded,
    required this.onTap,
    required this.icon,
    required this.iconColor,
    super.key,
  });

  final String title;
  final Widget child;
  final bool isExpanded;
  final VoidCallback onTap;
  final String? icon;
  final Color? iconColor;

  @override
  Widget build(final BuildContext context) {
    return WCard(
      showBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: const EdgeInsetsDirectional.only(start: 12),
            minTileHeight: 30,
            splashColor: Colors.transparent,
            onTap: onTap,
            leading: icon != null
                ? UImage(
                    icon!,
                    color: iconColor ?? Theme.of(context).primaryColorDark,
                    size: 25,
                  )
                : null,
            title: Text(title).bodyMedium(),
            trailing: AnimatedRotation(
              turns: isExpanded ? (isPersianLang ? 0.5 : 0) : (isPersianLang ? 0 : 0.5),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutExpo,
              child: Icon(Icons.keyboard_arrow_down_rounded, color: context.theme.hintColor),
            ),
          ),
          if (isExpanded) const Divider(height: 18),
          // AnimatedSize به صورت خودکار انیمیشن نرمی را برای تغییر سایز فراهم می‌کند.
          // این بهترین و بهینه‌ترین راه برای نمایش/مخفی کردن محتوا با انیمیشن است.
          AnimatedSize(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutExpo,
            child: SizedBox(
              width: double.infinity,
              child: isExpanded ? child : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
