import '../entities/invoice.dart';
import '../repositories/invoice_repository.dart';

/// UseCase for paying invoice
class PayInvoiceUseCase {
  PayInvoiceUseCase(this.repository);

  final InvoiceRepository repository;

  Future<InvoiceEntity> call(
    final int invoiceId,
    final Map<String, dynamic> params,
  ) => repository.payInvoice(invoiceId, params);
}
