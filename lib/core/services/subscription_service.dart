import 'package:u/utilities.dart';

import '../../data/data.dart';
import '../core.dart';
import '../navigator/navigator.dart';
import '../utils/enums/enums.dart';

class SubscriptionService extends GetxService {
  SubscriptionService({required final Rx<WorkspaceReadDto> currentWorkspace}) : _currentWorkspace = currentWorkspace;

  final Rx<WorkspaceReadDto> _currentWorkspace;

  SubscriptionReadDto get subscription => _currentWorkspace.value.subscription ?? const SubscriptionReadDto(slug: '');

  SubscriptionStatus get status => subscription.status;

  bool get isExpired => subscription.isExpired;

  int get remainingDays => subscription.remainingDays;

  /// Subscription PurchaseType Helpers
  bool get isNoPurchased => subscription.isNoPurchase;

  bool get isPurchased => subscription.isPurchase;

  bool get isTrial => subscription.isTrial;

  bool get isPurchasedOrTrial => isTrial || isPurchased;

  void checkSubscription({required final VoidCallback action}) {
    if (isNoPurchased || isExpired) {
      AppNavigator.snackbarRed(
        title: s.error,
        subtitle: isNoPurchased ? s.noSubscriptionDialogDescription : s.expiredSubscriptionDialogDescription,
      );
      return;
    }
    action();
  }

  List<String> get activeModuleTypeNames {
    List<String> list = [];
    for (var sub in subscription.modules) {
      if (sub.type != null && sub.isActive) {
        list.add(sub.type!.name);
      }
    }
    return list;
  }

  /// For Access to Module
  bool get projectModuleIsActive => subscription.modules.projectBoardIsActive;

  bool get crmModuleIsActive => subscription.modules.crmIsActive;

  bool get hrModuleIsActive => subscription.modules.humanResourcesIsActive;

  bool get requestsModuleIsActive => subscription.modules.requestsIsActive;

  bool get groupChatModuleIsActive => subscription.modules.groupChatIsActive;

  bool get smsModuleIsActive => subscription.modules.smsIsActive;

  bool get cloudCallModuleIsActive => subscription.modules.cloudCallIsActive;

  bool get employmentModuleIsActive => subscription.modules.employmentIsActive;

  bool get marketingModuleIsActive => subscription.modules.marketingIsActive;

  bool get planningModuleIsActive => subscription.modules.planningIsActive;

  bool get lettersModuleIsActive => subscription.modules.lettersIsActive;

  bool get legalModuleIsActive => subscription.modules.legalIsActive;
}
