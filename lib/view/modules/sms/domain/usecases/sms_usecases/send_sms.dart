import 'package:u/utils/shamsi_date/src/jalali/jalali_date.dart';

import '../../entity/sms.dart';
import '../../repositories/sms_panel_repository.dart';

/// UseCase for sending single SMS
class SendSmsUseCase {
  SendSmsUseCase(this.repository);

  final SmsPanelRepository repository;

  Future<SmsEntity> call({
    required final String content,
    required final String recipientPhoneNumber,
    required final int senderId,
    final int? departmentId,
    final Jalali? scheduledAt,
  }) => repository.sendSMS(
    content: content,
    recipient: recipientPhoneNumber,
    senderId: senderId,
    departmentId: departmentId,
    scheduledAt: scheduledAt,
  );
}
