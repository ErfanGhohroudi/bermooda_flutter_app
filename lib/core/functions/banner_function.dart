import 'package:u/utilities.dart';

import '../../data/data.dart';
import '../core.dart';

/// get Application Banners to show in [HomePage]
Future<List<String>> getBanners() async {
  final completer = Completer<List<String>>();

  Get.find<BannerDatasource>().getBanners(
    onResponse: (final response) {
      final list = response.resultList!.map((final e) => e.webFile?.url).whereType<String>().toList();

      Get.find<Core>().updateBannerUrls(list);

      completer.complete(list);
    },
    onError: (final errorResponse) => completer.completeError(errorResponse),
  );

  return completer.future;
}
