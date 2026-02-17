import 'package:decimal/decimal.dart';
import 'package:u/utilities.dart';
import '../../../../../../core/core.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../core/widgets/image_files.dart';
import '../../../../../../data/data.dart';
import '../../data/params/pay_invoice_params.dart';
import '../../data/repositories/invoice_repository_impl.dart';
import '../../domain/usecases/pay_invoice.dart';
import '../../domain/usecases/payment_verification.dart';

class RegisterPaymentController extends GetxController {
  RegisterPaymentController({
    required this.installmentId,
    required this.invoiceMainId,
    required this.amount,
  });

  final int? installmentId;
  final String invoiceMainId;
  final Decimal amount;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final InvoiceRepositoryImpl _repository = InvoiceRepositoryImpl();
  late final PayInvoiceUseCase _payInvoiceUseCase = PayInvoiceUseCase(_repository);
  late final PaymentVerificationUseCase _paymentVerificationUseCase = PaymentVerificationUseCase(_repository);

  final RxList<MainFileReadDto> receiptFiles = <MainFileReadDto>[].obs;
  final RxBool isUploadingFiles = false.obs;

  final RxString paymentDate = ''.obs;
  final Rxn<String> paymentTime = Rxn<String>(null);

  final TextEditingController trackingCodeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final RxBool autoApprove = false.obs;

  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    trackingCodeController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void updatePaymentTime(final String? time) {
    paymentTime.value = time;
  }

  void submit({required final VoidCallback onResponse}) {
    if (!formKey.currentState!.validate()) return;

    if (paymentDate.isEmpty) {
      AppSnackBar.snackbarRed(title: s.error, subtitle: s.isRequired(s.paymentDate));
      return;
    }

    if (paymentTime.value == null || paymentTime.value?.trim() == '') {
      AppSnackBar.snackbarRed(title: s.error, subtitle: s.isRequired(s.paymentTime));
      return;
    }

    if (trackingCodeController.text.isEmpty) {
      AppSnackBar.snackbarRed(title: s.error, subtitle: s.isRequired(s.trackingCode));
      return;
    }

    WImageFiles.checkFileUploading(
      isUploadingFile: isUploadingFiles.value,
      action: () async {
        if (receiptFiles.isEmpty) {
          AppSnackBar.snackbarRed(title: s.error, subtitle: s.isRequired(s.paymentReceiptImages));
          return;
        }

        try {
          isLoading(true);

          final params = PayInvoiceParams(
            amount: amount,
            installmentId: installmentId,
            paymentDate: paymentDate.value,
            // YYYY/MM/DD
            paymentTime: paymentTime.value!,
            // HH:MM
            description: descriptionController.text.trim().isNotEmpty ? descriptionController.text.trim() : null,
            receiptFiles: receiptFiles,
            trackingCode: trackingCodeController.text.trim(),
            autoApprove: autoApprove.value,
          );

          final paymentResponse = await _payInvoiceUseCase(invoiceMainId, params);
          if (autoApprove.value && paymentResponse.result?.id != null) {
            await _paymentVerificationUseCase(
              recordId: paymentResponse.result!.id!,
              reason: '',
              verify: autoApprove.value,
              installmentId: installmentId,
            );
          }

          isLoading(false);
          AppSnackBar.snackbarGreen(title: s.done, subtitle: paymentResponse.message);
          AppNavigator.back();
          onResponse();
        } catch (e) {
          isLoading(false);
        }
      },
    );
  }
}
