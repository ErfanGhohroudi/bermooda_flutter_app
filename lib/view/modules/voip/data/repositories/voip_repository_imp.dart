import 'package:u/utilities.dart';

import '../../../../../data/data.dart';
import '../../domain/entity/voip_department.dart';
import '../../domain/entity/sms_panel_number.dart';
import '../../domain/enums/enums.dart';
import '../../domain/repositories/sms_panel_repository.dart';
import '../datasources/voip_datasource.dart';
import '../datasources/voip_departments_datasource.dart';
import '../models/response/sms_panel_number.dart';
import '../models/response/voip_department.dart';

/// Repository Implementation
/// Converts DTOs to Domain Entities (Data Layer to Domain Layer)
class VoipRepositoryImpl implements VoipRepository {
  VoipRepositoryImpl();

  VoipDepartmentsDatasource get _departmentsDatasource => Get.find<VoipDepartmentsDatasource>();

  VoipDatasource get _smsPanelDatasource => Get.find<VoipDatasource>();

  // department methods -----------------------------------------------------------

  @override
  Future<GenericResponse<VoipDepartment>> getDepartments({
    required final int pageNumber,
    final String? search,
  }) async {
    final completer = Completer<GenericResponse<VoipDepartment>>();
    _departmentsDatasource.getDepartments(
      pageNumber: pageNumber,
      search: search,
      onResponse: (final response) {
        final genRes = GenericResponse<VoipDepartment>(
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
  Future<GenericResponse<VoipDepartment>> getArchivedDepartments({
    required final int pageNumber,
    final String? search,
  }) async {
    final completer = Completer<GenericResponse<VoipDepartment>>();
    _departmentsDatasource.getArchivedDepartments(
      pageNumber: pageNumber,
      search: search,
      onResponse: (final response) {
        final genRes = GenericResponse<VoipDepartment>(
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
  Future<VoipDepartment> createDepartment({
    required final String title,
    required final List<UserReadDto> members,
    final MainFileReadDto? avatar,
  }) {
    final completer = Completer<VoipDepartment>();
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
  Future<VoipDepartment> updateDepartment({
    required final int id,
    required final String title,
    required final List<UserReadDto> members,
    final MainFileReadDto? avatar,
  }) {
    final completer = Completer<VoipDepartment>();
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
  Future<void> sendSMS({
    required final String content,
    required final String recipient,
    required final int senderId,
  }) async {
    final completer = Completer<void>();
    _smsPanelDatasource.sendSMS(
      content: content,
      recipient: recipient,
      senderId: senderId,
      onResponse: () => completer.complete(),
      onError: (final error) => completer.completeError(error),
    );
    return completer.future;
  }

  /// Convert SmsPanelNumberReadDto DTO to SmsPanelNumber Entity
  SmsPanelNumber _convertSmsNumberDtoToEntity(final SmsPanelNumberReadDto dto) {
    return SmsPanelNumber.fromDto(dto);
  }

  /// Convert SmsDepartmentReadDto DTO to SmsDepartment Entity
  VoipDepartment _convertDepartmentDtoToEntity(final VoipDepartmentReadDto dto) {
    return VoipDepartment.fromDto(dto);
  }
}
