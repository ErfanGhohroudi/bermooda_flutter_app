import 'package:equatable/equatable.dart';

import '../../../../../data/data.dart';

/// Domain Entity for Warehouse
class Warehouse extends Equatable {
  const Warehouse({
    required this.id,
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
    this.avatarUrl,
    this.members,
    this.created,
  });

  final int id;
  final int? workspace;
  final int? workSpaceId;
  final int? owner;
  final int? ownerId;
  final String? title;
  final String? code;
  final double? capacity;
  final String? description;
  final int? state;
  final int? stateId;
  final int? city;
  final int? cityId;
  final String? stateName;
  final String? cityName;
  final double? latitude;
  final double? longitude;
  final int? mainCategory;
  final int? mainCategoryId;
  final int? avatar;
  final int? avatarId;
  final String? avatarUrl;
  final List<UserReadDto>? members;
  final String? created;

  @override
  List<Object?> get props => [
        id,
        workspace,
        workSpaceId,
        owner,
        ownerId,
        title,
        code,
        capacity,
        description,
        state,
        stateId,
        city,
        cityId,
        stateName,
        cityName,
        latitude,
        longitude,
        mainCategory,
        mainCategoryId,
        avatar,
        avatarId,
        avatarUrl,
        members,
        created,
      ];
}
