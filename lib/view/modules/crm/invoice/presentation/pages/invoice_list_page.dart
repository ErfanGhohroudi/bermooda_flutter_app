import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../controllers/invoice_list_controller.dart';
import '../widgets/invoice_card.dart';
import 'create_invoice_page.dart';

class InvoiceListPage extends StatefulWidget {
  const InvoiceListPage({
    required this.customerId,
    super.key,
  });

  final int customerId;

  @override
  State<InvoiceListPage> createState() => _InvoiceListPageState();
}

class _InvoiceListPageState extends State<InvoiceListPage> {
  late final InvoiceListController ctrl;

  @override
  void initState() {
    ctrl = Get.put(InvoiceListController(customerId: widget.customerId));
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<InvoiceListController>();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      floatingActionButtonLocation: isPersianLang
          ? FloatingActionButtonLocation.startFloat
          : FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: "invoice_list_fab",
        onPressed: () {
          AppNavigator.push(CreateInvoicePage(customerId: widget.customerId));
        },
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
      body: Obx(
        () {
          if (ctrl.pageState.isInitial() || ctrl.pageState.isLoading()) {
            return const Center(child: WCircularLoading());
          }

          if (ctrl.pageState.isError()) {
            return Center(child: WErrorWidget(onTapButton: ctrl.onRefresh));
          }

          if (ctrl.pageState.isLoaded() && ctrl.invoices.isEmpty) {
            return const Center(child: WEmptyWidget());
          }

          return WSmartRefresher(
            controller: ctrl.refreshController,
            onRefresh: ctrl.onRefresh,
            enablePullUp: false,
            child: ListView.separated(
              itemCount: ctrl.invoices.length,
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 100),
              separatorBuilder: (final context, final index) => const SizedBox(height: 8),
              itemBuilder: (final context, final index) {
                final invoice = ctrl.invoices[index];
                return WInvoiceCard(
                  invoice: invoice,
                  onTapPay: ctrl.onTapPayInvoice,
                  onTapReCreate: () => ctrl.onTapReCreate(invoice),
                  onTapSuspension: () => ctrl.showSuspensionSheet(invoice),
                  onTapPaymentVerification: ctrl.onTapPaymentVerification,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
