import 'package:u/utilities.dart';

import '../../../core/widgets/widgets.dart';
import '../../../core/core.dart';
import '../../../core/navigator/navigator.dart';
import '../../../core/services/vpn_listener_service.dart';
import '../../../core/utils/enums/enums.dart';
import '../../../data/data.dart';
import '../payment/payment_receipt/payment_receipt_page.dart';
import '../payment/payment_page.dart';
import '../workspace/authentication/authentication_page.dart';
import 'enums/discount_code_state.dart';
import 'enums/max_contract_count.dart';

class SubscriptionController extends GetxController {
  SubscriptionController({
    required this.workspaceId,
  });

  late final String workspaceId;

  final SubscriptionDatasource _subscriptionDatasource = Get.find<SubscriptionDatasource>();
  final core = Get.find<Core>();
  int minUser = 10;
  final maxUser = 500;
  int minStorage = 5;
  final maxStorage = 500;
  MaxContractCount minContract = MaxContractCount.values.first;

  final Rx<UniqueKey> maxContractDropdownUniqueKey = UniqueKey().obs;
  final Rx<PageState> pageState = PageState.initial.obs;
  final Rx<SubscriptionReadDto> subscription = const SubscriptionReadDto(slug: '').obs;
  final RxList<ModuleReadDto> availableModules = <ModuleReadDto>[].obs;
  final Rxn<SubscriptionPriceReadDto?> priceCalculation = Rxn<SubscriptionPriceReadDto?>(null);

  // Form controllers
  final RxList<ModuleReadDto> selectedModules = <ModuleReadDto>[].obs;
  final RxInt selectedUserCount = 5.obs;
  final RxInt selectedStorage = 5.obs;
  final Rx<SubscriptionPeriod> selectedPeriod = SubscriptionPeriod.twelveMonths.obs;
  final Rx<MaxContractCount> selectedMaxContractCount = MaxContractCount.values.first.obs;

  // Discount Code variables
  final TextEditingController discountCodeCtrl = TextEditingController();
  final Rx<DiscountCodeState> discountCodeFieldState = DiscountCodeState.empty.obs;
  String discountCode = '';

  final bool showBankAccountInfo = false;
  final Rxn<BankAccountInfoReadDto?> bermoodaBankAccountInfo = Rxn<BankAccountInfoReadDto?>(null);

  bool get isLegalModuleSelected => selectedModules.any((final module) => module.type == ModuleType.legal);

  @override
  void onInit() {
    getBankAccountInfo();
    getSubscriptionInfo();
    super.onInit();
  }

  @override
  void onClose() {
    discountCodeCtrl.dispose();
    debugPrint("SubscriptionController closed!!!");
    super.onClose();
  }

  //-------------------------------------------
  // Discount Code Methods
  //-------------------------------------------

  void onDiscountCodeChanged(final String value) {
    if (value.isEmpty) {
      discountCodeFieldState.empty();
    } else {
      discountCodeFieldState.notEmpty();
    }
  }

  void onDiscountCodeApply() {
    if (discountCodeFieldState.isEmpty) return;
    discountCode = discountCodeCtrl.text;
    discountCodeFieldState.applying();
    calculatePrice();
  }

  void changeDiscountCodeStateToApplied() {
    if (discountCodeFieldState.isApplying && discountCode.isNotEmpty) {
      if (priceCalculation.value?.hasDiscountCodeExist ?? false) {
        discountCodeFieldState.applied();
      } else {
        discountCodeFieldState.invalid();
      }
    }
  }

  void onDiscountCodeRemove() {
    discountCodeCtrl.clear();
    discountCode = '';
    if (discountCodeFieldState.isInvalid || discountCodeFieldState.isEmpty || discountCodeFieldState.isApplying) {
      onDiscountCodeChanged(discountCode);
      return;
    }
    onDiscountCodeChanged(discountCode);
    calculatePrice();
  }

  //-------------------------------------------
  //-------------------------------------------
  //-------------------------------------------

  void getBankAccountInfo() {
    if (showBankAccountInfo) {
      _subscriptionDatasource.getBankInfo(
        onResponse: (final response) {
          bermoodaBankAccountInfo(response.result);
        },
        onError: (final errorResponse) {},
      );
    }
  }

  void getSubscriptionInfo() {
    pageState.loading();

    _subscriptionDatasource.getCurrentSubscription(
      workspaceId: workspaceId,
      onResponse: (final response) {
        if (subscription.subject.isClosed || response.result == null) return;
        subscription(response.result);
        selectedPeriod(subscription.value.period);
        selectedUserCount(subscription.value.userCount >= minUser ? subscription.value.userCount : minUser);
        selectedStorage(subscription.value.storage >= minStorage ? subscription.value.storage : minStorage);
        selectedMaxContractCount(
          subscription.value.maxOnlineContract.count >= minContract.count ? subscription.value.maxOnlineContract : minContract,
        );
        minUser = selectedUserCount.value;
        minStorage = selectedStorage.value;
        minContract = selectedMaxContractCount.value;
        selectedModules.assignAll(subscription.value.modules);
        if (selectedModules.isNotEmpty) calculatePrice();
        pageState.loaded();
      },
      onError: (final errorResponse) {},
    );
  }

  void getAvailableModules() {
    _subscriptionDatasource.getAvailableModules(
      workspaceId: workspaceId,
      onResponse: (final response) {
        if (availableModules.subject.isClosed || response.resultList == null) return;
        availableModules.assignAll(response.resultList!);
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void calculatePrice({final bool goToBank = false, final VoidCallback? action}) {
    if (selectedModules.isEmpty) {
      showEmptyModulesSnackBar();
      priceCalculation.value = null;
      priceCalculation.refresh();
      return;
    }

    _subscriptionDatasource.calculateSubscriptionPrice(
      workspaceId: workspaceId,
      period: selectedPeriod.value,
      modules: selectedModules,
      usersCount: selectedUserCount.value,
      storage: selectedStorage.value,
      maxContractCount: isLegalModuleSelected ? selectedMaxContractCount.value.count : null,
      discountCode: discountCode,
      goToBank: goToBank,
      onResponse: (final response) {
        final SubscriptionPriceReadDto? calculation = response.result;
        priceCalculation.value = calculation;
        changeDiscountCodeStateToApplied();
        priceCalculation.refresh();
        action?.call();
      },
      onError: (final errorResponse) {
        priceCalculation.value = null;
        priceCalculation.refresh();
      },
      withRetry: true,
    );
  }

  void createPaymentRequest() {
    if (selectedModules.isEmpty) {
      showEmptyModulesSnackBar();
      return;
    }

    calculatePrice(
      goToBank: true,
      action: _navigateToPaymentPage,
    );
  }

  void toggleModule(final ModuleReadDto module) {
    if (selectedModules.contains(module)) {
      selectedModules.remove(module);
    } else {
      selectedModules.add(module);
    }
    // refresh available modules list
    availableModules.refresh();
    // Recalculate price when modules change
    if (selectedModules.isNotEmpty) {
      calculatePrice();
    } else {
      priceCalculation.value = null;
      priceCalculation.refresh();
    }
  }

  void updateUserCount(final int count, {final bool withCalculation = true}) {
    if (count < minUser || count > maxUser) return;
    selectedUserCount(count);
    if (selectedModules.isNotEmpty) {
      if (withCalculation) calculatePrice();
    } else {
      priceCalculation.value = null;
      priceCalculation.refresh();
    }
  }

  void updateStorage(final int storage, {final bool withCalculation = true}) {
    if (storage < minStorage || storage > maxStorage) return;
    selectedStorage(storage);
    if (selectedModules.isNotEmpty) {
      if (withCalculation) calculatePrice();
    } else {
      priceCalculation.value = null;
      priceCalculation.refresh();
    }
  }

  void updateMaxContractCount(final MaxContractCount count) {
    if (count.count < minContract.count) return _resetMaxContractDropdownKey(); // for rebuild dropdown
    if (selectedMaxContractCount.value == count) return _resetMaxContractDropdownKey();
    selectedMaxContractCount(count);
    if (selectedModules.isNotEmpty) {
      calculatePrice();
    } else {
      priceCalculation.value = null;
      priceCalculation.refresh();
    }
  }

  void _resetMaxContractDropdownKey() {
    maxContractDropdownUniqueKey.value = UniqueKey();
  }


  void updatePeriod(final SubscriptionPeriod period) {
    selectedPeriod(period);
    calculatePrice();
  }

  void showEmptyModulesSnackBar() {
    AppNavigator.snackbarRed(
      title: s.warning,
      subtitle: s.selectAtLeastOneModule,
    );
  }

  void _navigateToPaymentPage() {
    if (priceCalculation.value?.isWorkspaceInfoCompleted == false) {
      return delay(
        300,
        () => bottomSheet(
          child: AuthenticationPage(workspaceId: workspaceId),
        ),
      );
    }
    VpnListenerService().checkVPN(
      onIsNotActive: () {
        final zibalGatewayUrl = priceCalculation.value?.redirectUrl;
        if (zibalGatewayUrl == null) return;
        // UNavigator.push(PaymentReceiptPage(
        //   invoiceCode: 'MD_701097',
        //   status: PaymentReceiptStatus.success,
        // ));
        // return;
        UNavigator.push(
          PaymentPage(
            zibalGatewayUrl: zibalGatewayUrl,
            onPaymentSuccess: (final invoiceCode) {
              _navigateToInvoicePage(invoiceCode, PaymentReceiptStatus.success);
            },
            onPaymentError: (final invoiceCode) {
              _navigateToInvoicePage(invoiceCode, PaymentReceiptStatus.fail);
            },
            onPaymentCancel: () {},
          ),
        );
      },
      onIsActive: () {
        AppNavigator.snackbarRed(
          title: s.error,
          subtitle: s.turnOffVPNToEnterPaymentGateway,
        );
      },
    );
  }

  void _navigateToInvoicePage(final String invoiceCode, final PaymentReceiptStatus status) {
    UNavigator.off(PaymentReceiptPage(invoiceCode: invoiceCode, status: status));
  }
}
