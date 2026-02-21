
import '../../../../../data/data.dart';
import '../entities/support_department.dart';
import '../repositories/support_department_repository.dart';

class CreateSupportDepartmentUseCase {
  final SupportDepartmentRepository repository;

  CreateSupportDepartmentUseCase(this.repository);

  Future<SupportDepartment> call({
    required final String title,
    required final List<UserReadDto> members,
    required final int? avatarId,
  }) {
    return repository.createDepartment(
      title: title,
      members: members,
      avatarId: avatarId,
    );
  }
}
