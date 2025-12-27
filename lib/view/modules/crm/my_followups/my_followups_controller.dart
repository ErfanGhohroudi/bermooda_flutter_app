import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../data/data.dart';
import 'enums/filter_enum.dart';

class MyFollowupsController extends GetxController {
  MyFollowupsController({required this.categoryId});

  late final String categoryId;
  final CustomerFollowUpDatasource _datasource = Get.find<CustomerFollowUpDatasource>();
  final RefreshController refreshController = RefreshController();
  final Rx<PageState> pageState = PageState.initial.obs;
  final TextEditingController searchCtrl = TextEditingController();
  final RxList<FollowUpReadDto> followups = <FollowUpReadDto>[].obs;
  final Rx<FollowUpFilterType> selectedFilter = FollowUpFilterType.values.first.obs;
  int pageNumber = 1;

  @override
  void onInit() {
    onRefresh();
    super.onInit();
  }

  @override
  void onClose() {
    refreshController.dispose();
    searchCtrl.dispose();
    super.onClose();
  }

  void setFilter(final FollowUpFilterType value) {
    if (selectedFilter.value == value) return;
    selectedFilter(value);
    pageState.loading();
    onRefresh();
  }

  void onSearch() {
    pageState.loading();
    pageNumber = 1;
    _getMyFollowups();
  }

  void onRefresh() {
    pageNumber = 1;
    _getMyFollowups();
  }

  void onLoadMore() {
    pageNumber++;
    _getMyFollowups();
  }

  void updateItem(final FollowUpReadDto model) {
    for (var i = 0; i < followups.length; i++) {
      if (followups[i].slug == model.slug) {
        followups[i] = model;
        break;
      }
    }
  }

  void insertItem(final FollowUpReadDto model) {
    followups.insert(0, model);
  }

  void removeItem(final FollowUpReadDto model) {
    followups.removeWhere((final e) => e.slug == model.slug);
  }

  void _getMyFollowups() {
    _datasource.getMyFollowups(
      categoryId: categoryId,
      pageNumber: pageNumber,
      filter: selectedFilter.value,
      query: searchCtrl.text.trim(),
      onResponse: (final response) {
        if (response.resultList == null) return;
        if (followups.subject.isClosed) return;
        if (pageNumber == 1) {
          followups.assignAll(response.resultList ?? []);
          refreshController.refreshCompleted();
        } else {
          followups.addAll(response.resultList ?? []);
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
      withRetry: pageNumber == 1 && followups.isEmpty,
    );
  }
}
