part of '../../data.dart';

class LetterReadDto {
  int? id;
  UserReadDto? creator;
  StatusMail? statusMail;
  int? workspaceId;
  MainFileReadDto? mailImage;
  String? title;
  LabelReadDto? label;
  List<MemberReadDto>? members;
  String? mailText;
  String? slug;
  List<MainFileReadDto>? files;
  String? jtime;
  bool? signCompleted;
  String? mailCode;
  String? senderFullname;
  String? mailType;
  List<Recipient> recipients;
  bool? favoriteStatus;
  String? status;

  LetterReadDto({
    required this.recipients,
    this.id,
    this.creator,
    this.statusMail,
    this.workspaceId,
    this.mailImage,
    this.title,
    this.label,
    this.members,
    this.mailText,
    this.slug,
    this.files,
    this.jtime,
    this.signCompleted,
    this.mailCode,
    this.senderFullname,
    this.mailType,
    this.favoriteStatus,
    this.status,
  });

  factory LetterReadDto.fromJson(final String str) => LetterReadDto.fromMap(json.decode(str));

  factory LetterReadDto.fromMap(final Map<String, dynamic> json) => LetterReadDto(
        id: json["id"],
        creator: json["creator"] == null ? null : UserReadDto.fromMap(json["creator"]),
        statusMail: json["status_mail"] == null ? null : StatusMail.fromMap(json["status_mail"]),
        workspaceId: json["workspace_id"],
        mailImage: json["mail_image"] == null ? null : MainFileReadDto.fromMap(json["mail_image"]),
        title: json["title"],
        label: json["label"] == null ? null : LabelReadDto.fromMap(json["label"]),
        members: json["members"] == null ? [] : List<MemberReadDto>.from(json["members"]!.map((final x) => MemberReadDto.fromMap(x))),
        mailText: json["mail_text"],
        slug: json["slug"],
        files: json["files"] == null ? [] : List<MainFileReadDto>.from(json["files"]!.map((final x) => MainFileReadDto.fromMap(x))),
        jtime: json["jtime"],
        signCompleted: json["sign_completed"],
        mailCode: json["mail_code"],
        senderFullname: json["sender_fullname"],
        mailType: json["mail_type"],
        recipients: json["recipients"] == null ? [] : List<Recipient>.from(json["recipients"]!.map((final x) => Recipient.fromMap(x))),
        favoriteStatus: json["favorite_status"],
        status: json["status"],
      );
}

class Recipient {
  int? id;
  RecipientType? recipientType;
  UserReadDto? user;
  MainFileReadDto? signatureImage;
  bool? signatureStatus;

  Recipient({
    this.id,
    this.recipientType,
    this.user,
    this.signatureImage,
    this.signatureStatus,
  });

  factory Recipient.fromJson(final String str) => Recipient.fromMap(json.decode(str));

  factory Recipient.fromMap(final Map<String, dynamic> json) => Recipient(
        id: json["id"],
        recipientType: RecipientType.values.firstWhereOrNull((final e) => e.name == json["recipient_type"]),
        user: json["user"] == null ? null : UserReadDto.fromMap(json["user"]),
        signatureImage: json["signature_image"] == null ? null : MainFileReadDto.fromMap(json["signature_image"]),
        signatureStatus: json["signature_status"],
      );
}

class StatusMail {
  int? id;
  bool? isDeleted;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? title;
  int? workspace;

  StatusMail({
    this.id,
    this.isDeleted,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.workspace,
  });

  factory StatusMail.fromJson(final String str) => StatusMail.fromMap(json.decode(str));

  factory StatusMail.fromMap(final Map<String, dynamic> json) => StatusMail(
        id: json["id"],
        isDeleted: json["is_deleted"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        title: json["title"],
        workspace: json["workspace"],
      );
}

class CurrentMailStatus {
  List<MailStatus>? statusList;
  List<UserReadDto>? userList;

  CurrentMailStatus({
    this.statusList,
    this.userList,
  });

  factory CurrentMailStatus.fromJson(final String str) => CurrentMailStatus.fromMap(json.decode(str));

  factory CurrentMailStatus.fromMap(final Map<String, dynamic> json) => CurrentMailStatus(
        statusList: json["status_list"] == null? [] : List<MailStatus>.from(json["status_list"].map((final x) => MailStatus.fromMap(x))),
        userList: json["user_list"] == null? [] : List<UserReadDto>.from(json["user_list"].map((final x) => UserReadDto.fromMap(x))),
      );
}

class MailStatus {
  int? id;
  String? title;
  bool selected;

  MailStatus({
    this.id,
    this.title,
    this.selected = false,
  });

  factory MailStatus.fromJson(final String str) => MailStatus.fromMap(json.decode(str));

  factory MailStatus.fromMap(final Map<String, dynamic> json) => MailStatus(
        id: json["id"],
        title: json["title"],
        selected: json["selected"] ?? false,
      );
}
