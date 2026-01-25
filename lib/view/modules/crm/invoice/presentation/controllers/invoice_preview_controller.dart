import 'package:u/utilities.dart';

import '../../data/repositories/invoice_repository_impl.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/usecases/get_invoice_preview.dart';

class InvoicePreviewController extends GetxController {
  InvoicePreviewController({required this.mainId});

  final String mainId;
  final InvoiceRepositoryImpl _repository = InvoiceRepositoryImpl();
  late final GetInvoicePreviewUseCase _getPreviewUseCase = GetInvoicePreviewUseCase(_repository);
  
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
      final result = await _getPreviewUseCase(mainId);
      if (invoice.subject.isClosed) return;
      invoice(result);
      pageState.loaded();
    } catch (e) {
      pageState.error();
    }
  }
}
