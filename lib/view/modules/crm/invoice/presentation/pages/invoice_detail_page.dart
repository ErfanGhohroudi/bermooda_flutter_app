import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../controllers/invoice_detail_controller.dart';
import '../widgets/invoice_summary.dart';

class InvoiceDetailPage extends StatefulWidget {
  const InvoiceDetailPage({
    required this.invoiceId,
    super.key,
  });

  final int invoiceId;

  @override
  State<InvoiceDetailPage> createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends State<InvoiceDetailPage> {
  late final InvoiceDetailController ctrl;

  @override
  void initState() {
    ctrl = Get.put(InvoiceDetailController(invoiceId: widget.invoiceId));
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<InvoiceDetailController>();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(title: Text(s.invoiceDetails)),
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
