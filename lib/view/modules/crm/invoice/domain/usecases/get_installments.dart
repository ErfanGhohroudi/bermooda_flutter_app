import '../../../../../../data/data.dart';
import '../repositories/invoice_repository.dart';

/// UseCase for getting installments
class GetInstallmentsUseCase {
  GetInstallmentsUseCase(this.repository);

  final InvoiceRepository repository;

  Future<List<Installment>> call(final int invoiceId) => repository.getInstallments(invoiceId);
}
