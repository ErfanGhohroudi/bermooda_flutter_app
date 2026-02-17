import '../../../../../../data/data.dart';
import '../../entity/sms_department.dart';
import '../../repositories/sms_panel_repository.dart';

/// UseCase for update department
class UpdateDepartmentUseCase {
  UpdateDepartmentUseCase(this.repository);

  final SmsPanelRepository repository;

  Future<SmsDepartment> call({
    required final int id,
    required final String title,
    required final List<UserReadDto> members,
  }) => repository.updateDepartment(
    id: id,
    title: title,
    members: members,
  );
}
