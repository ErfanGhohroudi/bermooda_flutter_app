import 'app_config.dart';
import 'core/app_initializer.dart';

void main() async {
  await AppInitializer.instance.initializeApp(Flavor.development);
}

