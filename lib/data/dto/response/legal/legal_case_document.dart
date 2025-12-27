part of '../../../data.dart';

class LegalCaseDocumentDto extends Equatable {
  const LegalCaseDocumentDto({
    required this.id,
    required this.title,
    required this.file,
    this.creatorDetail,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String title;
  final MainFileReadDto file;
  final UserReadDto? creatorDetail;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LegalCaseDocumentDto copyWith({
    final int? id,
    final String? title,
    final MainFileReadDto? file,
    final UserReadDto? creatorDetail,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) {
    return LegalCaseDocumentDto(
      id: id ?? this.id,
      title: title ?? this.title,
      file: file ?? this.file,
      creatorDetail: creatorDetail ?? this.creatorDetail,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory LegalCaseDocumentDto.fromJson(final String str) => LegalCaseDocumentDto.fromMap(json.decode(str));

  factory LegalCaseDocumentDto.fromMap(final Map<String, dynamic> json) => LegalCaseDocumentDto(
        id: json['id'] as int,
        title: json["title"],
        file: MainFileReadDto.fromMap(json), // from json["file"] and json["file_url"]
        creatorDetail: json["creator_detail"] == null ? null : UserReadDto.fromMap(json["creator_detail"]),
        createdAt: DateTime.tryParse(json["created_at"]),
        updatedAt: DateTime.tryParse(json["updated_at"]),
      );

  @override
  List<Object?> get props => [
        id,
        title,
        file,
        creatorDetail,
        createdAt?.toIso8601String(),
        updatedAt?.toIso8601String(),
      ];
}
