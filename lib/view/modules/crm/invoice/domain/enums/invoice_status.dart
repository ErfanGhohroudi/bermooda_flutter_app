import 'package:flutter/material.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/theme.dart';

enum InvoiceStatus {
  // preInvoices only have these status
  confirmed,
  revised,

  // final invoices only have these status
  partial_paid,
  paid,
  expired,
  overdue,
  suspended,

  // common status for both
  issued,
  closed;

  String get title =>
      switch (this) {
        InvoiceStatus.confirmed => s.confirmed,
        InvoiceStatus.revised => s.revised,
        //
        InvoiceStatus.partial_paid => s.partiallyPaid,
        InvoiceStatus.paid => s.paid,
        InvoiceStatus.expired => s.expired,
        InvoiceStatus.overdue => s.overdueInstallmentStatus,
        InvoiceStatus.suspended => s.suspended,
        //
        InvoiceStatus.issued => s.issued,
        InvoiceStatus.closed => s.closed,
      };

  Color get color =>
      switch (this) {
        InvoiceStatus.confirmed => AppColors.green,
        InvoiceStatus.revised => AppColors.orange,
        //
        InvoiceStatus.partial_paid => AppColors.orange,
        InvoiceStatus.paid => AppColors.green,
        InvoiceStatus.expired => Colors.grey,
        InvoiceStatus.overdue => AppColors.red,
        InvoiceStatus.suspended => Colors.grey,
        //
        InvoiceStatus.issued => AppColors.blue,
        InvoiceStatus.closed => Colors.grey,
      };

  static InvoiceStatus fromString(final String title) => switch (title) {
    'confirmed' => InvoiceStatus.confirmed,
    'revised' => InvoiceStatus.revised,
    //
    'partial_paid' => InvoiceStatus.partial_paid,
    'paid' => InvoiceStatus.paid,
    'expired' => InvoiceStatus.expired,
    'overdue' => InvoiceStatus.overdue,
    'suspended' => InvoiceStatus.suspended,
    //
    'issued' => InvoiceStatus.issued,
    'closed' => InvoiceStatus.closed,
    _ => InvoiceStatus.issued,
  };
}