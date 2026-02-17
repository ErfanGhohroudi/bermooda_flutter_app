import '../../../../../../data/data.dart';
import '../../data/models/models.dart';
import '../entities/invoice.dart';
import '../repositories/invoice_repository.dart';

/// UseCase for paying invoice
class PayInvoiceUseCase {
  PayInvoiceUseCase(this.repository);

  final InvoiceRepository repository;

  Future<GenericResponse<InvoiceEntity>> call(
    final String invoiceMainId,
    final PayInvoiceParams params,
  ) => repository.payInvoice(invoiceMainId, params);
}
