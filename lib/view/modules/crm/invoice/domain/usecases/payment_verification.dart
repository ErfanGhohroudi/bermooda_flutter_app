import '../../../../../../data/data.dart';
import '../entities/invoice.dart';
import '../repositories/invoice_repository.dart';

/// UseCase for verify or reject payment record
class PaymentVerificationUseCase {
  PaymentVerificationUseCase(this.repository);

  final InvoiceRepository repository;

  Future<GenericResponse<InvoiceEntity>> call({
    required final int recordId,
    required final bool verify,
    final String? reason,
    final int? installmentId,
  }) => repository.paymentVerification(
    recordId,
    verify,
    reason,
    installmentId,
  );
}
