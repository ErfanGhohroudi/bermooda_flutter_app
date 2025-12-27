import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/theme.dart';
import '../../profile_controller.dart';

class SalaryBenefitsTab extends StatelessWidget {
  const SalaryBenefitsTab({
    required this.controller,
    super.key,
  });

  final ProfileController controller;

  @override
  Widget build(final BuildContext context) {
    return Obx(() {
      if (controller.pageState.isLoading()) {
        return const Center(child: WCircularLoading());
      }

      if (controller.hrModuleIsActive == false) {
        return Center(
          child: WErrorWidget(
            iconString: AppIcons.info,
            iconColor: context.theme.hintColor,
            errorTitle: s.hRModuleIsRequired,
            size: 50,
            onTapButton: () {},
          ),
        );
      }

      return Center(
        child: WErrorWidget(
          iconString: AppIcons.info,
          iconColor: context.theme.hintColor,
          errorTitle: s.soon,
          size: 50,
          onTapButton: () {},
        ),
      );

      return SingleChildScrollView(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
        child: Column(
          spacing: 16,
          children: [
            // Header with actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(s.salaryAndBenefits).titleMedium().bold(),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: controller.addSalaryRecord,
                      icon: const Icon(Icons.add, size: 18),
                      label: Text("s.addSalary"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: controller.addBenefit,
                      icon: const Icon(Icons.add, size: 18),
                      label: Text("s.addBenefit"),
                    ),
                  ],
                ),
              ],
            ),

            // Current Salary Summary
            WCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Text("s.currentSalary").titleMedium().bold(),
                  Row(
                    spacing: 16,
                    children: [
                      Expanded(
                        child: _buildSalaryInfo(
                          label: "s.baseSalary",
                          value: '${_formatCurrency(_getCurrentBaseSalary())}',
                          icon: Icons.account_balance_wallet_outlined,
                          color: Colors.blue,
                        ),
                      ),
                      Expanded(
                        child: _buildSalaryInfo(
                          label: "s.totalBenefits",
                          value: '${_formatCurrency(_getTotalBenefits())}',
                          icon: Icons.card_giftcard_outlined,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 16,
                    children: [
                      Expanded(
                        child: _buildSalaryInfo(
                          label: "s.grossSalary",
                          value: '${_formatCurrency(_getGrossSalary())}',
                          icon: Icons.trending_up_outlined,
                          color: Colors.orange,
                        ),
                      ),
                      Expanded(
                        child: _buildSalaryInfo(
                          label: "s.netSalary",
                          value: '${_formatCurrency(_getNetSalary())}',
                          icon: Icons.account_balance_outlined,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Salary History
            WCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("s.salaryHistory").titleMedium().bold(),
                      TextButton(
                        onPressed: controller.addSalaryRecord,
                        child: Text("s.addRecord"),
                      ),
                    ],
                  ),
                  if (controller.salaryHistory.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.history_outlined,
                              size: 48,
                              color: context.theme.hintColor,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "s.noSalaryHistory",
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.theme.hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      itemCount: controller.salaryHistory.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (final context, final index) {
                        final salary = controller.salaryHistory[index];
                        return _buildSalaryHistoryItem(salary, context);
                      },
                    ),
                ],
              ),
            ),

            // Benefits
            WCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("s.benefits").titleMedium().bold(),
                      TextButton(
                        onPressed: controller.addBenefit,
                        child: Text("s.addBenefit"),
                      ),
                    ],
                  ),
                  if (controller.benefits.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.card_giftcard_outlined,
                              size: 48,
                              color: context.theme.hintColor,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "s.noBenefits",
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.theme.hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      itemCount: controller.benefits.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (final context, final index) {
                        final benefit = controller.benefits[index];
                        return _buildBenefitItem(benefit, context);
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSalaryInfo({
    required final String label,
    required final String value,
    required final IconData icon,
    required final Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(value).titleMedium().bold(),
        const SizedBox(height: 4),
        Text(label, textAlign: TextAlign.center).bodySmall(color: Get.theme.hintColor),
      ],
    );
  }

  Widget _buildSalaryHistoryItem(final Map<String, dynamic> salary, final BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(salary['month'] ?? "- -").titleMedium().bold(),
              Text('${_formatCurrency(salary['total'] ?? 0)}').titleMedium(color: Colors.green).bold(),
            ],
          ),
          Row(
            spacing: 16,
            children: [
              Expanded(
                child: _buildSalaryDetail(
                  label: "s.baseSalary",
                  value: '${_formatCurrency(salary['baseSalary'] ?? 0)}',
                ),
              ),
              Expanded(
                child: _buildSalaryDetail(
                  label: "s.bonus",
                  value: '${_formatCurrency(salary['bonus'] ?? 0)}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryDetail({
    required final String label,
    required final String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        Text(label).bodySmall(color: Get.theme.hintColor),
        Text(value).bodyMedium(),
      ],
    );
  }

  Widget _buildBenefitItem(final Map<String, dynamic> benefit, final BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.theme.dividerColor),
      ),
      child: Row(
        children: [
          const Icon(Icons.card_giftcard_outlined, color: Colors.green, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(benefit['type'] ?? "- -").titleMedium().bold(),
                Text('${_formatCurrency(benefit['amount'] ?? 0)}').bodyLarge(color: AppColors.green).bold(),
              ],
            ),
          ),
          _buildStatusChip(benefit['status'] ?? "- -"),
          const SizedBox(width: 8),
          WMoreButtonIcon(
            items: [
              WPopupMenuItem(
                title: s.edit,
                titleColor: AppColors.green,
                icon: AppIcons.editOutline,
                iconColor: AppColors.green,
                onTap: () => _editBenefit(benefit),
              ),
              WPopupMenuItem(
                title: s.delete,
                titleColor: AppColors.red,
                icon: AppIcons.delete,
                iconColor: AppColors.red,
                onTap: () => _deleteBenefit(benefit),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(final String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'active':
        color = Colors.green;
        break;
      case 'inactive':
        color = Colors.red;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return WLabel(text: status, color: color);
  }

  String _formatCurrency(final dynamic amount) {
    if (amount is int || amount is double) {
      return '${amount.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (final Match m) => '${m[1]},',
          )} ${s.currency}';
    }
    return '0 ${s.currency}';
  }

  int _getCurrentBaseSalary() {
    if (controller.salaryHistory.isNotEmpty) {
      return controller.salaryHistory.last['baseSalary'] ?? 0;
    }
    return 0;
  }

  int _getTotalBenefits() {
    return controller.benefits
        .where((final benefit) => benefit['status']?.toLowerCase() == 'active')
        .fold(0, (final sum, final benefit) => sum + ((benefit['amount'] as int?) ?? 0));
  }

  int _getGrossSalary() {
    return _getCurrentBaseSalary() + _getTotalBenefits();
  }

  int _getNetSalary() {
    // In real app, you'd calculate taxes and deductions
    return (_getGrossSalary() * 0.85).round();
  }

  void _editBenefit(final Map<String, dynamic> benefit) {
    // Navigate to edit benefit page
    controller.showSuccess("s.benefitEdited");
  }

  void _deleteBenefit(final Map<String, dynamic> benefit) {
    appShowYesCancelDialog(
      title: s.delete,
      description: "s.deleteBenefitConfirmation",
      yesButtonTitle: s.delete,
      yesBackgroundColor: AppColors.red,
      onYesButtonTap: () {
        UNavigator.back();
        controller.benefits.remove(benefit);
        controller.showSuccess("s.benefitDeleted");
      },
    );
    showDialog(
      context: Get.context!,
      builder: (final context) => AlertDialog(
        title: Text("s.deleteBenefit"),
        content: Text("s.deleteBenefitConfirmation"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(s.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.benefits.remove(benefit);
              controller.showSuccess("s.benefitDeleted");
            },
            child: Text(s.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
