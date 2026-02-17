import '../../../../../../data/data.dart';
import '../../data/params/invoice_params.dart';
import '../../data/params/pay_invoice_params.dart';
import '../entities/invoice.dart';

/// Repository interface for Invoice operations
/// Follows Dependency Inversion Principle - depends on abstraction
abstract class InvoiceRepository {
  /// Get suggested invoice code
  Future<String> getInvoiceCode();

  /// Get list of invoices for a customer
  Future<List<InvoiceEntity>> getInvoicesByCustomer(final int customerId);

  /// Get invoice by ID
  Future<InvoiceEntity> getInvoiceById(final int invoiceId);

  /// Get invoice buyer and seller information
  Future<InvoiceBuyerSellerInfo> getInvoiceBuyerAndSellerInfo(final int customerId);

  /// Create new invoice
  Future<InvoiceEntity> createInvoice(final InvoiceParams params);

  /// Pay invoice (cash/installment payment)
  Future<GenericResponse<PaymentRecord>> payInvoice(final String invoiceMainId, final PayInvoiceParams params);

  /// Suspend invoice
  Future<InvoiceEntity> suspendInvoice(final int invoiceId, final String reason, final int? documentId);

  /// Payment verification : if invoice is installments; [installmentId] is Required.
  Future<InvoiceEntity> paymentVerification(
    final int recordId,
    final bool verify,
    final String reason,
    final int? installmentId,
  );
}
