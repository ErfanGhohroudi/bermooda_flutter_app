import '../../entity/voip_number.dart';
import '../../repositories/voip_repository.dart';

/// UseCase for getting numbers with user access
class GetVoipNumbersWithUserAccessUseCase {
  GetVoipNumbersWithUserAccessUseCase(this.repository);

  final VoipRepository repository;

  Future<List<VoipNumber>> call() => repository.getNumbersWithUserAccess();
}
