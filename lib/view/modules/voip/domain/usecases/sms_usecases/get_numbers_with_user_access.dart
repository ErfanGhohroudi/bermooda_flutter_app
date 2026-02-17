import '../../entity/sms_panel_number.dart';
import '../../repositories/sms_panel_repository.dart';

/// UseCase for getting numbers with user access
class GetNumbersWithUserAccessUseCase {
  GetNumbersWithUserAccessUseCase(this.repository);

  final VoipRepository repository;

  Future<List<SmsPanelNumber>> call() => repository.getNumbersWithUserAccess();
}
