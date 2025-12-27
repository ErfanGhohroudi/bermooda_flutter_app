part of '../dashboard_reports_page.dart';

class DashboardCardItem {
  DashboardCardItem({
    required this.label,
    required this.color,
    required this.value,
    this.iconString,
    this.iconData,
  });

  final String label;
  final Color color;
  final int value;
  final String? iconString;
  final IconData? iconData;
}

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    required this.label,
    required this.color,
    this.iconString,
    this.iconData,
    this.items = const [],
    super.key,
  });

  final String label;
  final Color color;
  final String? iconString;
  final IconData? iconData;
  final List<DashboardCardItem> items;

  @override
  Widget build(final BuildContext context) {
    if (iconString != null && iconData != null) throw Exception('iconString != null && iconData != null');

    return WCard(
      showBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Header
          Row(
            spacing: 12,
            children: [
              if (iconString != null || iconData != null) _buildIcon(context),
              Flexible(
                child: Text(label, maxLines: 1).bodyMedium(fontSize: 14).bold(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// Items
          ...items.map((final item) => _buildItem(context, item)),
        ],
      ),
    );
  }

  Widget _buildIcon(final BuildContext ctx) {
    final double size = 50;
    final double padding = 8;
    final double iconSize = size - (padding * 2);
    final Color iconColor = color;

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(size),
      ),
      child: iconString != null
          ? UImage(iconString!, color: iconColor, size: iconSize)
          : iconData != null
              ? Icon(iconData!, color: iconColor, size: iconSize)
              : null,
    );
  }

  Widget _buildItem(final BuildContext ctx, final DashboardCardItem item) => WCard(
        showBorder: true,
        color: item.color.withValues(alpha: 0.05),
        borderColor: item.color,
        borderWidth: 1,
        padding: 8,
        child: Row(
          children: [
            if (item.iconString != null || item.iconData != null) _buildItemIcon(ctx, item),
            const SizedBox(width: 12),
            Expanded(
              child: Text(item.label, maxLines: 1).bodyMedium(),
            ),
            const SizedBox(width: 12),
            Text(item.value.toString().separateNumbers3By3()).bodyLarge().bold(),
            const SizedBox(width: 8),
          ],
        ),
      );

  Widget _buildItemIcon(final BuildContext ctx, final DashboardCardItem item) {
    final double size = 40;
    final double padding = 8;
    final double borderRadius = 12;
    final double iconSize = size - (padding * 2);
    final Color iconColor = Colors.white;

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: item.color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: item.iconString != null
          ? UImage(item.iconString!, color: iconColor, size: iconSize)
          : item.iconData != null
              ? Icon(item.iconData!, color: iconColor, size: iconSize)
              : null,
    );
  }
}
