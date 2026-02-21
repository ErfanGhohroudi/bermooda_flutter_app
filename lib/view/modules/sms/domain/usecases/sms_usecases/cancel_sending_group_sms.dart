import '../../entity/group_sms.dart';
import '../../repositories/sms_panel_repository.dart';

/// UseCase for cancel sending a group SMS
class CancelSendingGroupSmsUseCase {
  CancelSendingGroupSmsUseCase(this.repository);

  final SmsPanelRepository repository;

  Future<GroupSmsEntity> call(final int id) => repository.cancelGroupSMS(id);
}
