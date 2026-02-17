import '../../../../../../data/data.dart';
import '../../entity/voip_number.dart';
import '../../repositories/voip_repository.dart';

/// UseCase for getting numbers by department
class GetNumbersByDepartmentUseCase {
  GetNumbersByDepartmentUseCase(this.repository);

  final VoipRepository repository;

  Future<GenericResponse<VoipNumber>> call({
    required final int departmentId,
    required final int pageNumber,
  }) => repository.getNumbersByDepartment(
    departmentId: departmentId,
    pageNumber: pageNumber,
  );
}
