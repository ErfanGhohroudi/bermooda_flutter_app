import '../../repositories/voip_repository.dart';

/// UseCase for archive a department
class ArchiveDepartmentUseCase {
  ArchiveDepartmentUseCase(this.repository);

  final VoipRepository repository;

  Future<void> call(final int id) => repository.archiveDepartment(id);
}
