import '../../../../../../data/data.dart';
import '../../entity/voip_department.dart';
import '../../repositories/voip_repository.dart';

/// UseCase for getting archived department
class GetArchivedDepartmentsUseCase {
  GetArchivedDepartmentsUseCase(this.repository);

  final VoipRepository repository;

  Future<GenericResponse<VoipDepartment>> call({
    required final int pageNumber,
    final String? search,
  }) => repository.getArchivedDepartments(
    pageNumber: pageNumber,
    search: search,
  );
}
