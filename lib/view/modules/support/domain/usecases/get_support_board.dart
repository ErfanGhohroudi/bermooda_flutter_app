import '../../../../../data/data.dart';
import '../entities/support_customer_entity.dart';
import '../repositories/support_board_repository.dart';
import '../entities/support_section.dart';
import '../../../../../../core/widgets/kanban_board/view_models/section_view_model.dart';

class GetSupportBoardUseCase {
  final SupportBoardRepository repository;

  GetSupportBoardUseCase(this.repository);

  void call({
    required final String departmentSlug,
    required final Function(List<Section<SupportSection, SupportCustomer>> sections) onResponse,
    required final Function(GenericResponse<dynamic> error) onError,
  }) {
    repository.getBoard(
      departmentSlug: departmentSlug,
      onResponse: onResponse,
      onError: onError,
    );
  }
}
