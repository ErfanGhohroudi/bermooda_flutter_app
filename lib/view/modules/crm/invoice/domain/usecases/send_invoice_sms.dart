import '../repositories/invoice_repository.dart';

/// UseCase for sending invoice SMS
class SendInvoiceSmsUseCase {
  SendInvoiceSmsUseCase(this.repository);

  final InvoiceRepository repository;

  Future<void> call(final int invoiceId) => repository.sendInvoiceSms(invoiceId);
}
