import 'package:u/utils/shamsi_date/src/jalali/jalali_date.dart';

import '../../entity/group_sms.dart';
import '../../repositories/sms_panel_repository.dart';

/// UseCase for sending group SMS
/// Either [recipients] or [fileId] must be provided
class SendGroupSmsUseCase {
  SendGroupSmsUseCase(this.repository);

  final SmsPanelRepository repository;

  Future<GroupSmsEntity> call({
    required final String campaignTitle,
    required final String content,
    required final List<String>? recipientsPhoneNumbers,
    required final int? fileId,
    required final int senderId,
    final int? departmentId,
    final Jalali? scheduledAt,
  }) => repository.sendGroupSMS(
    title: campaignTitle,
    content: content,
    recipients: recipientsPhoneNumbers,
    fileId: fileId,
    senderId: senderId,
    departmentId: departmentId,
    scheduledAt: scheduledAt,
  );
}
