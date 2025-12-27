import 'package:u/utilities.dart';

import '../../data/data.dart';
import '../utils/enums/enums.dart';
import '/core/utils/extensions/user_permission_extensions.dart';

class PermissionService extends GetxService {
  PermissionService({required final Rx<WorkspaceReadDto> currentWorkspace}) : _currentWorkspace = currentWorkspace;

  final Rx<WorkspaceReadDto> _currentWorkspace;

  bool get isWorkspaceOwner => _currentWorkspace.value.type.isOwner();

  /// [isWorkspaceOwner] or at Least have a [PermissionType.manager] (access) in any [PermissionName.values] (modules)
  bool get haveAnyManagerAccess => isWorkspaceOwner || (_currentWorkspace.value.userPermissions?.any((final e) => e.permissionType == PermissionType.manager) ?? false);

  /// HR /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  bool get isHRNoAccess => _currentWorkspace.value.userPermissions.getByName(PermissionName.humanResources).isNoAccess();
  bool get isHRExpert => _currentWorkspace.value.userPermissions.getByName(PermissionName.humanResources).isExpert();
  bool get isHRSupervisor => _currentWorkspace.value.userPermissions.getByName(PermissionName.humanResources).isSupervisor();
  bool get isHRManger => _currentWorkspace.value.userPermissions.getByName(PermissionName.humanResources).isManager();
  /// [isWorkspaceOwner] or ![isHRNoAccess]
  bool get haveHRAccess => isWorkspaceOwner || !isHRNoAccess;
  /// [isWorkspaceOwner] or [isHRManger] or [isHRSupervisor]
  bool get haveHRAdminAccess => isWorkspaceOwner || isHRManger || isHRSupervisor;
  /// [isWorkspaceOwner] or [isHRManger]
  bool get haveHRManagerAccess => isWorkspaceOwner || isHRManger;

  /// Project /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  bool get isProjectNoAccess => _currentWorkspace.value.userPermissions.getByName(PermissionName.project).isNoAccess();
  bool get isProjectExpert => _currentWorkspace.value.userPermissions.getByName(PermissionName.project).isExpert();
  bool get isProjectSupervisor => _currentWorkspace.value.userPermissions.getByName(PermissionName.project).isSupervisor();
  bool get isProjectManger => _currentWorkspace.value.userPermissions.getByName(PermissionName.project).isManager();
  /// [isWorkspaceOwner] or ![isProjectNoAccess]
  bool get haveProjectAccess => isWorkspaceOwner || !isProjectNoAccess;
  /// [isWorkspaceOwner] or [isProjectManger] or [isProjectSupervisor]
  bool get haveProjectAdminAccess => isWorkspaceOwner || isProjectManger || isProjectSupervisor;
  /// [isWorkspaceOwner] or [isProjectManger]
  bool get haveProjectManagerAccess => isWorkspaceOwner || isProjectManger;

  /// CRM /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  bool get isCRMNoAccess => _currentWorkspace.value.userPermissions.getByName(PermissionName.crm).isNoAccess();
  bool get isCRMExpert => _currentWorkspace.value.userPermissions.getByName(PermissionName.crm).isExpert();
  bool get isCRMSupervisor => _currentWorkspace.value.userPermissions.getByName(PermissionName.crm).isSupervisor();
  bool get isCRMManger => _currentWorkspace.value.userPermissions.getByName(PermissionName.crm).isManager();
  /// [isWorkspaceOwner] or ![isCRMNoAccess]
  bool get haveCRMAccess => isWorkspaceOwner || !isCRMNoAccess;
  /// [isWorkspaceOwner] or [isCRMManger] or [isCRMSupervisor]
  bool get haveCRMAdminAccess => isWorkspaceOwner || isCRMManger || isCRMSupervisor;
  /// [isWorkspaceOwner] or [isCRMManger]
  bool get haveCRMManagerAccess => isWorkspaceOwner || isCRMManger;

  /// Legal /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  bool get isLegalNoAccess => _currentWorkspace.value.userPermissions.getByName(PermissionName.legal).isNoAccess();
  bool get isLegalExpert => _currentWorkspace.value.userPermissions.getByName(PermissionName.legal).isExpert();
  bool get isLegalSupervisor => _currentWorkspace.value.userPermissions.getByName(PermissionName.legal).isSupervisor();
  bool get isLegalManger => _currentWorkspace.value.userPermissions.getByName(PermissionName.legal).isManager();
  /// [isWorkspaceOwner] or ![isLegalNoAccess]
  bool get haveLegalAccess => isWorkspaceOwner || !isLegalNoAccess;
  /// [isWorkspaceOwner] or [isLegalManger] or [isLegalSupervisor]
  bool get haveLegalAdminAccess => isWorkspaceOwner || isLegalManger || isLegalSupervisor;
  /// [isWorkspaceOwner] or [isLegalManger]
  bool get haveLegalManagerAccess => isWorkspaceOwner || isLegalManger;
}
