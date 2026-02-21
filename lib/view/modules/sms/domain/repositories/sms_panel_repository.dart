import 'package:bermooda_business/data/data.dart';
import 'package:u/utils/shamsi_date/src/jalali/jalali_date.dart';

import '../entity/group_sms.dart';
import '../entity/received_sms_entity.dart';
import '../entity/sms.dart';
import '../entity/sms_department.dart';
import '../entity/sms_panel_number.dart';
import '../entity/validation_numbers_result.dart';
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

  /// Send Single SMS
  Future<SmsEntity> sendSMS({
    required final String content,
    required final String recipient,
    required final int senderId,
    final int? departmentId,
    final Jalali? scheduledAt,
  });

  /// Send Group SMS
  /// Either [recipients] or [fileId] must be provided
  Future<GroupSmsEntity> sendGroupSMS({
    required final String title,
    required final String content,
    required final List<String>? recipients,
    required final int? fileId,
    required final int senderId,
    final int? departmentId,
    final Jalali? scheduledAt,
  });

  /// Send Single SMS for Test
  Future<SmsEntity> sendTestSMS({
    required final String content,
    required final String recipient,
    required final int senderId,
  });

  /// Cansel Sending a Single SMS
  Future<SmsEntity> cancelSMS(final int id);

  /// Cansel Sending a Group SMS
  Future<GroupSmsEntity> cancelGroupSMS(final int id);

  /// Get List of Single SMS
  Future<GenericResponse<SmsEntity>> getSmsList({
    required final int departmentId,
    required final int pageNumber,
    required final int perPageCount,
    required final String? search,
    required final SMSStatus? status,
  });

  /// Get List of Group SMS
  Future<GenericResponse<GroupSmsEntity>> getGroupSmsList({
    required final int departmentId,
    required final int pageNumber,
    required final int perPageCount,
    required final String? search,
    required final GroupSMSStatus? status,
  });

  /// Validate Phone Numbers for send SMS
  Future<ValidationNumbersResultEntity> validatePhoneNumberList(final List<String> numbers);

  /// Validate Phone Numbers for send SMS from file
  Future<ValidationNumbersResultEntity> validateFilePhoneNumberList(final int fileId);

  /// Get List of Received SMS
  Future<GenericResponse<ReceivedSmsEntity>> getInboxSmsList({
    required final int departmentId,
    final int? phoneId,
    final int? pageNumber,
    final int? perPageCount,
    final String? search,
    final Jalali? startDate,
    final Jalali? endDate,
    final bool isExport,
  });
}
