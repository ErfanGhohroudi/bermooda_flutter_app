import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/utils/extensions/date_extensions.dart';
import '../../../../../core/utils/extensions/money_extensions.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../domain/entity/group_sms.dart';

class GroupSmsDetailSheet extends StatelessWidget {
  const GroupSmsDetailSheet({
    required this.item,
    super.key,
  });

  final GroupSmsEntity item;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 10,
      children: [
        _buildGeneralInfo(context),
        _buildContent(context),
        _buildStatistics(context),
        if (item.invalidRecipients.isNotEmpty || item.duplicateRecipients.isNotEmpty) _buildValidationInfo(context),
      ],
    );
  }

  Widget _buildGeneralInfo(final BuildContext context) {
    return WCard(
      showBorder: true,
      margin: EdgeInsets.zero,
      verPadding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(s.generalInfo).titleMedium(),
          _buildInfoRowWidget(
            context,
            s.status,
            item.status != null
                ? WLabel(
                    text: item.status?.title,
                    color: item.status?.color,
                  )
                : null,
          ),
          _buildInfoRow(context, s.senderNumber, item.senderNumber ?? '- -'),
          if (item.senderProvider != null) _buildInfoRow(context, s.provider, item.senderProvider!),
          if (item.sentByUser != null)
            _buildInfoRowWidget(
              context,
              s.sentBy,
              item.sentByUser != null
                  ? Flexible(
                    child: WCircleAvatar(
                        user: item.sentByUser,
                        showFullName: true,
                        size: 25,
                        bodySmall: true,
                        imageFontSize: 9,
                        expand: false,
                      ),
                  )
                  : null,
            ),
          _buildInfoRow(context, s.createdAt, item.createdAt?.toDateTimeString ?? '- -'),
          if (item.scheduledAt != null) _buildInfoRow(context, s.scheduledDate, item.scheduledAt!.toDateTimeString),
          if (item.totalCost != null) _buildInfoRow(context, s.cost, (item.totalCost ?? '0').toRialMoney()),
        ],
      ),
    );
  }

  Widget _buildContent(final BuildContext context) {
    return WCard(
      showBorder: true,
      margin: EdgeInsets.zero,
      verPadding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(s.messageContent).titleMedium(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: context.theme.dividerColor),
            ),
            child: Text(item.content).bodyMedium(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics(final BuildContext context) {
    return WCard(
      showBorder: true,
      margin: EdgeInsets.zero,
      verPadding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(s.statistics).titleMedium(),
          Row(
            children: [
              _buildStatItem(context, s.recipients, item.totalRecipients, null).expanded(),
              _buildStatItem(context, s.sent, item.sentCount, AppColors.blue).expanded(),
            ],
          ),
          const Divider(),
          Row(
            children: [
              _buildStatItem(context, s.delivered, item.deliveredCount, AppColors.green).expanded(),
              _buildStatItem(context, s.failed, item.failedCount, AppColors.red).expanded(),
            ],
          ),
          const Divider(),
          _buildInfoRow(context, s.success, "${item.successRate.percentageFormatted}%"),
        ],
      ),
    );
  }

  Widget _buildValidationInfo(final BuildContext context) {
    return WCard(
      showBorder: true,
      margin: EdgeInsets.zero,
      verPadding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(s.validationIssues).titleMedium(),
          if (item.invalidRecipients.isNotEmpty) ...[
            Text("${s.invalid}: ${item.invalidRecipients.length}").bodySmall(color: AppColors.red),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: item.invalidRecipients
                  .take(10)
                  .map(
                    (final e) => Chip(
                      label: Text(e).bodySmall(),
                      backgroundColor: AppColors.red.withValues(alpha: 0.1),
                      padding: EdgeInsets.zero,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                  )
                  .toList(),
            ),
            if (item.invalidRecipients.length > 10)
              Text("... ${s.andMore(item.invalidRecipients.length - 10)}").bodySmall(color: context.theme.hintColor),
          ],
          if (item.duplicateRecipients.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text("${s.duplicate}: ${item.duplicateRecipients.length}").bodySmall(color: AppColors.orange),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: item.duplicateRecipients
                  .take(10)
                  .map(
                    (final e) => Chip(
                      label: Text(e).bodySmall(),
                      backgroundColor: AppColors.orange.withValues(alpha: 0.1),
                      padding: EdgeInsets.zero,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                  )
                  .toList(),
            ),
            if (item.duplicateRecipients.length > 10)
              Text("... ${s.andMore(item.duplicateRecipients.length - 10)}").bodySmall(color: context.theme.hintColor),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(final BuildContext context, final String label, final String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 5,
      children: [
        Text(label).bodyMedium(color: context.theme.hintColor),
        Flexible(child: Text(value).bodyMedium()),
      ],
    );
  }

  Widget _buildInfoRowWidget(final BuildContext context, final String label, final Widget? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 5,
      children: [
        Text(label).bodyMedium(color: context.theme.hintColor),
        if (value != null) value,
      ],
    );
  }

  Widget _buildStatItem(final BuildContext context, final String label, final int count, final Color? color) {
    return Column(
      children: [
        Text(label).bodyMedium(color: context.theme.hintColor),
        Text(count.toString().separateNumbers3By3()).bodyLarge(color: color),
      ],
    );
  }
}
