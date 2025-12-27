import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../core/services/permission_service.dart';
import '../../../core/core.dart';
import '../../../core/services/subscription_service.dart';
import '../../../core/utils/enums/enums.dart';
import '../../../data/data.dart';

mixin ModulesController {
  final core = Get.find<Core>();
  final subService = Get.find<SubscriptionService>();
  final perService = Get.find<PermissionService>();
  final NoticeDatasource _noticeDatasource = Get.find<NoticeDatasource>();
  final RefreshController refreshController = RefreshController();
  final RxList<NoticeReadDto> notices = <NoticeReadDto>[].obs;
  final Rx<PageState> noticesState = PageState.loading.obs;

  SubscriptionStatus get subStatus => subService.status;

  bool get subIsNoPurchased => subService.isNoPurchased;

  String get subIsNoPurchasedText => SubscriptionPurchaseType.no_purchase.getTitle();

  bool get subIsExpired => subService.isExpired;

  bool get subWillExpiringSoon => subService.status == SubscriptionStatus.expiringSoon;

  bool get isWorkspaceOwner => perService.isWorkspaceOwner;

  void disposeItems() {
    refreshController.dispose();
    notices.close();
    noticesState.close();
  }

  Future<void> fetchAllData() async {
    try {
      final results = await Future.wait([fetchNotices()]).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('timed out'),
      );

      if (notices.subject.isClosed) return;
      notices(results[0]);

      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
  }

  Future<List<NoticeReadDto>> fetchNotices() {
    final completer = Completer<List<NoticeReadDto>>();
    _noticeDatasource.getNotices(
      onResponse: (final response) {
        final list = response.resultList;
        noticesState.loaded();
        completer.complete(list);
      },
      onError: (final errorResponse) {
        noticesState.error();
        completer.completeError(errorResponse);
      },
    );
    return completer.future;
  }
}
