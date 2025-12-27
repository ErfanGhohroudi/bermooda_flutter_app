import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({
    required this.title,
    required this.child,
    this.actionButton,
    super.key,
  });

  final String title;
  final Widget? actionButton;
  final Widget child;

  @override
  Widget build(final BuildContext context) {
    return WCard(
      showBorder: true,
      child: Column(
        spacing: 18,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(title).bodyMedium().bold()),
              if (actionButton != null) actionButton!,
            ],
          ),
          child.marginOnly(bottom: 10),
        ],
      ).pOnly(top: 8),
    );
  }
}
