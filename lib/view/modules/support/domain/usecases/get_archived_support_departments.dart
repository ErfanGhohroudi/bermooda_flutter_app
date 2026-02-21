import '../../../../../data/data.dart';
import '../entities/support_department.dart';
import '../repositories/support_department_repository.dart';

class GetArchivedSupportDepartmentsUseCase {
  final SupportDepartmentRepository repository;

  GetArchivedSupportDepartmentsUseCase(this.repository);

  Future<GenericResponse<SupportDepartment>> call({
    required final int pageNumber,
    final int perPageCount = 20,
    final String? search,
  }) {
    return repository.getArchivedDepartments(
      pageNumber: pageNumber,
      perPageCount: perPageCount,
      search: search,
    );
  }
}
