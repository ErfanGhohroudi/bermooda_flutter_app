import '../entities/invoice.dart';
import '../repositories/invoice_repository.dart';

/// UseCase for getting invoice preview
class GetInvoicePreviewUseCase {
  GetInvoicePreviewUseCase(this.repository);

  final InvoiceRepository repository;

  Future<InvoiceEntity> call(final String mainId) => repository.getInvoicePreview(mainId);
}
