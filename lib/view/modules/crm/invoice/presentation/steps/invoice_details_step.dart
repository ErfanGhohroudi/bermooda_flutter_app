import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
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

  @override
  Widget build(final BuildContext context) {
    return Form(
      key: ctrl.step2FormKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 24,
          children: [
            // Invoice Type
            Obx(
              () => WDropDownFormField<String>(
                labelText: s.invoiceType,
                value: ctrl.selectedInvoiceType.value?.getTitle(),
                required: true,
                showRequiredIcon: false,
                items: getDropDownMenuItemsFromString(
                  menuItems: InvoiceType.values.map((final e) => e.getTitle()).toList(),
                ),
                onChanged: (final value) {
                  ctrl.selectedInvoiceType.value = InvoiceType.values.firstWhereOrNull(
                    (final e) => e.getTitle() == value,
                  );
                },
              ),
            ),

            // Invoice Code
            WTextField(
              controller: ctrl.invoiceCodeController,
              labelText: s.invoiceId,
              enabled: false,
              maxLength: 50,
            ),

            // Payment Type
            Obx(
              () => WDropDownFormField<String>(
                labelText: '${s.payment} ${s.type}',
                value: ctrl.selectedPaymentType.value?.getTitle(),
                required: true,
                showRequiredIcon: false,
                items: getDropDownMenuItemsFromString(
                  menuItems: PaymentType.values.map((final e) => e.getTitle()).toList(),
                ),
                onChanged: (final value) {
                  ctrl.selectedPaymentType.value = PaymentType.values.firstWhereOrNull(
                    (final e) => e.getTitle() == value,
                  );
                  ctrl.onInstallmentFieldsChanged();
                },
              ),
            ),

            // Installment Fields
            Obx(
              () {
                if (ctrl.selectedPaymentType.value != PaymentType.installment) {
                  return const SizedBox.shrink();
                }

                return WCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 18,
                    children: [
                      Text('اطلاعات اقساط').titleMedium(),
                      const Divider(),

                      // Installment Count
                      WPlusMinusField(
                        labelText: 'تعداد اقساط',
                        defaultValue: ctrl.installmentCount,
                        required: true,
                        min: 1,
                        max: 24,
                        onChanged: (final value) {
                          ctrl.installmentCount = value;
                          ctrl.onInstallmentFieldsChanged();
                        },
                      ),

                      // Interest Percentage
                      WAmountCurrencyField(
                        controller: ctrl.interestPercentageController,
                        labelText: 'نرخ بهره (%)',
                        showRequired: false,
                        onChanged: (final value) => ctrl.onInstallmentFieldsChanged(),
                      ),

                      // Installment Start Date
                      WDatePickerField(
                        labelText: 'شروع اقساط از',
                        initialValue: ctrl.installmentStartDate?.formatCompactDate(),
                        onConfirm: (final date, final formattedDate) {
                          ctrl.installmentStartDate = date;
                          ctrl.onInstallmentFieldsChanged();
                        },
                      ),

                      // Installment Period
                      WDropDownFormField<String>(
                        labelText: 'دوره زمانی',
                        value: ctrl.installmentPeriod.toString(),
                        items: getDropDownMenuItemsFromString(
                          menuItems: ['10', '20', '30'],
                        ),
                        onChanged: (final value) {
                          if (value == null) return;
                          ctrl.installmentPeriod = int.tryParse(value) ?? 10;
                          ctrl.onInstallmentFieldsChanged();
                        },
                      ),

                      // Installments List
                      if (ctrl.installmentPayments.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text('لیست اقساط').bodyMedium(),
                        const SizedBox(height: 8),
                        ...ctrl.installmentPayments.asMap().entries.map((final entry) {
                          final index = entry.key;
                          final payment = entry.value;
                          return WCard(
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('قسط ${index + 1}').bodyMedium(),
                                  Text(payment['date_to_pay'] ?? '').bodyMedium(),
                                  Text('${payment['price'] ?? ''} ${s.toman}').bodyMedium(),
                                ],
                              ),
                            ),
                          ).marginOnly(bottom: 8);
                        }),
                      ],
                    ],
                  ),
                );
              },
            ),

            // Products Section
            WCard(
              horPadding: 0,
              verPadding: 0,
              margin: EdgeInsets.zero,
              showBorder: true,
              color: Colors.white,
              borderWidth: 1,
              child: Scrollbar(
                trackVisibility: true,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width - 32,
                    ),
                    child: IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Table Header
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 40,
                                  child: Text('#').bodySmall(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: Text('شرح کالا / خدمات').bodySmall(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 120,
                                  child: Text(s.productCode).bodySmall(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: Text(s.count).bodySmall(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Text(s.unit).bodySmall(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 120,
                                  child: Text(s.unitPrice).bodySmall(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Row(
                                    children: [
                                      Text('${s.totalPrice} ').bodySmall(fontWeight: FontWeight.bold),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(s.toman).bodySmall(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Products Table Rows
                          Obx(
                            () {
                              if (ctrl.products.isEmpty) {
                                return Container(
                                  padding: const EdgeInsets.all(24),
                                  child: Center(
                                    child: Text(s.listIsEmpty).bodyMedium(color: context.theme.hintColor),
                                  ),
                                );
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
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: InkWell(
                              onTap: () => _showAddProductDialog(context),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'اضافه کردن ردیف',
                                    style: TextStyle(
                                      color: context.theme.primaryColor,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.add_circle,
                                    color: Colors.green,
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

            // Calculations Section
            WCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('محاسبات').titleMedium(),
                  const Divider(),
                  const SizedBox(height: 10),
                  Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 18,
                      children: [
                        // Total Products Price
                        _calculationRow(
                          'جمع کل محصولات',
                          ctrl.totalProductsPrice.toString().toTomanMoney(),
                        ),

                        // Discount
                        WAmountCurrencyField(
                          controller: ctrl.discountController,
                          labelText: s.discount,
                          showRequired: false,
                          onChanged: (final value) => ctrl.onInstallmentFieldsChanged(),
                        ),

                        // Taxes
                        WAmountCurrencyField(
                          controller: ctrl.taxesController,
                          labelText: s.tax,
                          showRequired: false,
                          onChanged: (final value) => ctrl.onInstallmentFieldsChanged(),
                        ),

                        // Shipping Cost
                        WAmountCurrencyField(
                          controller: ctrl.shippingCostController,
                          labelText: 'هزینه ارسال',
                          showRequired: false,
                          onChanged: (final value) => ctrl.onInstallmentFieldsChanged(),
                        ),

                        // Interest (if installment)
                        if (ctrl.selectedPaymentType.value == PaymentType.installment && ctrl.interestAmount > 0)
                          _calculationRow(
                            'نرخ بهره',
                            ctrl.interestAmount.toString().toTomanMoney(),
                          ),
                      ],
                    ),
                  ),
                  const Divider(height: 30),
                  // Final Price
                  _calculationRow(
                    'قابل پرداخت',
                    ctrl.finalPrice.toString().toTomanMoney(),
                    isBold: true,
                  ),
                ],
              ),
            ),

            // Date to Pay
            WDatePickerField(
              labelText: s.paymentDate,
              initialValue: ctrl.dateToPay?.formatCompactDate(),
              onConfirm: (final date, final formattedDate) {
                ctrl.dateToPay = date;
              },
            ),

            // Description
            WTextField(
              controller: ctrl.descriptionController,
              labelText: s.description,
              minLines: 4,
              maxLines: 8,
              maxLength: 2000,
              showCounter: true,
              multiLine: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),

            const SizedBox(height: 100), // Space for bottom button
          ],
        ),
      ),
    );
  }

  Widget _calculationRow(final String label, final String value, {final bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label).bodyMedium(),
        Text(value).bodyMedium(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
      ],
    );
  }

  Widget _buildProductRow(final BuildContext context, final int index, final InvoiceProduct product) {
    final price = int.tryParse(product.price.numericOnly()) ?? 0;
    final total = (price * product.count).toString().toTomanMoney();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: index.isEven ? Colors.white : Colors.grey.shade50,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text('${index + 1}').bodySmall(),
          ),
          SizedBox(
            width: 200,
            child: Text(product.title).bodySmall(),
          ),
          SizedBox(
            width: 120,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    product.code ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: product.code != null ? null : context.theme.hintColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () => _showProductCodeDialog(context, index, product),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 16,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(product.count.toString()).bodySmall(),
          ),
          SizedBox(
            width: 150,
            child: Text(product.unit ?? '').bodySmall(),
          ),
          SizedBox(
            width: 120,
            child: Text(product.price).bodySmall(),
          ),
          SizedBox(
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    total,
                    overflow: TextOverflow.ellipsis,
                  ).bodySmall(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => _showEditProductDialog(context, index, product),
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(5),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: const UImage(
                    AppIcons.editOutline,
                    size: 20,
                    color: AppColors.green,
                  ),
                ),
                IconButton(
                  onPressed: () => ctrl.removeProduct(index),
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(5),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: const UImage(
                    AppIcons.delete,
                    size: 20,
                    color: AppColors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProductDialog(final BuildContext context, final int index, final InvoiceProduct product) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: product.title);
    final codeController = TextEditingController(text: product.code ?? '');
    final unitController = TextEditingController(text: product.unit ?? '');
    final priceController = TextEditingController(text: product.price);
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
                labelText: 'شرح کالا / خدمات',
                required: true,
                showRequired: false,
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
                required: true,
                showRequired: false,
              ),
              Row(
                spacing: 10,
                children: [
                  UElevatedButton(
                    title: s.cancel,
                    backgroundColor: context.theme.hintColor,
                    onTap: () => UNavigator.back(),
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
                            price: priceController.text.trim(),
                            unit: unitController.text.trim().isEmpty ? null : unitController.text.trim(),
                            code: codeController.text.trim().isEmpty ? null : codeController.text.trim(),
                          );
                          ctrl.updateProduct(index, updatedProduct);
                          UNavigator.back();
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

  void _showProductCodeDialog(final BuildContext context, final int index, final InvoiceProduct product) {
    final codeController = TextEditingController(text: product.code ?? '');

    bottomSheet(
      title: 'کد کالا',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 18,
          children: [
            WTextField(
              controller: codeController,
              labelText: s.productCode,
            ),
            Row(
              spacing: 10,
              children: [
                UElevatedButton(
                  title: s.cancel,
                  backgroundColor: context.theme.hintColor,
                  onTap: () => UNavigator.back(),
                ).expanded(),
                UElevatedButton(
                  title: s.save,
                  onTap: () {
                    final updatedProduct = InvoiceProduct(
                      id: product.id,
                      title: product.title,
                      count: product.count,
                      price: product.price,
                      unit: product.unit,
                      code: codeController.text.trim().isEmpty ? null : codeController.text.trim(),
                    );
                    ctrl.updateProduct(index, updatedProduct);
                    UNavigator.back();
                  },
                ).expanded(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProductDialog(final BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey();
    final productIdController = TextEditingController();
    final productTitleController = TextEditingController();
    final productPriceController = TextEditingController();
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
                labelText: 'شرح کالا / خدمات',
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
                required: true,
                showRequired: false,
              ),
              Row(
                spacing: 10,
                children: [
                  UElevatedButton(
                    title: s.cancel,
                    backgroundColor: context.theme.hintColor,
                    onTap: () => UNavigator.back(),
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
                            price: productPriceController.text.trim(),
                            unit: productUnitController.text.trim().isEmpty ? null : productUnitController.text.trim(),
                            code: productCodeController.text.trim().isEmpty ? null : productCodeController.text.trim(),
                          );

                          ctrl.addProduct(product);
                          UNavigator.back();
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
}
