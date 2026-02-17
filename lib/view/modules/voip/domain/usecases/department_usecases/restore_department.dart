import '../../repositories/voip_repository.dart';

/// UseCase for restore a department
class RestoreDepartmentUseCase {
  RestoreDepartmentUseCase(this.repository);

  final VoipRepository repository;

  Future<void> call(final int id) => repository.restoreDepartment(id);
}
