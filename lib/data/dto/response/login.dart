part of '../../data.dart';

class LoginReadDto {
  LoginReadDto({
    this.jwtToken,
    this.webSocketToken,
    this.workspaces,
  });

  JwtToken? jwtToken;
  String? webSocketToken;
  List<WorkspaceReadDto>? workspaces;

  factory LoginReadDto.fromJson(final String str) => LoginReadDto.fromMap(json.decode(str));

  factory LoginReadDto.fromMap(final Map<String, dynamic> json) => LoginReadDto(
    jwtToken: json["jwt_token"] == null ? null : JwtToken.fromMap(json["jwt_token"]),
    webSocketToken: json["token"],
    workspaces: json["workspaces"] == null ? [] : List<WorkspaceReadDto>.from(json["workspaces"]!.map((final x) => WorkspaceReadDto.fromMap(x))),
  );
}

class JwtToken {
  String? refresh;
  String? access;

  JwtToken({
    this.refresh,
    this.access,
  });

  factory JwtToken.fromJson(final String str) => JwtToken.fromMap(json.decode(str));

  factory JwtToken.fromMap(final Map<String, dynamic> json) => JwtToken(
    refresh: json["refresh"],
    access: json["access"],
  );
}
