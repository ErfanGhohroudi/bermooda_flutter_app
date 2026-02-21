
import '../../../../../data/data.dart';
import '../entities/support_department.dart';
import '../repositories/support_department_repository.dart';

class GetSupportDepartmentsUseCase {
  final SupportDepartmentRepository repository;

  GetSupportDepartmentsUseCase(this.repository);

  Future<GenericResponse<SupportDepartment>> call({
    required final int pageNumber,
    final int perPageCount = 20,
    final String? search,
  }) {
    return repository.getDepartments(
      pageNumber: pageNumber,
      perPageCount: perPageCount,
      search: search,
    );
  }
}
