import '../../../../../data/data.dart';
import '../entities/support_department.dart';
import '../repositories/support_department_repository.dart';

class UpdateSupportDepartmentUseCase {
  final SupportDepartmentRepository repository;

  UpdateSupportDepartmentUseCase(this.repository);

  Future<SupportDepartment> call({
    required final int id,
    required final String title,
    required final List<UserReadDto> members,
    required final int? avatarId,
  }) {
    return repository.updateDepartment(
      id: id,
      title: title,
      members: members,
      avatarId: avatarId,
    );
  }
}
