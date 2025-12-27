import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../../data/data.dart';

mixin LettersListController {
  final MailDatasource _datasource = Get.find<MailDatasource>();
  final RefreshController refreshController = RefreshController();
  final Rx<PageState> pageState = PageState.initial.obs;
  final ScrollController scrollController = ScrollController();
  final Rx<bool> showScrollToTop = false.obs;
  final TextEditingController searchCtrl = TextEditingController();
  int pageNumber = 1;
  bool isNoMoreData = false;

  final RxList<LetterReadDto> letters = <LetterReadDto>[].obs;

  void disposeItems() {
    scrollController.removeListener(_scrollListener);
    refreshController.dispose();
    pageState.close();
    scrollController.dispose();
    showScrollToTop.close();
    searchCtrl.dispose();
    letters.close();
  }

  void initialController() {
    scrollController.addListener(_scrollListener);
    onRefresh();
  }

  void _scrollListener() {
    if (scrollController.offset > 300 && !showScrollToTop.value) {
      showScrollToTop(true);
    } else if (scrollController.offset <= 300 && showScrollToTop.value) {
      showScrollToTop(false);
    }
  }

  void onRefreshWithLoading() {
    pageState.initial();
    onRefresh();
  }

  void onRefresh() {
    pageNumber = 1;
    _getAllLetters();
  }

  void loadMore() {
    pageNumber++;
    _getAllLetters();
  }

  void _getAllLetters() {
    _datasource.getAllLetters(
      pageNumber: pageNumber,
      onResponse: (final response) {
        // if (response.resultList == null) return;
        if (letters.subject.isClosed) return;
        if (pageNumber == 1) {
          letters(response);
          refreshController.refreshCompleted();
        } else {
          letters.addAll(response);
        }

        if (response.isEmpty) {
          refreshController.loadNoData();
          isNoMoreData = true;
        } else {
          refreshController.loadComplete();
          isNoMoreData = false;
        }

        pageState.loaded();
      },
      onError: (final errorResponse) {
        if (pageState.isInitial()) {
          pageState.error();
          return;
        }

        if (pageNumber == 1) {
          refreshController.refreshFailed();
        } else {
          refreshController.loadFailed();
        }
      },
      withRetry: pageNumber == 1 && letters.isEmpty,
    );
  }
}
