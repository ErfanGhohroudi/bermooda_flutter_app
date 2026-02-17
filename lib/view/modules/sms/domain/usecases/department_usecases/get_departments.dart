import '../../../../../../data/data.dart';
import '../../entity/sms_department.dart';
import '../../repositories/sms_panel_repository.dart';

/// UseCase for getting numbers by department
class GetDepartmentsUseCase {
  GetDepartmentsUseCase(this.repository);

  final SmsPanelRepository repository;

  Future<GenericResponse<SmsDepartment>> call({
    required final int pageNumber,
    final String? search,
  }) => repository.getDepartments(
    pageNumber: pageNumber,
    search: search,
  );
}
