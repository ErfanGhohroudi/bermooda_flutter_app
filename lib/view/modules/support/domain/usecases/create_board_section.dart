import '../../../../../core/utils/enums/enums.dart';
import '../entities/support_section.dart';
import '../repositories/support_board_repository.dart';

class CreateBoardSectionUseCase {
  final SupportBoardRepository repository;

  CreateBoardSectionUseCase(this.repository);

  Future<SupportSection> call({
    required final int departmentId,
    required final String title,
    required final LabelColors color,
  }) {
    return repository.createSection(
      departmentId: departmentId,
      title: title,
      color: color,
    );
  }
}
