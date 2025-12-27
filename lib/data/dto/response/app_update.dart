part of '../../data.dart';

class AppUpdateReadDto {
  AppUpdateReadDto({
    this.lastVersion,
    this.isForce = false,
    this.cafebazarLink,
    this.myketLink,
    this.downloadLink,
  });

  String? lastVersion;
  bool isForce;
  String? cafebazarLink;
  String? myketLink;
  String? downloadLink;

  factory AppUpdateReadDto.fromJson(final String str) => AppUpdateReadDto.fromMap(json.decode(str));

  factory AppUpdateReadDto.fromMap(final Map<String, dynamic> json) => AppUpdateReadDto(
    lastVersion: json["last_version"].toString(),
    isForce: json["is_force"]?? false,
    cafebazarLink: json["cafe_bazar_link"],
    myketLink: json["myket_link"],
    downloadLink: json["download_link"],
  );

  String toJson() => json.encode(removeNullEntries(toMap()));

  Map<String, dynamic> toMap() => <String, dynamic>{
    "last_version": lastVersion,
    "is_force": isForce,
    "cafe_bazar_link": cafebazarLink,
    "myket_link": myketLink,
    "download_link": downloadLink,
  };
}