import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/loading/loading.dart';
import '../../../../core/services/subscription_service.dart';
import '../../../../core/utils/enums/request_enums.dart';
import '../../../../core/events/request_event_bus.dart';
import '../../../../data/data.dart';
import '../create/create_request_page.dart';
import '../entities/reviewer_entity.dart';

enum RequestListPageType { memberProfile, myRequests, myReviews, archive }

mixin RequestListController {
  final EmployeeRequestDatasource _datasource = Get.find<EmployeeRequestDatasource>();
  final SubscriptionService _subService = Get.find();
  final RefreshController refreshController = RefreshController();
  final Rx<PageState> pageState = PageState.loading.obs;
  final ScrollController scrollController = ScrollController();
  final Rx<bool> showScrollToTop = false.obs;
  final RxList<IRequestReadDto> requests = <IRequestReadDto>[].obs;
  int pageNumber = 1;
  bool _noMoreData = false;

  final Rx<StatusFilter> selectedFilter = StatusFilter.values.first.obs;

  late final RequestListPageType _pageType;
  late final int? _memberId;
  late final bool _showMyRequests;
  late final bool _showMyReviews;
  late final bool _showArchived;
  late final bool _withFilter;

  RequestListPageType get pageType => _pageType;

  bool get isAtEnd => _noMoreData;

  bool get showFilter => _pageType == RequestListPageType.memberProfile;

  bool get hrModuleIsActive => _subService.hrModuleIsActive;

  bool get showNewRequestFAB => _pageType == RequestListPageType.memberProfile || _pageType == RequestListPageType.myRequests;

  void initialController({
    required final RequestListPageType pageType,
    final int? memberId,
  }) {
    scrollController.addListener(scrollListener);
    _pageType = pageType;
    _memberId = memberId;
    _showMyRequests = (pageType == RequestListPageType.myRequests);
    _showMyReviews = (pageType == RequestListPageType.myReviews);
    _showArchived = (pageType == RequestListPageType.archive);
    _withFilter = (showFilter);
    pageNumber = 1;
    _getRequests();
  }

  /// ارسال رویداد به‌روزرسانی درخواست با بررسی وضعیت Event Bus
  void _emitRequestUpdated(final IRequestReadDto updatedRequest) {
    final eventBus = RequestEventBus();
    if (eventBus.isClosed) {
      eventBus.restart();
    }
    eventBus.emitRequestUpdated(updatedRequest);
  }

  void disposeItems() {
    scrollController.removeListener(scrollListener);
    refreshController.dispose();
    pageState.close();
    scrollController.dispose();
    showScrollToTop.close();
    requests.close();
    selectedFilter.close();
  }

  void scrollListener() {
    if (scrollController.offset > 300 && !showScrollToTop.value) {
      showScrollToTop(true);
    } else if (scrollController.offset <= 300 && showScrollToTop.value) {
      showScrollToTop(false);
    }
  }

  void switchFilter(final StatusFilter filter) {
    if (selectedFilter.value == filter) return;
    selectedFilter.value = filter;
    AppLoading.showLoading();
    refreshRequests();
  }

  void refreshRequests() {
    pageNumber = 1;
    _getRequests();
  }

  void loadMoreRequests() {
    pageNumber++;
    _getRequests();
  }

  void createRequest(final UserReadDto? requestingUser) {
    // Navigate to create request page
    UNavigator.push(
      CreateRequestPage(
        requestingUser: requestingUser,
        onResponse: (final request) {
          if (requests.subject.isClosed) return;
          requests.insert(0, request);
        },
      ),
    );
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
          // ارسال رویداد به‌روزرسانی به Event Bus
          _emitRequestUpdated(response.result!);
        }
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void onTapAddReviewers(final IRequestReadDto request) {
    final acceptorUsers = request.reviewerUsers.map((final e) => ReviewerEntity.from(e)).toList();
    _datasource.getDecidedUsers(
      memberId: _memberId,
      onResponse: (final response) {
        final availableReviewers = response.resultList?.map((final user) => ReviewerEntity(user: user)).toList();

        showReviewerSelectionBottomSheet(
          selectedReviewers: acceptorUsers,
          availableReviewers: availableReviewers ?? [],
          title: s.addReviewers,
          subtitle: s.selectReviewersInfoText,
          helperText: s.selectReviewersHelperText,
          onSelectionChanged: (final selectedUsers) => _addAcceptorUsers(request, selectedUsers),
        );
      },
      onError: (final errorResponse) {},
    );
  }

  void _addAcceptorUsers(
    final IRequestReadDto request,
    final List<ReviewerEntity> reviewerList,
  ) {
    _datasource.addAcceptorUsers(
      slug: request.slug ?? '',
      reviewerList: reviewerList,
      onResponse: (final response) {
        if (response.result == null) return;
        if (requests.subject.isClosed) return;
        final i = requests.indexWhere((final e) => e.slug == request.slug);
        if (i == -1 || requests.subject.isClosed) return;
        requests[i] = response.result!;
        // ارسال رویداد به‌روزرسانی به Event Bus
        _emitRequestUpdated(response.result!);
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void _getRequests() {
    _datasource.getAllRequest(
      pageType: _pageType,
      pageNumber: pageNumber,
      memberId: _memberId,
      myRequests: _showMyRequests,
      myReviews: _showMyReviews,
      isArchive: _showArchived,
      filter: _withFilter ? selectedFilter.value : null,
      onResponse: (final response) {
        AppLoading.dismissLoading();
        if (response.resultList == null) return;
        if (requests.subject.isClosed) return;
        if (pageNumber == 1) {
          requests(response.resultList);
          refreshController.refreshCompleted();
        } else {
          requests.addAll(response.resultList!);
        }

        if (response.extra?.next == null) {
          refreshController.loadNoData();
          _noMoreData = true;
        } else {
          refreshController.loadComplete();
          _noMoreData = false;
        }

        pageState.loaded();
      },
      onError: (final errorResponse) {
        AppLoading.dismissLoading();
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
