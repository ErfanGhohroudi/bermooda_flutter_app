part of '../../../data.dart';

class CustomersBankDocument extends Equatable {
  const CustomersBankDocument({
    this.id,
    this.exelFile,
  });

  final int? id;
  final MainFileReadDto? exelFile;

  factory CustomersBankDocument.fromJson(final String str) =>
      CustomersBankDocument.fromMap(json.decode(str));

  factory CustomersBankDocument.fromMap(final Map<String, dynamic> json) =>
      CustomersBankDocument(
        id: json["id"],
        exelFile: json["exel_file"] == null ? null : MainFileReadDto.fromMap(json["exel_file"]),
      );

  @override
  List<Object?> get props => [
    id,
    exelFile,
  ];
}
