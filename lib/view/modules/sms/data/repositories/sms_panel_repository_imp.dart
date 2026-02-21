import 'package:u/utilities.dart';

import '../../../../../data/data.dart';
import '../../domain/entity/group_sms.dart';
import '../../domain/entity/received_sms_entity.dart';
import '../../domain/entity/sms.dart';
import '../../domain/entity/sms_department.dart';
import '../../domain/entity/sms_panel_number.dart';
import '../../domain/entity/validation_numbers_result.dart';
import '../../domain/enums/enums.dart';
import '../../domain/repositories/sms_panel_repository.dart';
import '../datasources/sms_panel_datasource.dart';
import '../../../sms/data/models/response/sms_panel_number_dto.dart';
import '../datasources/sms_panel_departments_datasource.dart';
import '../models/response/sms_department_dto.dart';

/// Repository Implementation
/// Converts DTOs to Domain Entities (Data Layer to Domain Layer)
class SmsPanelRepositoryImpl implements SmsPanelRepository {
  SmsPanelRepositoryImpl();

  SmsPanelDepartmentsDatasource get _departmentsDatasource => Get.find<SmsPanelDepartmentsDatasource>();

  SmsPanelDatasource get _smsPanelDatasource => Get.find<SmsPanelDatasource>();

  // department methods -----------------------------------------------------------

  @override
  Future<GenericResponse<SmsDepartment>> getDepartments({
    required final int pageNumber,
    final String? search,
  }) async {
    final completer = Completer<GenericResponse<SmsDepartment>>();
    _departmentsDatasource.getDepartments(
      pageNumber: pageNumber,
      search: search,
      onResponse: (final response) {
        final genRes = GenericResponse<SmsDepartment>(
          status: response.status,
          message: response.message,
          resultList: (response.resultList ?? []).map((final e) => _convertDepartmentDtoToEntity(e)).toList(),
          extra: response.extra,
        );
        completer.complete(genRes);
      },
      onError: (final error) => completer.completeError(error),
    );
    return completer.future;
  }

  @override
  Future<GenericResponse<SmsDepartment>> getArchivedDepartments({
    required final int pageNumber,
    final String? search,
  }) async {
    final completer = Completer<GenericResponse<SmsDepartment>>();
    _departmentsDatasource.getArchivedDepartments(
      pageNumber: pageNumber,
      search: search,
      onResponse: (final response) {
        final genRes = GenericResponse<SmsDepartment>(
          status: response.status,
          message: response.message,
          resultList: (response.resultList ?? []).map((final e) => _convertDepartmentDtoToEntity(e)).toList(),
          extra: response.extra,
        );
        completer.complete(genRes);
      },
      onError: (final error) => completer.completeError(error),
    );
    return completer.future;
  }

  @override
  Future<SmsDepartment> createDepartment({
    required final String title,
    required final List<UserReadDto> members,
    final MainFileReadDto? avatar,
  }) {
    final completer = Completer<SmsDepartment>();
    _departmentsDatasource.createDepartment(
      title: title,
      members: members,
      avatar: avatar,
      onResponse: (final response) {
        if (response.result == null) return completer.completeError(response);

        completer.complete(_convertDepartmentDtoToEntity(response.result!));
      },
      onError: (final error) => completer.completeError(error),
    );
    return completer.future;
  }

  @override
  Future<SmsDepartment> updateDepartment({
    required final int id,
    required final String title,
    required final List<UserReadDto> members,
    final MainFileReadDto? avatar,
  }) {
    final completer = Completer<SmsDepartment>();
    _departmentsDatasource.updateDepartment(
      id: id,
      title: title,
      members: members,
      avatar: avatar,
      onResponse: (final response) {
        if (response.result == null) return completer.completeError(response);

        completer.complete(_convertDepartmentDtoToEntity(response.result!));
      },
      onError: (final error) => completer.completeError(error),
    );
    return completer.future;
  }

  @override
  Future<void> archiveDepartment(final int id) {
    final completer = Completer<void>();
    _departmentsDatasource.archiveDepartment(
      id: id,
      onResponse: () => completer.complete(),
      onError: (final error) => completer.completeError(error),
    );
    return completer.future;
  }

  @override
  Future<void> restoreDepartment(final int id) {
    final completer = Completer<void>();
    _departmentsDatasource.restoreDepartment(
      id: id,
      onResponse: () => completer.complete(),
      onError: (final error) => completer.completeError(error),
    );
    return completer.future;
  }

  // sms panel methods -----------------------------------------------------------

  @override
  Future<GenericResponse<SmsPanelNumber>> getNumbersByDepartment({
    required final int departmentId,
    required final int pageNumber,
  }) async {
    final completer = Completer<GenericResponse<SmsPanelNumber>>();
    _smsPanelDatasource.getNumbersByDepartment(
      departmentId: departmentId,
      pageNumber: pageNumber,
      onResponse: (final response) {
        final list = (response.resultList ?? []).map((final e) => _convertSmsNumberDtoToEntity(e)).toList();
        final genRes = GenericResponse<SmsPanelNumber>(
          status: response.status,
          message: response.message,
          resultList: list,
          extra: response.extra,
        );
        completer.complete(genRes);
      },
      onError: (final error) => completer.completeError(error),
    );
    return completer.future;
  }

  @override
  Future<List<SmsPanelNumber>> getNumbersWithUserAccess() async {
    final completer = Completer<List<SmsPanelNumber>>();
    _smsPanelDatasource.getNumbersWithUserAccess(
      onResponse: (final response) {
        final list = (response.resultList ?? []).map((final e) => _convertSmsNumberDtoToEntity(e)).toList();
        completer.complete(list);
      },
      onError: (final error) => completer.completeError(error),
    );
    return completer.future;
  }

  @override
  Future<SmsPanelNumber> createNumber({
    required final int departmentId,
    required final String number,
    required final String providerName,
    required final ProviderType providerType,
    required final String apiKey,
  }) async {
    final completer = Completer<SmsPanelNumber>();
    _smsPanelDatasource.createNumber(
      departmentId: departmentId,
      number: number,
      providerName: providerName,
      providerType: providerType,
      apiKey: apiKey,
      onResponse: (final response) {
        completer.complete(_convertSmsNumberDtoToEntity(response));
      },
      onError: (final error) => completer.completeError(error),
    );
    return completer.future;
  }

  @override
  Future<void> deleteNumber(final int id) async {
    final completer = Completer<void>();
    _smsPanelDatasource.deleteNumber(
      id: id,
      onResponse: () {
        completer.complete();
      },
      onError: (final error) => completer.completeError(error),
    );
    return completer.future;
  }

  @override
  Future<SmsEntity> sendSMS({
    required final String content,
    required final String recipient,
    required final int senderId,
    final int? departmentId,
    final Jalali? scheduledAt,
  }) async {
    final completer = Completer<SmsEntity>();
    _smsPanelDatasource.sendSMS(
      content: content,
      recipient: recipient,
      senderId: senderId,
      departmentId: departmentId,
      onResponse: (final response) {
        if (response.result == null) return completer.completeError(response);
        final res = SmsEntity.fromDto(response.result!);
        completer.complete(res);
      },
      onError: (final error) => completer.completeError(error),
    );
    return completer.future;
  }

  @override
  /// Either [recipients] or [fileId] must be provided
  Future<GroupSmsEntity> sendGroupSMS({
    required final String title,
    required final String content,
    required final List<String>? recipients,
    required final int? fileId,
    required final int senderId,
    final int? departmentId,
    final Jalali? scheduledAt,
  }) {
    final completer = Completer<GroupSmsEntity>();
    _smsPanelDatasource.sendGroupSMS(
      title: title,
      content: content,
      recipients: recipients,
      fileId: fileId,
      senderId: senderId,
      departmentId: departmentId,
      onResponse: (final response) {
        if (response.result == null) return completer.completeError(response);
        final res = GroupSmsEntity.fromDto(response.result!);
        completer.complete(res);
      },
      onError: (final error) => completer.completeError(error),
    );
    return completer.future;
  }

  @override
  Future<SmsEntity> sendTestSMS({
    required final String content,
    required final String recipient,
    required final int senderId,
  }) {
    final completer = Completer<SmsEntity>();
    _smsPanelDatasource.sendTestSMS(
      content: content,
      recipient: recipient,
      senderId: senderId,
      onResponse: (final response) {
        if (response.result == null) return completer.completeError(response);
        final res = SmsEntity.fromDto(response.result!);
        completer.complete(res);
      },
      onError: (final error) => completer.completeError(error),
    );
    return completer.future;
  }

  @override
  Future<SmsEntity> cancelSMS(final int id) {
    final completer = Completer<SmsEntity>();
    _smsPanelDatasource.cancelSMS(
      id: id,
      onResponse: (final response) {
        if (response.result == null) return completer.completeError(response);
        final res = SmsEntity.fromDto(response.result!);
        completer.complete(res);
      },
      onError: (final error) => completer.completeError(error),
    );
    return completer.future;
  }

  @override
  Future<GroupSmsEntity> cancelGroupSMS(final int id) {
    final completer = Completer<GroupSmsEntity>();
    _smsPanelDatasource.cancelGroupSMS(
      id: id,
      onResponse: (final response) {
        if (response.result == null) return completer.completeError(response);
        final res = GroupSmsEntity.fromDto(response.result!);
        completer.complete(res);
      },
      onError: (final error) => completer.completeError(error),
    );
    return completer.future;
  }

  @override
  Future<GenericResponse<SmsEntity>> getSmsList({
    required final int departmentId,
    required final int pageNumber,
    required final int perPageCount,
    required final String? search,
    required final SMSStatus? status,
  }) {
    final completer = Completer<GenericResponse<SmsEntity>>();
    _smsPanelDatasource.getSmsList(
      departmentId: departmentId,
      pageNumber: pageNumber,
      perPageCount: perPageCount,
      search: search,
      status: status,
      onResponse: (final response) {
        final res = GenericResponse(
          status: response.status,
          message: response.message,
          resultList: (response.resultList ?? []).map((final e) => SmsEntity.fromDto(e)).toList(),
          extra: response.extra,
        );
        completer.complete(res);
      },
      onError: (final error) => completer.completeError(error),
    );
    return completer.future;
  }

  @override
  Future<GenericResponse<GroupSmsEntity>> getGroupSmsList({
    required final int departmentId,
    required final int pageNumber,
    required final int perPageCount,
    required final String? search,
    required final GroupSMSStatus? status,
  }) {
    final completer = Completer<GenericResponse<GroupSmsEntity>>();
    _smsPanelDatasource.getGroupSmsList(
      departmentId: departmentId,
      pageNumber: pageNumber,
      perPageCount: perPageCount,
      search: search,
      status: status,
      onResponse: (final response) {
        final res = GenericResponse(
          status: response.status,
          message: response.message,
          resultList: (response.resultList ?? []).map((final e) => GroupSmsEntity.fromDto(e)).toList(),
          extra: response.extra,
        );
        completer.complete(res);
      },
      onError: (final error) => completer.completeError(error),
    );
    return completer.future;
  }

  @override
  Future<ValidationNumbersResultEntity> validatePhoneNumberList(final List<String> numbers) {
    final completer = Completer<ValidationNumbersResultEntity>();
    _smsPanelDatasource.validatePhoneNumberList(
      numbers: numbers,
      onResponse: (final response) {
        if (response.result == null) return completer.completeError(response);
        final res = ValidationNumbersResultEntity.fromDto(response.result!);
        completer.complete(res);
      },
      onError: (final error) => completer.completeError(error),
    );
    return completer.future;
  }

  @override
  Future<ValidationNumbersResultEntity> validateFilePhoneNumberList(final int fileId) {
    final completer = Completer<ValidationNumbersResultEntity>();
    _smsPanelDatasource.validateFilePhoneNumberList(
      fileId: fileId,
      onResponse: (final response) {
        if (response.result == null) return completer.completeError(response);
        final res = ValidationNumbersResultEntity.fromDto(response.result!);
        completer.complete(res);
      },
      onError: (final error) => completer.completeError(error),
    );
    return completer.future;
  }

  @override
  Future<GenericResponse<ReceivedSmsEntity>> getInboxSmsList({
    required final int departmentId,
    final int? phoneId,
    final int? pageNumber,
    final int? perPageCount,
    final String? search,
    final Jalali? startDate,
    final Jalali? endDate,
    final bool isExport = false,
  }) {
    final completer = Completer<GenericResponse<ReceivedSmsEntity>>();
    _smsPanelDatasource.getReceivedMessages(
      departmentId: departmentId,
      phoneId: phoneId,
      pageNumber: pageNumber,
      perPageCount: perPageCount,
      search: search,
      startDate: startDate,
      endDate: endDate,
      isExport: isExport,
      onResponse: (final response) {
        final res = GenericResponse(
          status: response.status,
          message: response.message,
          resultList: (response.resultList ?? []).map((final e) => ReceivedSmsEntity.fromDto(e)).toList(),
          extra: response.extra,
          exportedFile: response.exportedFile,
        );
        completer.complete(res);
      },
      onError: (final error) => completer.completeError(error),
    );
    return completer.future;
  }

  /// Convert SmsPanelNumberReadDto DTO to SmsPanelNumber Entity
  SmsPanelNumber _convertSmsNumberDtoToEntity(final SmsPanelNumberReadDto dto) {
    return SmsPanelNumber.fromDto(dto);
  }

  /// Convert SmsDepartmentReadDto DTO to SmsDepartment Entity
  SmsDepartment _convertDepartmentDtoToEntity(final SmsDepartmentReadDto dto) {
    return SmsDepartment.fromDto(dto);
  }
}
