import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/theme.dart';
import '../../splash/splash_page.dart';
import 'payment_receipt_controller.dart';

enum PaymentReceiptStatus { success, fail }

class PaymentReceiptPage extends StatefulWidget {
  const PaymentReceiptPage({
    required this.invoiceCode,
    required this.status,
    super.key,
  });

  final String invoiceCode;
  final PaymentReceiptStatus status;

  @override
  State<PaymentReceiptPage> createState() => _PaymentReceiptPageState();
}

class _PaymentReceiptPageState extends State<PaymentReceiptPage> with PaymentReceiptController {
  @override
  void initState() {
    initialController(status: widget.status, invoiceCode: widget.invoiceCode);
    super.initState();
  }

  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return PopScope(
      canPop: false,
      child: UScaffold(
        appBar: AppBar(
          title: Text(s.paymentReceipt).bodyLarge(),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const SizedBox.shrink(),
        ),
        body: Obx(
          () {
            if (pageState.isLoading() || pageState.isInitial()) {
              return const SizedBox.shrink();
            }

            if (pageState.isError()) {
              return Center(
                child: WErrorWidget(onTapButton: onTryAgain),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                spacing: 18,
                children: [
                  _buildStatusCard().onTap(
                    () {
                      onTryAgain();
                    },
                  ),
                  _buildInvoiceDetails(),
                  _buildActionButtons(context),
                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    final isSuccess = widget.status == PaymentReceiptStatus.success;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isSuccess ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSuccess ? Colors.green[200]! : Colors.red[200]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isSuccess ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSuccess ? Icons.check_circle : Icons.cancel,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isSuccess ? s.successfulPayment : s.unsuccessfulPayment,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isSuccess ? s.paymentWasSuccessful : s.paymentFailed,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceDetails() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.details,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Display subscription title prominently
          if (invoice.title.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.blue.withValues(alpha: 0.3)),
              ),
              child: Text(
                invoice.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blue,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
          ],
          _buildDetailRow(s.invoiceNumber, invoice.invoiceCode),
          const SizedBox(height: 12),
          _buildDetailRow(s.amount, getFormattedPrice()),
          const SizedBox(height: 12),
          _buildDetailRow(s.paymentDate, getCurrentDate(), ltr: true),
          const SizedBox(height: 12),
          _buildDetailRow(s.transactionNumber, invoice.trackId ?? '- -'),
          const SizedBox(height: 12),
          _buildDetailRow(s.referenceID, invoice.refNumber ?? '- -'),
          const SizedBox(height: 12),
          _buildDetailRow(s.cardNumber, invoice.cardNumber ?? '- -', ltr: true),
          const SizedBox(height: 12),
          _buildDetailRow(
            s.status,
            widget.status == PaymentReceiptStatus.success ? s.successfulPayment : s.unsuccessfulPayment,
            valueColor: widget.status == PaymentReceiptStatus.success ? Colors.green : Colors.red,
          ),
          if (invoice.description != null && invoice.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildDetailRow(s.description, invoice.description!),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(final String label, final String value, {final Color? valueColor, final bool ltr = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 10,
      children: [
        Text("$label:").titleMedium(color: context.theme.hintColor),
        Flexible(
          child: Text(value, textDirection: ltr ? TextDirection.ltr : null).bodyMedium(color: valueColor),
        ),
      ],
    );
  }

  Widget _buildActionButtons(final BuildContext context) {
    final isSuccess = widget.status == PaymentReceiptStatus.success;

    return Column(
      spacing: 6,
      children: [
        UElevatedButton(
          width: double.infinity,
          title: "${s.share} ${s.paymentReceipt}",
          icon: const Icon(Icons.share, size: 20, color: Colors.white),
          onTap: shareInvoice,
        ),
        UElevatedButton(
          width: double.infinity,
          title: s.invoice,
          backgroundColor: context.theme.scaffoldBackgroundColor,
          titleColor: AppColors.blue,
          borderColor: AppColors.blue,
          borderWidth: 1,
          icon: const Icon(Icons.print, size: 20, color: AppColors.blue),
          onTap: () {
            if (invoice.invoiceUrl == null) return;
            ULaunch.launchURL(invoice.invoiceUrl!, mode: LaunchMode.platformDefault);
          },
        ),
        UElevatedButton(
          width: double.infinity,
          title: isSuccess ? s.goToHomePage : s.back,
          backgroundColor: isSuccess ? AppColors.green : AppColors.red,
          onTap: () {
            if (isSuccess) {
              UNavigator.offAll(const SplashPage());
            } else {
              UNavigator.back();
            }
          },
        ),
      ],
    );
  }
}
