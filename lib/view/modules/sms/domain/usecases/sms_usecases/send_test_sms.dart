import '../../entity/sms.dart';
import '../../repositories/sms_panel_repository.dart';

/// UseCase for sending single SMS for test
class SendTestSmsUseCase {
  SendTestSmsUseCase(this.repository);

  final SmsPanelRepository repository;

  Future<SmsEntity> call({
    required final String content,
    required final String recipientPhoneNumber,
    required final int senderId,
  }) => repository.sendTestSMS(
    content: content,
    recipient: recipientPhoneNumber,
    senderId: senderId,
  );
}
