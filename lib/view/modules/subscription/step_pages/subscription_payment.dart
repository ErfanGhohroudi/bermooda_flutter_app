import 'package:u/utilities.dart';

import '../../../../core/core.dart';
import '../../../../core/theme.dart';
import '../../../../core/utils/extensions/money_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../enums/discount_code_state.dart';
import '../subscription_controller.dart';
import '../widgets/price_row.dart';

class SubscriptionPayment extends StatelessWidget {
  const SubscriptionPayment({
    required this.ctrl,
    super.key,
  });

  final SubscriptionController ctrl;

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () {
        if (ctrl.priceCalculation.value == null) {
          return Center(child: WErrorWidget(onTapButton: () => ctrl.calculatePrice()));
        }

        return WCard(
          margin: EdgeInsets.zero,
          child: Column(
            spacing: 16,
            children: [
              _buildDiscountCodeField(context),
              _buildFinalTotal(context),
            ],
          ),
        );
      },
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
            WPriceRow(s.totalPrice, calculated.totalPrice.toString().toTomanMoney()),
            WPriceRow(
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

  Widget _buildDiscountCodeField(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                // textDirection: TextDirection.ltr,
                helperText: ctrl.discountCodeFieldState.value.helperText,
                helperStyle: ctrl.discountCodeFieldState.value.helperStyle(context),
                // formatters: [
                //   FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]'))
                // ],
                onChanged: ctrl.onDiscountCodeChanged,
                onFieldSubmitted: ctrl.onDiscountCodeChanged,
                suffixIcon: switch (ctrl.discountCodeFieldState.value) {
                  DiscountCodeState.empty => null,
                  _ => _buildApplyButton(),
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildApplyButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        constraints: const BoxConstraints(minWidth: 60),
        child: InkWell(
          onTap: switch (ctrl.discountCodeFieldState.value) {
            DiscountCodeState.empty => null,
            DiscountCodeState.notEmpty => ctrl.onDiscountCodeApply,
            DiscountCodeState.applying => null,
            DiscountCodeState.applied => ctrl.onDiscountCodeRemove,
            DiscountCodeState.invalid => ctrl.onDiscountCodeRemove,
          },
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: ctrl.discountCodeFieldState.value.buttonColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              widthFactor: 1,
              heightFactor: 1,
              child: switch (ctrl.discountCodeFieldState.value) {
                DiscountCodeState.applying => const SizedBox(
                  width: 20,
                  height: 20,
                  child: WCircularLoading(color: Colors.white),
                ),
                _ => Text(ctrl.discountCodeFieldState.value.buttonText).bodyMedium(color: Colors.white),
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFinalTotal(final BuildContext context) {
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
        ],
      );
    });
  }
}
