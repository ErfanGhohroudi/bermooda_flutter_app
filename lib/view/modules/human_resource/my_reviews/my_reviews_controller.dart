import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../core/loading/loading.dart';
import '../../../../core/utils/enums/request_enums.dart';
import '../../../../data/data.dart';

mixin MyReviewsController {
  late final HRDepartmentReadDto _department;
  final EmployeeRequestDatasource _datasource = Get.find<EmployeeRequestDatasource>();
  final RefreshController refreshController = RefreshController();
  final Rx<PageState> pageState = PageState.initial.obs;
  final RxList<IRequestReadDto> requests = <IRequestReadDto>[].obs;
  final TextEditingController searchCtrl = TextEditingController();

  int pageNumber = 1;

  void disposeItems() {
    pageState.close();
    requests.close();
    searchCtrl.dispose();
  }

  void initialController(final HRDepartmentReadDto department) {
    _department = department;
    refreshListData();
  }

  void onSearch() {
    pageState.loading();
    refreshListData();
  }

  void refreshListData() {
    pageNumber = 1;
    _getMyReviews();
  }

  void loadMoreListData() {
    pageNumber++;
    _getMyReviews();
  }

  void callChangeStatus(final IRequestReadDto request, final StatusType status) {
    if (request.slug == null) return;
    _datasource.changeRequestStatus(
      slug: request.slug!,
      status: status,
      onResponse: (final response) {
        if (response.result == null) return;
        if (requests.subject.isClosed) return;
        final requestIndex = requests.indexWhere((final e) => e.slug == request.slug);
        if (requestIndex != -1) {
          if (requests.subject.isClosed) return;
          requests[requestIndex] = response.result!;
        }
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void _getMyReviews() {
    _datasource.getMyReviews(
      slug: _department.slug,
      pageNumber: pageNumber,
      query: searchCtrl.text.trim().isNotEmpty ? searchCtrl.text.trim() : null,
      onResponse: (final response) {
        AppLoading.dismissLoading();
        if (response.resultList == null) return;
        if (requests.subject.isClosed) return;

        if (pageNumber == 1) {
          requests.assignAll(response.resultList!);
          refreshController.refreshCompleted();
        } else {
          requests.addAll(response.resultList!);
        }

        if (response.extra?.next == null) {
          refreshController.loadNoData();
        } else {
          refreshController.loadComplete();
        }

        pageState.loaded();
      },
      onError: (final errorResponse) {
        if (pageNumber == 1) {
          refreshController.refreshFailed();
        } else {
          refreshController.loadFailed();
        }
      },
      withRetry: pageNumber == 1 && requests.isEmpty,
    );
  }
}
