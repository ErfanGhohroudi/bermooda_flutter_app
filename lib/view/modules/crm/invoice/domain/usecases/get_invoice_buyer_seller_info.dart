import '../../data/models/models.dart';
import '../repositories/invoice_repository.dart';

/// UseCase for getting invoice by ID
class GetInvoiceBuyerSellerInfoUseCase {
  GetInvoiceBuyerSellerInfoUseCase(this.repository);

  final InvoiceRepository repository;

  Future<InvoiceBuyerSellerInfo> call(final int customerId) => repository.getInvoiceBuyerAndSellerInfo(customerId);
}
