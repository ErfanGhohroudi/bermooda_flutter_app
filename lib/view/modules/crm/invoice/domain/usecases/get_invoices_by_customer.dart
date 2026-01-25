import '../entities/invoice.dart';
import '../repositories/invoice_repository.dart';

/// UseCase for getting invoices by customer
class GetInvoicesByCustomerUseCase {
  GetInvoicesByCustomerUseCase(this.repository);

  final InvoiceRepository repository;

  Future<List<InvoiceEntity>> call(int customerId) => repository.getInvoicesByCustomer(customerId);
}
