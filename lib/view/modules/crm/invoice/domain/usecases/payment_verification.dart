import '../entities/invoice.dart';
import '../repositories/invoice_repository.dart';

/// UseCase for verify or reject payment record
class PaymentVerificationUseCase {
  PaymentVerificationUseCase(this.repository);

  final InvoiceRepository repository;

  Future<InvoiceEntity> call({
    required final int recordId,
    required final bool verify,
    required final String reason,
    final int? installmentId,
  }) => repository.paymentVerification(
    recordId,
    verify,
    reason,
    installmentId,
  );
}
