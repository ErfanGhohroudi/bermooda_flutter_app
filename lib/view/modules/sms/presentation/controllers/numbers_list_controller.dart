import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/services/permission_service.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../data/repositories/sms_panel_repository_imp.dart';
import '../../domain/entity/sms_panel_number.dart';
import '../../domain/enums/enums.dart';
import '../../domain/usecases/sms_usecases/create_number.dart';
import '../../domain/usecases/sms_usecases/delete_number.dart';
import '../../domain/usecases/sms_usecases/get_numbers_by_department.dart';

class SmsNumbersListController extends GetxController {
  SmsNumbersListController({
    required this.departmentId,
  });

  final int departmentId;

  final SmsPanelRepositoryImpl _repository = SmsPanelRepositoryImpl();

  late final GetNumbersByDepartmentUseCase _getNumbersByDepartmentUseCase = GetNumbersByDepartmentUseCase(_repository);
  late final CreateNumberUseCase _createNumberUseCase = CreateNumberUseCase(_repository);
  late final DeleteNumberUseCase _deleteNumberUseCase = DeleteNumberUseCase(_repository);

  final RefreshController refreshController = RefreshController();
  final ScrollController scrollController = ScrollController();
  final Rx<bool> showScrollToTop = false.obs;
  final Rx<PageState> pageState = PageState.initial.obs;
  bool isEndOfList = false;
  int pageNumber = 1;
  final RxList<SmsPanelNumber> numbers = <SmsPanelNumber>[].obs;

  bool get haveAdminAccess => Get.find<PermissionService>().haveSMSAdminAccess;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    _getDepartments();
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    refreshController.dispose();
    pageState.close();
    numbers.close();
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

  void onRefresh() {
    pageNumber = 1;
    _getDepartments();
  }

  void loadMore() {
    pageNumber++;
    _getDepartments();
  }

  Future<void> _getDepartments() async {
    try {
      final response = await _getNumbersByDepartmentUseCase(
        departmentId: departmentId,
        pageNumber: pageNumber,
      );

      if (numbers.subject.isClosed) return;
      if (pageNumber == 1) {
        numbers.assignAll(response.resultList ?? []);
        refreshController.refreshCompleted();
      } else {
        numbers.addAll(response.resultList ?? []);
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

  Future<SmsPanelNumber?> createNumber({
    required final String number,
    required final String providerName,
    required final ProviderType providerType,
    required final String apiKey,
  }) async {
    try {
      final SmsPanelNumber smsNumber = await _createNumberUseCase(
        departmentId: departmentId,
        number: number,
        providerName: providerName,
        providerType: providerType,
        apiKey: apiKey,
      );
      insertNumber(smsNumber);
      return smsNumber;
    } catch (e) {
      return null;
    }
  }

  void deleteNumber(final SmsPanelNumber number) {
    appShowYesCancelDialog(
      title: s.delete,
      description: s.areYouSureYouWantToDeleteItem(s.number.toLowerCase()),
      yesButtonTitle: s.delete,
      yesBackgroundColor: AppColors.red,
      onYesButtonTap: () async {
        AppNavigator.back();
        try {
          await _deleteNumberUseCase(number.id);
          final index = numbers.indexOf(number);
          if (index == -1) return;
          numbers.removeAt(index);
          numbers.refresh();
        } catch (e) {
          AppSnackBar.snackbarRed(title: s.error, subtitle: '');
        }
      },
    );
  }

  void insertNumber(final SmsPanelNumber newNumber) {
    numbers.add(newNumber);
  }
}
