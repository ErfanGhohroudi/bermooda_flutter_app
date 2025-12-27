import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/data.dart';

mixin ChangeCustomerStateController {
  final CustomerDatasource _customerDatasource = Get.find<CustomerDatasource>();
  late final CustomerReadDto customer;

  void changeCustomerStatus(final CustomerStatus customerStatus, {required final Function(CustomerReadDto customer) onResponse}) {
    _customerDatasource.changeCustomerStatus(
      customerId: customer.id,
      dto: CustomerStatusParams(
        customerStatus: customerStatus,
      ),
      onResponse: (final response) {
        onResponse(response.result!);
        UNavigator.back();
        delay(100, () {
          AppNavigator.snackbarGreen(
            title: s.done,
            subtitle: s.customerAddedToArchiveList,
          );
        });
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }
}
