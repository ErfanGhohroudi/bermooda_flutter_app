import '../../data/params/invoice_params.dart';
import '../entities/invoice.dart';
import '../repositories/invoice_repository.dart';

/// UseCase for creating invoice
class CreateInvoiceUseCase {
  CreateInvoiceUseCase(this.repository);

  final InvoiceRepository repository;

  Future<InvoiceEntity> call(final InvoiceParams params) => repository.createInvoice(params);
}
