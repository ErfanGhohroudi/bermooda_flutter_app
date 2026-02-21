
import '../../../../../data/data.dart';
import '../entities/support_department.dart';

abstract class SupportDepartmentRepository {
  Future<GenericResponse<SupportDepartment>> getDepartments({
    required final int pageNumber,
    required final int perPageCount,
    required final String? search,
  });

  Future<SupportDepartment> createDepartment({
    required final String title,
    required final List<UserReadDto> members,
    required final int? avatarId,
  });

  Future<SupportDepartment> updateDepartment({
    required final int id,
    required final String title,
    required final List<UserReadDto> members,
    required final int? avatarId,
  });

  Future<void> archiveDepartment(final int id);

  Future<GenericResponse<SupportDepartment>> getArchivedDepartments({
    required final int pageNumber,
    required final int perPageCount,
    required final String? search,
  });

  Future<void> restoreDepartment(final int id);
}
