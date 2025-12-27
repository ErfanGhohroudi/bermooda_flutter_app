import 'package:u/utilities.dart';

import '../core.dart';

/// یک کلاس مدل برای تعریف هر آیتم تب.
class TabItem {
  final String title;
  final String? iconString;
  final Widget content;

  TabItem({
    required this.title,
    required this.content,
    this.iconString,
  });
}

/// یک کامپوننت TabBar که تب‌های اضافی را در یک منوی "بیشتر" نمایش می‌دهد
/// و به عنوان PreferredSizeWidget برای استفاده در AppBar طراحی شده است.
class TabBarWithMoreMenu extends StatefulWidget implements PreferredSizeWidget {
  const TabBarWithMoreMenu({
    required this.tabItems,
    required this.onChanged,
    this.initialIndex = 0,
    this.maxVisibleTabs = 3,
    this.height = kToolbarHeight,
    super.key,
  });

  /// لیست کامل آیتم‌های تب.
  final List<TabItem> tabItems;

  /// اندیس تب فعال فعلی.
  final int initialIndex;

  /// یک callback که با انتخاب یک تب جدید فراخوانی می‌شود.
  final ValueChanged<int> onChanged;

  /// حداکثر تعداد تب‌هایی که قبل از منوی "بیشتر" نمایش داده می‌شوند.
  final int maxVisibleTabs;

  /// ارتفاع نوار تب.
  final double height;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  State<TabBarWithMoreMenu> createState() => _TabBarWithMoreMenuState();
}

class _TabBarWithMoreMenuState extends State<TabBarWithMoreMenu> {
  late int _currentIndex;

  @override
  void initState() {
    _currentIndex = widget.initialIndex;
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    // تقسیم تب‌ها به دو لیست: قابل مشاهده و داخل منو
    final visibleItems = widget.tabItems.take(widget.maxVisibleTabs).toList();
    final menuItems = widget.tabItems.skip(widget.maxVisibleTabs).toList();

    // آیا تب فعال فعلی در منوی "بیشتر" قرار دارد؟
    final bool isMoreTabActive = _currentIndex >= widget.maxVisibleTabs;

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Row(
        children: [
          // ساخت تب‌های قابل مشاهده
          ...List.generate(visibleItems.length, (final index) {
            return _buildTab(
              context: context,
              item: visibleItems[index],
              index: index,
              isSelected: _currentIndex == index,
            );
          }),

          // ساخت تب "بیشتر" در صورت وجود آیتم‌های اضافی
          if (menuItems.isNotEmpty) _buildMoreTab(context, menuItems, isMoreTabActive),
        ],
      ),
    );
  }

  // ویجت کمکی برای ساخت هر تب قابل مشاهده
  Widget _buildTab({
    required final BuildContext context,
    required final TabItem item,
    required final int index,
    required final bool isSelected,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final color = isSelected ? (isDarkMode ? theme.primaryColorDark : theme.primaryColor) : theme.primaryColorDark.withAlpha(100);

    return Expanded(
      child: Tooltip(
        message: item.title,
        waitDuration: const Duration(milliseconds: 500), // تاخیر قبل از نمایش
        child: InkWell(
          onTap: () {
            setState(() {
              _currentIndex = index;
            });
            widget.onChanged(_currentIndex);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isSelected ? theme.primaryColor : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: DefaultTextStyle(
              style: theme.textTheme.bodyMedium?.copyWith(
                    color: color,
                    overflow: TextOverflow.ellipsis,
                  ) ??
                  const TextStyle(),
              child: IconTheme(
                data: IconThemeData(color: color),
                child: Center(child: _buildTabItemWidget(item.title, item.iconString, color)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ویجت کمکی برای ساخت تب "بیشتر"
  Widget _buildMoreTab(final BuildContext context, final List<TabItem> menuItems, final bool isSelected) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final color = isSelected ? (isDarkMode ? theme.primaryColorDark : theme.primaryColor) : theme.primaryColorDark.withAlpha(100);

    return Expanded(
      child: PopupMenuButton<int>(
        onSelected: (final int selectedIndex) {
          setState(() {
            _currentIndex = selectedIndex;
          });
          widget.onChanged(_currentIndex);
        },
        itemBuilder: (final BuildContext context) {
          final List<PopupMenuEntry<int>> entries = [];

          for (int index = 0; index < menuItems.length; index++) {
            final totalIndex = widget.maxVisibleTabs + index;
            final bool isItemSelectedInMenu = _currentIndex == totalIndex;
            TabItem item = menuItems[index];
            Widget child = _buildTabItemWidget(item.title, item.iconString, isItemSelectedInMenu ? Colors.white : theme.primaryColorDark);

            if (isItemSelectedInMenu) {
              child = Container(
                color: theme.primaryColor,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: DefaultTextStyle(
                  style: (Theme.of(context).textTheme.bodyMedium ?? const TextStyle()).copyWith(color: Colors.white),
                  child: IconTheme.merge(
                    data: const IconThemeData(color: Colors.white),
                    child: child,
                  ),
                ),
              );
            }
            // آیتم را به لیست اضافه می‌کنیم
            entries.add(
              PopupMenuItem<int>(
                value: totalIndex,
                padding: isItemSelectedInMenu ? const EdgeInsets.symmetric(horizontal: 0.0) : const EdgeInsets.symmetric(horizontal: 16.0),
                child: child,
              ),
            );

            // ✅ اگر این آخرین آیتم نبود، یک جداکننده اضافه می‌کنیم
            if (index < menuItems.length - 1) {
              entries.add(const PopupMenuDivider(height: 10));
            }
          }
          return entries;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? theme.primaryColor : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: DefaultTextStyle(
            style: theme.textTheme.bodyMedium?.copyWith(
                  color: color,
                  overflow: TextOverflow.ellipsis,
                ) ??
                const TextStyle(),
            child: IconTheme(
              data: IconThemeData(color: color),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(s.more),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItemWidget(final String title, final String? iconString, final Color iconColor) => Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 3,
        children: [
          if (iconString != null) UImage(iconString, size: 20, color: iconColor),
          Flexible(child: Text(title, maxLines: 2)),
        ],
      );
}
