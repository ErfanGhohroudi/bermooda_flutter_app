import 'package:u/utilities.dart';

import '../../../../../core/services/subscription_service.dart';

class WModuleCard extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onTap;

  const WModuleCard({
    required this.title,
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    final SubscriptionService subService = Get.find<SubscriptionService>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        InkWell(
          onTap: () => subService.checkSubscription(action: onTap),
          borderRadius: BorderRadius.circular(15),
          child: Ink(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.theme.cardColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: context.theme.shadowColor,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: UImage(icon),
          ),
        ),
        SizedBox(width: context.width, child: Text(title, textAlign: TextAlign.center, maxLines: 2).bodySmall(fontSize: 12, overflow: TextOverflow.ellipsis)),
      ],
    ).withTooltip(title);
  }
}
