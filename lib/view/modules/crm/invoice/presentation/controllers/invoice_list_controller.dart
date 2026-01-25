import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../data/repositories/invoice_repository_impl.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/usecases/get_invoices_by_customer.dart';

class InvoiceListController extends GetxController {
  InvoiceListController({required this.customerId});

  final int customerId;
  final InvoiceRepositoryImpl _repository = InvoiceRepositoryImpl();
  late final GetInvoicesByCustomerUseCase _getInvoicesUseCase = GetInvoicesByCustomerUseCase(_repository);

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
}
