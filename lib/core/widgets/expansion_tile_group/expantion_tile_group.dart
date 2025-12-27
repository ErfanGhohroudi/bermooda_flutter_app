import 'package:u/utilities.dart';

import 'expansion_item.dart';

// یک مدل ساده برای داده‌های هر آیتم
// در یک اپلیکیشن بزرگ، این مدل در فایل خودش قرار می‌گیرد.
class ExpansionTileItemModel {
  const ExpansionTileItemModel({
    required this.title,
    required this.body,
    this.icon,
    this.iconColor,
  });

  final String title;
  final String? icon;
  final Color? iconColor;
  final Widget body;
}

/// MAIN WIDGET
// این ویجت گروهی از آیتم‌های آکاردئونی را مدیریت و نمایش می‌دهد.
// این ویجت، کنترلر را initialize کرده و به آن متصل می‌شود.
class ExpansionTileGroup extends StatefulWidget {
  const ExpansionTileGroup({
    required this.items,
    this.initialIndex,
    super.key,
  });

  final List<ExpansionTileItemModel> items;
  final int? initialIndex;

  @override
  State<ExpansionTileGroup> createState() => _ExpansionTileGroupState();
}

class _ExpansionTileGroupState extends State<ExpansionTileGroup> {
  late List<ExpansionTileItemModel> _items;
  int? _selectedIndex;

  @override
  void initState() {
    _items = widget.items;
    _selectedIndex = widget.initialIndex;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant final ExpansionTileGroup oldWidget) {
    // if (oldWidget.items.length != widget.items.length) {
      setState(() {
        _items = widget.items;
      });
    // }
    super.didUpdateWidget(oldWidget);
  }

  // این متد برای باز یا بسته کردن یک آیتم فراخوانی می‌شود.
  void _toggleItem(final int index) {
    setState(() {
      if (_selectedIndex == index) {
        _selectedIndex = null;
      } else {
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    return ListView.builder(
      itemCount: _items.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (final context, final index) {
        final item = _items[index];

        return ExpansionItem(
          title: item.title,
          icon: item.icon,
          iconColor: item.iconColor,
          isExpanded: _selectedIndex == index,
          onTap: () => _toggleItem(index),
          child: item.body,
        );
      },
    );
  }
}
