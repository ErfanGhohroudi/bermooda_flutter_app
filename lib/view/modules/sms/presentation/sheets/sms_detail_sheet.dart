import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/utils/extensions/date_extensions.dart';
import '../../../../../core/utils/extensions/money_extensions.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../domain/entity/sms.dart';

class SmsDetailSheet extends StatelessWidget {
  const SmsDetailSheet({
    required this.item,
    super.key,
  });

  final SmsEntity item;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 10,
      children: [
        _buildGeneralInfo(context),
        _buildContent(context),
        if (item.errorMessage != null && item.errorMessage!.isNotEmpty) _buildErrorInfo(context),
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
        spacing: 12,
        children: [
          Text(s.generalInfo).titleMedium().bold(),
          _buildInfoRow(context, s.recipient, item.recipient ?? '- -'),
          if (item.recipientName != null) _buildInfoRow(context, s.name, item.recipientName!),
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
          if (item.senderNumber != null) _buildInfoRow(context, s.senderNumber, item.senderNumber!),
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
          if (item.sentAt != null) _buildInfoRow(context, s.sentAt, item.sentAt!.toDateTimeString),
          if (item.cost != null) _buildInfoRow(context, s.cost, (item.cost ?? '0').toRialMoney()),
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
          Text(s.messageContent).titleMedium().bold(),
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

  Widget _buildErrorInfo(final BuildContext context) {
    return WCard(
      showBorder: true,
      margin: EdgeInsets.zero,
      borderColor: AppColors.red.withValues(alpha: 0.3),
      color: AppColors.red.withValues(alpha: 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            spacing: 10,
            children: [
              const UImage(AppIcons.warningOutline, color: AppColors.red, size: 25),
              Text(s.error).titleMedium(color: AppColors.red, fontWeight: FontWeight.bold),
            ],
          ),
          Text(item.errorMessage!).bodyMedium(color: AppColors.red),
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
}
