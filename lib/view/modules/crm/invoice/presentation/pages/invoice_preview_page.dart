import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../controllers/invoice_preview_controller.dart';
import '../widgets/invoice_summary.dart';

class InvoicePreviewPage extends StatefulWidget {
  const InvoicePreviewPage({
    required this.mainId,
    super.key,
  });

  final String mainId;

  @override
  State<InvoicePreviewPage> createState() => _InvoicePreviewPageState();
}

class _InvoicePreviewPageState extends State<InvoicePreviewPage> {
  late final InvoicePreviewController ctrl;

  @override
  void initState() {
    ctrl = Get.put(InvoicePreviewController(mainId: widget.mainId));
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<InvoicePreviewController>();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(title: Text(s.preview)),
      body: Obx(
        () {
          if (ctrl.pageState.isError()) {
            return Center(child: WErrorWidget(onTapButton: ctrl.loadInvoice));
          }

          if (ctrl.pageState.isLoaded() && ctrl.invoice.value != null) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: InvoiceSummary(invoice: ctrl.invoice.value!),
            );
          }

          return const Center(child: WCircularLoading());
        },
      ),
    );
  }
}
