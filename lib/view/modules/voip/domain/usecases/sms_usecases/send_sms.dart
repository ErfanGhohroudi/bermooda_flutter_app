import '../../repositories/sms_panel_repository.dart';

/// UseCase for verify or reject payment record
class SendSmsUseCase {
  SendSmsUseCase(this.repository);

  final VoipRepository repository;

  Future<void> call({
    required final String content,
    required final String recipientPhoneNumber,
    required final int senderId,
  }) => repository.sendSMS(
    content: content,
    recipient: recipientPhoneNumber,
    senderId: senderId,
  );
}
