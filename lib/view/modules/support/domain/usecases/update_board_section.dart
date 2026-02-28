import '../../../../../core/utils/enums/enums.dart';
import '../entities/support_section.dart';
import '../repositories/support_board_repository.dart';

class UpdateBoardSectionUseCase {
  final SupportBoardRepository repository;

  UpdateBoardSectionUseCase(this.repository);

  Future<SupportSection> call({
    required final int id,
    required final String title,
    required final LabelColors color,
  }) {
    return repository.updateSection(
      id: id,
      title: title,
      color: color,
    );
  }
}
