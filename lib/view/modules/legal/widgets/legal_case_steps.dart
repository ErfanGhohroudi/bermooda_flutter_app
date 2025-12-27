import 'package:u/utilities.dart';

import '../../../../core/widgets/chevron_painter.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/navigator/navigator.dart';
import '../../../../core/theme.dart';
import '../../../../data/data.dart';
import '../board/legal_board_controller.dart';

class LegalCaseSteps extends StatelessWidget {
  const LegalCaseSteps({
    required this.legalCase,
    required this.onStepChanged,
    this.canEdit = true,
    super.key,
  });

  final LegalCaseReadDto legalCase;
  final Function(LegalCaseReadDto model) onStepChanged;
  final bool canEdit;

  bool get haveAccessToChange =>
      Get.find<LegalBoardController>().department.members.any((final e) => e.id == Get.find<Core>().userReadDto.value.id);

  void toggleCustomerStepStatus(final LegalCaseStep step) {
    // Check if toggle is allowed
    if (!_canToggleStep(step)) {
      AppNavigator.snackbarRed(title: s.error, subtitle: s.cannotChangeStep);
      return;
    }

    appShowYesCancelDialog(
      description: s.changeStepStatus,
      onYesButtonTap: () {
        UNavigator.back();
        final LegalCaseDatasource datasource = Get.find<LegalCaseDatasource>();
        final isCompleted = !step.isCompleted;
        
        // Save snapshot of all steps before any changes
        final stepsSnapshot = List<LegalCaseStep>.from(legalCase.steps);
        
        // If marking as completed, mark all previous steps as completed too
        final updatedStepsList = List<LegalCaseStep>.from(legalCase.steps);
        if (isCompleted) {
          _markPreviousStepsAsCompleted(step, updatedStepsList);
        }

        // Update current step
        final currentIndex = updatedStepsList.indexWhere((final e) => e.id == step.id);
        if (currentIndex != -1) {
          updatedStepsList[currentIndex] = step.copyWith(isCompleted: isCompleted);
        }

        // Update UI immediately
        onStepChanged(legalCase.copyWith(steps: updatedStepsList));

        // Call API for the current step
        datasource.changeCaseStepStatus(
          stepId: step.id,
          isCompleted: isCompleted,
          onResponse: (final response) {
            if (response.result == null) {
              // Revert all changes on error
              onStepChanged(legalCase.copyWith(steps: stepsSnapshot));
              return;
            }
            final newStep = response.result!;
            final currentStepsList = List<LegalCaseStep>.from(legalCase.steps);
            final index = currentStepsList.indexWhere((final e) => e.id == newStep.id);
            if (index != -1) {
              currentStepsList[index] = newStep;
            }
            onStepChanged(legalCase.copyWith(steps: currentStepsList));
          },
          onError: (final errorResponse) {
            // Revert all changes on error
            onStepChanged(legalCase.copyWith(steps: stepsSnapshot));
            AppNavigator.snackbarRed(title: s.error, subtitle: '');
          },
        );
      },
    );
  }

  /// Check if a step can be toggled
  /// Only the last completed step or any non-completed step can be toggled
  bool _canToggleStep(final LegalCaseStep step) {
    if (step.isCompleted == false) {
      return true; // Non-completed steps can always be toggled
    }

    return false;
  }

  /// Mark all previous steps (with lower stepNumber) as completed
  void _markPreviousStepsAsCompleted(final LegalCaseStep currentStep, final List<LegalCaseStep> stepsList) {
    final currentStepNumber = currentStep.stepNumber ?? 0;

    for (var i = 0; i < stepsList.length; i++) {
      final step = stepsList[i];
      final stepNumber = step.stepNumber ?? 0;
      if (stepNumber < currentStepNumber && !step.isCompleted) {
        stepsList[i] = step.copyWith(isCompleted: true);
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    if (legalCase.steps.isEmpty) {
      return const SizedBox();
    }

    final steps = legalCase.steps;

    return SizedBox(
      height: 22,
      child: Row(
        children: List.generate(steps.length, (final i) {
          final step = steps[i];
          bool isActive = step.isCompleted;
          // bool isActive = i < (legalCase.stepStatus ?? 0);
          return CustomPaint(
            painter: ChevronPainter(
              color: isActive ? AppColors.green : navigatorKey.currentContext!.theme.dividerColor,
            ),
            child: SizedBox(
              height: 30,
              child: Center(
                widthFactor: 1,
                heightFactor: 1,
                child: Text(
                  step.title ?? '',
                  maxLines: 1,
                ).bodySmall(fontSize: 11, color: Colors.white, overflow: TextOverflow.ellipsis).bold().pSymmetric(horizontal: 7),
              ),
            ), // تنظیم ارتفاع هر مرحله
          ).withTooltip(step.title ?? '').onTap(
            () {
              if (!canEdit) return;

              if (haveAccessToChange) {
                toggleCustomerStepStatus(step);
              } else {
                return AppNavigator.snackbarRed(title: s.error, subtitle: s.notAllowChangeStatus);
              }
            },
          ).expanded();
        }),
      ),
    );
  }
}
