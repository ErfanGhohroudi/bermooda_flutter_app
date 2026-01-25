import '../repositories/invoice_repository.dart';

/// UseCase for getting invoice code
class GetInvoiceCodeUseCase {
  GetInvoiceCodeUseCase(this.repository);

  final InvoiceRepository repository;

  Future<String> call() => repository.getInvoiceCode();
}
