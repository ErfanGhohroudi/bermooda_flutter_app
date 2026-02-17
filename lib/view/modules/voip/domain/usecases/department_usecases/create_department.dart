import '../../../../../../data/data.dart';
import '../../entity/voip_department.dart';
import '../../repositories/sms_panel_repository.dart';

/// UseCase for create a new department
class CreateDepartmentUseCase {
  CreateDepartmentUseCase(this.repository);

  final VoipRepository repository;

  Future<VoipDepartment> call({
    required final String title,
    required final List<UserReadDto> members,
    final MainFileReadDto? avatar,
  }) => repository.createDepartment(
    title: title,
    members: members,
    avatar: avatar,
  );
}
