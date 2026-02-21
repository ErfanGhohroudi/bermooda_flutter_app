import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/services/permission_service.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../data/repositories/sms_panel_repository_imp.dart';
import '../../domain/entity/sms.dart';
import '../../domain/enums/enums.dart';
import '../../domain/usecases/sms_usecases/cancel_sending_sms.dart';
import '../../domain/usecases/sms_usecases/get_sms_list.dart';

class SmsListController extends GetxController {
  SmsListController({
    required this.departmentId,
  });

  final int departmentId;

  final SmsPanelRepositoryImpl _repository = SmsPanelRepositoryImpl();

  late final GetSmsListUseCase _getSmsListUseCase = GetSmsListUseCase(_repository);

  late final CancelSendingSmsUseCase _cancelSendingSmsUseCase = CancelSendingSmsUseCase(_repository);

  static const List<SMSStatus?> statuses = [null, ...SMSStatus.values];

  final TextEditingController searchCtrl = TextEditingController();
  final Rxn<SMSStatus> selectedStatus = Rxn<SMSStatus>(null);

  final RefreshController refreshController = RefreshController();
  final ScrollController scrollController = ScrollController();
  final Rx<bool> showScrollToTop = false.obs;
  final Rx<PageState> pageState = PageState.initial.obs;
  bool isEndOfList = false;
  int pageNumber = 1;

  final RxList<SmsEntity> smsList = <SmsEntity>[].obs;

  bool get haveAccess => Get.find<PermissionService>().haveSMSAccess;

  List<SMSStatus> get statusFiltersList => SMSStatus.values;

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
    smsList.close();
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
      final response = await _getSmsListUseCase(
        departmentId: departmentId,
        pageNumber: pageNumber,
        search: searchCtrl.text.trim().isNotEmpty ? searchCtrl.text.trim() : null,
        status: selectedStatus.value,
      );

      if (smsList.subject.isClosed) return;
      if (pageNumber == 1) {
        smsList.assignAll(response.resultList ?? []);
        refreshController.refreshCompleted();
      } else {
        smsList.addAll(response.resultList ?? []);
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
          final updatedItem = await _cancelSendingSmsUseCase(itemId);
          updateItem(updatedItem);
        } catch (e) {
          // Error
        }
      },
    );
  }

  void insertItem(final SmsEntity item) {
    smsList.add(item);
  }

  void updateItem(final SmsEntity item) {
    final index = smsList.indexWhere((final e) => e.id == item.id);
    if (index != -1) {
      smsList[index] = item;
    }
  }
}
