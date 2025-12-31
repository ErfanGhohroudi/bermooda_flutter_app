import 'package:u/utilities.dart';

import '../../../../core/core.dart';
import '../../../../core/utils/extensions/money_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../subscription_controller.dart';
import '../widgets/info_row.dart';
import '../widgets/price_row.dart';

class SubscriptionPriceSummery extends StatelessWidget {
  const SubscriptionPriceSummery({
    required this.ctrl,
    super.key,
  });

  final SubscriptionController ctrl;
  static const double spacing = 16.0;

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => WCard(
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.priceSummary).titleMedium().bold(),
            const SizedBox(height: spacing),

            // Current subscription status
            if (ctrl.isSubscriptionPurchased) ...[
              _buildCurrentSubscriptionCard(context),
              const SizedBox(height: spacing),
            ],

            Obx(
              () {
                if (ctrl.priceCalculation.value == null) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: WErrorWidget(onTapButton: () => ctrl.calculatePrice()).alignAtCenter(),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Price breakdown
                    _buildPriceBreakdown(),
                    const SizedBox(height: spacing),

                    // Final total
                    _buildFinalTotal(context),
                    const SizedBox(height: spacing),
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
              const SizedBox(height: spacing),

              // Bank account info
              // Obx(
              //   () {
              //     if (ctrl.bermoodaBankAccountInfo.value == null) return const SizedBox.shrink();
              //
              //     return Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         _buildBankAccountInfo(context),
              //         const SizedBox(height: spacing),
              //       ],
              //     );
              //   },
              // ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFinalTotal(final BuildContext context) {
    return Obx(() {
      final calculated = ctrl.priceCalculation.value!;

      return Column(
        spacing: 10,
        children: [
          Divider(color: context.theme.dividerColor.withValues(alpha: 0.5), height: 0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${s.total}: ').titleMedium(),
              Text(calculated.totalPrice.toString().toTomanMoney()).titleMedium(color: context.theme.primaryColor),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildCurrentSubscriptionCard(final BuildContext context) {
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
          WInfoRow(s.users, '${sub.userCount} ${s.user}'),
          WInfoRow(s.activeModules, '${sub.modules.length} ${s.module}'),
          WInfoRow(s.storage, '${sub.storage} ${s.gb}', isLtr: true),
          WInfoRow(s.subscriptionPeriod, "12 ${s.months}"),
          WInfoRow(s.remaining, "${sub.remainingDays} ${s.days}"),
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
          WInfoRow(s.subscriptionPeriod, ctrl.selectedPeriod.value.getTitle()),
          WPriceRow('${s.users} (${ctrl.selectedUserCount.value})', calculated.totalUserPrice.toString().toTomanMoney()),
          WPriceRow(
            '${s.storage} (${ctrl.selectedStorage.value} ${s.gb})',
            calculated.totalStoragePrice.toString().toTomanMoney(),
          ),
          if (ctrl.isLegalModuleSelected)
            WPriceRow(
              '${s.contractCount} (${ctrl.selectedMaxContractCount.value.title})',
              calculated.totalContractPrice.toString().toTomanMoney(),
            ),
          if (calculated.modulePriceList.isNotEmpty) ...[
            WInfoRow('${s.selectedModules} (${calculated.modulePriceList.length})', ''),
            Container(
              margin: const EdgeInsetsDirectional.only(start: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                children: calculated.modulePriceList.map((final mod) {
                  final module = mod.module;
                  final finalPrice = mod.finalPrice.toString().toTomanMoney();
                  return WPriceRow("- ${module.title} (${calculated.daysToAdd} ${s.days})", finalPrice, verPadding: 0);
                }).toList(),
              ),
            ),
          ],
        ],
      );
    });
  }

  // Widget _buildBankAccountInfo(final BuildContext context) {
  //   return WCard(
  //     color: AppColors.purple.withValues(alpha: 0.05),
  //     margin: EdgeInsets.zero,
  //     showBorder: true,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(s.bankAccountInformation).titleMedium(color: AppColors.purple).alignAtCenter(),
  //         const SizedBox(height: 8),
  //         WInfoRow(s.bank, ctrl.bermoodaBankAccountInfo.value?.bankName ?? ''),
  //         WInfoRow(s.iban, ctrl.bermoodaBankAccountInfo.value?.iban ?? ''),
  //         WInfoRow(s.accountOwnerName, ctrl.bermoodaBankAccountInfo.value?.accountOwnerName ?? ''),
  //         Divider(color: context.theme.dividerColor.withValues(alpha: 0.5)),
  //         // Payment receipt upload
  //         _buildPaymentReceiptUpload().marginOnly(top: 10),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildPaymentReceiptUpload() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text('${s.sendPaymentReceipt}:').bodyMedium(color: AppColors.purple),
  //       const SizedBox(height: 8),
  //       Row(
  //         children: [
  //           Expanded(
  //             child: Container(
  //               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //               decoration: BoxDecoration(
  //                 color: Colors.grey.shade100,
  //                 border: Border.all(color: Colors.grey.shade300),
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: Text('${s.select} ${s.file}').bodyMedium(color: Colors.grey.shade600),
  //             ),
  //           ),
  //           const SizedBox(width: 8),
  //           UElevatedButton(
  //             title: s.send,
  //             backgroundColor: Colors.purple,
  //             onTap: () {
  //               AppNavigator.snackbarGreen(title: s.done, subtitle: '');
  //             },
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 4),
  //       Text('فرمت های مجاز JPG, PNG, PDF (حداکثر ۵MB)').bodySmall(color: Colors.grey.shade600),
  //     ],
  //   );
  // }
}
