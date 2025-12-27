import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../data/data.dart';
import '../customers_bank_controller.dart';
import 'dialog/upload_exel_dialog.dart';

class CustomerExelController extends GetxController {
  CustomerExelController({
    required this.categoryId,
  });

  late final String categoryId;
  final List<String> allowedExtensions = ['xlsx', 'xls', 'csv'];
  final int maxBytes = 10 * 1024 * 1024; // 10 MB
  final CustomerExelImportDatasource _datasource = Get.find<CustomerExelImportDatasource>();
  final RxBool buttonState = true.obs;

  final RxInt currentStep = 0.obs; // 0: Upload, 1: Mapping, 2: Preview, 3: Result
  final Rxn<PlatformFile?> selectedFile = Rxn(null);
  final Rxn<ExelUploadResultReadDto?> exelUploadResult = Rxn(null);
  ExelMappingResultReadDto? exelMappingResult;
  ExelResultReadDto? exelResult;

  bool get canBack => currentStep > 0;

  bool get isLastStep => currentStep.value == 3;

  void onBack() {
    if (canBack) {
      _previousStep();
    } else {
      UNavigator.back();
    }
  }

  void onNext() {
    if (currentStep.value == 0 && selectedFile.value != null) {
      /// Upload Step
      _uploadExel();
    } else if (currentStep.value == 1 && exelUploadResult.value != null) {
      /// Mapping Step
      _confirmExelMapping();
    } else if (currentStep.value == 2 && exelMappingResult != null) {
      /// Preview Step
      _executeImport();
    } else if (currentStep.value == 3) {
      UNavigator.back();
    }
  }

  void _firstStep() {
    currentStep.value = 0;
    currentStep.refresh();
    buttonState.refresh();
  }

  void _nextStep() {
    currentStep.value++;
    currentStep.refresh();
    buttonState.refresh();
  }

  void _previousStep() {
    appShowYesCancelDialog(
      description: s.backToPreviousStepDialogDescription,
      onYesButtonTap: () {
        UNavigator.back();
        currentStep.value--;
        currentStep.refresh();
        buttonState.refresh();
      },
    );
  }

  /// Upload Step API
  void _uploadExel() async {
    if (selectedFile.value == null) return;
    final result = await uploadExel(categoryId: categoryId, file: selectedFile.value!);
    exelUploadResult.value = result;
    if (exelUploadResult.value != null) {
      _nextStep();
    }
  }

  /// Mapping Step API
  void _confirmExelMapping() {
    if (exelUploadResult.value == null) return;
    _datasource.confirmMapping(
      tempFileId: exelUploadResult.value?.tempFileId,
      exelColumns: exelUploadResult.value?.columns ?? [],
      onResponse: (final response) {
        if (response.result == null) return;
        exelMappingResult = response.result;
        if (exelMappingResult != null) {
          _nextStep();
        }
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  /// Preview Step API
  void _executeImport() {
    if (exelMappingResult == null) return;
    _datasource.executeImport(
      tempFileId: exelUploadResult.value?.tempFileId,
      categoryId: categoryId,
      exelColumns: exelUploadResult.value?.columns ?? [],
      onResponse: (final response) {
        if (Get.isRegistered<CustomersBankController>()) {
          Get.find<CustomersBankController>().onSearch();
        }
        if (response.result == null) return;
        exelResult = response.result;
        if (exelResult != null) {
          _nextStep();
        }
      },
      onError: (final response, final errorResponse) {
        if (response.statusCode == 400) {
          _clearAllData();
        }
      },
      withRetry: true,
    );
  }

  void _clearAllData() {
    selectedFile.value = null;
    exelUploadResult.value = null;
    exelMappingResult = null;
    exelResult = null;
    _firstStep();
  }

  String prettySize(final int bytes) {
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(1)} KB";
    return "${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB";
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final ext = (file.extension ?? '').toLowerCase();
    final size = file.size;

    if (!allowedExtensions.contains(ext)) {
      AppNavigator.snackbarRed(title: s.error, subtitle: s.formatIsNotAllowed);
      return;
    }

    if (size > maxBytes) {
      AppNavigator.snackbarRed(title: s.error, subtitle: "${s.fileSizeExceedsTheAllowedLimit} (${s.maximum} 10 MB)");
      return;
    }

    selectedFile(file);
  }

  void updateColumns({
    required final int index,
    required final DropdownItemReadDto? value,
    required final ExelColumn column,
  }) {
    // Create a new list to trigger Obx rebuild
    final updatedColumns = List<ExelColumn>.from(exelUploadResult.value!.columns);
    updatedColumns[index] = column.copyWithDetectedField(value?.slug);
    // Create a new ExelResultReadDto with updated columns to trigger Obx rebuild
    exelUploadResult.value = ExelUploadResultReadDto(
      tempFileId: exelUploadResult.value!.tempFileId,
      totalRows: exelUploadResult.value!.totalRows,
      hasDuplicates: exelUploadResult.value!.hasDuplicates,
      duplicateCount: exelUploadResult.value!.duplicateCount,
      columns: updatedColumns,
      previewData: exelUploadResult.value!.previewData,
    );
  }
}
