import 'package:bermooda_business/data/data.dart';

import '../entity/voip_department.dart';
import '../entity/voip_number.dart';

abstract class VoipRepository {
  // department methods -----------------------------------------------------------
  /// get departments
  Future<GenericResponse<VoipDepartment>> getDepartments({
    required final int pageNumber,
    final String? search,
  });

  /// get archived departments
  Future<GenericResponse<VoipDepartment>> getArchivedDepartments({
    required final int pageNumber,
    final String? search,
  });

  /// create a new department
  Future<VoipDepartment> createDepartment({
    required final String title,
    required final List<UserReadDto> members,
    final MainFileReadDto? avatar,
  });

  /// update department
  Future<VoipDepartment> updateDepartment({
    required final int id,
    required final String title,
    required final List<UserReadDto> members,
    final MainFileReadDto? avatar,
  });

  /// archive department
  Future<void> archiveDepartment(final int id);

  /// restore department
  Future<void> restoreDepartment(final int id);

  // sms panel methods -----------------------------------------------------------
  /// get numbers of a department
  Future<GenericResponse<VoipNumber>> getNumbersByDepartment({
    required final int departmentId,
    required final int pageNumber,
  });

  /// get numbers with user access
  Future<List<VoipNumber>> getNumbersWithUserAccess();

  /// create a new number
  Future<VoipNumber> createNumber({
    required final int departmentId,
    required final String number,
    required final String name,
    // required final ProviderType providerType,
    required final String serviceId,
    required final String webserviceToken,
  });

  /// delete a number
  Future<void> deleteNumber(final int id);
}
