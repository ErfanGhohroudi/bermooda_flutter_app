import '../../../../../data/data.dart';
import '../repositories/support_board_repository.dart';

class GetMembersUseCase {
  final SupportBoardRepository repository;

  GetMembersUseCase(this.repository);

  Future<List<UserReadDto>> call() {
    return repository.getAllMembers();
  }
}
