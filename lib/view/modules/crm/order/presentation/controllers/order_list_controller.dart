import 'package:decimal/decimal.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../data/data.dart';
import '../../../invoice/data/repositories/invoice_repository_impl.dart';
import '../../../invoice/domain/entities/invoice.dart';
import '../../../invoice/domain/mappers/invoice_mappers.dart';
import '../../../invoice/domain/usecases/payment_verification.dart';
import '../../../invoice/domain/usecases/suspend_invoice.dart';
import '../../../invoice/presentation/pages/create_invoice_page.dart';
import '../../../invoice/presentation/pages/register_payment_page.dart';
import '../../../invoice/presentation/sheets/suspend_invoice_sheet.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/get_orders_by_customer.dart';

class CustomerOrderListController extends GetxController {
  CustomerOrderListController({required this.customerId});

  final int customerId;
  final OrderRepositoryImpl _repository = OrderRepositoryImpl();
  final InvoiceRepositoryImpl _invoiceRepository = InvoiceRepositoryImpl();

  late final GetOrdersByCustomerUseCase _getOrdersUseCase = GetOrdersByCustomerUseCase(_repository);

  late final SuspendInvoiceUseCase _suspendInvoiceUseCase = SuspendInvoiceUseCase(_invoiceRepository);
  late final PaymentVerificationUseCase _paymentVerificationUseCase = PaymentVerificationUseCase(_invoiceRepository);

  final RefreshController refreshController = RefreshController();
  final Rx<PageState> pageState = PageState.initial.obs;
  final RxList<CustomerOrder> orders = <CustomerOrder>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  @override
  void onClose() {
    pageState.close();
    orders.close();
    super.onClose();
  }

  void addOrder(final CustomerOrder order) {
    orders.insert(0, order);
  }

  void updateOrder(final CustomerOrder order) {
    final index = orders.indexWhere((final CustomerOrder item) => item.id == order.id);
    if (index != -1) {
      orders[index] = order;
    }
  }

  Future<void> loadOrders() async {
    try {
      final result = await _getOrdersUseCase(customerId);
      if (orders.subject.isClosed) return;
      orders(result);
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
    await loadOrders();
  }

  Future<void> onTryAgain() async {
    pageState.initial();
    await loadOrders();
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
            loadOrders();
          } else {
            final order = invoice.toOrderEntity();
            updateOrder(order);
          }
        },
      ),
    );
  }

  void onTapCreateInvoice() async {
    final result = await AppNavigator.push<InvoiceEntity>(CreateInvoicePage(customerId: customerId));
    if (result != null) {
      final invoice = result.toOrderEntity();
      addOrder(invoice);
    }
  }

  void onTapCreateContract() async {
    // final result = await AppNavigator.push<InvoiceEntity>(const CreateContractPage());
    // if (result != null) {
    //   final invoice = result.toOrderEntity();
    //   addOrder(invoice);
    // }
  }

  void onTapReCreateInvoice(final InvoiceEntity invoice) async {
    final result = await AppNavigator.push<InvoiceEntity>(CreateInvoicePage(customerId: customerId, invoice: invoice));
    if (result != null) {
      final invoice = result.toOrderEntity();
      addOrder(invoice);
    }
  }

  Future<void> showSuspensionSheet(final InvoiceEntity invoice) async {
    await bottomSheet(
      title: s.suspendInvoice,
      child: SuspendInvoiceSheet(onSubmit: suspendInvoice, invoiceId: invoice.id),
    );
  }

  Future<bool> suspendInvoice(final int invoiceId, final String reason, final int? documentId) async {
    try {
      final result = await _suspendInvoiceUseCase(invoiceId, reason, documentId);

      final index = orders.indexWhere((final e) {
        if (e is! InvoiceOrderEntity) return false;
        return e.id == result.id && e.invoice.invoiceCode == result.invoiceCode;
      });
      if (index == -1) return false;
      orders[index] = result.toOrderEntity();
      orders.refresh();
      AppSnackBar.snackbarGreen(title: s.done, subtitle: s.suspended);
    } catch (e) {
      AppSnackBar.snackbarRed(title: s.error, subtitle: s.error400);
      return false;
    }
    return true;
  }

  Future<GenericResponse<InvoiceEntity>?> onTapInvoicePaymentVerification(
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
        updateOrder(result.result!.toOrderEntity());
      }
      return result;
    } catch (e) {
      return null;
    }
  }
}
