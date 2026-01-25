import 'package:u/utilities.dart';

import '../../data/repositories/invoice_repository_impl.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/usecases/get_invoice_by_id.dart';
import '../../domain/usecases/update_invoice_status.dart';
import '../../domain/usecases/send_invoice_sms.dart';

class InvoiceDetailController extends GetxController {
  InvoiceDetailController({required this.invoiceId});

  final int invoiceId;
  final InvoiceRepositoryImpl _repository = InvoiceRepositoryImpl();
  late final GetInvoiceByIdUseCase _getInvoiceUseCase = GetInvoiceByIdUseCase(_repository);
  late final UpdateInvoiceStatusUseCase _updateStatusUseCase = UpdateInvoiceStatusUseCase(_repository);
  late final SendInvoiceSmsUseCase _sendSmsUseCase = SendInvoiceSmsUseCase(_repository);
  
  final Rx<PageState> pageState = PageState.initial.obs;
  final Rx<InvoiceEntity?> invoice = Rx<InvoiceEntity?>(null);

  @override
  void onInit() {
    super.onInit();
    loadInvoice();
  }

  @override
  void onClose() {
    pageState.close();
    invoice.close();
    super.onClose();
  }

  Future<void> loadInvoice() async {
    try {
      pageState.loading();
      final result = await _getInvoiceUseCase(invoiceId);
      if (invoice.subject.isClosed) return;
      invoice(result);
      pageState.loaded();
    } catch (e) {
      pageState.error();
    }
  }

  Future<void> changeStatus(final int statusId) async {
    try {
      final result = await _updateStatusUseCase(invoiceId, statusId);
      if (invoice.subject.isClosed) return;
      invoice(result);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> sendSms() async {
    try {
      await _sendSmsUseCase(invoiceId);
      // Show success message
    } catch (e) {
      // Handle error
    }
  }
}
