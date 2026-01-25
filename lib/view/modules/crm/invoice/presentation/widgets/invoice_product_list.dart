import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../domain/entities/invoice.dart';

class InvoiceProductList extends StatelessWidget {
  const InvoiceProductList({
    required this.products,
    super.key,
  });

  final List<InvoiceProduct> products;

  @override
  Widget build(final BuildContext context) {
    return WCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.productsOrServices).titleMedium(),
          const SizedBox(height: 8),
          ...products.map((final product) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.title).bodyMedium(),
                          if (product.code != null)
                            Text('${s.productCode}: ${product.code}').bodySmall(color: context.theme.hintColor),
                        ],
                      ),
                    ),
                    Text('${product.count} ${product.unit ?? ''}').bodyMedium(),
                    const SizedBox(width: 8),
                    Text(product.price).bodyMedium(),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
