import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../module_card/module_card.dart';

class WExpandableCardGrid extends StatefulWidget {
  const WExpandableCardGrid({
    required this.modules,
    super.key,
  });

  final List<WModuleCard> modules;

  @override
  State<WExpandableCardGrid> createState() => _WExpandableCardGridState();
}

class _WExpandableCardGridState extends State<WExpandableCardGrid> {
  bool _isExpanded = false;

  // تعداد آیتم‌هایی که در حالت بسته نمایش داده می‌شوند
  final int _displayLimit = 7;

  // لیست کامل تمام آیتم‌ها
  late final List<WModuleCard> _allItems;

  @override
  void initState() {
    _allItems = widget.modules;
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    // 2. بر اساس وضعیت _isExpanded، لیست نمایشی را تعیین می‌کنیم
    final List<WModuleCard> displayedItems = _isExpanded ? _allItems : _allItems.take(_displayLimit).toList();

    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 6,
        mainAxisSpacing: 3,
        childAspectRatio: 3 / 3.7,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        ...displayedItems,

        // 3. اگر تعداد کل آیتم‌ها بیشتر از حد نمایش بود، دکمه نمایش بیشتر/کمتر را نشان بده
        if (_allItems.length > _displayLimit) _buildMoreCard(),
      ],
    );
  }

  // ویجت برای ساخت کارت "نمایش بیشتر" یا "نمایش کمتر"
  Widget _buildMoreCard() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: context.theme.hintColor.withAlpha(120), width: 2),
          ),
          child: Icon(
            _isExpanded ? Icons.arrow_back_ios_rounded : Icons.arrow_forward_ios_rounded,
            size: 25,
            color: context.theme.hintColor.withAlpha(120),
          ),
        ),
        SizedBox(width: context.width, child: Text(_isExpanded ? s.less : s.more, textAlign: TextAlign.center).bodySmall(fontSize: 12)),
      ],
    ).onTap(() {
      setState(() {
        _isExpanded = !_isExpanded;
      });
    });
  }
}
