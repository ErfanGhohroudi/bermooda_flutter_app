import '../../../../../../data/data.dart';
import '../../entity/voip_department.dart';
import '../../repositories/voip_repository.dart';

/// UseCase for getting numbers by department
class GetDepartmentsUseCase {
  GetDepartmentsUseCase(this.repository);

  final VoipRepository repository;

  Future<GenericResponse<VoipDepartment>> call({
    required final int pageNumber,
    final String? search,
  }) => repository.getDepartments(
    pageNumber: pageNumber,
    search: search,
  );
}
