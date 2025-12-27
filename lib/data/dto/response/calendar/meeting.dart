part of '../../../data.dart';

class MeetingReadDto {
  MeetingReadDto({
    this.id,
    this.label,
    this.meetingPhoneNumbers,
    this.meetingEmails,
    this.workspaceId,
    this.members,
    this.repeatType,
    this.files,
    this.dateToStart,
    this.title,
    this.reminderTimeType,
    this.description,
    this.moreInformation = false,
    this.link,
    this.startMeetingTime,
    this.endMeetingTime,
  });

  int? id;
  LabelReadDto? label;
  List<MeetingPhoneNumber>? meetingPhoneNumbers;
  List<MeetingEmail>? meetingEmails;
  int? workspaceId;
  List<UserReadDto>? members;
  RepeatType? repeatType;
  List<MainFileReadDto>? files;
  Jalali? dateToStart;
  String? title;
  ReminderTimeType? reminderTimeType;
  String? description;
  bool moreInformation;
  String? link;
  String? startMeetingTime;
  String? endMeetingTime;

  factory MeetingReadDto.fromJson(final String str) => MeetingReadDto.fromMap(json.decode(str));

  factory MeetingReadDto.fromMap(final Map<String, dynamic> json) => MeetingReadDto(
        id: json["id"],
        label: json["label"] == null ? null : LabelReadDto.fromMap(json["label"]),
        meetingPhoneNumbers:
            json["meeting_phone_numbers"] == null ? [] : List<MeetingPhoneNumber>.from(json["meeting_phone_numbers"]!.map((final x) => MeetingPhoneNumber.fromMap(x))),
        meetingEmails: json["meeting_emails"] == null ? [] : List<MeetingEmail>.from(json["meeting_emails"]!.map((final x) => MeetingEmail.fromMap(x))),
        workspaceId: json["workspace_id"],
        members: json["members"] == null ? [] : List<UserReadDto>.from(json["members"]!.map((final x) => UserReadDto.fromMap(x["user"]))),
        repeatType: json["reaped_type"] == null ? null : RepeatType.values.firstWhereOrNull((final type) => type.name == json["reaped_type"]),
        files: json["files"] == null ? [] : List<MainFileReadDto>.from(json["files"]!.map((final x) => MainFileReadDto.fromMap(x))),
        dateToStart: json["date_to_start"] == null ? null : DateTime.parse(json["date_to_start"]).toJalali(),
        title: json["title"],
        reminderTimeType: json["remember_type"] == null
            ? null
            : ReminderTimeType.values.firstWhereOrNull((final type) => type.type == json["remember_type"] && type.number == json["remember_number"]),
        description: json["description"],
        moreInformation: json["more_information"] ?? false,
        link: json["link"],
        startMeetingTime: json["start_meeting_time"] == null
            ? null
            : json["start_meeting_time"].length >= 5
                ? json["start_meeting_time"]?.substring(0, 5)
                : json["start_meeting_time"],
        endMeetingTime: json["end_meeting_time"] == null
            ? null
            : json["end_meeting_time"].length >= 5
                ? json["end_meeting_time"]?.substring(0, 5)
                : json["end_meeting_time"],
      );
}

class MeetingPhoneNumber {
  MeetingPhoneNumber({
    this.id,
    this.phoneNumber,
  });

  int? id;
  String? phoneNumber;

  factory MeetingPhoneNumber.fromMap(final Map<String, dynamic> json) => MeetingPhoneNumber(
        id: json["id"],
        phoneNumber: json["phone_number"],
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        "id": id,
        "phone_number": phoneNumber,
      };
}

class MeetingEmail {
  MeetingEmail({
    this.id,
    this.email,
  });

  int? id;
  String? email;

  factory MeetingEmail.fromMap(final Map<String, dynamic> json) => MeetingEmail(
        id: json["id"],
        email: json["email"],
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        "id": id,
        "email": email,
      };
}
