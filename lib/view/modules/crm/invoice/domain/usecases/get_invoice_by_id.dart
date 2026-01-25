import '../entities/invoice.dart';
import '../repositories/invoice_repository.dart';

/// UseCase for getting invoice by ID
class GetInvoiceByIdUseCase {
  GetInvoiceByIdUseCase(this.repository);

  final InvoiceRepository repository;

  Future<InvoiceEntity> call(int invoiceId) => repository.getInvoiceById(invoiceId);
}
