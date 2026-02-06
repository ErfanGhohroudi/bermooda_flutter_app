part of '../../../data.dart';

class WarehouseReadDto {
  int? id;
  int? workspace;
  int? workSpaceId;
  int? owner;
  int? ownerId;
  String? title;
  String? code;
  double? capacity;
  String? description;
  int? state;
  int? stateId;
  int? city;
  int? cityId;
  String? stateName;
  String? cityName;
  double? latitude;
  double? longitude;
  int? mainCategory;
  int? mainCategoryId;
  int? avatar;
  int? avatarId;
  MainFileReadDto? avatarFile;
  List<UserReadDto>? members;
  String? created;

  WarehouseReadDto({
    this.id,
    this.workspace,
    this.workSpaceId,
    this.owner,
    this.ownerId,
    this.title,
    this.code,
    this.capacity,
    this.description,
    this.state,
    this.stateId,
    this.city,
    this.cityId,
    this.stateName,
    this.cityName,
    this.latitude,
    this.longitude,
    this.mainCategory,
    this.mainCategoryId,
    this.avatar,
    this.avatarId,
    this.avatarFile,
    this.members,
    this.created,
  });

  factory WarehouseReadDto.fromJson(final String str) =>
      WarehouseReadDto.fromMap(json.decode(str));

  factory WarehouseReadDto.fromMap(final Map<String, dynamic> json) =>
      WarehouseReadDto(
        id: json['id'],
        workspace: json['workspace'],
        workSpaceId: json['workSpaceId'],
        owner: json['owner'],
        ownerId: json['ownerId'],
        title: json['title'],
        code: json['code'],
        capacity: json['capacity']?.toDouble(),
        description: json['description'],
        state: json['state'],
        stateId: json['stateId'],
        city: json['city'],
        cityId: json['cityId'],
        stateName: json['state_name'],
        cityName: json['city_name'],
        latitude: json['latitude']?.toDouble(),
        longitude: json['longitude']?.toDouble(),
        mainCategory: json['main_category'],
        mainCategoryId: json['mainCategoryId'],
        avatar: json['avatar'],
        avatarId: json['avatarId'],
        avatarFile: json['avatar'] != null && json['avatar'] is Map
            ? MainFileReadDto.fromMap(json['avatar'])
            : null,
        members: json['members'] != null
            ? List<UserReadDto>.from(
                json['members'].map((final x) => UserReadDto.fromMap(x)))
            : null,
        created: json['created'],
      );

  String toJson() => json.encode(removeNullEntries(toMap()));

  Map<String, dynamic> toMap() => {
        'id': id,
        'workspace': workspace,
        'workSpaceId': workSpaceId,
        'owner': owner,
        'ownerId': ownerId,
        'title': title,
        'code': code,
        'capacity': capacity,
        'description': description,
        'state': state,
        'stateId': stateId,
        'city': city,
        'cityId': cityId,
        'state_name': stateName,
        'city_name': cityName,
        'latitude': latitude,
        'longitude': longitude,
        'main_category': mainCategory,
        'mainCategoryId': mainCategoryId,
        'avatar': avatarId,
        'avatarId': avatarId,
      };
}
