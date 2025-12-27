import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Flavor { development, production }

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  static AppConfig get instance => _instance;

  Flavor _appFlavor = Flavor.development;
  bool _isFlavorSet = false;

  Flavor get appFlavor => _appFlavor;

  void setFlavor(final Flavor flavor) {
    if (!_isFlavorSet) {
      _appFlavor = flavor;
      _isFlavorSet = true;
    }
  }

  String get title {
    switch (_appFlavor) {
      case Flavor.development:
        return 'Dev';
      case Flavor.production:
        return 'Prod';
    }
  }

  String get baseUrl {
    switch (_appFlavor) {
      case Flavor.development:
        return dotenv.env['DEV_BASE_URL'] ?? "";
      case Flavor.production:
        return dotenv.env['PROD_BASE_URL'] ?? "";
    }
  }

  String get wsBaseUrl {
    switch (_appFlavor) {
      case Flavor.development:
        return dotenv.env['DEV_WS_BASE_URL'] ?? "";
      case Flavor.production:
        return dotenv.env['PROD_WS_BASE_URL'] ?? "";
    }
  }
}
