import '../entities/invoice.dart';
import '../repositories/invoice_repository.dart';

/// UseCase for updating invoice status
class UpdateInvoiceStatusUseCase {
  UpdateInvoiceStatusUseCase(this.repository);

  final InvoiceRepository repository;

  Future<InvoiceEntity> call(int invoiceId, int statusId) => repository.changeInvoiceStatus(invoiceId, statusId);
}
