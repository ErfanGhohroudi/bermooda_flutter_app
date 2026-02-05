import 'dart:io';
import 'package:decimal/decimal.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../core/utils/extensions/money_extensions.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../controllers/create_invoice_controller.dart';

class InvoicePreviewStep extends StatefulWidget {
  const InvoicePreviewStep({
    required this.ctrl,
    super.key,
  });

  final CreateInvoiceController ctrl;

  @override
  State<InvoicePreviewStep> createState() => _InvoicePreviewStepState();
}

class _InvoicePreviewStepState extends State<InvoicePreviewStep> {
  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> _printOrSaveInvoice() async {
    try {
      final image = await _screenshotController.capture();
      if (image == null) return;

      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'invoice_${widget.ctrl.invoiceCodeController.text}_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(image);

      ULaunch.shareFile(
        [file.path],
        'فاکتور ${widget.ctrl.invoiceCodeController.text}',
      );

      AppNavigator.snackbarGreen(
        title: s.done,
        subtitle: 'فاکتور ذخیره شد',
      );
    } catch (e) {
      AppNavigator.snackbarRed(
        title: s.error,
        subtitle: 'خطا در ذخیره فاکتور',
      );
    }
  }

  @override
  Widget build(final BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 10, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          // Action Buttons
          Row(
            spacing: 10,
            children: [
              UElevatedButton(
                title: 'چاپ / ذخیره PDF',
                icon: const Icon(Icons.print, color: Colors.white),
                onTap: _printOrSaveInvoice,
              ).expanded(),
              UElevatedButton(
                title: 'ریست فاکتور',
                backgroundColor: context.theme.hintColor,
                onTap: () => _showResetConfirmation(context),
              ).expanded(),
            ],
          ),

          // Invoice Preview (Printable)
          Screenshot(
            controller: _screenshotController,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: _buildInvoiceContent(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceContent(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        _buildHeader(context),
        const SizedBox(height: 24),

        // Invoice Info
        _buildInvoiceInfo(context),
        const SizedBox(height: 24),

        // Buyer and Seller Info
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildBuyerInfo(context)),
            const SizedBox(width: 16),
            Expanded(child: _buildSellerInfo(context)),
          ],
        ),
        const SizedBox(height: 24),

        // Products Table
        _buildProductsTable(context),
        const SizedBox(height: 24),

        // Price Summary
        _buildPriceSummary(context),
        const SizedBox(height: 24),

        // Installments (if applicable)
        Obx(
          () {
            if (widget.ctrl.selectedPaymentTerms.value == PaymentTerms.installment && widget.ctrl.installmentPayments.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInstallmentsTable(context),
                  const SizedBox(height: 24),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),

        // Footer
        _buildFooter(context),
      ],
    );
  }

  Widget _buildHeader(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.theme.primaryColor, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Obx(
                  () {
                    final wsInfo = widget.ctrl.sellerInfo.value;
                    return Text(wsInfo?.name ?? '- -').titleMedium(color: context.theme.primaryColor);
                  },
                ),
                Obx(
                  () {
                    final wsInfo = widget.ctrl.sellerInfo.value;
                    if (wsInfo!.address.isNotEmpty) {
                      return Text(wsInfo.address).bodyMedium();
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 4,
            children: [
              Text(s.invoice).titleMedium(color: context.theme.primaryColor),
              Text(widget.ctrl.invoiceCodeController.text).bodyMedium(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceInfo(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (widget.ctrl.selectedInvoiceType.value != null)
            _infoItem(
              context,
              s.invoiceType,
              widget.ctrl.selectedInvoiceType.value?.getTitle() ?? '',
            ),
          if (widget.ctrl.createdDate != null)
            _infoItem(
              context,
              s.dateOfEntry,
              widget.ctrl.createdDate!.formatCompactDate(),
            ),
          if (widget.ctrl.validityDate != null)
            _infoItem(
              context,
              s.validityDate,
              widget.ctrl.validityDate!.formatCompactDate(),
            ),
        ],
      ),
    );
  }

  Widget _infoItem(final BuildContext context, final String label, final String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(label).bodyMedium(color: context.theme.hintColor),
        Text(value).bodyMedium(),
      ],
    );
  }

  Widget _buildBuyerInfo(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.buyer).titleMedium(color: context.theme.primaryColor),
          const Divider(height: 16),
          _infoRow(context, s.name, widget.ctrl.buyerNameController.text),
          _infoRow(context, s.phoneNumber, widget.ctrl.buyerPhoneController.text),
          Obx(
            () {
              if (widget.ctrl.selectedState.value != null) {
                return _infoRow(context, s.state, widget.ctrl.selectedState.value?.title ?? '');
              }
              return const SizedBox.shrink();
            },
          ),
          Obx(
            () {
              if (widget.ctrl.selectedCity.value != null) {
                return _infoRow(context, s.city, widget.ctrl.selectedCity.value?.title ?? '');
              }
              return const SizedBox.shrink();
            },
          ),
          if (widget.ctrl.buyerAddressController.text.isNotEmpty)
            _infoRow(context, s.address, widget.ctrl.buyerAddressController.text),
        ],
      ),
    );
  }

  Widget _buildSellerInfo(final BuildContext context) {
    return Obx(
      () {
        final wsInfo = widget.ctrl.sellerInfo.value;
        if (wsInfo == null) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.seller).titleMedium(color: context.theme.primaryColor),
              const Divider(height: 16),
              _infoRow(context, s.name, wsInfo.name),
              if (wsInfo.state?.title != null) _infoRow(context, s.state, wsInfo.state!.title!),
              if (wsInfo.city?.title != null) _infoRow(context, s.city, wsInfo.city!.title!),
              if (wsInfo.address.isNotEmpty) _infoRow(context, s.address, wsInfo.address),
              if (wsInfo.phoneNumber.isNotEmpty) _infoRow(context, s.phoneNumber, wsInfo.phoneNumber),
              if (wsInfo.email != null && wsInfo.email!.isNotEmpty) _infoRow(context, s.email, wsInfo.email!),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductsTable(final BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: context.theme.primaryColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text('شرح کالا/خدمات').bodyMedium(fontWeight: FontWeight.bold)),
                Expanded(flex: 1, child: Text('تعداد').bodyMedium(fontWeight: FontWeight.bold)),
                Expanded(flex: 1, child: Text(s.unitPrice).bodyMedium(fontWeight: FontWeight.bold)),
                Expanded(flex: 1, child: Text('مبلغ کل').bodyMedium(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          // Table Rows
          ...widget.ctrl.products.asMap().entries.map((final entry) {
            final index = entry.key;
            final product = entry.value;
            final price = double.tryParse(product.price.replaceAll(',', '')) ?? 0;
            final total = (price * product.count).toString().toTomanMoney();

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                ),
                color: index.isEven ? Colors.white : Colors.grey.shade50,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.title).bodyMedium(),
                        if (product.code != null) ...[
                          const SizedBox(height: 4),
                          Text('کد: ${product.code}').bodyMedium(color: context.theme.hintColor),
                        ],
                        if (product.unit != null) ...[
                          const SizedBox(height: 2),
                          Text('واحد: ${product.unit}').bodyMedium(color: context.theme.hintColor),
                        ],
                      ],
                    ),
                  ),
                  Expanded(flex: 1, child: Text(product.count.toString()).bodyMedium()),
                  Expanded(flex: 1, child: Text(product.price).bodyMedium()),
                  Expanded(flex: 1, child: Text(total).bodyMedium(fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPriceSummary(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          _summaryRow(s.totalAmountOfProductsServices, widget.ctrl.totalProductsPrice.toString().toTomanMoney()),
          if (widget.ctrl.discountAmount > 0.toDecimal()) _summaryRow(s.discount, '-${widget.ctrl.discountAmount.toString().toTomanMoney()}'),
          if (widget.ctrl.taxAmount > 0.toDecimal()) _summaryRow('ارزش افزوده', widget.ctrl.taxAmount.toString().toTomanMoney()),
          if (widget.ctrl.shippingCostAmount > 0)
            _summaryRow(s.shippingCost, widget.ctrl.shippingCostAmount.toString().toTomanMoney()),
          Obx(
            () {
              if (widget.ctrl.selectedPaymentTerms.value == PaymentTerms.installment && widget.ctrl.interestAmount > 0.toDecimal()) {
                return _summaryRow(s.interestRate, widget.ctrl.interestAmount.toString().toTomanMoney());
              }
              return const SizedBox.shrink();
            },
          ),
          const Divider(height: 24),
          _summaryRow(
            s.payable,
            widget.ctrl.finalPriceWithInterest.toRialMoney(),
            isBold: true,
            fontSize: 18,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(final String label, final String value, {final bool isBold = false, final double fontSize = 14}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label).bodyMedium(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          Text(value).bodyMedium(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ],
      ),
    );
  }

  Widget _buildInstallmentsTable(final BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: context.theme.primaryColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Expanded(flex: 1, child: Text('قسط').bodyMedium(fontWeight: FontWeight.bold)),
                Expanded(flex: 2, child: Text(s.paymentDate).bodyMedium(fontWeight: FontWeight.bold)),
                Expanded(flex: 2, child: Text(s.amount).bodyMedium(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          ...widget.ctrl.installmentPayments.asMap().entries.map((final entry) {
            final index = entry.key;
            final payment = entry.value;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
                color: index.isEven ? Colors.white : Colors.grey.shade50,
              ),
              child: Row(
                children: [
                  Expanded(flex: 1, child: Text('${index + 1}').bodyMedium()),
                  Expanded(flex: 2, child: Text(payment.dateToPay.formatCompactDate()).bodyMedium()),
                  Expanded(flex: 2, child: Text('${payment.principalAmount} ${s.toman}').bodyMedium(fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFooter(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        spacing: 8,
        children: [
          Text('با تشکر از اعتماد شما').titleMedium(color: context.theme.primaryColor),
          Text('این فاکتور به صورت الکترونیکی صادر شده است').bodyMedium(color: context.theme.hintColor),
        ],
      ),
    );
  }

  Widget _infoRow(final BuildContext context, final String label, final String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text('$label:').bodyMedium(color: context.theme.hintColor),
          ),
          Expanded(
            child: Text(value).bodyMedium(),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation(final BuildContext context) {
    appShowYesCancelDialog(
      title: 'ریست فاکتور',
      description: 'آیا از پاک کردن تمام اطلاعات فرم مطمئن هستید؟',
      onYesButtonTap: () {
        UNavigator.back();
        widget.ctrl.resetForm();
      },
    );
  }
}
