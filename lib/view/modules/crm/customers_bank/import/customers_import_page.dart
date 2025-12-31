import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/constants.dart';
import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../data/data.dart';
import 'customer_exel_controller.dart';
import 'steps/preview_step_page.dart';
import 'steps/result_step_page.dart';

part 'steps/upload_step_page.dart';

part 'steps/mapping_step_page.dart';

class CustomersImportPage extends StatefulWidget {
  const CustomersImportPage({
    required this.categoryId,
    super.key,
  });

  final String categoryId;

  @override
  State<CustomersImportPage> createState() => CustomersImportPageState();
}

class CustomersImportPageState extends State<CustomersImportPage> {
  late final CustomerExelController ctrl;

  @override
  void initState() {
    ctrl = Get.put(CustomerExelController(categoryId: widget.categoryId));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(title: Text(s.uploadExelFile)),
      body: _buildStepper(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildStepper() {
    final steps = [s.upload, "Mapping", s.preview, s.result];
    return Theme(
      data: context.theme.copyWith(
        colorScheme: context.theme.colorScheme.copyWith(primary: context.theme.primaryColor),
        canvasColor: context.theme.scaffoldBackgroundColor,
      ),
      child: Obx(
        () => Theme(
          data: context.theme.copyWith(
            colorScheme: context.theme.colorScheme.copyWith(
              primary: context.theme.primaryColor,
            ),
            canvasColor: context.theme.scaffoldBackgroundColor, // یا هر رنگ دیگری که می‌خواهید
          ),
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: ctrl.currentStep.value,
            elevation: 0,
            stepIconMargin: const EdgeInsets.only(left: 3, right: 3, bottom: 10),
            // onStepTapped: (final i) => setState(() => currentStep.value = i),
            controlsBuilder: (final context, final details) => const SizedBox.shrink(),
            steps: List.generate(4, (final index) {
              final isActive = index <= ctrl.currentStep.value;
              final isComplete = index < ctrl.currentStep.value;

              return Step(
                isActive: isActive,
                state: isComplete ? StepState.complete : StepState.indexed,
                title: const SizedBox.shrink(),
                // title: Text(steps[index], textAlign: TextAlign.center).bodySmall(color: isActive ? context.theme.primaryColor : context.theme.hintColor),
                label: Text(steps[index], textAlign: TextAlign.center).bodyMedium(color: isActive ? context.theme.primaryColor : context.theme.hintColor),
                stepStyle: StepStyle(
                  color: isActive ? context.theme.primaryColor : context.theme.dividerColor,
                  connectorColor: context.theme.dividerColor,
                  indexStyle: context.textTheme.bodyMedium?.copyWith(
                    color: isActive ? Colors.white : context.theme.hintColor,
                  ),
                ),
                content: _buildStepContent(index),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent(final int step) {
    switch (step) {
      case 0:
        return UploadStepPage(ctrl: ctrl);
      case 1:
        return MappingStepPage(ctrl: ctrl);
      case 2:
        return PreviewStepPage(ctrl: ctrl);
      case 3:
        return ResultStepPage(ctrl: ctrl);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBottomBar() {
    return SafeArea(
      top: false,
      child: Obx(
        () {
          final showButtons = ctrl.buttonState;

          if (showButtons.value == false) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
            child: Row(
              spacing: 10,
              children: [
                if (ctrl.isLastStep == false)
                  UElevatedButton(
                    onTap: ctrl.onBack,
                    title: ctrl.canBack ? s.back : s.cancel,
                    backgroundColor: context.theme.hintColor,
                  ).expanded(),
                UElevatedButton(
                  onTap: ctrl.onNext,
                  backgroundColor: ctrl.isLastStep ? AppColors.green : null,
                  title: ctrl.isLastStep ? s.close : s.next,
                ).expanded(),
              ],
            ),
          );
        },
      ),
    );
  }
}
