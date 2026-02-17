import 'package:flutter/material.dart';

import '../../../invoice/presentation/widgets/invoice_card.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/order.dart';
import '../controllers/order_list_controller.dart';

class WOrderCard extends StatelessWidget {
  const WOrderCard({
    required this.order,
    required this.ctrl,
    super.key,
  });

  final CustomerOrder order;
  final CustomerOrderListController ctrl;

  @override
  Widget build(final BuildContext context) {
    if (order is InvoiceOrderEntity) {
      final invoice = (order as InvoiceOrderEntity).invoice;
      return WInvoiceCard(
        invoice: invoice,
        onTapPay: ctrl.onTapPayInvoice,
        onTapReCreate: () => ctrl.onTapReCreateInvoice(invoice),
        onTapSuspension: () => ctrl.showSuspensionSheet(invoice),
        onTapPaymentVerification: ctrl.onTapInvoicePaymentVerification,
      );
    }
    // if (order is ContractOrderEntity) {
    //   final contract = (order as ContractOrderEntity).contract;
    // }
    return const SizedBox.shrink();
  }
}
