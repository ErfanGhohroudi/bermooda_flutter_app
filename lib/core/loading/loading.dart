import 'package:u/utilities.dart';

import '../core.dart';

abstract class AppLoading {
  static void showLoading() => EasyLoading.show(status: s.wait);

  static void dismissLoading() => EasyLoading.dismiss();

  static void showError() => EasyLoading.showError(s.error);

  static bool isLoadingShow() => EasyLoading.isShow;
}