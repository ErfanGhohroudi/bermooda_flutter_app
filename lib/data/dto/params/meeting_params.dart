part of '../../data.dart';

class MeetingParams {
  MeetingParams({
    this.labelId,
    this.reapedType,
    this.title,
    this.reminderTimeType,
    this.description,
    this.moreInformation = false,
    this.link,
    this.fileIdList,
    this.memberIdList,
    this.phoneNumberList,
    this.emailList,
    this.dateToStartPersian,
    this.startMeetingTime,
    this.endMeetingTime,
  });

  final int? labelId;
  final RepeatType? reapedType;
  final String? title;
  final ReminderTimeType? reminderTimeType;
  final String? description;
  final bool moreInformation;
  final String? link;
  final List<int>? fileIdList;
  final List<String>? memberIdList;
  final List<String>? phoneNumberList;
  final List<String>? emailList;
  final String? dateToStartPersian;
  final String? startMeetingTime;
  final String? endMeetingTime;

  String toJson() => json.encode(toMap()).englishNumber();

  Map<String, dynamic> toMap() => <String, dynamic>{
        "label_id": labelId,
        "reaped_type": reapedType?.value,
        "title": title,
        "remember_type": reminderTimeType?.type,
        "remember_number": reminderTimeType?.number,
        "description": description,
        "more_information": moreInformation,
        "link": link,
        "file_id_list": fileIdList != null && (fileIdList ?? []).isNotEmpty ? fileIdList : null,
        "member_id_list": memberIdList != null && (memberIdList ?? []).isNotEmpty ? memberIdList?.map((final e) => e.toInt()).toList() : null,
        "phone_number_list": phoneNumberList != null && (phoneNumberList ?? []).isNotEmpty ? phoneNumberList : null,
        "email_list": emailList != null && (emailList ?? []).isNotEmpty ? emailList : null,
        "date_to_start_persian": dateToStartPersian,
        "start_meeting_time": startMeetingTime,
        "end_meeting_time": endMeetingTime,
      };
}
