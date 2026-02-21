import 'package:decimal/decimal.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/widgets/fields/amount_field/amount_currency_field.dart';
import '../../../../../../core/widgets/fields/fields.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../core/utils/extensions/money_extensions.dart';
import '../../domain/entities/invoice.dart';
import '../controllers/create_invoice_controller.dart';

class InvoiceDetailsStep extends StatelessWidget {
  const InvoiceDetailsStep({
    required this.ctrl,
    super.key,
  });

  final CreateInvoiceController ctrl;

  static const productRowCellsWidth = <double>[
    100, // title
    30, // code
    30, // count
    30, // unit
    60, // unit price
    60, // discount
    170, // total price
  ];

  static const headerCellPadding = 12.0;
  static const rowCellPadding = 10.0;

  @override
  Widget build(final BuildContext context) {
    return Form(
      key: ctrl.detailsStepFormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10, bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 24,
          children: [
            // Invoice Type Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 18,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    // Invoice Type
                    Obx(
                      () => WDropDownFormField<String>(
                        labelText: s.invoiceType,
                        value: ctrl.selectedInvoiceType.value?.getTitle(),
                        required: true,
                        items: getDropDownMenuItemsFromString(
                          menuItems: InvoiceType.values.map((final e) => e.getTitle()).toList(),
                        ),
                        onChanged: (final value) {
                          ctrl.selectedInvoiceType.value = InvoiceType.values.firstWhereOrNull(
                            (final e) => e.getTitle() == value,
                          );
                        },
                      ),
                    ).expanded(),

                    // Invoice Code
                    WTextField(
                      controller: ctrl.invoiceCodeController,
                      labelText: s.invoiceId,
                      enabled: false,
                      required: true,
                      showRequired: false,
                      maxLength: 50,
                    ).expanded(),
                  ],
                ),

                Row(
                  spacing: 10,
                  children: [
                    // Created Date
                    WDatePickerField(
                      labelText: s.dateOfEntry,
                      initialValue: ctrl.createdDate,
                      required: true,
                      onConfirm: (final date) {
                        ctrl.createdDate = date;
                      },
                    ).expanded(),

                    // Validity Date
                    WDatePickerField(
                      labelText: s.validityDate,
                      initialValue: ctrl.validityDate,
                      showYearSelector: true,
                      required: true,
                      onConfirm: (final date) {
                        ctrl.validityDate = date;
                      },
                    ).expanded(),
                  ],
                ),
              ],
            ),

            // Products Section
            Container(
              decoration: BoxDecoration(
                color: context.theme.cardColor,
                border: Border.all(color: context.theme.dividerColor, width: 2),
                borderRadius: BorderRadiusGeometry.circular(6),
              ),
              child: Theme(
                data: ThemeData(
                  scrollbarTheme: context.theme.scrollbarTheme.copyWith(
                    thumbColor: const WidgetStatePropertyAll(AppColors.green),
                  ),
                ),
                child: Scrollbar(
                  trackVisibility: true,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: context.width - 32,
                      ),
                      child: IntrinsicWidth(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Table Header
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              // color: Colors.grey.shade200,
                              color: context.theme.primaryColor.withValues(alpha: 0.1),
                              child: IntrinsicHeight(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: productRowCellsWidth[0],
                                      child: Text(
                                        s.productService,
                                        textAlign: TextAlign.center,
                                      ).bodySmall(fontSize: 10).alignAtCenter(),
                                    ).pSymmetric(vertical: headerCellPadding),
                                    const VerticalDivider(),
                                    SizedBox(
                                      width: productRowCellsWidth[1],
                                      child: Text(
                                        s.productCode,
                                        textAlign: TextAlign.center,
                                      ).bodySmall(fontSize: 10).alignAtCenter(),
                                    ).pSymmetric(vertical: headerCellPadding),
                                    const VerticalDivider(),
                                    SizedBox(
                                      width: productRowCellsWidth[2],
                                      child: Text(s.count, textAlign: TextAlign.center).bodySmall(fontSize: 10).alignAtCenter(),
                                    ).pSymmetric(vertical: headerCellPadding),
                                    const VerticalDivider(),
                                    SizedBox(
                                      width: productRowCellsWidth[3],
                                      child: Text(s.unit, textAlign: TextAlign.center).bodySmall(fontSize: 10).alignAtCenter(),
                                    ).pSymmetric(vertical: headerCellPadding),
                                    const VerticalDivider(),
                                    SizedBox(
                                      width: productRowCellsWidth[4],
                                      child: Text(
                                        s.unitPrice,
                                        textAlign: TextAlign.center,
                                      ).bodySmall(fontSize: 10).alignAtCenter(),
                                    ).pSymmetric(vertical: headerCellPadding),
                                    const VerticalDivider(),
                                    SizedBox(
                                      width: productRowCellsWidth[5],
                                      child: Text(
                                        s.discount,
                                        textAlign: TextAlign.center,
                                      ).bodySmall(fontSize: 10).alignAtCenter(),
                                    ).pSymmetric(vertical: headerCellPadding),
                                    const VerticalDivider(),
                                    SizedBox(
                                      width: productRowCellsWidth[6],
                                      child: Row(
                                        children: [
                                          Text('${s.totalPrice} ', textAlign: TextAlign.center).bodySmall(fontSize: 10),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(s.rial).bodySmall(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ).pSymmetric(vertical: headerCellPadding),
                                  ],
                                ),
                              ),
                            ),

                            // Products Table Rows
                            Obx(
                              () {
                                if (ctrl.products.isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                return Column(
                                  children: ctrl.products.asMap().entries.map((final entry) {
                                    return _buildProductRow(context, entry.key, entry.value);
                                  }).toList(),
                                );
                              },
                            ),

                            // Add Row Button
                            Container(
                              height: 50,
                              padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 12),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.grey.shade300),
                                ),
                              ),
                              child: InkWell(
                                onTap: () => _showAddProductDialog(context),
                                child: Row(
                                  spacing: 4,
                                  children: [
                                    Text(s.addRow).bodyMedium(color: context.theme.primaryColor),
                                    UImage(
                                      AppIcons.addSquareOutline,
                                      color: context.theme.primaryColor,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Calculations Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 18,
                    children: [
                      // Total Products Price
                      _calculationRow(
                        s.totalAmountOfProductsServices,
                        ctrl.totalProductsPriceAfterDiscount.toString().toRialMoney(),
                      ),

                      // Products Discount
                      _calculationRow(
                        "${s.discount} (${s.productsOrServices})",
                        ("${ctrl.totalProductsDiscountAmount > 0.toDecimal() ? "ـ " : ''}${ctrl.totalProductsDiscountAmount}")
                            .toRialMoney(),
                        color: AppColors.red,
                      ),

                      // Discount Amount
                      _calculationRow(
                        s.discount,
                        ("${ctrl.discountAmount > 0.toDecimal() ? "ـ " : ''}${ctrl.discountAmount}").toRialMoney(),
                        color: AppColors.red,
                      ),

                      // Tax Amount
                      _calculationRow(
                        s.tax,
                        ("${ctrl.taxAmount > 0.toDecimal() ? "+ " : ''}${ctrl.taxAmount}").toRialMoney(),
                        color: AppColors.green,
                      ),

                      // Discount
                      WPlusMinusField(
                        labelText: "${s.discount} (%)",
                        defaultValue: ctrl.discountPercentage.value,
                        max: 100,
                        onChanged: (final value) {
                          ctrl.discountPercentage(value);
                          ctrl.onFinancialFieldsChanged();
                        },
                      ),

                      // Taxes
                      WPlusMinusField(
                        labelText: "${s.tax} (%)",
                        defaultValue: ctrl.taxesPercentage.value,
                        max: 100,
                        onChanged: (final value) {
                          ctrl.taxesPercentage(value);
                          ctrl.onFinancialFieldsChanged();
                        },
                      ),

                      // Shipping Cost
                      Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 12,
                          children: [
                            WCheckBox(
                              isChecked: ctrl.shipping.value,
                              title: s.shippingCost,
                              onChanged: (final value) {
                                ctrl.shipping(value);
                                if (ctrl.shipping.value) {
                                  ctrl.shippingCostFocusNode.requestFocus();
                                }
                                ctrl.onShippingCostFieldChanged();
                              },
                            ),
                            if (ctrl.shipping.value)
                              WAmountCurrencyField(
                                controller: ctrl.shippingCostController,
                                focusNode: ctrl.shippingCostFocusNode,
                                labelText: '',
                                required: ctrl.shipping.value,
                                currencyText: s.rial,
                                onChanged: (final value) {
                                  ctrl.onShippingCostFieldChanged();
                                  ctrl.onFinancialFieldsChanged();
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Description
                WTextField(
                  controller: ctrl.descriptionController,
                  labelText: s.description,
                  minLines: 3,
                  maxLines: 8,
                  maxLength: 2000,
                  showCounter: true,
                  multiLine: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ],
            ),

            // Payment Terms
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text(s.paymentTerms).titleMedium(color: context.theme.hintColor),
                WRadioGroup<PaymentTerms>(
                  items: PaymentTerms.values,
                  initialValue: ctrl.selectedPaymentTerms.value,
                  onChanged: (final value) {
                    ctrl.selectedPaymentTerms.value = PaymentTerms.values.firstWhere((final e) => e == value);
                    ctrl.onFinancialFieldsChanged();
                  },
                  labelBuilder: (final item) => item.getTitle(),
                ),
              ],
            ),

            // Final Price
            Obx(
              () => IntrinsicHeight(
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: context.theme.primaryColor,
                        borderRadius: BorderRadiusGeometry.horizontal(start: const Radius.circular(15)),
                      ),
                      child: Text(s.payable).bodyMedium(color: Colors.white).alignAtCenter(),
                    ).expanded(flex: 1),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: context.theme.dividerColor,
                        borderRadius: BorderRadiusGeometry.horizontal(end: const Radius.circular(15)),
                      ),
                      child: Text(
                        ctrl.finalPrice.toString().toRialMoney(),
                      ).bodyMedium().bold().alignAtCenter(),
                    ).expanded(flex: 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductRow(final BuildContext context, final int index, final InvoiceProduct product) {
    final price = int.tryParse(product.price.numericOnly()) ?? 0;
    final discount = int.tryParse(product.discount?.numericOnly() ?? '0') ?? 0;
    final total = ((price * product.count) - discount).toString().toRialMoney();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: index.isEven ? Colors.white : Colors.grey.shade50,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            SizedBox(
              width: productRowCellsWidth[0],
              child: Text("${index + 1} - ${product.title}").bodySmall(fontSize: 10),
            ).pSymmetric(vertical: rowCellPadding),
            const VerticalDivider(),
            SizedBox(
              width: productRowCellsWidth[1],
              child: Text(product.code ?? '').bodySmall(fontSize: 10).alignAtCenter(),
            ).pSymmetric(vertical: rowCellPadding),
            const VerticalDivider(),
            SizedBox(
              width: productRowCellsWidth[2],
              child: Text(product.count.toString()).bodySmall(fontSize: 10).alignAtCenter(),
            ).pSymmetric(vertical: rowCellPadding),
            const VerticalDivider(),
            SizedBox(
              width: productRowCellsWidth[3],
              child: Text(product.unit ?? '').bodySmall(fontSize: 10).alignAtCenter(),
            ).pSymmetric(vertical: rowCellPadding),
            const VerticalDivider(),
            SizedBox(
              width: productRowCellsWidth[4],
              child: Text(product.price.separateNumbers3By3()).bodySmall(fontSize: 10).alignAtCenter(),
            ).pSymmetric(vertical: rowCellPadding),
            const VerticalDivider(),
            SizedBox(
              width: productRowCellsWidth[5],
              child: Text(product.discount?.separateNumbers3By3() ?? '0').bodySmall(fontSize: 10).alignAtCenter(),
            ).pSymmetric(vertical: rowCellPadding),
            const VerticalDivider(),
            SizedBox(
              width: productRowCellsWidth[6],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(total).bodySmall(fontSize: 10).bold().expanded(),
                  IconButton(
                    onPressed: () => _showEditProductDialog(context, index, product),
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(5),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const UImage(AppIcons.editOutline, size: 20, color: AppColors.green),
                  ),
                  IconButton(
                    onPressed: () => ctrl.removeProduct(index),
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(5),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const UImage(AppIcons.delete, size: 20, color: AppColors.red),
                  ),
                ],
              ),
            ).pSymmetric(vertical: rowCellPadding),
          ],
        ),
      ),
    );
  }

  void _showEditProductDialog(final BuildContext context, final int index, final InvoiceProduct product) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: product.title);
    final codeController = TextEditingController(text: product.code ?? '');
    final unitController = TextEditingController(text: product.unit ?? '');
    final priceController = TextEditingController(text: product.price);
    final discountController = TextEditingController(text: product.discount);
    int count = product.count;

    bottomSheet(
      title: '${s.edit} ${s.productsOrServices}',
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 18,
            children: [
              WTextField(
                controller: titleController,
                labelText: s.productService,
                required: true,
              ),
              WTextField(
                controller: codeController,
                labelText: s.productCode,
              ),
              WPlusMinusField(
                labelText: s.count,
                defaultValue: count,
                required: true,
                min: 1,
                onChanged: (final value) => count = value,
              ),
              WTextField(
                controller: unitController,
                labelText: s.unit,
                hintText: s.invoiceUnitExample,
              ),
              WAmountCurrencyField(
                controller: priceController,
                labelText: s.unitPrice,
                currencyText: s.rial,
                required: true,
              ),
              WAmountCurrencyField(
                controller: discountController,
                labelText: s.discount,
                currencyText: s.rial,
              ),
              Row(
                spacing: 10,
                children: [
                  UElevatedButton(
                    title: s.cancel,
                    backgroundColor: context.theme.hintColor,
                    onTap: () => AppNavigator.back(),
                  ).expanded(),
                  UElevatedButton(
                    title: s.save,
                    onTap: () {
                      validateForm(
                        key: formKey,
                        action: () {
                          final updatedProduct = InvoiceProduct(
                            id: product.id,
                            title: titleController.text.trim(),
                            count: count,
                            price: priceController.text.trim().numericOnly(),
                            discount: discountController.text.trim().isEmpty ? null : discountController.text.trim().numericOnly(),
                            unit: unitController.text.trim().isEmpty ? null : unitController.text.trim(),
                            code: codeController.text.trim().isEmpty ? null : codeController.text.trim(),
                          );
                          ctrl.updateProduct(index, updatedProduct);
                          AppNavigator.back();
                        },
                      );
                    },
                  ).expanded(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddProductDialog(final BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey();
    final productIdController = TextEditingController();
    final productTitleController = TextEditingController();
    final productPriceController = TextEditingController();
    final productDiscountController = TextEditingController();
    final productUnitController = TextEditingController();
    final productCodeController = TextEditingController();
    int productCount = 1;

    bottomSheet(
      title: '${s.addText} ${s.productsOrServices}',
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 18,
            children: [
              WTextField(
                controller: productTitleController,
                labelText: s.productService,
                required: true,
                showRequired: false,
              ),
              WTextField(
                controller: productCodeController,
                labelText: s.productCode,
              ),
              WPlusMinusField(
                labelText: s.count,
                defaultValue: productCount,
                required: true,
                min: 1,
                onChanged: (final value) => productCount = value,
              ),
              WTextField(
                controller: productUnitController,
                labelText: s.unit,
                hintText: s.invoiceUnitExample,
              ),
              WAmountCurrencyField(
                controller: productPriceController,
                labelText: s.unitPrice,
                currencyText: s.rial,
                required: true,
                showRequired: false,
              ),
              WAmountCurrencyField(
                controller: productDiscountController,
                labelText: s.discount,
                currencyText: s.rial,
              ),
              Row(
                spacing: 10,
                children: [
                  UElevatedButton(
                    title: s.cancel,
                    backgroundColor: context.theme.hintColor,
                    onTap: () => AppNavigator.back(),
                  ).expanded(),
                  UElevatedButton(
                    title: s.addText,
                    onTap: () {
                      validateForm(
                        key: formKey,
                        action: () {
                          final product = InvoiceProduct(
                            id: int.tryParse(productIdController.text.trim()) ?? 0,
                            title: productTitleController.text.trim(),
                            count: productCount,
                            price: productPriceController.text.trim().numericOnly(),
                            discount: productDiscountController.text.trim().isEmpty
                                ? null
                                : productDiscountController.text.trim().numericOnly(),
                            unit: productUnitController.text.trim().isEmpty ? null : productUnitController.text.trim(),
                            code: productCodeController.text.trim().isEmpty ? null : productCodeController.text.trim(),
                          );

                          ctrl.addProduct(product);
                          AppNavigator.back();
                        },
                      );
                    },
                  ).expanded(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _calculationRow(
    final String label,
    final String value, {
    final bool isBold = false,
    final Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label).bodyMedium(),
        Text(value).bodyMedium(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: color,
        ),
      ],
    );
  }
}
