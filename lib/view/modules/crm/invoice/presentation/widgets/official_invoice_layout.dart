import 'dart:io';
import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../data/data.dart';
import '../../domain/entities/invoice.dart';

class OfficialInvoiceLayout extends StatefulWidget {
  const OfficialInvoiceLayout({
    required this.invoice,
    super.key,
  });

  final InvoiceEntity invoice;

  @override
  State<OfficialInvoiceLayout> createState() => _OfficialInvoiceLayoutState();
}

class _OfficialInvoiceLayoutState extends State<OfficialInvoiceLayout> {
  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> _saveOrPrintInvoice() async {
    try {
      final image = await _screenshotController.capture();
      if (image == null) return;

      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'invoice_${widget.invoice.invoiceCode}_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(image);

      ULaunch.shareFile(
        [file.path],
        'فاکتور ${widget.invoice.invoiceCode}',
      );

      AppNavigator.snackbarGreen(
        title: s.success,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Save/Print Button
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            UElevatedButton(
              title: 'ذخیره / چاپ',
              icon: const Icon(Icons.print, color: Colors.white),
              onTap: _saveOrPrintInvoice,
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Invoice Content wrapped in Screenshot
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
            // Header with Serial Number and Date at top
            _buildHeader(context),
            const SizedBox(height: 24),

            // Seller Information
            if (widget.invoice.sellerInformation != null) ...[
              _buildSellerInfo(context, widget.invoice.sellerInformation!),
              const SizedBox(height: 16),
            ],

            // Buyer Information
            if (widget.invoice.buyerInformation != null) ...[
              _buildBuyerInfo(context, widget.invoice.buyerInformation!),
              const SizedBox(height: 24),
            ],

            // Product Table
            _buildProductTable(context),
            const SizedBox(height: 24),

            // Payment Terms and Description side by side
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Payment Terms
                Expanded(
                  child: _buildPaymentTerms(context),
                ),
                const SizedBox(width: 16),
                // Description
                Expanded(
                  child: _buildDescription(context),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Signatures
            _buildSignatures(context),
          ],
        ),
      ),
        ),
      ],
    );
  }

  Widget _buildHeader(final BuildContext context) {
    return Column(
      children: [
        // Serial Number and Date at top
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Serial Number (right side in RTL)
            Row(
              children: [
                Text(
                  'شماره سریال :',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.invoice.invoiceCode,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            // Date (left side in RTL)
            Row(
              children: [
                Text(
                  'تاریخ :',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.invoice.createdDatePersian,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Title centered
        Text(
          'صورتحساب فروش کالا و خدمات',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSellerInfo(final BuildContext context, final ErInformation seller) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title centered
          Center(
            child: Text(
              'مشخصات فروشنده',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Right Column (in RTL, this appears on the right)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoField('نام شخص حقیقی / حقوقی :', seller.fullnameOrCompanyName ?? '-'),
                    const SizedBox(height: 8),
                    _infoField('نشانی کامل : استان :', seller.stateName ?? '-'),
                    const SizedBox(height: 4),
                    _infoField('شهرستان :', seller.cityName ?? '-'),
                    const SizedBox(height: 4),
                    _infoField('نشانی :', seller.address ?? '-'),
                    const SizedBox(height: 8),
                    _infoField('شماره اقتصادی :', '-'),
                    const SizedBox(height: 8),
                    _infoField('کد پستی ۱۰ رقمی :', '-'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Left Column (in RTL, this appears on the left)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoField('شماره ثبت / شماره ملی :', '-'),
                    const SizedBox(height: 8),
                    _infoField('شهر :', seller.cityName ?? '-'),
                    const SizedBox(height: 8),
                    _infoField('شماره تلفن / نمابر :', seller.phoneNumber ?? '-'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBuyerInfo(final BuildContext context, final ErInformation buyer) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title centered
          Center(
            child: Text(
              'مشخصات خریدار',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Right Column (in RTL, this appears on the right)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoField('نام شخص حقیقی / حقوقی :', buyer.fullnameOrCompanyName ?? '-'),
                    const SizedBox(height: 8),
                    _infoField('نشانی کامل : استان :', buyer.stateName ?? '-'),
                    const SizedBox(height: 4),
                    _infoField('شهرستان :', buyer.cityName ?? '-'),
                    const SizedBox(height: 4),
                    _infoField('نشانی :', buyer.address ?? '-'),
                    const SizedBox(height: 8),
                    _infoField('شماره اقتصادی :', '-'),
                    const SizedBox(height: 8),
                    _infoField('کد پستی ۱۰ رقمی :', '-'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Left Column (in RTL, this appears on the left)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoField('شماره ثبت / شماره ملی :', '-'),
                    const SizedBox(height: 8),
                    _infoField('شهر :', buyer.cityName ?? '-'),
                    const SizedBox(height: 8),
                    _infoField('شماره تلفن / نمابر :', buyer.phoneNumber ?? '-'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoField(final String label, final String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductTable(final BuildContext context) {
    if (widget.invoice.products.isEmpty) {
      return const SizedBox.shrink();
    }

    // Calculate totals for each product
    final productTotals = widget.invoice.products.map((product) {
      final unitPrice = _parsePrice(product.price);
      final total = product.count * unitPrice;
      return total;
    }).toList();

    final totalProductsPrice = productTotals.fold<int>(0, (sum, price) => sum + price);
    final discountAmount = widget.invoice.discount ?? 0;
    final taxAmount = widget.invoice.taxes ?? 0;
    final totalAfterDiscount = totalProductsPrice - discountAmount;
    final totalWithTax = totalAfterDiscount + taxAmount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'مشخصات کالا یا خدمات مورد معامله',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400, width: 1.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Table(
              border: TableBorder.all(color: Colors.grey.shade400, width: 1),
              columnWidths: const {
                0: FixedColumnWidth(50), // Row number
                1: FixedColumnWidth(100), // Product code
                2: FixedColumnWidth(200), // Description
                3: FixedColumnWidth(80), // Quantity
                4: FixedColumnWidth(80), // Unit
                5: FixedColumnWidth(120), // Unit price
                6: FixedColumnWidth(120), // Total amount
                7: FixedColumnWidth(100), // Discount
                8: FixedColumnWidth(120), // Total after discount
                9: FixedColumnWidth(120), // Tax
                10: FixedColumnWidth(140), // Total with tax
              },
              children: [
                // Header row
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade200),
                  children: [
                    _tableCell('ردیف', isHeader: true),
                    _tableCell('کد کالا', isHeader: true),
                    _tableCell('شرح کالا یا خدمات', isHeader: true),
                    _tableCell('تعداد / مقدار', isHeader: true),
                    _tableCell('واحد اندازه گیری', isHeader: true),
                    _tableCell('مبلغ واحد (ریال)', isHeader: true),
                    _tableCell('مبلغ کل (ریال)', isHeader: true),
                    _tableCell('مبلغ تخفیف', isHeader: true),
                    _tableCell('مبلغ کل پس از تخفیف (ریال)', isHeader: true),
                    _tableCell('جمع مالیات و عوارض (ریال)', isHeader: true),
                    _tableCell('جمع مبلغ کل بعلاوه جمع مالیات و عوارض (ریال)', isHeader: true),
                  ],
                ),
                // Product rows
                ...widget.invoice.products.asMap().entries.map((entry) {
                  final index = entry.key;
                  final product = entry.value;
                  final unitPrice = _parsePrice(product.price);
                  final total = productTotals[index];
                  final productDiscount = discountAmount > 0 && totalProductsPrice > 0
                      ? ((total / totalProductsPrice) * discountAmount).round()
                      : 0;
                  final totalAfterDiscount = total - productDiscount;
                  final productTax = taxAmount > 0 && (totalProductsPrice - discountAmount) > 0
                      ? ((totalAfterDiscount / (totalProductsPrice - discountAmount)) * taxAmount).round()
                      : 0;
                  final totalWithTax = totalAfterDiscount + productTax;

                  return TableRow(
                    children: [
                      _tableCell('${index + 1}'),
                      _tableCell(product.code ?? '-'),
                      _tableCell(product.title),
                      _tableCell('${product.count}'),
                      _tableCell(product.unit ?? '-'),
                      _tableCell(_formatPrice(unitPrice)),
                      _tableCell(_formatPrice(total)),
                      _tableCell(productDiscount > 0 ? _formatPrice(productDiscount) : '-'),
                      _tableCell(_formatPrice(totalAfterDiscount)),
                      _tableCell(productTax > 0 ? _formatPrice(productTax) : '-'),
                      _tableCell(_formatPrice(totalWithTax)),
                    ],
                  );
                }),
                // Grand total row
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  children: [
                    _tableCell('جمع کل', isBold: true),
                    _tableCell('', isBold: true),
                    _tableCell('', isBold: true),
                    _tableCell('', isBold: true),
                    _tableCell('', isBold: true),
                    _tableCell('', isBold: true), // Unit price column
                    _tableCell(_formatPrice(totalProductsPrice), isBold: true),
                    _tableCell(discountAmount > 0 ? _formatPrice(discountAmount) : '-', isBold: true),
                    _tableCell(_formatPrice(totalAfterDiscount), isBold: true),
                    _tableCell(taxAmount > 0 ? _formatPrice(taxAmount) : '-', isBold: true),
                    _tableCell(_formatPrice(totalWithTax), isBold: true),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _tableCell(
    final String text, {
    final bool isHeader = false,
    final bool isBold = false,
  }) {
    return TableCell(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isHeader ? 11 : 10,
            fontWeight: isHeader || isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentTerms(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'شرایط و نحوه فروش :',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: widget.invoice.paymentType == PaymentType.cash,
                    onChanged: null,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  const SizedBox(width: 4),
                  const Text('نقدی', style: TextStyle(fontSize: 12)),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  Checkbox(
                    value: widget.invoice.paymentType == PaymentType.installment,
                    onChanged: null,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  const SizedBox(width: 4),
                  const Text('غیر نقدی', style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'توضیحات :',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(minHeight: 60),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              widget.invoice.description ?? '',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignatures(final BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Buyer signature (right side in RTL)
        Expanded(
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400, width: 1.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'مهر و امضاء خریدار',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                // Could add signature image here if available
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Seller signature (left side in RTL)
        Expanded(
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400, width: 1.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'مهر و امضاء فروشنده',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                // Could add signature image here if available
              ],
            ),
          ),
        ),
      ],
    );
  }

  int _parsePrice(final String price) {
    // Remove commas and parse
    final cleanPrice = price.replaceAll(',', '').replaceAll('ریال', '').trim();
    return int.tryParse(cleanPrice) ?? 0;
  }

  String _formatPrice(final int price) {
    return price.toString().separateNumbers3By3();
  }
}
