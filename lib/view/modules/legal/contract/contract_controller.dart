import 'package:bermooda_business/core/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../core/core.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../data/data.dart';
import '../../reports/controllers/legal/legal_case_reports_controller.dart';
import 'create_contract/create_contract_page.dart';

class ContractController extends GetxController {
  final int legalCaseId;
  final bool _canEdit;

  ContractController({
    required this.legalCaseId,
    required final bool canEdit,
  }) : _canEdit = canEdit;

  final ContractDatasource _datasource = Get.find();
  final PermissionService _perService = Get.find();
  final Rxn<ContractReadDto> contract = Rxn(null);
  final Rx<PageState> pageState = PageState.loading.obs;
  final RefreshController refreshController = RefreshController();

  bool get haveAccess => _canEdit && _perService.haveLegalAccess;

  /// if have access and any of signers, not signed, then can delete
  bool get canDelete => haveAccess && contract.value != null && contract.value!.hasAnySignerSigned == false;

  @override
  void onInit() {
    _getContract();
    super.onInit();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  void onTryAgain() {
    pageState.loading();
    _getContract();
  }

  void onRefresh() {
    _getContract();
  }

  void navigateToCreateContractPage() {
    UNavigator.push(const CreateContractPage());
  }

  void createContract(
    final ContractParams params, {
    required final VoidCallback onSuccess,
    required final VoidCallback onFailure,
  }) {
    _datasource.create(
      dto: params,
      onResponse: () {
        onSuccess();

        // refresh page
        onTryAgain();

        // refresh history page
        if (Get.isRegistered<LegalCaseReportsController>()) {
          Get.find<LegalCaseReportsController>().onInit();
        }
      },
      onError: (final errorResponse) => onFailure(),
    );
  }

  void deleteContract() {
    if (contract.value == null || canDelete == false) return;
    appShowYesCancelDialog(
      description: s.areYouSureYouWantToDeleteItem,
      onYesButtonTap: () {
        UNavigator.back();
        _datasource.delete(
          contractId: contract.value!.id,
          onResponse: () {
            contract.value = null;
            pageState.loaded();
          },
          onError: (final errorResponse) {},
        );
      },
    );
  }

  void _getContract() {
    _datasource.getContract(
      caseId: legalCaseId,
      onResponse: (final response) {
        contract.value = response;
        refreshController.refreshCompleted();
        pageState.loaded();
      },
      onError: (final errorResponse) {
        pageState.error();
        refreshController.refreshFailed();
      },
    );
  }
}
