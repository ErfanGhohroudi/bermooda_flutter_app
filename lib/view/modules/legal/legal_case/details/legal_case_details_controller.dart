import 'package:bermooda_business/core/services/permission_service.dart';
import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../data/data.dart';
import '../steps/create_update_step_page.dart';
import '../update/update_legal_case_Page.dart';
import 'create_update_document_page.dart';

class LegalCaseDetailsController extends GetxController {
  LegalCaseDetailsController({
    required final int legalCaseId,
    required final bool canEdit,
  }) {
    _legalCaseId = legalCaseId;
    _canEdit = canEdit;
  }

  late final int _legalCaseId;
  late final bool _canEdit;
  final LegalCaseDatasource _datasource = Get.find<LegalCaseDatasource>();
  final PermissionService _perService = Get.find<PermissionService>();
  final Rx<PageState> pageState = PageState.initial.obs;
  final Rx<LegalCaseReadDto> legalCase = const LegalCaseReadDto(id: 0).obs;
  final RxList<LegalCaseStep> steps = <LegalCaseStep>[].obs;
  final RxList<LegalCaseDocumentDto> documents = <LegalCaseDocumentDto>[].obs;

  bool get haveAdminAccess => _perService.haveLegalAdminAccess;

  bool get canEdit => _canEdit && haveAdminAccess;

  @override
  void onInit() {
    _getAllData();
    super.onInit();
  }

  void onTryAgain() {
    pageState.loading();
    _getAllData();
  }

  void updateLegalCase(final LegalCaseReadDto legalCase) {
    this.legalCase(legalCase);
    steps(this.legalCase.value.steps);
  }

  void showUpdateLegalCaseBottomSheet() {
    bottomSheet(
      title: s.editCase,
      child: UpdateLegalCasePage(controller: this),
    );
  }

  void showCreateStepBottomSheet() {
    bottomSheet(
      title: "${s.addText} ${s.step}",
      child: CreateUpdateStepPage(controller: this),
    );
  }

  void showUpdateStepBottomSheet(final LegalCaseStep step) {
    bottomSheet(
      title: s.edit,
      child: CreateUpdateStepPage(controller: this, step: step),
    );
  }

  void onDeleteLegalCase() {
    appShowYesCancelDialog(
      title: s.delete,
      description: s.areYouSureYouWantToDeleteItem,
      onYesButtonTap: () {
        UNavigator.back(); // close dialog
        _datasource.delete(
          caseId: _legalCaseId,
          onResponse: () {
            UNavigator.back(); // exit the page
          },
          onError: (final errorResponse) {},
        );
      },
    );
  }

  void reorderSteps(final int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    // Check if reorder is allowed
    final oldStep = steps[oldIndex];

    // Only non-completed steps can be reordered
    if (oldStep.isCompleted) {
      AppNavigator.snackbarRed(title: s.error, subtitle: s.cannotMoveCompletedSteps);
      return;
    }

    // Find the index of the last completed step
    final lastCompletedIndex = _getLastCompletedStepIndex();

    // newIndex must be after all completed steps
    if (newIndex <= lastCompletedIndex) {
      AppNavigator.snackbarRed(title: s.error, subtitle: s.cannotInsertInCompletedBetweenCompletedSteps);
      return;
    }

    // Save the old order in case we need to revert
    final oldSteps = List<LegalCaseStep>.from(steps);

    final item = steps.removeAt(oldIndex);
    steps.insert(newIndex, item);

    // Update step numbers locally (only for non-completed steps)
    final completedCount = lastCompletedIndex + 1;
    for (var i = completedCount; i < steps.length; i++) {
      if (steps[i].stepNumber != i + 1) {
        final updatedStep = steps[i].copyWith(stepNumber: i + 1);
        steps[i] = updatedStep;
      }
    }

    // Reorder on server
    _reorderStepsOnServer(
      onRevert: () {
        if (steps.subject.isClosed) return;
        steps.assignAll(oldSteps);
      },
    );
  }

  //--------------------------------------------------------
  // API Methods
  //--------------------------------------------------------

  void _getAllData() {
    Future.wait([
          _getLegalCase(),
          _getLegalCaseDocuments(),
        ])
        .then((final values) {
          if (legalCase.subject.isClosed || steps.subject.isClosed) return pageState.error();
          updateLegalCase(values[0] as LegalCaseReadDto);
          documents.assignAll(values[1] as List<LegalCaseDocumentDto>);
          pageState.loaded();
        })
        .timeout(20.seconds, onTimeout: () => pageState.error())
        .onError((final e, final s) {
          return pageState.error();
        });
  }

  Future<LegalCaseReadDto> _getLegalCase() async {
    final completer = Completer<LegalCaseReadDto>();
    _datasource.getCaseById(
      caseId: _legalCaseId,
      onResponse: (final response) {
        if (response.result == null) return completer.completeError(response);
        completer.complete(response.result);
      },
      onError: (final errorResponse) {
        completer.completeError(errorResponse);
      },
    );
    return completer.future;
  }

  Future<List<LegalCaseDocumentDto>> _getLegalCaseDocuments() async {
    final completer = Completer<List<LegalCaseDocumentDto>>();
    _datasource.getDocuments(
      caseId: _legalCaseId,
      onResponse: (final response) {
        completer.complete(response.resultList ?? []);
      },
      onError: (final errorResponse) {
        completer.completeError(errorResponse);
      },
    );
    return completer.future;
  }

  void editLegalCase({
    required final String title,
    required final String description,
    required final VoidCallback onSuccess,
    required final VoidCallback onFailure,
  }) {
    _datasource.update(
      id: legalCase.value.id.toString(),
      title: title,
      description: description,
      onResponse: (final response) {
        if (legalCase.subject.isClosed || response.result == null) return onFailure();
        legalCase(response.result);
        onSuccess();
      },
      onError: (final errorResponse) => onFailure(),
    );
  }

  //--------------------------------------------------------
  // Step Methods
  //--------------------------------------------------------

  void createStep({
    required final String title,
    required final VoidCallback onSuccess,
    required final VoidCallback onFailure,
  }) {
    final stepNumber = steps.length + 1;
    _datasource.createCaseStep(
      caseId: _legalCaseId,
      title: title,
      stepNumber: stepNumber,
      onResponse: (final response) {
        if (steps.subject.isClosed || response.result == null) return onFailure();
        steps.add(response.result!);
        onSuccess();
      },
      onError: (final errorResponse) => onFailure(),
    );
  }

  void updateStep({
    required final LegalCaseStep step,
    required final String title,
    required final VoidCallback onSuccess,
    required final VoidCallback onFailure,
  }) {
    _datasource.updateCaseStep(
      stepId: step.id,
      title: title,
      stepNumber: step.stepNumber ?? 1,
      onResponse: (final response) {
        if (steps.subject.isClosed || response.result == null) return onFailure();
        final index = steps.indexWhere((final s) => s.id == step.id);
        if (index != -1) {
          steps[index] = response.result!;
        }
        onSuccess();
      },
      onError: (final errorResponse) => onFailure(),
    );
  }

  void deleteStep(final LegalCaseStep step) {
    appShowYesCancelDialog(
      title: s.delete,
      description: s.areYouSureYouWantToDeleteItem,
      onYesButtonTap: () {
        UNavigator.back(); // close dialog
        _datasource.deleteCaseStep(
          stepId: step.id,
          onResponse: () {
            steps.removeWhere((final s) => s.id == step.id);
            // Update step numbers after deletion
            for (var i = 0; i < steps.length; i++) {
              if (steps[i].stepNumber != i + 1) {
                final updatedStep = steps[i].copyWith(stepNumber: i + 1);
                steps[i] = updatedStep;
              }
            }
            debugPrint('Steps after deletion: $steps');
          },
          onError: (final errorResponse) {},
        );
      },
    );
  }

  void _reorderStepsOnServer({final VoidCallback? onRevert}) {
    _datasource.reorderCaseSteps(
      caseId: _legalCaseId,
      steps: steps.toList(),
      onResponse: (final response) {
        if (steps.subject.isClosed) return;
        if (response.resultList != null && response.resultList!.isNotEmpty) {
          steps(response.resultList!);
        }
      },
      onError: (final errorResponse) {
        if (onRevert != null) onRevert();
      },
    );
  }

  //--------------------------------------------------------
  // Helper Methods
  //--------------------------------------------------------

  /// Check if a step can be toggled
  /// Only the non-completed steps can be toggled
  bool _canToggleStep(final LegalCaseStep step) {
    if (step.isCompleted == false) {
      return true; // Non-completed steps can always be toggled
    }

    return false;
  }

  /// Get the index of the last completed step in the sorted list
  int _getLastCompletedStepIndex() {
    for (var i = steps.length - 1; i >= 0; i--) {
      if (steps[i].isCompleted) {
        return i;
      }
    }
    return -1;
  }

  /// Mark all previous steps (with lower stepNumber) as completed
  void _markPreviousStepsAsCompleted(final int currentIndex) {
    final currentStep = steps[currentIndex];
    final currentStepNumber = currentStep.stepNumber ?? 0;

    for (var i = 0; i < steps.length; i++) {
      final step = steps[i];
      final stepNumber = step.stepNumber ?? 0;
      if (stepNumber < currentStepNumber && !step.isCompleted) {
        steps[i] = step.copyWith(isCompleted: true);
      }
    }
  }

  /// Check if a step can be reordered (for UI)
  bool canReorderStep(final LegalCaseStep step) {
    return !step.isCompleted;
  }

  void toggleStepStatus(final LegalCaseStep step, final bool isCompleted) {
    // Check if toggle is allowed
    if (!_canToggleStep(step)) {
      AppNavigator.snackbarRed(title: s.error, subtitle: s.cannotChangeStep);
      return;
    }

    // Save snapshot of all steps before any changes
    final stepsSnapshot = List<LegalCaseStep>.from(steps);

    final oldValue = step.isCompleted;
    final index = steps.indexWhere((final s) => s.id == step.id);

    if (index == -1) return;

    // If marking as completed, mark all previous steps as completed too
    if (isCompleted && !oldValue) {
      _markPreviousStepsAsCompleted(index);
    }

    // Optimistically update UI
    steps[index] = steps[index].copyWith(isCompleted: isCompleted);

    // Call API for the current step
    _datasource.changeCaseStepStatus(
      stepId: step.id,
      isCompleted: isCompleted,
      onResponse: (final response) {
        if (steps.subject.isClosed || response.result == null) {
          // Revert all changes on error
          steps.assignAll(stepsSnapshot);
          return;
        }
        // Update with server response
        final currentIndex = steps.indexWhere((final s) => s.id == step.id);
        if (currentIndex != -1) {
          steps[currentIndex] = response.result!;
        }
      },
      onError: (final errorResponse) {
        // Revert all changes on error
        steps.assignAll(stepsSnapshot);
      },
    );
  }

  //--------------------------------------------------------
  // Document Methods
  //--------------------------------------------------------

  void showCreateDocumentBottomSheet() {
    bottomSheet(
      title: "${s.addText} ${s.file}",
      child: CreateUpdateDocumentPage(controller: this),
    );
  }

  void showUpdateDocumentBottomSheet(final LegalCaseDocumentDto document) {
    bottomSheet(
      title: s.edit,
      child: CreateUpdateDocumentPage(controller: this, document: document),
    );
  }

  // Future<void> pickFileAndCreateDocument({
  //   required final String title,
  //   required final MainFileReadDto file,
  // }) async {
  //   final uploadItem = DocumentUploadEntity(
  //     file: file,
  //     title: title,
  //     state: DocumentUploadState.pending,
  //     cancelToken: dio.CancelToken(),
  //   );
  //
  //   uploadingDocuments.add(uploadItem);
  //
  //   uploadFileAndCreateDocument(uploadItem);
  // }

  // void uploadFileAndCreateDocument(final DocumentUploadEntity item) async {
  //   item.cancelToken ??= dio.CancelToken();
  //
  //   final index = uploadingDocuments.indexWhere((final i) => i == item);
  //   if (index == -1) return;
  //
  //   _uploadFileDatasource.uploadFile(
  //     file: item.file,
  //     cancelToken: item.cancelToken,
  //     onProgress: (final progress) {
  //       debugPrint("Progress uploaded: $progress");
  //       final itemIndex = uploadingDocuments.indexWhere((final i) => i == item);
  //       if (itemIndex != -1) {
  //         if (uploadingDocuments[itemIndex].state != DocumentUploadState.uploading) {
  //           uploadingDocuments[itemIndex] = uploadingDocuments[itemIndex].copyWith(state: DocumentUploadState.uploading);
  //         }
  //         uploadingDocuments[itemIndex] = uploadingDocuments[itemIndex].copyWith(progress: progress);
  //       }
  //     },
  //     onFileUploaded: (final file) {
  //       final itemIndex = uploadingDocuments.indexWhere((final i) => i == item);
  //       if (itemIndex != -1) {
  //         uploadingDocuments[itemIndex] = uploadingDocuments[itemIndex].copyWith(
  //           uploadedFile: file,
  //           state: DocumentUploadState.uploaded,
  //         );
  //       }
  //
  //       // Create document
  //       createDocument(
  //         fileId: file.fileId!,
  //         uploadItem: item,
  //       );
  //     },
  //     onError: (final file, final response) {
  //       final itemIndex = uploadingDocuments.indexWhere((final i) => i == item);
  //       if (itemIndex != -1) {
  //         uploadingDocuments[itemIndex] = uploadingDocuments[itemIndex].copyWith(state: DocumentUploadState.failed);
  //       }
  //     },
  //     onCancel: () {
  //       final itemIndex = uploadingDocuments.indexWhere((final i) => i == item);
  //       if (itemIndex != -1) {
  //         uploadingDocuments.removeAt(itemIndex);
  //       }
  //     },
  //   );
  // }

  void createDocument({
    required final int fileId,
    required final String title,
    required final VoidCallback onSuccess,
    required final VoidCallback onFailure,
  }) {
    _datasource.createDocument(
      caseId: _legalCaseId,
      title: title,
      fileId: fileId,
      onResponse: (final response) {
        documents.add(response.result!);
        onSuccess();
      },
      onError: (final errorResponse) {
        onFailure();
      },
    );
  }

  void updateDocument({
    required final LegalCaseDocumentDto document,
    required final String title,
    required final VoidCallback onSuccess,
    required final VoidCallback onFailure,
  }) {
    if (document.file.fileId == null) return onFailure();

    _datasource.updateDocument(
      id: document.id,
      title: title,
      fileId: document.file.fileId!,
      onResponse: (final response) {
        if (documents.subject.isClosed || response.result == null) return onFailure();
        final index = documents.indexWhere((final d) => d.id == document.id);
        if (index != -1) {
          documents[index] = response.result!;
        }
        onSuccess();
      },
      onError: (final errorResponse) => onFailure(),
    );
  }

  void deleteDocument(final LegalCaseDocumentDto document) {
    appShowYesCancelDialog(
      title: s.delete,
      description: s.areYouSureYouWantToDeleteItem,
      onYesButtonTap: () {
        UNavigator.back(); // close dialog
        _datasource.deleteDocument(
          id: document.id,
          onResponse: () {
            documents.removeWhere((final d) => d.id == document.id);
          },
          onError: (final errorResponse) {},
        );
      },
    );
  }
}
