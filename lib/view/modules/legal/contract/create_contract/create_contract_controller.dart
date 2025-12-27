import 'package:u/utilities.dart';

import '../../../../../core/constants.dart';
import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/utils/extensions/file_extensions.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../data/data.dart';
import '../contract_controller.dart';
import '../create_update_signer_or_party/create_update_signer_or_party_page.dart';

mixin CreateContractController {
  late final ContractController ctrl;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxBool isSaving = false.obs;
  static const List<String> allowedExtensions = ['pdf'];
  bool isUploading = false;

  late ContractParams params;
  final TextEditingController titleCtrl = TextEditingController();
  final Rxn<MainFileReadDto> selectedFile = Rxn(null);

  void initialController() {
    ctrl = Get.find<ContractController>();
    params = ContractParams(legalCaseId: ctrl.legalCaseId);
    titleCtrl.addListener(_updateTitleListener);
  }

  void disposeItems() {
    titleCtrl.removeListener(_updateTitleListener);
    isSaving.close();
    titleCtrl.dispose();
    selectedFile.close();
  }

  void _updateTitleListener() {
    params = params.copyWith(title: titleCtrl.text);
  }

  Future<void> pickFile() async {
    final maxFileSizeInBytes = AppConstants.maxFileSizeLimitInMB.convertSizeFromMBToByte;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      dialogTitle: s.onlyPDFFilesAllowed,
      allowedExtensions: allowedExtensions,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    final ext = (file.extension ?? '').toLowerCase();

    if (!allowedExtensions.contains(ext)) {
      AppNavigator.snackbarRed(title: s.error, subtitle: s.onlyPDFFilesAllowed);
      return;
    }

    if (file.size > maxFileSizeInBytes) {
      AppNavigator.snackbarRed(
        title: s.error,
        subtitle:
            "${s.fileSizeExceedsTheAllowedLimit} "
            "(${s.maximum} ${maxFileSizeInBytes.convertSizeFromByteToMB.floor()} MB)",
      );
      return;
    }

    selectedFile.value = MainFileReadDto(
      url: file.path,
      fileName: file.name,
      originalName: file.name,
    );
  }

  Future<void> addOrEditSignatoryOrParty({
    final SignerDto? model,
    required final Function(SignerDto model) action,
  }) async {
    final result = await bottomSheet<SignerDto>(
      title: switch (params.type) {
        ContractType.contract => model == null ? s.newSignatory : s.editSignatory,
        ContractType.legalCase => model == null ? s.newParty : s.editParty,
      },
      child: CreateUpdateSignerOrPartyPage(model: model),
    );

    if (result != null) {
      action(result);
    }
  }

  void onSubmit() async {
    validateForm(
      key: formKey,
      action: () {
        if (isUploading) {
          AppNavigator.snackbarRed(title: s.error, subtitle: s.uploading);
          return;
        }
        if (selectedFile.value?.fileId == null) {
          AppNavigator.snackbarRed(
            title: s.error,
            subtitle: "${s.requiredField}: ${s.file}",
          );
          return;
        }
        if (params.members.isEmpty) {
          AppNavigator.snackbarRed(
            title: s.error,
            subtitle: "${s.requiredField}: ${switch (params.type) {
              ContractType.contract => s.signatories,
              ContractType.legalCase => s.parties,
            }}",
          );
          return;
        }
        _createContract();
      },
    );
  }

  void _createContract() {
    if (selectedFile.value?.fileId == null) return;
    isSaving(true);
    ctrl.createContract(
      params,
      onSuccess: () {
        isSaving(false);
        UNavigator.back();
      },
      onFailure: () => isSaving(false),
    );
  }
}
