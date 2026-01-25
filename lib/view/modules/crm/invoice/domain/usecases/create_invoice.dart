import '../entities/invoice.dart';
import '../repositories/invoice_repository.dart';

/// UseCase for creating invoice
class CreateInvoiceUseCase {
  CreateInvoiceUseCase(this.repository);

  final InvoiceRepository repository;

  Future<InvoiceEntity> call(Map<String, dynamic> params) => repository.createInvoice(params);
}
