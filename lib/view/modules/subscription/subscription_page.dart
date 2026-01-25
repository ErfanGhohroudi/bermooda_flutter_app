import 'package:u/utilities.dart';

import '../../../core/utils/extensions/money_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/core.dart';
import 'step_pages/subscription_payment.dart';
import 'step_pages/subscription_price_summery.dart';
import 'step_pages/subscription_settings.dart';
import 'subscription_controller.dart';
import 'step_pages/module_management_page.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({
    required this.workspaceId,
    super.key,
  });

  final String workspaceId;

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  late final SubscriptionController ctrl;

  @override
  void initState() {
    ctrl = Get.put(SubscriptionController(workspaceId: widget.workspaceId));
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<SubscriptionController>();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text(s.subscriptionManagement)),
      bottomNavigationBar: _buildButtons(),
      body: Obx(() {
        if (!ctrl.pageState.isLoaded()) {
          return const Center(child: WCircularLoading());
        }

        if (ctrl.pageState.isError()) {
          return Center(child: WErrorWidget(onTapButton: ctrl.getSubscriptionInfo));
        }

        return Theme(
          data: context.theme.copyWith(
            colorScheme: context.theme.colorScheme.copyWith(
              primary: context.theme.primaryColor,
            ),
            canvasColor: context.theme.scaffoldBackgroundColor, // یا هر رنگ دیگری که می‌خواهید
          ),
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: ctrl.currentStep.value,
            stepIconMargin: const EdgeInsets.only(left: 3, right: 3, bottom: 10),
            elevation: 0,
            controlsBuilder: (final context, final details) => const SizedBox.shrink(),
            steps: _buildSteps(),
          ),
        );
      }),
    );
  }

  List<Step> _buildSteps() {
    return List.generate(4, (final index) {
      final isActive = index <= ctrl.currentStep.value;
      final isComplete = index < ctrl.currentStep.value;

      return Step(
        isActive: isActive,
        state: isComplete ? StepState.complete : StepState.indexed,
        title: const SizedBox.shrink(),
        label: Text(
          ctrl.steps[index],
          textAlign: TextAlign.center,
        ).bodyMedium(color: isActive ? context.theme.primaryColor : context.theme.hintColor),
        stepStyle: StepStyle(
          color: isActive ? context.theme.primaryColor : context.theme.dividerColor,
          connectorColor: context.theme.dividerColor,
          indexStyle: context.textTheme.bodyMedium?.copyWith(
            color: isActive ? Colors.white : context.theme.hintColor,
          ),
        ),
        content: _buildStepContent(index),
      );
    });
  }

  Widget _buildStepContent(final int step) {
    switch (step) {
      case 0:
        return ModuleManagementPage(ctrl: ctrl);
      case 1:
        return SubscriptionSettings(ctrl: ctrl);
      case 2:
        return SubscriptionPriceSummery(ctrl: ctrl);
      case 3:
        return SubscriptionPayment(ctrl: ctrl);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildButtons() {
    return Obx(
      () {
        Widget getButtons() {
          switch (ctrl.currentStep.value) {
            case 0:
              if (ctrl.availableModules.isEmpty) return const SizedBox.shrink();
              return UElevatedButton(
                width: double.maxFinite,
                title: s.next,
                onTap: ctrl.onSaveSelectedModules,
              );
            case 1 || 2:
              final hideNextButton = ctrl.currentStep.value == 2 && ctrl.priceCalculation.value == null;
              return Row(
                spacing: 10,
                children: [
                  UElevatedButton(
                    title: s.previous,
                    onTap: ctrl.previousStep,
                    backgroundColor: context.theme.hintColor,
                  ).expanded(),
                  if (hideNextButton == false)
                    UElevatedButton(
                      title: s.next,
                      onTap: ctrl.nextStep,
                    ).expanded(),
                ],
              );
            case 3:
              final calculated = ctrl.priceCalculation.value;
              if (calculated == null) return const SizedBox.shrink();
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UElevatedButton(
                    width: double.infinity,
                    title: "${s.payNow} (${calculated.finalPrice.toString().toTomanMoney()})",
                    onTap: ctrl.createPaymentRequest,
                  ),
                  UElevatedButton(
                    width: double.infinity,
                    title: s.previous,
                    onTap: ctrl.previousStep,
                    backgroundColor: context.theme.hintColor,
                  ),
                ],
              );
            default:
              return const SizedBox.shrink();
          }
        }

        return AnimatedSwitcher(
          duration: 500.milliseconds,
          child: getButtons(),
        ).pOnly(left: 16, right: 16, bottom: 24);
      },
    );
  }
}
