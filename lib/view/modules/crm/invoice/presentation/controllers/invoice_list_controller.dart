import 'package:bermooda_business/core/widgets/widgets.dart';
import 'package:decimal/decimal.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../data/data.dart';
import '../../data/repositories/invoice_repository_impl.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/usecases/get_invoices_by_customer.dart';
import '../../domain/usecases/payment_verification.dart';
import '../../domain/usecases/suspend_invoice.dart';
import '../pages/create_invoice_page.dart';
import '../pages/register_payment_page.dart';
import '../sheets/suspend_invoice_sheet.dart';

class InvoiceListController extends GetxController {
  InvoiceListController({required this.customerId});

  final int customerId;
  final InvoiceRepositoryImpl _repository = InvoiceRepositoryImpl();
  late final GetInvoicesByCustomerUseCase _getInvoicesUseCase = GetInvoicesByCustomerUseCase(_repository);
  late final SuspendInvoiceUseCase _suspendInvoiceUseCase = SuspendInvoiceUseCase(_repository);
  late final PaymentVerificationUseCase _paymentVerificationUseCase = PaymentVerificationUseCase(_repository);

  final RefreshController refreshController = RefreshController();
  final Rx<PageState> pageState = PageState.initial.obs;
  final RxList<InvoiceEntity> invoices = <InvoiceEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadInvoices();
  }

  @override
  void onClose() {
    pageState.close();
    invoices.close();
    super.onClose();
  }

  void addInvoice(final InvoiceEntity invoice) {
    invoices.insert(0, invoice);
  }

  void updateInvoice(final InvoiceEntity invoice) {
    final index = invoices.indexWhere((final item) => item.id == invoice.id);
    if (index != -1) {
      invoices[index] = invoice;
    }
  }

  Future<void> loadInvoices() async {
    try {
      final result = await _getInvoicesUseCase(customerId);
      if (invoices.subject.isClosed) return;
      invoices(result);
      refreshController.refreshCompleted();
      pageState.loaded();
    } catch (e) {
      if (pageState.isInitial()) {
        pageState.error();
      }
      refreshController.refreshFailed();
    }
  }

  Future<void> onRefresh() async {
    await loadInvoices();
  }

  Future<void> onTryAgain() async {
    pageState.initial();
    await loadInvoices();
  }

  void onTapPayInvoice(final String invoiceMainId, final int? installmentId, final Decimal amount) {
    AppNavigator.push(
      RegisterPaymentPage(
        invoiceMainId: invoiceMainId,
        installmentId: installmentId,
        amount: amount,
        onResponse: (final invoice) {
          if (invoice == null) {
            pageState.initial();
            loadInvoices();
          } else {
            updateInvoice(invoice);
          }
        },
      ),
    );
  }

  void onTapReCreate(final InvoiceEntity invoice) {
    UNavigator.push(CreateInvoicePage(customerId: customerId, invoice: invoice));
  }

  Future<void> showSuspensionSheet(final InvoiceEntity invoice) async {
    await bottomSheet(
      title: s.suspendInvoice,
      child: SuspendInvoiceSheet(ctrl: this, invoiceId: invoice.id),
    );
  }

  Future<bool> suspendInvoice(final int invoiceId, final String reason, final int? documentId) async {
    try {
      final result = await _suspendInvoiceUseCase(invoiceId, reason, documentId);

      final index = invoices.indexWhere((final e) => e.id == result.id && e.invoiceCode == result.invoiceCode);
      if (index == -1) return false;
      invoices[index] = result;
      invoices.refresh();
      AppSnackBar.snackbarGreen(title: s.done, subtitle: s.suspended);
    } catch (e) {
      AppSnackBar.snackbarRed(title: s.error, subtitle: s.error400);
      return false;
    }
    return true;
  }

  Future<GenericResponse<InvoiceEntity>?> onTapPaymentVerification(
    final int recordId,
    final bool verify,
    final String? reason,
    final int? installmentId,
  ) async {
    try {
      final result = await _paymentVerificationUseCase(
        recordId: recordId,
        verify: verify,
        reason: reason,
        installmentId: installmentId,
      );
      if (result.result != null) {
        updateInvoice(result.result!);
      }
      return result;
    } catch (e) {
      return null;
    }
  }
}
