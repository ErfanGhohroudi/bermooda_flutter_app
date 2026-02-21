import '../../../../../../data/data.dart';
import '../../entity/sms_panel_number.dart';
import '../../repositories/sms_panel_repository.dart';

/// UseCase for getting numbers by department
class GetSmsNumbersByDepartmentUseCase {
  GetSmsNumbersByDepartmentUseCase(this.repository);

  final SmsPanelRepository repository;

  Future<GenericResponse<SmsPanelNumber>> call({
    required final int departmentId,
    required final int pageNumber,
  }) => repository.getNumbersByDepartment(
    departmentId: departmentId,
    pageNumber: pageNumber,
  );
}
