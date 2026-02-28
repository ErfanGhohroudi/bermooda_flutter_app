import '../repositories/support_board_repository.dart';

class DeleteBoardSectionUseCase {
  final SupportBoardRepository repository;

  DeleteBoardSectionUseCase(this.repository);

  Future<void> call(final int id) {
    return repository.deleteSection(id);
  }
}
