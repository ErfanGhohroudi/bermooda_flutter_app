import '../../../../../../core/widgets/kanban_board/view_models/section_view_model.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/data.dart';
import '../entities/support_customer_entity.dart';
import '../entities/support_section.dart';

abstract class SupportBoardRepository {
  Future<SupportCustomer> createCustomer({
    required final int departmentId,
    required final int sectionId,
    required final String fullName,
    required final String phoneNumber,
  });

  void getBoard({
    required final String departmentSlug,
    required final Function(List<Section<SupportSection, SupportCustomer>> sections) onResponse,
    required final Function(GenericResponse<dynamic> error) onError,
  });

  void moveCard({
    required final String cardSlug,
    required final String targetSectionSlug,
    required final String? previousCardSlug,
    required final String? nextCardSlug,
    required final Function(GenericResponse<dynamic> response) onResponse,
    required final Function(GenericResponse<dynamic> error) onError,
  });

  Future<SupportSection> createSection({
    required final int departmentId,
    required final String title,
    required final LabelColors color,
  });

  Future<SupportSection> updateSection({
    required final int id,
    required final String title,
    required final LabelColors color,
  });

  Future<void> deleteSection(final int id);

  Future<List<UserReadDto>> getAllMembers();
}
