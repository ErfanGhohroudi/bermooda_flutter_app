part of '../../../data.dart';

class LegalDepartmentReadDto extends Equatable {
  const LegalDepartmentReadDto({
    this.id,
    this.department,
    this.title,
    this.avatarUrl,
    this.profitPrice,
    this.members = const [],
    this.casesCount = 0,
    this.total = 0,
    this.pending = 0,
    this.signed = 0,
  });

  final String? id;
  final Department? department;
  final String? title;
  final String? avatarUrl;
  final String? profitPrice;
  final List<UserReadDto> members;
  final int casesCount;
  final int total;
  final int pending;
  final int signed;

  factory LegalDepartmentReadDto.fromJson(final String str) => LegalDepartmentReadDto.fromMap(json.decode(str));

  factory LegalDepartmentReadDto.fromMap(final Map<String, dynamic> json) => LegalDepartmentReadDto(
        id: json["id"]?.toString(),
        department: json['department'] != null ? Department.fromJson(json['department'] as Map<String, dynamic>) : null,
        title: json["title"],
        avatarUrl: json['avatar_url'] as String?,
        profitPrice: json['profit_price'] as String?,
        members: json["members_detail"] == null ? [] : List<UserReadDto>.from(json["members_detail"]!.map((final x) => UserReadDto.fromMap(x))),
        casesCount: json['cases_count'] as int? ?? 0,
        total: json['total'] as int? ?? 0,
        pending: json['pending'] as int? ?? 0,
        signed: json['signed'] as int? ?? 0,
      );

  @override
  List<Object?> get props => [
        id,
        department,
        title,
        avatarUrl,
        profitPrice,
        members,
        casesCount,
        total,
        pending,
        signed,
      ];
}

class Department extends Equatable {
  const Department({
    required this.id,
    required this.title,
  });

  final int id;
  final String title;

  factory Department.fromJson(final Map<String, dynamic> json) {
    return Department(
      id: json['id'] as int,
      title: json['title'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }

  @override
  List<Object?> get props => [id, title];
}
