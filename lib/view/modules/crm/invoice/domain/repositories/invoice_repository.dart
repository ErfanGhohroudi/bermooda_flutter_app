import '../../../../../../data/data.dart';
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

  /// Get invoice preview by main ID (public link)
  Future<InvoiceEntity> getInvoicePreview(final String mainId);

  /// Create new invoice
  Future<InvoiceEntity> createInvoice(final InvoiceParams params);

  /// Change invoice status
  Future<InvoiceEntity> changeInvoiceStatus(final int invoiceId, final int statusId);

  /// Get invoice statuses by group CRM ID
  Future<List<InvoiceStatusReadDto>> getInvoiceStatuses(final int groupCrmId);

  /// Create invoice status
  Future<InvoiceStatusReadDto> createInvoiceStatus(final Map<String, dynamic> params);

  /// Update invoice status
  Future<InvoiceStatusReadDto> updateInvoiceStatus(final int statusId, final Map<String, dynamic> params);

  /// Delete invoice status
  Future<void> deleteInvoiceStatus(final int statusId);

  /// Get installments by invoice ID
  Future<List<Installment>> getInstallments(final int invoiceId);

  /// Pay installments
  Future<void> payInstallments(final Map<String, dynamic> params);

  /// Get payment info for invoice
  Future<InvoiceEntity> getPaymentInfo(final int invoiceId);

  /// Pay invoice (cash payment)
  Future<InvoiceEntity> payInvoice(final int invoiceId, final Map<String, dynamic> params);

  /// Send invoice link via SMS
  Future<void> sendInvoiceSms(final int invoiceId);
}
