import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/theme.dart';
import '../../controllers/send_group_sms_controller.dart';
import 'steps/content_step.dart';
import 'steps/recipients_step.dart';
import 'steps/review_step.dart';

class SendGroupSmsPage extends StatefulWidget {
  const SendGroupSmsPage({
    required this.departmentId,
    super.key,
  });

  final int departmentId;

  @override
  State<SendGroupSmsPage> createState() => _SendGroupSmsPageState();
}

class _SendGroupSmsPageState extends State<SendGroupSmsPage> {
  late final SendGroupSmsController ctrl;

  @override
  void initState() {
    ctrl = Get.put(SendGroupSmsController(departmentId: widget.departmentId));
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<SendGroupSmsController>();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text(s.sendGroupSMS)),
      body: _buildStepper(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildStepper() {
    final steps = [s.recipients, s.contentAndSettings, s.finalApproval];
    return Obx(
      () => Theme(
        data: context.theme.copyWith(
          colorScheme: context.theme.colorScheme.copyWith(
            primary: context.theme.primaryColor,
          ),
          canvasColor: context.theme.scaffoldBackgroundColor,
        ),
        child: Stepper(
          type: StepperType.horizontal,
          currentStep: ctrl.currentStep.value,
          elevation: 0,
          stepIconMargin: const EdgeInsets.only(left: 3, right: 3, bottom: 10),
          controlsBuilder: (final context, final details) => const SizedBox.shrink(),
          steps: List.generate(3, (final index) {
            final isActive = index <= ctrl.currentStep.value;
            final isComplete = index < ctrl.currentStep.value;

            return Step(
              isActive: isActive,
              state: isComplete ? StepState.complete : StepState.indexed,
              title: const SizedBox.shrink(),
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
    );
  }

  Widget _buildStepContent(final int step) {
    switch (step) {
      case 0:
        return RecipientsStep(ctrl: ctrl);
      case 1:
        return ContentStep(ctrl: ctrl);
      case 2:
        return ReviewStep(ctrl: ctrl);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBottomBar() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
        child: Obx(
          () => Row(
            spacing: 10,
            children: [
              UElevatedButton(
                onTap: ctrl.onBack,
                title: ctrl.canBack ? s.previous : s.cancel,
                backgroundColor: context.theme.hintColor,
              ).expanded(),
              UElevatedButton(
                onTap: ctrl.onNext,
                backgroundColor: ctrl.isLastStep ? AppColors.green : null,
                title: ctrl.isLastStep ? s.sendSMS : s.next,
              ).expanded(),
            ],
          ),
        ),
      ),
    );
  }
}
