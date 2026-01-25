import 'package:u/utilities.dart';

import '../../../../core/core.dart';
import '../../../../core/theme.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../core/widgets/widgets.dart';
import '../subscription_controller.dart';

class SubscriptionSettings extends StatelessWidget {
  const SubscriptionSettings({
    required this.ctrl,
    super.key,
  });

  final SubscriptionController ctrl;

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => WCard(
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.subscriptionSettings).titleMedium(),
            const SizedBox(height: 16),

            // Subscription Period
            _buildSubscriptionPeriodSection(context),
            const SizedBox(height: 20),

            // Active modules
            _buildActiveModulesSection(context),
            const SizedBox(height: 20),

            // User count
            _buildUserCountSection(context),
            const SizedBox(height: 20),

            // Storage
            _buildStorageSection(context),
            const SizedBox(height: 20),

            // Warning note
            _buildWarningNote(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionPeriodSection(final BuildContext context) {
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
          () => Opacity(
            opacity: ctrl.canChangePeriod ? 1 : 0.3,
            child: GridView.count(
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
        ),
      ],
    );
  }

  Widget _buildActiveModulesSection(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        if (ctrl.selectedModulesIsNotEmpty) ...[
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

  Widget _buildUserCountSection(final BuildContext context) {
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

  Widget _buildStorageSection(final BuildContext context) {
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
                child: Obx(() => Text('${ctrl.selectedStorage.value} ${s.gb}').bodyMedium()),
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
}
