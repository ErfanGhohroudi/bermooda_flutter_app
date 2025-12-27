part of '../../data.dart';

class WorkspaceReadDto extends Equatable {
  const WorkspaceReadDto({
    required this.id,
    this.memberId,
    this.title,
    this.isAuthenticated = false,
    this.jadooWorkspaceId,
    this.isAccepted = false,
    this.isActive = false,
    this.unreadNotifications,
    this.type,
    this.userPermissions,
    this.authStatus,
    this.usedStorage = 0.0,
    this.totalStorage = 0,
    this.subscription,
    this.memberCount = 1,
  });

  final String id;
  final int? memberId;
  final String? title;
  final bool isAuthenticated;
  final int? jadooWorkspaceId;
  final bool isAccepted;
  final bool isActive;
  final int? unreadNotifications;
  final OwnerMemberType? type;
  final List<PermissionReadDto>? userPermissions;

  final AuthStatus? authStatus;
  final double usedStorage;
  final int totalStorage;
  final SubscriptionReadDto? subscription;
  final int memberCount;

  WorkspaceReadDto copyWith({
    final String? id,
    final int? memberId,
    final String? title,
    final bool? isAuthenticated,
    final int? jadooWorkspaceId,
    final bool? isAccepted,
    final bool? isActive,
    final int? unreadNotifications,
    final OwnerMemberType? type,
    final List<PermissionReadDto>? userPermissions,
    final AuthStatus? authStatus,
    final double? usedStorage,
    final int? totalStorage,
    final SubscriptionReadDto? subscription,
    final int? memberCount,
  }) {
    return WorkspaceReadDto(
      id: id ?? this.id,
      title: title ?? this.title,
      memberId: memberId ?? this.memberId,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      jadooWorkspaceId: jadooWorkspaceId ?? this.jadooWorkspaceId,
      isAccepted: isAccepted ?? this.isAccepted,
      isActive: isActive ?? this.isActive,
      unreadNotifications: unreadNotifications ?? this.unreadNotifications,
      type: type ?? this.type,
      userPermissions: userPermissions ?? this.userPermissions,
      authStatus: authStatus ?? this.authStatus,
      usedStorage: usedStorage ?? this.usedStorage,
      totalStorage: totalStorage ?? this.totalStorage,
      subscription: subscription ?? this.subscription,
      memberCount: memberCount ?? this.memberCount,
    );
  }

  factory WorkspaceReadDto.fromJson(final String str) => WorkspaceReadDto.fromMap(json.decode(str));

  factory WorkspaceReadDto.fromMap(final Map<String, dynamic> json) => WorkspaceReadDto(
        id: json["id"].toString(),
        title: json["title"],
        memberId: json["member_id"],
        isAuthenticated: json["is_authenticated"] ?? false,
        jadooWorkspaceId: json["jadoo_workspace_id"],
        isAccepted: json["is_accepted"] ?? false,
        isActive: json["is_active"] ?? false,
        unreadNotifications: json["unread_notifications"],
        type: OwnerMemberType.values.firstWhereOrNull((final element) => element.name == json["type"]),
        userPermissions: json["permissions"] == null ? [] : List<PermissionReadDto>.from(json["permissions"]!.map((final x) => PermissionReadDto.fromMap(x))),
        authStatus: json["auth_status"] == null ? null : AuthStatus.values.firstWhereOrNull((final element) => element.name == json["auth_status"]),
        usedStorage: json["used_storage"] ?? 0,
        totalStorage: json["total_storage"] ?? 0,
        subscription: json["main_subscription"] == null ? null : SubscriptionReadDto.fromMap(json["main_subscription"]),
        memberCount: json["member_count"] ?? 1,
      );

  bool get membersIsEmpty => memberCount <= 1;

  @override
  List<Object?> get props => [
        id,
        memberId,
        title,
        isAuthenticated,
        jadooWorkspaceId,
        isAccepted,
        isActive,
        unreadNotifications,
        type,
        userPermissions,
        authStatus,
        usedStorage,
        totalStorage,
        subscription,
        memberCount,
      ];
}
