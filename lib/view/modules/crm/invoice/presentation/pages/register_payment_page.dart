import 'package:decimal/decimal.dart';
import 'package:u/utilities.dart';
import '../../../../../../core/core.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../core/widgets/fields/fields.dart';
import '../../../../../../core/widgets/image_files.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../domain/entities/invoice.dart';
import '../controllers/register_payment_controller.dart';

class RegisterPaymentPage extends StatefulWidget {
  const RegisterPaymentPage({
    required this.installmentId,
    required this.invoiceMainId,
    required this.amount,
    required this.onResponse,
    super.key,
  });

  final int? installmentId;
  final String invoiceMainId;
  final Decimal amount;
  final Function(InvoiceEntity? invoice) onResponse;

  @override
  State<RegisterPaymentPage> createState() => _RegisterPaymentPageState();
}

class _RegisterPaymentPageState extends State<RegisterPaymentPage> {
  late final RegisterPaymentController ctrl;

  @override
  void initState() {
    ctrl = Get.put(
      RegisterPaymentController(
        installmentId: widget.installmentId,
        invoiceMainId: widget.invoiceMainId,
        amount: widget.amount,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<RegisterPaymentController>();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text(s.registerPaymentDocuments)),
      bottomNavigationBar: Obx(
        () => UElevatedButton(
          title: s.submitPayment,
          width: double.infinity,
          isLoading: ctrl.isLoading.value,
          onTap: () => ctrl.submit(onResponse: widget.onResponse),
        ).pOnly(left: 16, right: 16, bottom: 24),
      ),
      body: Form(
        key: ctrl.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 18,
            children: [
              // Info Alert
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.blue.withValues(alpha: 0.3)),
                ),
                child: Text(
                  s.paymentRegistrationInfo,
                  style: const TextStyle(color: AppColors.blue, fontSize: 13),
                ),
              ),

              // Receipt Images
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text("${s.paymentReceiptImages}*").titleMedium(color: context.theme.hintColor),
                  WImageFiles(
                    files: ctrl.receiptFiles,
                    maxFileSizeMB: 5,
                    allowedExtensions: const ['jpg', 'jpeg', 'png', 'pdf'],
                    onFilesUpdated: (final uploadedFiles) {
                      ctrl.receiptFiles.assignAll(uploadedFiles);
                    },
                    uploadingFileStatus: (final value) {
                      ctrl.isUploadingFiles(value);
                    },
                  ),
                ],
              ).marginOnly(bottom: 24),

              // Date and Time
              Row(
                spacing: 12,
                children: [
                  WDatePickerField(
                    labelText: s.paymentDate,
                    required: true,
                    onConfirm: (final jalali, final compactDate) {
                      ctrl.paymentDate(compactDate);
                    },
                  ).expanded(),
                  WTimePickerField(
                    initialValue: ctrl.paymentTime.value,
                    required: true,
                    labelText: s.paymentTime,
                    onConfirm: (final time, final timeOfDay) => ctrl.updatePaymentTime(time),
                  ).expanded(),
                ],
              ),

              // Tracking Code
              WTextField(
                controller: ctrl.trackingCodeController,
                labelText: s.trackingCode,
                hintText: s.trackingCodeHint,
                required: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),

              // Description
              WTextField(
                controller: ctrl.descriptionController,
                labelText: '${s.description} ${s.optional}',
                hintText: s.descriptionHint,
                multiLine: true,
                showCounter: true,
                maxLines: 8,
                maxLength: 500,
              ),

              // Auto Approve Checkbox
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.theme.dividerColor.withValues(alpha: 0.1),
                  border: Border.all(color: context.theme.dividerColor),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  spacing: 6,
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        Obx(
                          () => WCheckBox(
                            isChecked: ctrl.autoApprove.value,
                            onChanged: (final value) => ctrl.autoApprove(value),
                            activeColor: AppColors.blue,
                            borderColor: AppColors.blue,
                          ),
                        ),
                        Text(s.autoApproveAfterRegistration).bodyMedium().bold().expanded(),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsetsDirectional.only(start: 40),
                      child: Text(
                        s.invoiceAutoApproveInfo,
                      ).bodyMedium(color: context.theme.hintColor),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
