part of '../../data.dart';

class OTPReadDto {
  OTPReadDto({
    this.slug,
    this.phoneNumber,
    this.jwtToken,
    this.webSocketToken,
  });

  String? slug;
  String? phoneNumber;
  JwtToken? jwtToken;
  String? webSocketToken;

  factory OTPReadDto.fromJson(final String str) => OTPReadDto.fromMap(json.decode(str));

  factory OTPReadDto.fromMap(final Map<String, dynamic> json) => OTPReadDto(
    slug: json["slug"]?.toString(),
    phoneNumber: json["phone_number"]?.toString(),
    jwtToken: json["jwt_token"] == null ? null : JwtToken.fromMap(json["jwt_token"]),
    webSocketToken: json["token"],
  );
}
