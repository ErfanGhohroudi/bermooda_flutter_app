import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../controllers/create_invoice_controller.dart';
import '../steps/buyer_seller_info_step.dart';
import '../steps/invoice_details_step.dart';
import '../steps/invoice_preview_step.dart';

class CreateInvoicePage extends StatefulWidget {
  const CreateInvoicePage({
    required this.customerId,
    super.key,
  });

  final int customerId;

  @override
  State<CreateInvoicePage> createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends State<CreateInvoicePage> {
  late final CreateInvoiceController ctrl;

  @override
  void initState() {
    ctrl = Get.put(CreateInvoiceController(customerId: widget.customerId));
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<CreateInvoiceController>();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(title: Text(s.newInvoice)),
      bottomNavigationBar: _buildButtons(),
      body: Obx(
        () {
          if (ctrl.pageState.isLoading()) {
            return const Center(child: WCircularLoading());
          }

          if (ctrl.pageState.isError()) {
            return Center(
              child: WErrorWidget(
                onTapButton: ctrl.loadInvoiceCode,
              ),
            );
          }

          return _buildStepper();
        },
      ),
    );
  }

  Widget _buildStepper() {
    return Theme(
      data: context.theme.copyWith(
        colorScheme: context.theme.colorScheme.copyWith(
          primary: context.theme.primaryColor,
        ),
        canvasColor: context.theme.scaffoldBackgroundColor,
      ),
      child: Obx(
        () => Stepper(
          type: StepperType.horizontal,
          currentStep: ctrl.currentStep.value,
          stepIconMargin: const EdgeInsets.only(left: 3, right: 3, bottom: 10),
          elevation: 0,
          controlsBuilder: (final context, final details) => const SizedBox.shrink(),
          steps: _buildSteps(),
        ),
      ),
    );
  }

  List<Step> _buildSteps() {
    return List.generate(3, (final index) {
      final isActive = index <= ctrl.currentStep.value;
      final isComplete = index < ctrl.currentStep.value;

      return Step(
        isActive: isActive,
        state: isComplete ? StepState.complete : StepState.indexed,
        title: const SizedBox.shrink(),
        label: Text(
          ctrl.steps[index],
          textAlign: TextAlign.center,
        ).bodySmall(color: isActive ? context.theme.primaryColor : context.theme.hintColor),
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
        return BuyerSellerInfoStep(ctrl: ctrl);
      case 1:
        return InvoiceDetailsStep(ctrl: ctrl);
      case 2:
        return InvoicePreviewStep(ctrl: ctrl);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildButtons() {
    return SafeArea(
      top: false,
      child: Obx(
        () {
          Widget getButtons() {
            switch (ctrl.currentStep.value) {
              case 0:
                return UElevatedButton(
                  width: double.maxFinite,
                  title: s.next,
                  onTap: ctrl.nextStep,
                );
              case 1:
                return Row(
                  spacing: 10,
                  children: [
                    UElevatedButton(
                      title: s.previous,
                      backgroundColor: context.theme.hintColor,
                      onTap: ctrl.previousStep,
                    ).expanded(),
                    UElevatedButton(
                      title: s.next,
                      onTap: ctrl.nextStep,
                    ).expanded(),
                  ],
                );
              case 2:
                return Row(
                  spacing: 10,
                  children: [
                    UElevatedButton(
                      title: s.previous,
                      backgroundColor: context.theme.hintColor,
                      onTap: ctrl.previousStep,
                    ).expanded(),
                    UElevatedButton(
                      title: 'ثبت فاکتور',
                      isLoading: ctrl.isLoading.value,
                      onTap: () => _showSubmitConfirmation(),
                    ).expanded(),
                  ],
                );
              default:
                return const SizedBox.shrink();
            }
          }

          return getButtons().pOnly(left: 16, right: 16, bottom: 24, top: 16);
        },
      ),
    );
  }

  void _showSubmitConfirmation() {
    appShowYesCancelDialog(
      title: 'ثبت فاکتور',
      description: 'آیا از صدور فاکتور مطمئن هستید؟',
      yesButtonTitle: 'تایید',
      cancelButtonTitle: 'انصراف',
      onYesButtonTap: () {
        UNavigator.back();
        ctrl.submitInvoice();
      },
    );
  }
}
