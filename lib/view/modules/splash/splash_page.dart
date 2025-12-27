import 'package:u/utilities.dart';

import '../../../core/widgets/widgets.dart';
import '../../../core/core.dart';
import '../../../core/theme.dart';
import 'splash_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SplashController {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return PopScope(
      canPop: false,
      child: UScaffold(
        color: context.theme.cardColor,
        body: Center(
          child: Column(
            children: [
              const Spacer(),
              const UImage(AppImages.logoSplash, width: 300),
              const Spacer(),
              const WCircularLoading(size: 15, strokeWidth: 3).marginOnly(bottom: 10),
              Text("${s.version} ${UApp.version}").bodyMedium().marginOnly(bottom: 30)
            ],
          ),
        ),
      ),
    );
  }
}
