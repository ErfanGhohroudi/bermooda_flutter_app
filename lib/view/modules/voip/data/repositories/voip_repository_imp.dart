import 'package:u/utilities.dart';

import '../../../../../data/data.dart';
import '../../domain/entity/voip_department.dart';
import '../../domain/entity/voip_number.dart';
import '../../domain/repositories/voip_repository.dart';
import '../datasources/voip_datasource.dart';
import '../datasources/voip_departments_datasource.dart';
import '../models/response/voip_number.dart';
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
  Future<GenericResponse<VoipNumber>> getNumbersByDepartment({
    required final int departmentId,
    required final int pageNumber,
  }) async {
    final completer = Completer<GenericResponse<VoipNumber>>();
    _smsPanelDatasource.getNumbersByDepartment(
      departmentId: departmentId,
      pageNumber: pageNumber,
      onResponse: (final response) {
        final list = (response.resultList ?? []).map((final e) => _convertSmsNumberDtoToEntity(e)).toList();
        final genRes = GenericResponse<VoipNumber>(
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
  Future<List<VoipNumber>> getNumbersWithUserAccess() async {
    final completer = Completer<List<VoipNumber>>();
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
  Future<VoipNumber> createNumber({
    required final int departmentId,
    required final String number,
    required final String name,
    // required final ProviderType providerType,
    required final String serviceId,
    required final String webserviceToken,
  }) async {
    final completer = Completer<VoipNumber>();
    _smsPanelDatasource.createNumber(
      departmentId: departmentId,
      number: number,
      name: name,
      // providerType: providerType,
      serviceId: serviceId,
      webserviceToken: webserviceToken,
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

  /// Convert SmsPanelNumberReadDto DTO to SmsPanelNumber Entity
  VoipNumber _convertSmsNumberDtoToEntity(final VoipNumberReadDto dto) {
    return VoipNumber.fromDto(dto);
  }

  /// Convert SmsDepartmentReadDto DTO to SmsDepartment Entity
  VoipDepartment _convertDepartmentDtoToEntity(final VoipDepartmentReadDto dto) {
    return VoipDepartment.fromDto(dto);
  }
}
