import '../../../../../../data/data.dart';
import '../../entity/sms_department.dart';
import '../../repositories/sms_panel_repository.dart';

/// UseCase for getting archived department
class GetArchivedDepartmentsUseCase {
  GetArchivedDepartmentsUseCase(this.repository);

  final SmsPanelRepository repository;

  Future<GenericResponse<SmsDepartment>> call({
    required final int pageNumber,
    final String? search,
  }) => repository.getArchivedDepartments(
    pageNumber: pageNumber,
    search: search,
  );
}
