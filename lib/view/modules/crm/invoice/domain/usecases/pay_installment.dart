import '../repositories/invoice_repository.dart';

/// UseCase for paying installment
class PayInstallmentUseCase {
  PayInstallmentUseCase(this.repository);

  final InvoiceRepository repository;

  Future<void> call(final Map<String, dynamic> params) => repository.payInstallments(params);
}
