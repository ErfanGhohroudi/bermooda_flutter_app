import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/services/permission_service.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../data/repositories/sms_panel_repository_imp.dart';
import '../../domain/entity/group_sms.dart';
import '../../domain/enums/enums.dart';
import '../../domain/usecases/sms_usecases/cancel_sending_group_sms.dart';
import '../../domain/usecases/sms_usecases/get_group_sms_list.dart';

class GroupSmsListController extends GetxController {
  GroupSmsListController({
    required this.departmentId,
  });

  final int departmentId;

  final SmsPanelRepositoryImpl _repository = SmsPanelRepositoryImpl();

  late final GetGroupSmsListUseCase _getGroupSmsListUseCase = GetGroupSmsListUseCase(_repository);

  late final CancelSendingGroupSmsUseCase _cancelSendingGroupSmsUseCase = CancelSendingGroupSmsUseCase(_repository);

  static const List<GroupSMSStatus?> statuses = [null, ...GroupSMSStatus.values];

  final TextEditingController searchCtrl = TextEditingController();
  final Rxn<GroupSMSStatus> selectedStatus = Rxn<GroupSMSStatus>(null);

  final RefreshController refreshController = RefreshController();
  final ScrollController scrollController = ScrollController();
  final Rx<bool> showScrollToTop = false.obs;
  final Rx<PageState> pageState = PageState.initial.obs;
  bool isEndOfList = false;
  int pageNumber = 1;

  final RxList<GroupSmsEntity> groupSmsList = <GroupSmsEntity>[].obs;

  bool get haveAccess => Get.find<PermissionService>().haveSMSAccess;

  List<GroupSMSStatus> get statusFiltersList => GroupSMSStatus.values;

  bool get isFilterActive => selectedStatus.value != null;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    _getList();
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    searchCtrl.dispose();
    refreshController.dispose();
    pageState.close();
    groupSmsList.close();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.offset > 350 && !showScrollToTop.value) {
      showScrollToTop(true);
    } else if (scrollController.offset <= 350 && showScrollToTop.value) {
      showScrollToTop(false);
    }
  }

  void onTryAgain() {
    pageState.initial();
    onRefresh();
  }

  void onSearch() {
    pageState.initial();
    onRefresh();
  }

  void onApplyFilter() {
    AppNavigator.back();
    onSearch();
  }

  void onClearFilter() {
    selectedStatus.value = null;
    AppNavigator.back();
    onSearch();
  }

  void onRefresh() {
    pageNumber = 1;
    _getList();
  }

  void loadMore() {
    pageNumber++;
    _getList();
  }

  Future<void> _getList() async {
    try {
      final response = await _getGroupSmsListUseCase(
        departmentId: departmentId,
        pageNumber: pageNumber,
        search: searchCtrl.text.trim().isNotEmpty ? searchCtrl.text.trim() : null,
        status: selectedStatus.value,
      );

      if (groupSmsList.subject.isClosed) return;
      if (pageNumber == 1) {
        groupSmsList.assignAll(response.resultList ?? []);
        refreshController.refreshCompleted();
      } else {
        groupSmsList.addAll(response.resultList ?? []);
      }

      if (response.extra?.next == null || (response.resultList?.isEmpty ?? true)) {
        refreshController.loadNoData();
        isEndOfList = true;
      } else {
        refreshController.loadComplete();
        isEndOfList = false;
      }

      pageState.loaded();
    } catch (e) {
      if (pageState.isInitial()) {
        pageState.error();
      }
      if (pageNumber == 1) {
        refreshController.refreshFailed();
      } else {
        refreshController.loadFailed();
      }
    }
  }

  void cancelSend(final int itemId) {
    appShowYesCancelDialog(
      title: s.cancelSend,
      description: 'description',
      yesBackgroundColor: AppColors.red,
      onYesButtonTap: () async {
        AppNavigator.back();
        try {
          final updatedItem = await _cancelSendingGroupSmsUseCase(itemId);
          updateItem(updatedItem);
        } catch (e) {
          // Error
        }
      },
    );
  }

  void insertItem(final GroupSmsEntity item) {
    groupSmsList.insert(0, item);
  }

  void updateItem(final GroupSmsEntity item) {
    final index = groupSmsList.indexWhere((final e) => e.id == item.id);
    if (index != -1) {
      groupSmsList[index] = item;
    }
  }
}
