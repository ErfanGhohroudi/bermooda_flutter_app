import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../core/services/permission_service.dart';
import '../../../../../core/theme.dart';
import '../../../../../data/data.dart';

class CustomerInfoController extends GetxController {
  CustomerInfoController({required this.customerId});

  final int? customerId;
  final Rx<CustomerReadDto> customer = const CustomerReadDto().obs;
  final core = Get.find<Core>();
  final _perService = Get.find<PermissionService>();
  final CustomerDatasource _datasource = Get.find<CustomerDatasource>();
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

  void delete({
    required final VoidCallback action,
  }) {
    appShowYesCancelDialog(
      title: s.delete,
      description: s.areYouSureToDeleteCustomer,
      yesButtonTitle: s.delete,
      yesBackgroundColor: AppColors.red,
      onYesButtonTap: () {
        UNavigator.back();
        _datasource.delete(
          id: customer.value.id!,
          onResponse: action,
          onError: (final errorResponse) {},
          withRetry: true,
        );
      },
    );
  }
}
