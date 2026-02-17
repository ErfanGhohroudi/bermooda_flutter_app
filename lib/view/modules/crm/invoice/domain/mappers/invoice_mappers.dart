import '../../../order/domain/entities/invoice.dart';
import '../entities/invoice.dart';

extension InvoiceMapperExtension on InvoiceEntity {
  InvoiceOrderEntity toOrderEntity() => InvoiceOrderEntity(invoice: this);
}