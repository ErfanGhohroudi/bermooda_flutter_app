import 'package:decimal/decimal.dart';
import 'package:gal/gal.dart';
import 'package:open_filex/open_filex.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../core/utils/extensions/money_extensions.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../data/data.dart';
import '../../domain/entities/invoice.dart';
import '../controllers/create_invoice_controller.dart';
import '../widgets/installments_table.dart';

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

  CreateInvoiceController get ctrl => widget.ctrl;

  static const productRowCellsWidth = <double>[
    20, // index (ردیف)
    50, // code (کد کالا)
    150, // description (شرح کالا یا خدمات)
    40, // quantity (تعداد)
    60, // unit (واحد اندازه‌گیری)
    100, // unit price (مبلغ واحد)
    120, // total price (مبلغ کل)
    100, // discount (مبلغ تخفیف)
    120, // total after discount (مبلغ کل پس از تخفیف)
    120, // tax (جمع مالیات و عوارض)
    150, // grand total (جمع کل)
  ];

  static const headerCellPadding = 8.0;
  static const rowCellPadding = 10.0;

  Future<void> _printOrSaveInvoice() async {
    try {
      final image = await _screenshotController.capture();
      if (image == null) return;

      // Request permission
      final haveAccessToGallery = await Gal.requestAccess();

      if (haveAccessToGallery) {
        final directory = await getApplicationDocumentsDirectory();
        final fileName = 'invoice_${ctrl.invoiceCodeController.text}_${DateTime.now().millisecondsSinceEpoch}.png';
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(image);

        await Gal.putImage(file.path);

        ULaunch.shareFile(
          [file.path],
          '${s.invoice} ${ctrl.invoiceCodeController.text}',
        );

        AppNavigator.snackbarGreen(
          title: s.done,
          subtitle: 'فاکتور ذخیره شد',
        );
      } else {
        AppNavigator.snackbarRed(title: s.error, subtitle: s.galleryPermissionDenied);
      }
    } catch (e) {
      AppNavigator.snackbarRed(
        title: s.error,
        subtitle: 'خطا در ذخیره فاکتور',
      );
    }
  }

  Future<void> _captureAndSavePdf() async {
    // گرفتن اسکرین‌شات و دریافت داده‌ها به صورت بایت (Uint8List)
    final Uint8List? imageBytes = await _screenshotController.capture();

    if (imageBytes == null) {
      AppNavigator.snackbarRed(title: s.error, subtitle: 'خطا در ذخیره فاکتور');
      return;
    }

    // ۱. ایجاد یک سند PDF جدید با Syncfusion
    final PdfDocument document = PdfDocument();

    // ۲. افزودن یک صفحه به سند
    final PdfPage page = document.pages.add();

    // ۳. بارگذاری تصویر اسکرین‌شات در یک آبجکت PdfBitmap
    final PdfBitmap image = PdfBitmap(imageBytes);

    // ۴. رسم کردن تصویر بر روی صفحه PDF
    // می‌توانید ابعاد و موقعیت تصویر را به دلخواه تنظیم کنید
    page.graphics.drawImage(
      image,
      Rect.fromCenter(
        center: const Offset(0, 0),
        width: 500,
        height: 500,
      ), // Rect.fromLTWH(0, 0, page.getClientSize().width, page.getClientSize().height) برای تمام صفحه
      // const Rect.fromLTWH(0, 0, 0, 0), // Rect.fromLTWH(0, 0, page.getClientSize().width, page.getClientSize().height) برای تمام صفحه
    );

    // ۵. ذخیره کردن سند در قالب لیستی از بایت‌ها
    final List<int> bytes = await document.save();

    // ۶. آزاد کردن منابع سند (بسیار مهم)
    document.dispose();

    // پیدا کردن مسیر برای ذخیره فایل
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'invoice_${ctrl.invoiceCodeController.text}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${directory.path}/$fileName');

    // ذخیره کردن فایل PDF در دستگاه
    await file.writeAsBytes(bytes);

    // نمایش پیغام موفقیت و دکمه برای باز کردن فایل
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(s.pdfSavedAt(file.path)),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'باز کردن',
          onPressed: () {
            // باز کردن فایل PDF
            OpenFilex.open(file.path);
          },
        ),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 10, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          // Invoice Preview (Printable)
          Screenshot(
            controller: _screenshotController,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.theme.dividerColor),
              ),
              child: _buildInvoiceContent(context),
            ),
          ),

          // Action Button
          // UElevatedButton(
          //   title: 'چاپ / ذخیره PDF',
          //   backgroundColor: AppColors.green,
          //   icon: const Icon(Icons.print, color: Colors.white),
          //   onTap: _captureAndSavePdf,
          // ).alignAtCenter(),
        ],
      ),
    );
  }

  Widget _buildInvoiceContent(final BuildContext context) {
    final buyerInfoIsNotEmpty = ctrl.buyerInfo != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        _buildHeader(context),
        const SizedBox(height: 10),

        // Invoice Info
        // _buildInvoiceInfo(context),
        // const SizedBox(height: 24),

        // Buyer and Seller Info
        if (ctrl.sellerInfo.value != null || buyerInfoIsNotEmpty) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (ctrl.sellerInfo.value != null) _buildSellerInfo(context, ctrl.sellerInfo.value!),
              const SizedBox(height: 10),
              if (buyerInfoIsNotEmpty) _buildBuyerInfo(context, ctrl.buyerInfo!),
            ],
          ),
          const SizedBox(height: 24),
        ],

        // Products Table
        _buildProductsTable(context),
        const SizedBox(height: 24),

        // Price Summary
        _buildPriceSummary(context),
        const SizedBox(height: 24),

        // Installments (if applicable)
        Obx(
          () {
            if (ctrl.selectedPaymentTerms.value == PaymentTerms.installment && ctrl.installmentPayments.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.installments).titleMedium(color: context.theme.hintColor),
                  const SizedBox(height: 8),
                  WInstallmentsTable(
                    installmentPayments: ctrl.installmentPayments,
                  ),
                  const SizedBox(height: 16),
                  Text(s.installmentInterestNotice).bodySmall(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(s.salesInvoiceTitle).titleMedium(color: context.theme.primaryColor).bold().alignAtCenter(),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 24,
          children: [
            Text('${s.invoiceId}: ${ctrl.invoiceCode}').bodySmall(),
            if (ctrl.createdDate != null) Text('${s.date}: ${ctrl.createdDate!.formatCompactDate()}').bodySmall(),
          ],
        ),
        Divider(color: context.theme.primaryColor),
      ],
    );
  }

  Widget _buildInvoiceInfo(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.theme.dividerColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.theme.dividerColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (ctrl.selectedInvoiceType.value != null)
            _infoItem(
              context,
              s.invoiceType,
              ctrl.selectedInvoiceType.value?.getTitle() ?? '',
            ),
          if (ctrl.createdDate != null)
            _infoItem(
              context,
              s.dateOfEntry,
              ctrl.createdDate!.formatCompactDate(),
            ),
          if (ctrl.validityDate != null)
            _infoItem(
              context,
              s.validityDate,
              ctrl.validityDate!.formatCompactDate(),
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

  Widget _buildBuyerInfo(final BuildContext context, final BuyerInfo buyer) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.buyer).titleMedium(color: context.theme.primaryColor),
          const Divider(height: 16),
          _infoRow(context, s.name, buyer.name),
          _infoRow(context, s.phoneNumber, buyer.phoneNumber),
          if (buyer.nationalCode != null) _infoRow(context, s.nationalID, buyer.nationalCode ?? ''),
          if (buyer.economicCode != null) _infoRow(context, s.economicCode, buyer.economicCode ?? ''),
          if (buyer.state?.title != null) _infoRow(context, s.state, buyer.state?.title ?? ''),
          if (buyer.city?.title != null) _infoRow(context, s.city, buyer.city?.title ?? ''),
          if (buyer.address.isNotEmpty) _infoRow(context, s.address, buyer.address),
        ],
      ),
    );
  }

  Widget _buildSellerInfo(final BuildContext context, final SellerInfo seller) {
    final isLegal = seller.normalizedPersonalType == AuthenticationType.legal;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.seller).titleMedium(color: context.theme.primaryColor),
          const Divider(height: 16),
          _infoRow(context, s.name, seller.name),
          _infoRow(context, s.phoneNumber, seller.phoneNumber),
          if (seller.faxNumber != null) _infoRow(context, s.fax, seller.faxNumber ?? ''),
          if (seller.nationalCode != null)
            _infoRow(context, isLegal ? s.companyNationalID : s.nationalID, seller.nationalCode ?? ''),
          if (seller.registrationNumber != null && isLegal)
            _infoRow(context, s.registrationNumber, seller.registrationNumber ?? ''),
          if (seller.economicNumber != null && isLegal) _infoRow(context, s.economicCode, seller.economicNumber ?? ''),
          if (seller.email != null && seller.email!.isNotEmpty) _infoRow(context, s.email, seller.email!),
          if (seller.state?.title != null) _infoRow(context, s.state, seller.state!.title!),
          if (seller.city?.title != null) _infoRow(context, s.city, seller.city!.title!),
          _infoRow(context, s.address, seller.address),
          if (seller.postalCode != null) _infoRow(context, s.postalCode, seller.postalCode ?? ''),
        ],
      ),
    );
  }

  Widget _buildProductsTable(final BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        border: Border.all(color: context.theme.dividerColor, width: 2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Theme(
        data: ThemeData(
          scrollbarTheme: context.theme.scrollbarTheme.copyWith(
            thumbColor: const WidgetStatePropertyAll(AppColors.green),
          ),
        ),
        child: Scrollbar(
          trackVisibility: true,
          thumbVisibility: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: context.width - 32,
              ),
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Table Header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      color: context.theme.primaryColor.withValues(alpha: 0.1),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            _buildHeaderCell('#', productRowCellsWidth[0]),
                            const VerticalDivider(),
                            _buildHeaderCell(s.productCode, productRowCellsWidth[1]),
                            const VerticalDivider(),
                            _buildHeaderCell(s.productService, productRowCellsWidth[2]),
                            const VerticalDivider(),
                            _buildHeaderCell(s.count, productRowCellsWidth[3]),
                            const VerticalDivider(),
                            _buildHeaderCell(s.unit, productRowCellsWidth[4]),
                            const VerticalDivider(),
                            _buildHeaderCell(s.unitPrice, productRowCellsWidth[5], hasCurrency: true),
                            const VerticalDivider(),
                            _buildHeaderCell(s.totalPrice, productRowCellsWidth[6], hasCurrency: true),
                            const VerticalDivider(),
                            _buildHeaderCell(s.discount, productRowCellsWidth[7], hasCurrency: true),
                            const VerticalDivider(),
                            _buildHeaderCell(s.totalPriceAfterDiscount, productRowCellsWidth[8], hasCurrency: true),
                            const VerticalDivider(),
                            _buildHeaderCell(s.tax, productRowCellsWidth[9], hasCurrency: true),
                            const VerticalDivider(),
                            _buildHeaderCell(s.totalWithTax, productRowCellsWidth[10], hasCurrency: true),
                          ],
                        ),
                      ),
                    ),

                    // Products Table Rows
                    ...ctrl.products.asMap().entries.map((final entry) {
                      return _buildProductRow(context, entry.key, entry.value);
                    }),

                    // Summary Row
                    _buildTableSummaryRow(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCell(final String title, final double width, {final bool hasCurrency = false}) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
          ).bodySmall().alignAtCenter(),
          if (hasCurrency)
            Text(
              '(${s.rial})',
              textAlign: TextAlign.center,
            ).bodySmall(fontSize: 8, color: context.theme.hintColor).alignAtCenter(),
        ],
      ).pSymmetric(vertical: headerCellPadding),
    );
  }

  Widget _buildProductRow(final BuildContext context, final int index, final InvoiceProduct product) {
    final unitPrice = Decimal.tryParse(product.price.numericOnly()) ?? Decimal.zero;
    final count = product.count.toDecimal();
    final totalPrice = unitPrice * count;

    final discountPercent = ctrl.discountPercentage.value.toDecimal();
    final discountAmount = (totalPrice.toRational() * (discountPercent.toRational() / 100.toDecimal().toRational())).toDecimal();

    final totalAfterDiscount = totalPrice - discountAmount;

    final taxPercent = ctrl.taxesPercentage.value.toDecimal();
    final taxAmount = (totalAfterDiscount.toRational() * (taxPercent.toRational() / 100.toDecimal().toRational())).toDecimal();

    final grandTotal = totalAfterDiscount + taxAmount;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: index.isEven ? Colors.white : Colors.grey.shade50,
        border: Border(
          top: BorderSide(color: context.theme.dividerColor),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _buildDataCell((index + 1).toString(), productRowCellsWidth[0]),
            const VerticalDivider(),
            _buildDataCell(product.code ?? '-', productRowCellsWidth[1]),
            const VerticalDivider(),
            _buildDataCell(product.title, productRowCellsWidth[2], isDescription: true),
            const VerticalDivider(),
            _buildDataCell(product.count.toString(), productRowCellsWidth[3]),
            const VerticalDivider(),
            _buildDataCell(product.unit ?? '-', productRowCellsWidth[4]),
            const VerticalDivider(),
            _buildDataCell(unitPrice.toString().toRialMoney(), productRowCellsWidth[5]),
            const VerticalDivider(),
            _buildDataCell(totalPrice.toString().toRialMoney(), productRowCellsWidth[6]),
            const VerticalDivider(),
            _buildDataCell(discountAmount.toStringAsFixed(0).toRialMoney(), productRowCellsWidth[7]),
            const VerticalDivider(),
            _buildDataCell(totalAfterDiscount.toStringAsFixed(0).toRialMoney(), productRowCellsWidth[8]),
            const VerticalDivider(),
            _buildDataCell(taxAmount.toStringAsFixed(0).toRialMoney(), productRowCellsWidth[9]),
            const VerticalDivider(),
            _buildDataCell(grandTotal.toStringAsFixed(0).toRialMoney(), productRowCellsWidth[10], isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildDataCell(final String text, final double width, {final bool isDescription = false, final bool isBold = false}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        textAlign: isDescription ? TextAlign.start : TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ).bodySmall(fontWeight: isBold ? FontWeight.bold : null).pSymmetric(vertical: rowCellPadding),
    );
  }

  Widget _buildTableSummaryRow(final BuildContext context) {
    final totalProductsPrice = ctrl.totalProductsPrice;
    final totalDiscount = ctrl.discountAmount;
    final totalAfterDiscount = totalProductsPrice - totalDiscount;
    final totalTax = ctrl.taxAmount;
    final grandTotal = ctrl.finalPrice;

    // Calculate width for the first combined cell (Index + Code + Description)
    // Each VerticalDivider has a default width of 16.0
    final firstThreeColumnsWidth = productRowCellsWidth[0] + productRowCellsWidth[1] + productRowCellsWidth[2] + 32.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: context.theme.dividerColor.withValues(alpha: 0.3),
        border: Border(
          top: BorderSide(color: context.theme.dividerColor, width: 2),
          bottom: BorderSide(color: context.theme.dividerColor, width: 2),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            SizedBox(
              width: firstThreeColumnsWidth,
              child: Text(
                s.total,
                textAlign: TextAlign.center,
              ).bodySmall(fontWeight: FontWeight.bold).pSymmetric(vertical: rowCellPadding),
            ),
            const VerticalDivider(),
            SizedBox(
              width: productRowCellsWidth[3],
              child: Text(
                ctrl.products.fold<int>(0, (final sum, final p) => sum + p.count).toString(),
                textAlign: TextAlign.center,
              ).bodySmall(fontWeight: FontWeight.bold).pSymmetric(vertical: rowCellPadding),
            ),
            const VerticalDivider(),
            SizedBox(width: productRowCellsWidth[4]), // Unit
            const VerticalDivider(),
            SizedBox(width: productRowCellsWidth[5]), // Unit Price
            const VerticalDivider(),
            _buildDataCell(totalProductsPrice.toString().toRialMoney(), productRowCellsWidth[6], isBold: true),
            const VerticalDivider(),
            _buildDataCell(totalDiscount.toStringAsFixed(0).toRialMoney(), productRowCellsWidth[7], isBold: true),
            const VerticalDivider(),
            _buildDataCell(totalAfterDiscount.toStringAsFixed(0).toRialMoney(), productRowCellsWidth[8], isBold: true),
            const VerticalDivider(),
            _buildDataCell(totalTax.toStringAsFixed(0).toRialMoney(), productRowCellsWidth[9], isBold: true),
            const VerticalDivider(),
            _buildDataCell(grandTotal.toStringAsFixed(0).toRialMoney(), productRowCellsWidth[10], isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSummary(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.theme.dividerColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          _summaryRow(s.totalAmountOfProductsServices, ctrl.totalProductsPrice.toStringAsFixed(0).toRialMoney()),
          if (ctrl.discountAmount > 0.toDecimal())
            _summaryRow(
              s.discount,
              '- ${ctrl.discountAmount.toStringAsFixed(0).toRialMoney()}',
              color: AppColors.red,
            ),
          if (ctrl.taxAmount > 0.toDecimal())
            _summaryRow(
              s.tax,
              '+ ${ctrl.taxAmount.toStringAsFixed(0).toRialMoney()}',
              color: AppColors.green,
            ),
          if (ctrl.shippingCostAmount > 0)
            _summaryRow(
              s.shippingCost,
              '+ ${ctrl.shippingCostAmount.toStringAsFixed(0).toRialMoney()}',
              color: AppColors.green,
            ),
          Obx(
            () {
              if (ctrl.selectedPaymentTerms.value == PaymentTerms.installment && ctrl.interestAmount > 0.toDecimal()) {
                return _summaryRow(
                  s.interestRate,
                  '+ ${ctrl.interestAmount.toStringAsFixed(0).toRialMoney()}',
                  color: AppColors.green,
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const Divider(height: 24),
          _summaryRow(
            s.payable,
            ctrl.finalPriceWithInterest.round().toRialMoney(),
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    final String label,
    final String value, {
    final bool isBold = false,
    final Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 10,
        children: [
          Flexible(child: Text(label).bodyMedium(fontWeight: isBold ? FontWeight.bold : null)),
          Flexible(
            child: Text(value).bodyMedium(
              fontWeight: isBold ? FontWeight.bold : null,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(final BuildContext context) {
    return Container(
      width: context.width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        spacing: 8,
        children: [
          Text(s.thanksForTrust).titleMedium(color: context.theme.primaryColor),
          Text(s.electronicInvoiceNotice).bodyMedium(color: context.theme.hintColor),
        ],
      ),
    );
  }

  Widget _infoRow(final BuildContext context, final String label, final String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          Text('$label:').bodySmall(color: context.theme.hintColor),
          Text(value).bodySmall().expanded(),
        ],
      ),
    );
  }
}
