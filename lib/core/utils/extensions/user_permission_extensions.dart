import 'package:u/utilities.dart';

import '../enums/enums.dart';
import '../../../data/data.dart';

extension ListUserPermissionExtensions<T> on List<PermissionReadDto>? {
  PermissionReadDto? getByName(final PermissionName permissionName) {
    if (isNullOrEmpty()) {
      return null;
    }
    final per = this!.firstWhereOrNull((final element) => element.permissionName == permissionName);

    return per;
  }
}

extension UserPermissionExtensions<T> on PermissionReadDto? {
  bool isManager() {
    if (this == null) {
      return false;
    }
    return this!.permissionType == PermissionType.manager;
  }
  bool isSupervisor() {
    if (this == null) {
      return false;
    }
    return this!.permissionType == PermissionType.supervisor;
  }
  bool isExpert() {
    if (this == null) {
      return false;
    }
    return this!.permissionType == PermissionType.expert;
  }
  bool isNoAccess() {
    if (this == null) {
      return false;
    }
    return this!.permissionType == PermissionType.noAccess;
  }
  bool haveAccess() {
    if (this == null) {
      return false;
    }
    return isManager() || isSupervisor() || isExpert();
  }
}
