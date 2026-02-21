import '../repositories/support_department_repository.dart';

class RestoreSupportDepartmentUseCase {
  final SupportDepartmentRepository repository;

  RestoreSupportDepartmentUseCase(this.repository);

  Future<void> call(final int id) {
    return repository.restoreDepartment(id);
  }
}
