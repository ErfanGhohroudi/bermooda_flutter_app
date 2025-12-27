import 'package:flutter/cupertino.dart';
import 'package:u/utilities.dart';

import '../../../core/navigator/navigator.dart';
import '../../../core/utils/enums/enums.dart';
import '../../../core/utils/extensions/money_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/core.dart';
import '../../../core/theme.dart';
import 'enums/discount_code_state.dart';
import 'enums/max_contract_count.dart';
import 'subscription_controller.dart';
import 'module_management_page.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({
    required this.workspaceId,
    super.key,
  });

  final String workspaceId;

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  late final SubscriptionController ctrl;

  @override
  void initState() {
    ctrl = Get.put(SubscriptionController(workspaceId: widget.workspaceId));
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(s.subscriptionManagement),
      ),
      body: Obx(() {
        if (!ctrl.pageState.isLoaded()) return const Center(child: WCircularLoading());

        return _buildContent();
      }),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          // Subscription Settings Section
          _buildSubscriptionSettingsSection(),

          // Price Summary and Payment Section
          _buildPriceSummarySection(),
        ],
      ),
    );
  }

  Widget _buildPriceSummarySection() {
    final spacing = 16.0;
    return WCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.priceSummary).titleMedium().bold(),
          SizedBox(height: spacing),

          // Current subscription status
          if (ctrl.subscription.value.isPurchase) ...[
            _buildCurrentSubscriptionCard(),
            SizedBox(height: spacing),
          ],

          Obx(
            () {
              if (ctrl.priceCalculation.value == null) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price breakdown
                  _buildPriceBreakdown(),
                  SizedBox(height: spacing),

                  // Discount Code Field
                  _buildDiscountCodeField(),
                  SizedBox(height: spacing),

                  // Final total
                  _buildFinalTotal(),
                  SizedBox(height: spacing),
                ],
              );
            },
          ),

          if (ctrl.showBankAccountInfo) ...[
            Row(
              spacing: 10,
              children: [
                const Divider().expanded(),
                Text(s.or).bodyMedium(color: context.theme.dividerColor, fontSize: 20),
                const Divider().expanded(),
              ],
            ),
            SizedBox(height: spacing),

            // Bank account info
            Obx(
              () {
                if (ctrl.bermoodaBankAccountInfo.value == null) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBankAccountInfo(),
                    SizedBox(height: spacing),
                  ],
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCurrentSubscriptionCard() {
    final sub = ctrl.subscription.value;

    return WCard(
      color: Colors.grey.shade100,
      margin: EdgeInsets.zero,
      showBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.currentSubscription).titleMedium(),
          const SizedBox(height: 12),
          _buildInfoRow(s.users, '${sub.userCount} ${s.user}'),
          _buildInfoRow(s.activeModules, '${sub.modules.length} ${s.module}'),
          _buildInfoRow(s.storage, '${sub.storage} ${s.gb}', isLtr: true),
          _buildInfoRow(s.subscriptionPeriod, "12 ${s.months}"),
          _buildInfoRow(s.remaining, "${sub.remainingDays} ${s.days}"),
          const Divider().marginOnly(bottom: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${s.currentSubscriptionPrice}:').bodyMedium(),
              Text(sub.price.toString().toTomanMoney()).bodyMedium(color: context.theme.primaryColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdown() {
    return Obx(() {
      final calculated = ctrl.priceCalculation.value!;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(s.subscriptionPeriod, ctrl.selectedPeriod.value.getTitle()),
          _buildPriceRow('${s.users} (${ctrl.selectedUserCount.value})', calculated.totalUserPrice.toString().toTomanMoney()),
          _buildPriceRow(
            '${s.storage} (${ctrl.selectedStorage.value} ${s.gb})',
            calculated.totalStoragePrice.toString().toTomanMoney(),
          ),
          if (ctrl.isLegalModuleSelected)
            _buildPriceRow(
              '${s.contractCount} (${ctrl.selectedMaxContractCount.value.title})',
              calculated.totalContractPrice.toString().toTomanMoney(),
            ),
          if (calculated.modulePriceList.isNotEmpty) ...[
            _buildInfoRow('${s.selectedModules} (${calculated.modulePriceList.length})', ''),
            Container(
              margin: const EdgeInsetsDirectional.only(start: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                children: calculated.modulePriceList.map((final mod) {
                  final module = mod.module;
                  final finalPrice = mod.finalPrice.toString().toTomanMoney();
                  return _buildPriceRow("- ${module.title} (${calculated.daysToAdd} ${s.days})", finalPrice, verPadding: 0);
                }).toList(),
              ),
            ),
          ],
        ],
      );
    });
  }

  Widget _buildDiscountCodeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Text(s.promoCode).bodyMedium(),
        const SizedBox(height: 8),
        Obx(
          () => Column(
            spacing: 8,
            children: [
              UTextFormField(
                readOnly:
                    !(!ctrl.discountCodeFieldState.isApplying &&
                        !ctrl.discountCodeFieldState.isApplied &&
                        !ctrl.discountCodeFieldState.isInvalid),
                controller: ctrl.discountCodeCtrl,
                hintText: s.enterCodeHere,
                helperText: ctrl.discountCodeFieldState.value.helperText,
                helperStyle: ctrl.discountCodeFieldState.value.helperStyle(context),
                // formatters: [
                //   FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]'))
                // ],
                onChanged: ctrl.onDiscountCodeChanged,
                onFieldSubmitted: ctrl.onDiscountCodeChanged,
              ),
              if (ctrl.discountCodeFieldState.isEmpty == false)
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: UElevatedButton(
                    isLoading: ctrl.discountCodeFieldState.isApplying,
                    title: ctrl.discountCodeFieldState.value.buttonText,
                    backgroundColor: ctrl.discountCodeFieldState.value.buttonColor,
                    onTap: switch (ctrl.discountCodeFieldState.value) {
                      DiscountCodeState.empty => null,
                      DiscountCodeState.notEmpty => ctrl.onDiscountCodeApply,
                      DiscountCodeState.applying => null,
                      DiscountCodeState.applied => ctrl.onDiscountCodeRemove,
                      DiscountCodeState.invalid => ctrl.onDiscountCodeRemove,
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFinalTotal() {
    return Obx(() {
      final calculated = ctrl.priceCalculation.value!;
      final discount = calculated.discountPercentage;
      final hasDiscount = discount > 0;

      return Column(
        spacing: 10,
        children: [
          Divider(color: context.theme.dividerColor.withValues(alpha: 0.5), height: 0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${s.totalPrice}: ').titleMedium(),
              Text(calculated.totalPrice.toString().toTomanMoney()).titleMedium(color: context.theme.primaryColor),
            ],
          ),
          // Discount Card
          if (hasDiscount) _buildDiscountCard(),
          // _buildProformaInvoice(),
          UElevatedButton(
            width: double.infinity,
            title: "${s.payNow} (${calculated.finalPrice.toString().toTomanMoney()})",
            onTap: ctrl.createPaymentRequest,
          ),
        ],
      );
    });
  }

  Widget _buildProformaInvoice() {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.blue.withAlpha(30),
        border: Border.all(color: AppColors.blue.withAlpha(50), width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('پیش فاکتور').bodyMedium(color: AppColors.blue),
          WTextButton2(
            text: 'مشاهده جزئیات',
            onPressed: () {
              if (ctrl.priceCalculation.value == null) return;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountCard() {
    final calculated = ctrl.priceCalculation.value!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: WCard(
        showBorder: true,
        borderColor: AppColors.orange.withValues(alpha: 0.5),
        color: AppColors.orange.withValues(alpha: 0.05),
        child: Column(
          children: [
            Text(
              "${calculated.discountPercentageFormatted}% ${s.discount}",
              textAlign: TextAlign.center,
            ).titleMedium().marginOnly(bottom: 10),
            _buildPriceRow(s.totalPrice, calculated.totalPrice.toString().toTomanMoney()),
            _buildPriceRow(
              s.discount,
              '-${calculated.discountPrice.toString().toTomanMoney()}',
              isDiscount: true,
              labelColor: AppColors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankAccountInfo() {
    return WCard(
      color: AppColors.purple.withValues(alpha: 0.05),
      margin: EdgeInsets.zero,
      showBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.bankAccountInformation).titleMedium(color: AppColors.purple).alignAtCenter(),
          const SizedBox(height: 8),
          _buildInfoRow(s.bank, ctrl.bermoodaBankAccountInfo.value?.bankName ?? ''),
          _buildInfoRow(s.iban, ctrl.bermoodaBankAccountInfo.value?.iban ?? ''),
          _buildInfoRow(s.accountOwnerName, ctrl.bermoodaBankAccountInfo.value?.accountOwnerName ?? ''),
          Divider(color: context.theme.dividerColor.withValues(alpha: 0.5)),
          // Payment receipt upload
          _buildPaymentReceiptUpload().marginOnly(top: 10),
        ],
      ),
    );
  }

  Widget _buildPaymentReceiptUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${s.sendPaymentReceipt}:').bodyMedium(color: AppColors.purple),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('${s.select} ${s.file}').bodyMedium(color: Colors.grey.shade600),
              ),
            ),
            const SizedBox(width: 8),
            UElevatedButton(
              title: s.send,
              backgroundColor: Colors.purple,
              onTap: () {
                AppNavigator.snackbarGreen(title: s.done, subtitle: '');
              },
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text('فرمت های مجاز JPG, PNG, PDF (حداکثر ۵MB)').bodySmall(color: Colors.grey.shade600),
      ],
    );
  }

  Widget _buildSubscriptionSettingsSection() {
    return WCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.subscriptionSettings).titleMedium(),
          const SizedBox(height: 16),

          // Subscription Period
          if (!ctrl.subscription.value.isPurchase) ...[
            _buildSubscriptionPeriodSection(),
            const SizedBox(height: 20),
          ],

          // Active modules
          _buildActiveModulesSection(),
          const SizedBox(height: 20),

          // User count
          _buildUserCountSection(),
          const SizedBox(height: 20),

          // Storage
          _buildStorageSection(),
          const SizedBox(height: 20),

          // Contract count for legal Module
          if (ctrl.isLegalModuleSelected) ...[
            _buildMaxContractCountSection(),
            const SizedBox(height: 20),
          ],

          // Warning note
          _buildWarningNote(),
        ],
      ),
    );
  }

  Widget _buildSubscriptionPeriodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const UImage(AppIcons.calendarOutline, color: AppColors.green, size: 20),
            const SizedBox(width: 8),
            Text(s.subscriptionPeriod).bodyMedium().bold(),
          ],
        ),
        const SizedBox(height: 12),
        Obx(
          () => GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: SubscriptionPeriod.values.map((final period) {
              final isSelected = ctrl.selectedPeriod.value == period;
              final isPopular = period == SubscriptionPeriod.twelveMonths;

              return GestureDetector(
                onTap: () => ctrl.updatePeriod(period),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.blue : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            spacing: 4,
                            children: [
                              Text(
                                period.getTitle(),
                                textAlign: TextAlign.center,
                              ).bodyLarge(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? AppColors.blue : null,
                              ),
                              Text(
                                '${period.days} ${s.days}',
                                textAlign: TextAlign.center,
                              ).bodyMedium(color: context.theme.hintColor),
                            ],
                          ),
                        ),
                      ),
                      if (isPopular)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(8),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withValues(alpha: 0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(s.popular).bodySmall(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveModulesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Row(
          children: [
            Text(s.activeModules).bodyMedium(),
            const Spacer(),
            UElevatedButton(
              title: s.moduleManagement,
              backgroundColor: context.theme.primaryColor,
              onTap: () async {
                UNavigator.push(ModuleManagementPage(ctrl: ctrl));
              },
            ),
          ],
        ),
        if (ctrl.selectedModules.isNotEmpty) ...[
          Text('${s.activatedModules}:').bodySmall(),
          Obx(
            () => Wrap(
              spacing: 6,
              runSpacing: 6,
              children: ctrl.selectedModules.map((final module) {
                return Chip(
                  label: Text(module.title).bodyMedium(),
                  backgroundColor: context.theme.cardColor,
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildUserCountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.userCount).bodyMedium(),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              onPressed: () => ctrl.updateUserCount(ctrl.selectedUserCount.value - 1),
              icon: UImage(AppIcons.minusSquareOutline, color: context.theme.primaryColor),
              color: context.theme.primaryColor,
            ),
            Container(
              constraints: const BoxConstraints(minWidth: 100, minHeight: 40, maxHeight: 40),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: Obx(() => Text('${ctrl.selectedUserCount.value} ${s.user}').bodyMedium())),
            ),
            IconButton(
              onPressed: () => ctrl.updateUserCount(ctrl.selectedUserCount.value + 1),
              icon: UImage(AppIcons.addSquareOutline, color: context.theme.primaryColor),
              color: context.theme.primaryColor,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: ctrl.selectedUserCount.value.toDouble(),
          min: ctrl.minUser.toDouble(),
          max: ctrl.maxUser.toDouble(),
          onChanged: (final value) => ctrl.updateUserCount(value.round(), withCalculation: false),
          onChangeEnd: (final value) => ctrl.updateUserCount(value.round()),
        ),
      ],
    );
  }

  Widget _buildStorageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.storage).bodyMedium(),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              onPressed: () => ctrl.updateStorage(ctrl.selectedStorage.value - 1),
              icon: UImage(AppIcons.minusSquareOutline, color: context.theme.primaryColor),
              color: context.theme.primaryColor,
            ),
            Container(
              constraints: const BoxConstraints(minWidth: 100, minHeight: 40, maxHeight: 40),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Obx(() => Text('${ctrl.selectedStorage.value} ${s.gb}', textDirection: TextDirection.ltr).bodyMedium()),
              ),
            ),
            IconButton(
              onPressed: () => ctrl.updateStorage(ctrl.selectedStorage.value + 1),
              icon: UImage(AppIcons.addSquareOutline, color: context.theme.primaryColor),
              color: context.theme.primaryColor,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: ctrl.selectedStorage.value.toDouble(),
          min: ctrl.minStorage.toDouble(),
          max: ctrl.maxStorage.toDouble(),
          onChanged: (final value) => ctrl.updateStorage(value.round(), withCalculation: false),
          onChangeEnd: (final value) => ctrl.updateStorage(value.round()),
        ),
      ],
    );
  }

  Widget _buildMaxContractCountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Row(
          spacing: 12,
          children: [
            Text(s.contractCount).bodyMedium(),
            IconButton(
              onPressed: () {
                showAppDialog(
                  AlertDialog.adaptive(
                    title: Text(s.contractCount).titleMedium(),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 24,
                      children: [
                        Text(s.contractCountInfo).bodyMedium(),
                        UElevatedButton(
                          width: double.infinity,
                          title: s.ok,
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                );
              },
              icon: Icon(CupertinoIcons.info, color: context.theme.primaryColor, size: 22),
              style: IconButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        WDropDownFormField<MaxContractCount>(
          key: ctrl.maxContractDropdownUniqueKey.value,
          value: ctrl.selectedMaxContractCount.value,
          items: MaxContractCount.values.map((final count) {
            return DropdownMenuItem<MaxContractCount>(
              value: count,
              child: WDropdownItemText(text: count.title),
            );
          }).toList(),
          onChanged: (final value) {
            if (value == null) return;
            ctrl.updateMaxContractCount(value);
          },
        ),
      ],
    );
  }

  Widget _buildWarningNote() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.5)),
      ),
      child: Row(
        spacing: 8,
        children: [
          const UImage(AppIcons.warningOutline, color: Colors.orange, size: 25),
          Text(s.subscriptionNote, textAlign: TextAlign.justify).bodySmall().expanded(),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    final String label,
    final String value, {
    final bool isDiscount = false,
    final double verPadding = 4,
    final Color? labelColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$label: ").bodyMedium(color: labelColor),
          Text(value).bodyMedium(color: isDiscount ? AppColors.red : null),
        ],
      ),
    );
  }

  Widget _buildInfoRow(final String label, final String value, {final bool isLtr = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$label: ").bodyMedium(),
          Text(
            value,
            textDirection: isLtr ? TextDirection.ltr : null,
          ).bodyMedium(),
        ],
      ),
    );
  }
}
