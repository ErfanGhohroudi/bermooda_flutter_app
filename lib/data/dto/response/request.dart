part of '../../data.dart';
@Deprecated('use IRequestReadDto instead')
class RequestReadDto {
  RequestReadDto({
    required this.id,
    this.requestType,
    this.leaveType,
    this.missionType,
    this.state,
    this.city,
    this.address,
    this.description,
    this.vehicle,
    this.missionDateTimeToStart,
    this.missionDateTimeToEnd,
    this.requestingUser,
    this.leaveFiles,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.doctorDocument,
    this.folderCategory,
    this.slug,
    this.status,
  });

  String id;
  RequestCategoryType? requestType;
  LeaveType? leaveType;
  MissionType? missionType;
  DropdownItemReadDto? state;
  DropdownItemReadDto? city;
  String? address;
  String? description;
  String? vehicle;
  String? missionDateTimeToStart;
  String? missionDateTimeToEnd;
  UserReadDto? requestingUser;
  List<MainFileReadDto>? leaveFiles;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  MainFileReadDto? doctorDocument;
  FolderCategoryReadDto? folderCategory;
  String? slug;
  StatusType? status;

  factory RequestReadDto.fromJson(final String str) => RequestReadDto.fromMap(json.decode(str));

  factory RequestReadDto.fromMap(final Map<String, dynamic> json) => RequestReadDto(
        id: json["id"].toString(),
        requestType: json["request_type"] == null ? null : RequestCategoryType.values.firstWhereOrNull((final e) => e.name == json["request_type"]),
        leaveType: json["leave_type"] == null ? null : LeaveType.values.firstWhereOrNull((final e) => e.name == json["leave_type"]),
        missionType: json["mission_type"] == null ? null : MissionType.values.firstWhereOrNull((final e) => e.name == json["mission_type"]),
        state: json["state"] == null ? null : DropdownItemReadDto.fromMap(json["state"]),
        city: json["city"] == null ? null : DropdownItemReadDto.fromMap(json["city"]),
        address: json["address"],
        description: json["description"] ?? json["reason_for_leave"],
        vehicle: json["vehicle"],
        missionDateTimeToStart: json["date_time_to_start_jalali"],
        missionDateTimeToEnd: json["date_time_to_end_jalali"],
        requestingUser: json["requesting_user"] == null ? null : UserReadDto.fromMap(json["requesting_user"]),
        leaveFiles: json["leave_file_documents"] == null ? [] : List<MainFileReadDto>.from(json["leave_file_documents"]!.map((final x) => MainFileReadDto.fromMap(x))),
        startDate: json["start_date_jalali"]?? json["hourly_leave_date_jalali"],
        endDate: json["end_date_jalali"],
        startTime: json["time_to_start_at"],
        endTime: json["time_to_end_at"],
        doctorDocument: json["doctor_document"] == null ? null : MainFileReadDto.fromMap(json["doctor_document"]),
        folderCategory: json["folder_category"] == null ? null : FolderCategoryReadDto.fromMap(json["folder_category"]),
        slug: json["slug"],
        status: json["status"] == null ? null : StatusType.values.firstWhereOrNull((final e) => e.name == json["status"]),
      );
}

class FolderCategoryReadDto {
  FolderCategoryReadDto({
    this.name,
    this.slug,
  });

  String? name;
  String? slug;

  factory FolderCategoryReadDto.fromJson(final String str) => FolderCategoryReadDto.fromMap(json.decode(str));

  factory FolderCategoryReadDto.fromMap(final Map<String, dynamic> json) => FolderCategoryReadDto(
    name: json["name"],
    slug: json["slug"],
  );
}
