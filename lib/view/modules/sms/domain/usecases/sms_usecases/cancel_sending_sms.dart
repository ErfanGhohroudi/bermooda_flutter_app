import '../../entity/sms.dart';
import '../../repositories/sms_panel_repository.dart';

/// UseCase for cancel sending a single SMS
class CancelSendingSmsUseCase {
  CancelSendingSmsUseCase(this.repository);

  final SmsPanelRepository repository;

  Future<SmsEntity> call(final int id) => repository.cancelSMS(id);
}
