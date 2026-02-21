import 'dart:async';

import '../../../../../data/data.dart';
import '../../domain/entities/support_department.dart';
import '../../domain/repositories/support_department_repository.dart';
import '../datasources/support_department_datasource.dart';

class SupportDepartmentRepositoryImpl implements SupportDepartmentRepository {
  final SupportDepartmentDatasource _datasource = SupportDepartmentDatasource();

  @override
  Future<GenericResponse<SupportDepartment>> getDepartments({
    required final int pageNumber,
    required final int perPageCount,
    required final String? search,
  }) {
    final Completer<GenericResponse<SupportDepartment>> completer = Completer();
    _datasource.getDepartments(
      pageNumber: pageNumber,
      perPageCount: perPageCount,
      search: search,
      onResponse: (final response) {
        final res = GenericResponse(
          status: response.status,
          message: response.message,
          resultList: (response.resultList ?? []).map((final e) => SupportDepartment.fromDto(e)).toList(),
          extra:  response.extra,
        );
        completer.complete(res);
      },
      onError: (final errorResponse) {
        completer.completeError(errorResponse);
      },
    );
    return completer.future;
  }

  @override
  Future<SupportDepartment> createDepartment({
    required final String title,
    required final List<UserReadDto> members,
    required final int? avatarId,
  }) {
    final Completer<SupportDepartment> completer = Completer();
    _datasource.createDepartment(
      title: title,
      members: members,
      avatarId: avatarId,
      onResponse: (final response) {
        if (response.result == null) return completer.completeError(response);
        completer.complete(SupportDepartment.fromDto(response.result!));
      },
      onError: (final errorResponse) {
        completer.completeError(errorResponse);
      },
    );
    return completer.future;
  }

  @override
  Future<SupportDepartment> updateDepartment({
    required final int id,
    required final String title,
    required final List<UserReadDto> members,
    required final int? avatarId,
  }) {
    final Completer<SupportDepartment> completer = Completer();
    _datasource.updateDepartment(
      id: id,
      title: title,
      members: members,
      avatarId: avatarId,
      onResponse: (final response) {
        if (response.result == null) return completer.completeError(response);
        completer.complete(SupportDepartment.fromDto(response.result!));
      },
      onError: (final errorResponse) {
        completer.completeError(errorResponse);
      },
    );
    return completer.future;
  }

  @override
  Future<GenericResponse<dynamic>> archiveDepartment(final int id) {
    final Completer<GenericResponse<dynamic>> completer = Completer();
    _datasource.archiveDepartment(
      id: id,
      onResponse: (final response) {
        completer.complete(response);
      },
      onError: (final errorResponse) {
        completer.completeError(errorResponse);
      },
    );
    return completer.future;
  }

  @override
  Future<GenericResponse<SupportDepartment>> getArchivedDepartments({
    required final int pageNumber,
    required final int perPageCount,
    required final String? search,
  }) {
    final Completer<GenericResponse<SupportDepartment>> completer = Completer();
    _datasource.getArchivedDepartments(
      pageNumber: pageNumber,
      perPageCount: perPageCount,
      search: search,
      onResponse: (final response) {
        final res = GenericResponse(
          status: response.status,
          message: response.message,
          resultList: (response.resultList ?? []).map((final e) => SupportDepartment.fromDto(e)).toList(),
          extra:  response.extra,
        );
        completer.complete(res);
      },
      onError: (final errorResponse) {
        completer.completeError(errorResponse);
      },
    );
    return completer.future;
  }

  @override
  Future<void> restoreDepartment(final int id) {
    final Completer<void> completer = Completer();
    _datasource.restoreDepartment(
      id: id,
      onResponse: (final response) => completer.complete(),
      onError: (final errorResponse) {
        completer.completeError(errorResponse);
      },
    );
    return completer.future;
  }
}
