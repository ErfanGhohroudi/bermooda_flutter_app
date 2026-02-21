import '../repositories/support_department_repository.dart';

class ArchiveSupportDepartmentUseCase {
  final SupportDepartmentRepository repository;

  ArchiveSupportDepartmentUseCase(this.repository);

  Future<void> call(final int id) {
    return repository.archiveDepartment(id);
  }
}
