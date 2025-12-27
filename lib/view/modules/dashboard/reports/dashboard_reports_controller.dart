import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../core/core.dart';
import '../../../../data/data.dart';

mixin DashboardReportsController {
  final core = Get.find<Core>();
  final DashboardDatasource _datasource = Get.find<DashboardDatasource>();
  final RefreshController refreshController = RefreshController();
  final Rx<PageState> pageState = PageState.initial.obs;

  ProjectSummeryReadDto projectSummery = const ProjectSummeryReadDto();
  CrmSummeryReadDto crmSummery = const CrmSummeryReadDto();
  OnlineUsersSummeryReadDto onlineUsersSummery = const OnlineUsersSummeryReadDto();

  bool isFirstTime = true;

  void disposeItems() {
    pageState.close();
    refreshController.dispose();
  }

  void initialController() {
    _getAllData();
  }

  void onRefresh() {
    _getAllData();
  }

  void onTryAgain() {
    pageState.loading();
    _getAllData();
  }

  void _getAllData() async {
    try {
      final results = await Future.wait([_getProjectSummery(), _getCrmSummery(), _getOnlineUsersSummery()]).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('timed out'),
      );

      if (pageState.subject.isClosed) return;

      projectSummery = results[0] as ProjectSummeryReadDto;
      crmSummery = results[1] as CrmSummeryReadDto;
      onlineUsersSummery = results[2] as OnlineUsersSummeryReadDto;

      refreshController.refreshCompleted();
      isFirstTime = false;

      pageState.loaded();
    } catch (e) {
      if (pageState.subject.isClosed) return;
      refreshController.refreshFailed();
      if (isFirstTime) pageState.error();
    }
  }

  Future<ProjectSummeryReadDto> _getProjectSummery() {
    final memberId = core.currentWorkspace.value.memberId;
    final completer = Completer<ProjectSummeryReadDto>();
    if (memberId == null) {
      completer.completeError("memberId == null");
      return completer.future;
    }
    _datasource.getAllProjectSummery(
      memberId: memberId,
      onResponse: (final response) {
        if (response.result == null) return completer.completeError("response.result == null");
        completer.complete(response.result);
      },
      onError: (final errorResponse) {
        completer.completeError(errorResponse);
      },
    );
    return completer.future;
  }

  Future<CrmSummeryReadDto> _getCrmSummery() {
    final memberId = core.currentWorkspace.value.memberId;
    final completer = Completer<CrmSummeryReadDto>();
    if (memberId == null) {
      completer.completeError("memberId == null");
      return completer.future;
    }
    _datasource.getAllCrmSummery(
      memberId: memberId,
      onResponse: (final response) {
        if (response.result == null) return completer.completeError("response.result == null");
        completer.complete(response.result);
      },
      onError: (final errorResponse) {
        completer.completeError(errorResponse);
      },
    );
    return completer.future;
  }

  Future<OnlineUsersSummeryReadDto> _getOnlineUsersSummery() {
    final completer = Completer<OnlineUsersSummeryReadDto>();
    _datasource.getOnlineUsers(
      onResponse: (final response) {
        if (response.result == null) return completer.completeError("response.result == null");
        completer.complete(response.result);
      },
      onError: (final errorResponse) {
        completer.completeError(errorResponse);
      },
    );
    return completer.future;
  }
}
