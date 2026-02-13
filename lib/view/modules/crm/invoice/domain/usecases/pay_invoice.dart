import '../../../../../../data/data.dart';
import '../../data/params/pay_invoice_params.dart';
import '../repositories/invoice_repository.dart';

/// UseCase for paying invoice
class PayInvoiceUseCase {
  PayInvoiceUseCase(this.repository);

  final InvoiceRepository repository;

  Future<GenericResponse<PaymentRecord>> call(
    final String invoiceMainId,
    final PayInvoiceParams params,
  ) => repository.payInvoice(invoiceMainId, params);
}
