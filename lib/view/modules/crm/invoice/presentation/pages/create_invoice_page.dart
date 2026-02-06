import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../controllers/create_invoice_controller.dart';
import '../steps/buyer_seller_info_step.dart';
import '../steps/invoice_details_step.dart';
import '../steps/invoice_installments_step.dart';
import '../steps/invoice_preview_step.dart';
import '../widgets/stepper.dart';

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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (final didPop, final result) {
        if (didPop) return;
        if (ctrl.currentStep.value > 0) {
          ctrl.previousStep();
        } else {
          Navigator.pop(context);
        }
      },
      child: UScaffold(
        resizeToAvoidBottomInset: true,
        color: context.theme.cardColor,
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
                  onTapButton: ctrl.loadInvoiceCodeAndBuyerSellerInfo,
                ),
              );
            }

            return _buildStepper();
          },
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return Obx(
      () {
        final stepsLength = ctrl.stepTypes.length;
        final currentStepTitle = ctrl.steps[ctrl.currentStep.value];
        final currentStepContent = _buildStepContent(ctrl.currentStep.value);

        return WStepper(
          stepsLength: stepsLength,
          currentStep: ctrl.currentStep.value,
          currentStepTitle: currentStepTitle,
          currentStepContent: currentStepContent,
        );
      },
    );
  }

  Widget _buildStepContent(final int step) {
    final type = ctrl.stepTypes[step];
    switch (type) {
      case InvoiceStepType.details:
        return InvoiceDetailsStep(ctrl: ctrl);
      case InvoiceStepType.installments:
        return InvoiceInstallmentsStep(ctrl: ctrl);
      case InvoiceStepType.buyerSeller:
        return BuyerSellerInfoStep(ctrl: ctrl);
      case InvoiceStepType.preview:
        return InvoicePreviewStep(ctrl: ctrl);
    }
  }

  Widget _buildButtons() {
    return SafeArea(
      top: false,
      child: Obx(
        () {
          if (!ctrl.pageState.isLoaded()) {
            return const SizedBox.shrink();
          }

          Widget getButtons() {
            final type = ctrl.stepTypes[ctrl.currentStep.value];
            final isFirst = ctrl.currentStep.value == 0;
            final isLast = ctrl.currentStep.value == ctrl.stepTypes.length - 1;

            if (isFirst) {
              return UElevatedButton(
                width: double.maxFinite,
                title: s.next,
                onTap: ctrl.nextStep,
              );
            }

            if (isLast) {
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
            }

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
      onYesButtonTap: () {
        UNavigator.back();
        ctrl.submitInvoice(context);
      },
    );
  }
}
