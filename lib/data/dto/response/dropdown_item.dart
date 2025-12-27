part of '../../data.dart';

class DropdownItemReadDto extends Equatable {
  final int? id;
  final String? title;
  final String? slug;

  const DropdownItemReadDto({
    this.id,
    this.title,
    this.slug,
  });

  factory DropdownItemReadDto.fromJson(final String str) => DropdownItemReadDto.fromMap(json.decode(str));

  factory DropdownItemReadDto.fromMap(final Map<String, dynamic> json) => DropdownItemReadDto(
    id: json["id"],
    slug: json["slug"],
    title: json["title"] ?? json["name"],
  );

  @override
  List<Object?> get props => [
    id,
    title,
    slug,
  ];
}
