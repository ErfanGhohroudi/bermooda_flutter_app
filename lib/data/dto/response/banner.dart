part of '../../data.dart';

class BannerReadDto {
  BannerReadDto({
    this.webFile,
    this.appFile,
  });

  MainFileReadDto? webFile;
  MainFileReadDto? appFile;

  factory BannerReadDto.fromJson(final String str) => BannerReadDto.fromMap(json.decode(str));

  factory BannerReadDto.fromMap(final dynamic json) => BannerReadDto(
        webFile: json["image_web"] == null ? null : MainFileReadDto.fromMap(json["image_web"]),
        appFile: json["image_application"] == null ? null : MainFileReadDto.fromMap(json["image_application"]),
      );
}
