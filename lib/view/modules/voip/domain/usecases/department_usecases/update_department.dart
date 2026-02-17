import '../../../../../../data/data.dart';
import '../../entity/voip_department.dart';
import '../../repositories/voip_repository.dart';

/// UseCase for update department
class UpdateDepartmentUseCase {
  UpdateDepartmentUseCase(this.repository);

  final VoipRepository repository;

  Future<VoipDepartment> call({
    required final int id,
    required final String title,
    required final List<UserReadDto> members,
    final MainFileReadDto? avatar,
  }) => repository.updateDepartment(
    id: id,
    title: title,
    members: members,
    avatar: avatar,
  );
}
