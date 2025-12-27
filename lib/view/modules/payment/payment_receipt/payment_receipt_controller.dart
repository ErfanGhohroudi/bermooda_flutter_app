import 'package:u/utilities.dart';

import '../../../../core/utils/extensions/money_extensions.dart';
import '../../../../core/constants.dart';
import '../../../../data/data.dart';
import 'payment_receipt_page.dart';

mixin PaymentReceiptController {
  late final String _invoiceCode;
  late final PaymentReceiptStatus _status;
  final SubscriptionInvoiceDatasource _datasource = Get.find<SubscriptionInvoiceDatasource>();
  final Rx<PageState> pageState = PageState.loading.obs;

  SubscriptionInvoiceReadDto invoice = const SubscriptionInvoiceReadDto(slug: '', invoiceCode: '', title: '');

  bool get isSuccess => _status == PaymentReceiptStatus.success;

  void initialController({
    required final PaymentReceiptStatus status,
    required final String invoiceCode,
  }) {
    _invoiceCode = invoiceCode;
    _status = status;
    _getInvoice();
  }

  void onTryAgain() {
    pageState.loading();
    _getInvoice();
  }

  void disposeItems() {
    pageState.close();
  }

  void _getInvoice() {
    _datasource.getPaymentInvoiceDetails(
      invoiceCode: _invoiceCode,
      onResponse: (final response) {
        if (pageState.subject.isClosed || response.result == null) return;
        invoice = response.result!;
        pageState.loaded();
      },
      onError: (final errorResponse) {
        pageState.error();
      },
    );
  }

  void shareInvoice() {
    final StringBuffer invoiceText = StringBuffer();

    // Header
    invoiceText.writeln('رسید ${invoice.title}');
    invoiceText.writeln();

    // Invoice details
    invoiceText.writeln('شماره فاکتور: ${invoice.invoiceCode}');
    invoiceText.writeln('مبلغ: ${getFormattedPrice()}');
    invoiceText.writeln('تاریخ پرداخت: ${getCurrentDate()}');
    invoiceText.writeln('شماره تراکنش: ${invoice.trackId ?? '- -'}');
    invoiceText.writeln('شماره مرجع: ${invoice.refNumber ?? '- -'}');
    invoiceText.writeln('شماره کارت: ${invoice.cardNumber ?? '- -'}');

    // Status
    final statusText = isSuccess ? 'پرداخت موفق' : 'پرداخت ناموفق';
    invoiceText.writeln('وضعیت: ${isSuccess ? "✅" : "❌"} $statusText');

    // Description
    if (invoice.description != null && invoice.description!.isNotEmpty) {
      invoiceText.writeln('📝 توضیحات: ${invoice.description}');
    }
    invoiceText.writeln();
    invoiceText.writeln('برمودا - سیستم مدیریت کسب و کار');
    invoiceText.writeln(AppConstants.websiteAddress);

    // Share the formatted text
    ULaunch.shareText(invoiceText.toString());
  }

  String getCurrentDate() {
    final date = invoice.paidAt?.toJalali();
    if (date == null) return '- -';
    return "${date.formatCompactDate()} - ${_getCurrentTime()}";
  }

  String _getCurrentTime() {
    final date = invoice.paidAt?.toJalali();
    if (date == null) return '- -';
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
  }

  String getFormattedPrice() {
    if (invoice.price == 0) return '- -';
    return invoice.price.toString().toTomanMoney();
  }
}
