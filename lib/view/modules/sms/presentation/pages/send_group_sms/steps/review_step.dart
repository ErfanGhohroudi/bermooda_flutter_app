import 'package:u/utilities.dart';

import '../../../../../../../core/core.dart';
import '../../../../../../../core/theme.dart';
import '../../../../../../../core/utils/extensions/date_extensions.dart';
import '../../../../../../../core/utils/extensions/money_extensions.dart';
import '../../../../../../../core/widgets/fields/fields.dart';
import '../../../../../../../core/widgets/widgets.dart';
import '../../../controllers/send_group_sms_controller.dart';

class ReviewStep extends StatelessWidget {
  const ReviewStep({
    required this.ctrl,
    super.key,
  });

  final SendGroupSmsController ctrl;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        WCard(
          showBorder: true,
          elevation: 0,
          margin: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Text(s.campaignSummary).titleMedium(),
              _buildInfoRow(context, s.title, ctrl.titleCtrl.text),
              Obx(
                () => _buildInfoRow(
                  context,
                  s.sender,
                  ctrl.selectedSender.value != null
                      ? "${ctrl.selectedSender.value!.title} (${ctrl.selectedSender.value!.number})"
                      : '-',
                ),
              ),
              Obx(
                () => _buildInfoRow(
                  context,
                  s.sendTime,
                  ctrl.scheduledDate.value?.toDateTimeString ?? s.immediate,
                ),
              ),
              const Divider(),
              Obx(() {
                final result = ctrl.validationResult.value;
                return Row(
                  children: [
                    _buildStatItem(context, s.valid, result?.counts.valid ?? 0, AppColors.green).expanded(),
                    _buildStatItem(context, s.invalid, result?.counts.invalid ?? 0, AppColors.red).expanded(),
                    _buildStatItem(context, s.duplicate, result?.counts.duplicate ?? 0, AppColors.orange).expanded(),
                  ],
                );
              }),
              const Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.messageContent).bodySmall(color: context.theme.hintColor),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: context.theme.dividerColor),
                    ),
                    child: Text(ctrl.contentCtrl.text).bodyMedium(),
                  ),
                ],
              ),
              const Divider(),
              // Obx(
              //   () {
              //     final result = ctrl.validationResult.value;
              //     return _buildInfoRow(
              //       context,
              //       s.estimatedCost,
              //       ((result?.counts.valid ?? 0) * 33).toString().toRialMoney(),
              //     );
              //   },
              // ),
              _buildInfoRow(
                context,
                s.senderBalance,
                (ctrl.selectedSender.value?.balance ?? '0').toRialMoney(),
              ).pOnly(bottom: 10),
            ],
          ),
        ),
        WCard(
          showBorder: true,
          margin: EdgeInsets.zero,
          elevation: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Text("${s.sendTest} ${s.optional}").titleMedium(),
              Row(
                spacing: 10,
                children: [
                  Form(
                    key: ctrl.sendTestFormKey,
                    child: WPhoneNumberField(
                      controller: ctrl.testNumberCtrl,
                      hintText: "09123456789",
                      maxLength: 11,
                      minLength: 11,
                      startWith: '09',
                    ),
                  ).expanded(),
                  UElevatedButton(
                    onTap: ctrl.sendTestSms,
                    title: s.sendTest,
                    width: 100,
                    height: 48,
                  ),
                ],
              ),
              Text(s.testSendDoesNotAffectCampaignStats).bodySmall(color: context.theme.hintColor),
            ],
          ),
        ),
        WCard(
          showBorder: true,
          margin: EdgeInsets.zero,
          elevation: 0,
          color: AppColors.orange.withValues(alpha: 0.1),
          borderColor: AppColors.orange.withValues(alpha: 0.3),
          child: Column(
            spacing: 10,
            children: [
              Row(
                spacing: 12,
                children: [
                  const UImage(AppIcons.warningOutline, color: AppColors.orange, size: 25),
                  Text(s.warning).titleMedium(color: AppColors.orange).expanded(),
                ],
              ),
              Padding(
                padding: const EdgeInsetsGeometry.directional(start: 35),
                child: Text(s.groupSmsWarningMessage).bodyMedium(color: AppColors.orange),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(final BuildContext context, final String label, final String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label).bodySmall(color: context.theme.hintColor),
        Text(value).bodyMedium().bold(),
      ],
    );
  }

  Widget _buildStatItem(final BuildContext context, final String label, final int count, final Color color) {
    return Column(
      children: [
        Text(label).bodyMedium(color: context.theme.hintColor),
        Text(count.toString().separateNumbers3By3()).bodyLarge(color: color).bold(),
      ],
    );
  }
}
