import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/utils/extensions/money_extensions.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../domain/entities/invoice.dart';
import 'invoice_product_list.dart';

class InvoiceSummary extends StatelessWidget {
  const InvoiceSummary({
    required this.invoice,
    super.key,
  });

  final InvoiceEntity invoice;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(invoice.invoiceCode).titleLarge(),
              const SizedBox(height: 8),
              Text('${s.date}: ${invoice.invoiceDate}').bodyMedium(),
              if (invoice.status != null) ...[
                const SizedBox(height: 8),
                Text('${s.status}: ${invoice.status!.title}').bodyMedium(),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        InvoiceProductList(products: invoice.products),
        const SizedBox(height: 16),
        WCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.priceSummary).titleMedium(),
              const SizedBox(height: 8),
              _priceRow(s.totalPrice, invoice.factorPrice.factorPrice.toString().toRialMoney()),
              if (invoice.discountPercentage > 0)
                _priceRow(s.discount, invoice.factorPrice.discountPrice.toString().toRialMoney()),
              if (invoice.taxesPercentage > 0) _priceRow(s.tax, invoice.factorPrice.taxesPrice.toString().toRialMoney()),
              const Divider(),
              _priceRow(s.finalPrice, invoice.factorPrice.finalPrice.toString().toRialMoney(), isBold: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _priceRow(final String label, final String value, {final bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label).bodyMedium(),
          Text(value).bodyMedium(fontWeight: isBold ? FontWeight.bold : null),
        ],
      ),
    );
  }
}
