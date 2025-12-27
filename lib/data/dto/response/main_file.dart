part of '../../data.dart';

class MainFileReadDto extends Equatable {
  const MainFileReadDto({
    this.fileId,
    this.url,
    this.fileName,
    this.originalName,
    this.isRemoved = false,
  });

  final int? fileId;
  final String? url;
  final String? fileName;
  final String? originalName;

  /// این فیلد برای مدیریت وضعیت در UI کاربرد دارد و از سرور نمی‌آید.
  final bool isRemoved;

  String? get iconOrImage {
    if (url == null) return null;

    return url!.isVideoFileName
        ? AppImages.video
        : url!.isAudioFileName
        ? AppImages.music
        : url!.isPDFFileName
        ? AppImages.pdf
        : url!.isPPTFileName
        ? AppImages.powerPoint
        : url!.isDocumentFileName || url!.isTxtFileName
        ? AppImages.word
        : url!.isExcelFileName || url!.endsWith('.csv')
        ? AppImages.exel
        : url!;
  }

  MainFileReadDto copyWith({
    final int? fileId,
    final String? url,
    final String? fileName,
    final String? originalName,
    final bool? isRemoved,
  }) {
    return MainFileReadDto(
      fileId: fileId ?? this.fileId,
      url: url ?? this.url,
      fileName: fileName ?? this.fileName,
      originalName: originalName ?? this.originalName,
      isRemoved: isRemoved ?? this.isRemoved,
    );
  }

  factory MainFileReadDto.fromJson(final String str) => MainFileReadDto.fromMap(json.decode(str));

  factory MainFileReadDto.fromMap(final Map<String, dynamic> json) => MainFileReadDto(
    // json["file"] use for [LegalCaseDocumentDto]
    fileId: json["file"] ?? json["file_id"] ?? json["id"],
    url: json["url"] ?? json["file_url"],
    fileName: ((json["file_name"] ?? json["url"] ?? json["file_url"]) as String?)?.split('/').lastOrNull,
    originalName: json["original_name"] == null ? null : (json["original_name"] as String).split('/').lastOrNull,
    isRemoved: false,
  );

  String toJson() => json.encode(removeNullEntries(toMap()));

  Map<String, dynamic> toMap() => <String, dynamic>{
    "file_id": fileId,
    "url": url,
    "file_name": fileName,
    "original_name": originalName,
  };

  @override
  List<Object?> get props => [
    fileId,
    url,
    fileName,
    originalName,
    isRemoved,
  ];
}
