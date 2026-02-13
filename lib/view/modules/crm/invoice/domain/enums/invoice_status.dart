import 'package:flutter/material.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/theme.dart';

enum InvoiceStatus {
  issued,
  partial_paid,
  paid,
  expired,
  overdue,
  suspended,
  closed;

  String get title =>
      switch (this) {
        InvoiceStatus.issued => s.issued,
        InvoiceStatus.partial_paid => s.partiallyPaid,
        InvoiceStatus.paid => s.paid,
        InvoiceStatus.expired => s.expired,
        InvoiceStatus.overdue => s.overdueInstallmentStatus,
        InvoiceStatus.suspended => s.suspended,
        InvoiceStatus.closed => s.closed,
      };

  Color get color =>
      switch (this) {
        InvoiceStatus.issued => AppColors.blue,
        InvoiceStatus.partial_paid => AppColors.orange,
        InvoiceStatus.paid => AppColors.green,
        InvoiceStatus.expired => Colors.grey,
        InvoiceStatus.overdue => AppColors.red,
        InvoiceStatus.suspended => Colors.grey,
        InvoiceStatus.closed => Colors.grey,
      };

  static InvoiceStatus fromString(final String title) => switch (title) {
    'issued' => InvoiceStatus.issued,
    'partial_paid' => InvoiceStatus.partial_paid,
    'paid' => InvoiceStatus.paid,
    'expired' => InvoiceStatus.expired,
    'overdue' => InvoiceStatus.overdue,
    'suspended' => InvoiceStatus.suspended,
    'closed' => InvoiceStatus.closed,
    _ => InvoiceStatus.issued,
  };
}