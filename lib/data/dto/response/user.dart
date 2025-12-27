part of '../../data.dart';

class UserReadDto extends Equatable {
  const UserReadDto({
    required this.id,
    this.fullName,
    this.phoneNumber,
    this.email,
    this.avatarUrl,
    this.avatar,
    this.isAuth,
    this.jTime,
    this.currentWorkspace,
    this.selected,
    this.permissionType,
    this.progressPercentage,
    this.permissions,
    this.type,
    this.isSelf,
    this.accessType,
  });

  final String id;
  final String? fullName;
  final String? phoneNumber;
  final String? email;
  final String? avatarUrl;
  final MainFileReadDto? avatar;
  final bool? isAuth;
  final String? jTime;
  final WorkspaceReadDto? currentWorkspace;

  /// Just Used for Letters
  final bool? selected;

  /// use for Projects, CRM Categories, HR Departments info and Request reviewers selection
  final List<PermissionReadDto>? permissions;
  final OwnerMemberType? type;

  /// use for Projects, CRM Categories and HR Departments info
  final PermissionType? permissionType;
  final int? progressPercentage;

  /// Just Used in MemberPicker widget
  final bool? isSelf;

  /// Just Used in MemberPicker widget
  final PermissionType? accessType;

  UserReadDto copyWith({
    final String? id,
    final String? fullName,
    final String? username,
    final String? personalType,
    final String? phoneNumber,
    final String? cityName,
    final bool? isProfile,
    final String? email,
    final String? avatarUrl,
    final MainFileReadDto? avatar,
    final bool? isAuth,
    final String? jTime,
    final WorkspaceReadDto? currentWorkspace,
    final bool? selected,
    final PermissionType? permissionType,
    final int? progressPercentage,
    final List<PermissionReadDto>? permissions,
    final OwnerMemberType? type,
    final bool? isSelf,
    final PermissionType? accessType,
  }) {
    return UserReadDto(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatar: avatar ?? this.avatar,
      isAuth: isAuth ?? this.isAuth,
      jTime: jTime ?? this.jTime,
      currentWorkspace: currentWorkspace ?? this.currentWorkspace,
      selected: selected ?? this.selected,
      permissionType: permissionType ?? this.permissionType,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      permissions: permissions ?? this.permissions,
      type: type ?? this.type,
      isSelf: isSelf ?? this.isSelf,
      accessType: accessType ?? this.accessType,
    );
  }

  factory UserReadDto.fromJson(final String str) => UserReadDto.fromMap(json.decode(str));

  factory UserReadDto.fromMap(final Map<String, dynamic> json) => UserReadDto(
        id: (json["id"] ?? json["user_id"]).toString(),
        fullName: json["fullname"],
        phoneNumber: json["phone_number"],
        email: json["email"],
        avatarUrl: json["avatar_url"],
        avatar: json["avatar"] == null ? null : MainFileReadDto.fromMap(json["avatar"]),
        isAuth: json["is_auth"],
        jTime: json["jtime"],
        currentWorkspace: json["current_workspace"] == null ? null : WorkspaceReadDto.fromMap(json["current_workspace"]),
        selected: json["selected"] ?? false,
        permissionType: json["permission_type"] == null ? null : PermissionType.values.firstWhereOrNull((final e) => e.value == json["permission_type"]),
        progressPercentage: json["progress_percentage"] ?? json["progress_average"] ?? json["member_progress"]?.toInt(),
        permissions: json["permissions"] == null
            ? []
            : List<PermissionReadDto>.from(json["permissions"]!.map((final x) => PermissionReadDto.fromMap(x))),
        type: json["type"] == null ? null : OwnerMemberType.values.firstWhereOrNull((final element) => element.name == json["type"]),
        isSelf: json["self"] ?? false,
        accessType: json["current_permission"] == null ? null : PermissionType.values.firstWhereOrNull((final e) => e.value == json["current_permission"]),
      );

  @override
  List<Object?> get props => [
        id,
        fullName,
        phoneNumber,
        email,
        avatarUrl,
        avatar,
        isAuth,
        jTime,
        currentWorkspace,
        permissionType,
        progressPercentage,
        permissions,
        type,
      ];
}
