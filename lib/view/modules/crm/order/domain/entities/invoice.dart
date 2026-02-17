import '../../../invoice/domain/entities/invoice.dart';
import 'order.dart';

class InvoiceOrderEntity extends CustomerOrder {
  final InvoiceEntity invoice;

  const InvoiceOrderEntity({
    required this.invoice,
  });

  @override
  List<Object?> get props => [invoice];

  @override
  int get id => invoice.id;
}