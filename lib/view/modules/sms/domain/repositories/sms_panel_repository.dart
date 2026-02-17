import 'package:bermooda_business/data/data.dart';

import '../entity/sms_department.dart';
import '../entity/sms_panel_number.dart';
import '../enums/enums.dart';

abstract class SmsPanelRepository {
  // department methods -----------------------------------------------------------
  /// get departments
  Future<GenericResponse<SmsDepartment>> getDepartments({
    required final int pageNumber,
    final String? search,
  });

  /// get archived departments
  Future<GenericResponse<SmsDepartment>> getArchivedDepartments({
    required final int pageNumber,
    final String? search,
  });

  /// create a new department
  Future<SmsDepartment> createDepartment({
    required final String title,
    required final List<UserReadDto> members,
    final MainFileReadDto? avatar,
  });

  /// update department
  Future<SmsDepartment> updateDepartment({
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
  Future<GenericResponse<SmsPanelNumber>> getNumbersByDepartment({
    required final int departmentId,
    required final int pageNumber,
  });

  /// get numbers with user access
  Future<List<SmsPanelNumber>> getNumbersWithUserAccess();

  /// create a new number
  Future<SmsPanelNumber> createNumber({
    required final int departmentId,
    required final String number,
    required final String providerName,
    required final ProviderType providerType,
    required final String apiKey,
  });

  /// delete a number
  Future<void> deleteNumber(final int id);

  /// Send SMS to customer
  Future<void> sendSMS({
    required final String content,
    required final String recipient,
    required final int senderId,
  });
}
