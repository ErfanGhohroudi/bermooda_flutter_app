import 'package:u/utilities.dart';

import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../core/services/permission_service.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/core.dart';
import '../../../../../../data/data.dart';
import '../../../widgets/customer_state/change_customer_state_page.dart';

mixin CustomerCardController {
  final Rx<CustomerReadDto> customer = const CustomerReadDto().obs;
  final ScrollController scrollController = ScrollController();
  final PermissionService _perService = Get.find();

  bool get haveAdminAccess => _perService.haveCRMAdminAccess;

  void onTapCheckBox({
    required final Function(CustomerReadDto customer) onSubmitted,
  }) {
    if (!customer.value.isFollowed && haveAdminAccess) {
      showAppDialog(
        AlertDialog(
          content: ChangeCustomerStatePage(
            customer: customer.value,
            onSubmitted: (final model) {
              customer(model);
              onSubmitted(model);
            },
          ),
        ),
      );
    } else {
      AppNavigator.snackbarRed(title: s.warning, subtitle: s.notAllowChangeStatus);
    }
  }
}
