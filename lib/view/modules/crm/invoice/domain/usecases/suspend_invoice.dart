import '../entities/invoice.dart';
import '../repositories/invoice_repository.dart';

/// UseCase for suspend invoice
class SuspendInvoiceUseCase {
  SuspendInvoiceUseCase(this.repository);

  final InvoiceRepository repository;

  Future<InvoiceEntity> call(
    final int invoiceId,
    final String reason,
    final int? documentId,
  ) => repository.suspendInvoice(
    invoiceId,
    reason,
    documentId,
  );
}
