import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../core/theme.dart';
import '../../profile_controller.dart';

class EmploymentTab extends StatelessWidget {
  const EmploymentTab({
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            // Header with actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(s.employment).titleMedium().bold(),
                IconButton(
                  tooltip: s.edit,
                  onPressed: () => AppNavigator.snackbarGreen(title: s.done, subtitle: "Edited"),
                  icon: const UImage(AppIcons.editOutline, color: AppColors.green),
                ),
              ],
            ),

            // Employment Overview
            WCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "s.employmentOverview",
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (controller.employmentInfo.value != null) ...[
                    _buildEmploymentGrid([
                      _EmploymentItem(s.role, controller.employmentInfo.value!['position'] ?? "s.unknown"),
                      _EmploymentItem(s.employmentType, controller.employmentInfo.value!['employmentType'] ?? "s.unknown"),
                      _EmploymentItem(s.contractStartDate, controller.employmentInfo.value!['contractStart'] ?? "s.unknown"),
                      _EmploymentItem(s.contractEndDate, controller.employmentInfo.value!['contractEnd'] ?? "s.unknown"),
                      _EmploymentItem("s.probationPeriod", controller.employmentInfo.value!['probationPeriod'] ?? "s.unknown"),
                      _EmploymentItem("s.noticePeriod", controller.employmentInfo.value!['noticePeriod'] ?? "s.unknown"),
                    ]),
                  ] else ...[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            UImage(
                              AppIcons.briefcaseOutline,
                              size: 48,
                              color: context.theme.hintColor,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "s.noEmploymentInfo",
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.theme.hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Contract Details
            WCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("s.contractDetails").titleMedium().bold(),
                  const SizedBox(height: 16),
                  _buildContractInfo(),
                ],
              ),
            ),

            // Work Schedule
            WCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("s.workSchedule").titleMedium().bold(),
                  const SizedBox(height: 16),
                  _buildWorkScheduleInfo(),
                ],
              ),
            ),

            // Benefits and Compensation
            WCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("s.benefitsAndCompensation").titleMedium().bold(),
                  const SizedBox(height: 16),
                  _buildBenefitsInfo(),
                ],
              ),
            ),

            // Employment History
            WCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("s.employmentHistory").titleMedium().bold(),
                  const SizedBox(height: 16),
                  _buildEmploymentHistory(),
                ],
              ),
            ),

            // Emergency Actions
            if (controller.haveAdminAccess) ...[
              WCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("s.emergencyActions").titleMedium(color: AppColors.red).bold(),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _suspendEmployee,
                      icon: const Icon(Icons.pause_circle_outline),
                      label: Text("s.suspendEmployee"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange,
                        side: const BorderSide(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildEmploymentGrid(final List<_EmploymentItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (final context, final index) {
        final item = items[index];
        return _buildEmploymentItem(item);
      },
    );
  }

  Widget _buildEmploymentItem(final _EmploymentItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(item.label).bodySmall(color: Get.theme.hintColor),
        Text(item.value).bodyMedium(),
      ],
    );
  }

  Widget _buildContractInfo() {
    return Column(
      children: [
        _buildInfoRow("s.contractType", "s.fullTime"),
        _buildInfoRow(s.startDate, controller.employmentInfo.value?['contractStart'] ?? "s.unknown"),
        _buildInfoRow(s.endDate, controller.employmentInfo.value?['contractEnd'] ?? "s.unknown"),
        _buildInfoRow("s.renewalDate", "s.autoRenewal"),
        _buildInfoRow("s.contractStatus", "s.active"),
      ],
    );
  }

  Widget _buildWorkScheduleInfo() {
    return Column(
      children: [
        _buildInfoRow("s.workDays", "s.mondayToFriday"),
        _buildInfoRow("s.workHours", "s.nineToFive"),
        _buildInfoRow("s.breakTime", "s.oneHour"),
        _buildInfoRow("s.overtimePolicy", "s.asPerCompanyPolicy"),
        _buildInfoRow("s.remoteWork", "s.hybrid"),
      ],
    );
  }

  Widget _buildBenefitsInfo() {
    return Column(
      children: [
        _buildInfoRow("s.healthInsurance", "s.included"),
        _buildInfoRow("s.lifeInsurance", "s.included"),
        _buildInfoRow("s.retirementPlan", "s.contributionBased"),
        _buildInfoRow("s.vacationDays", "s.twentyFiveDays"),
        _buildInfoRow("s.sickLeave", "s.unlimited"),
      ],
    );
  }

  Widget _buildEmploymentHistory() {
    final history = [
      {
        'position': "s.softwareDeveloper",
        'department': "s.engineering",
        'startDate': '2024-01-01',
        'endDate': "s.current",
        'status': "s.active",
      },
      {
        'position': "s.juniorDeveloper",
        'department': "s.engineering",
        'startDate': '2023-06-01',
        'endDate': '2023-12-31',
        'status': "s.promoted",
      },
    ];

    return Column(
      children: history.map((final item) => _buildHistoryItem(item)).toList(),
    );
  }

  Widget _buildHistoryItem(final Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Get.theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item['position']).titleMedium().bold(),
              _buildStatusChip(item['status']),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoRow(s.department, item['department']),
          _buildInfoRow(s.startDate, item['startDate']),
          _buildInfoRow(s.endDate, item['endDate']),
        ],
      ),
    );
  }

  Widget _buildInfoRow(final String label, final String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          SizedBox(
            width: 120,
            child: Text(label).bodyMedium(color: Get.theme.hintColor),
          ),
          Text(value).bodyMedium().expanded(),
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
      case 'promoted':
        color = Colors.blue;
        break;
      case 'terminated':
        color = Colors.red;
        break;
      case 'suspended':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return WLabel(text: status, color: color);
  }

  void _suspendEmployee() {
    showDialog(
      context: Get.context!,
      builder: (final context) => AlertDialog(
        title: Text("s.suspendEmployee").titleMedium().bold(),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            Text("s.suspendEmployeeConfirmation").bodyMedium(),
            TextField(
              decoration: InputDecoration(
                labelText: "s.reason",
                hintText: "s.enterSuspensionReason",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 3,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "s.duration",
                hintText: "s.enterSuspensionDuration",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(s.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.showSuccess("s.employeeSuspended");
            },
            child: Text("s.suspend", style: const TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }
}

class _EmploymentItem {
  final String label;
  final String value;

  _EmploymentItem(this.label, this.value);
}
