import 'package:decimal/decimal.dart';

import '../../../../../../data/data.dart';

class PayInvoiceParams {
  PayInvoiceParams({
    required this.amount,
    required this.autoApprove,
    required this.trackingCode,
    required this.paymentDate,
    required this.paymentTime,
    required this.receiptFiles,
    this.installmentId,
    this.description,
  });

  final Decimal amount;
  final bool autoApprove;
  final String trackingCode;

  /// YYYY/MM/DD
  final String paymentDate;

  /// HH:MM
  final String paymentTime;

  final List<MainFileReadDto> receiptFiles;

  final int? installmentId;
  final String? description;

  Map<String, dynamic> toMap() => <String, dynamic>{
    'amount': amount,
    if (installmentId != null) 'installment_id_list': [installmentId],
    'tracking_code': trackingCode,
    'description': description,
    'payment_date_jalali': paymentDate,
    'payment_time_str': paymentTime,
    'payment_file_id_list': receiptFiles.map((final f) => f.fileId).whereType<int>().toList(),
    'auto_approve': autoApprove,
  };
}
