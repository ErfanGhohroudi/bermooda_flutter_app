import 'package:u/utilities.dart';

import '../../../../../core/functions/date_picker_functions.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../core/services/permission_service.dart';
import '../../../../../core/theme.dart';
import '../../../../../data/data.dart';
import '../../../reports/controllers/crm/crm_customer_reports_controller.dart';
import '../../my_followups/my_followups_controller.dart';

class CustomerInfoController extends GetxController {
  CustomerInfoController({required this.customerId});

  final int? customerId;
  final Rx<CustomerReadDto> customer = const CustomerReadDto().obs;
  final core = Get.find<Core>();
  final _perService = Get.find<PermissionService>();
  final CustomerDatasource _datasource = Get.find<CustomerDatasource>();
  final CustomerFollowUpDatasource _followUpDatasource = Get.find<CustomerFollowUpDatasource>();
  final Rx<PageState> pageState = PageState.initial.obs;

  bool get haveAccess => _perService.haveCRMAccess;

  @override
  void onInit() {
    getCustomer();
    super.onInit();
  }

  @override
  void onClose() {
    customer.close();
    pageState.close();
    super.onClose();
  }

  void _reloadHistory() {
    if (Get.isRegistered<CrmCustomerReportsController>()) {
      Get.find<CrmCustomerReportsController>().onInit();
    }
  }

  void _insertAtMyFollowUps(final FollowUpReadDto model) {
    if (model.assignedUser?.id != core.userReadDto.value.id) return;
    if (Get.isRegistered<MyFollowupsController>()) {
      Get.find<MyFollowupsController>().insertItem(model);
    }
  }

  void getCustomer() {
    if (customerId == null) return;

    pageState.loading();
    _datasource.getCustomer(
      customerId: customerId,
      onResponse: (final response) {
        if (customer.subject.isClosed) return;
        customer(response.result);
        pageState.loaded();
      },
      onError: (final errorResponse) {
        pageState.error();
      },
    );
  }

  void sortFollowUpList() {
    final updatedList = List<FollowUpReadDto>.from(customer.value.followUps);

    updatedList.sort((final a, final b) {
      final aDate = a.date?.formatCompactDate().numericOnly().toInt();
      final bDate = b.date?.formatCompactDate().numericOnly().toInt();
      if (bDate == null) return -1;
      if (aDate == null) return 1;
      return aDate.compareTo(bDate);
    });

    customer.update((val) {
      val = val?.copyWith(followUps: updatedList);
    });
  }

  Future<void> createFollowUp({required final Function(CustomerReadDto) action}) async {
    final date = await DateAndTimeFunctions.showCustomPersianDatePicker(startDate: Jalali.now());
    if (date != null) {
      _followUpDatasource.create(
        sourceId: customer.value.id,
        date: date.formatCompactDate(),
        onResponse: (final GenericResponse<FollowUpReadDto> response) {
          if (customer.subject.isClosed) return;
          if (response.result != null) {
            customer.value.followUps.add(response.result!);
            sortFollowUpList();
            action(customer.value);
            _insertAtMyFollowUps(response.result!);
          }
          _reloadHistory();
        },
        onError: (final errorResponse) {},
        withRetry: true,
      );
    }
  }

  void delete({
    required final CustomerReadDto customer,
    required final VoidCallback action,
  }) {
    appShowYesCancelDialog(
      title: s.delete,
      description: s.areYouSureToDeleteCustomer,
      yesButtonTitle: s.delete,
      yesBackgroundColor: AppColors.red,
      onYesButtonTap: () {
        UNavigator.back();
        _delete(customer: customer, action: action);
      },
    );
  }

  void _delete({
    required final CustomerReadDto customer,
    required final VoidCallback action,
  }) {
    _datasource.delete(
      id: customer.id!,
      onResponse: action,
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }
}
