part of 'conversation_dtos.dart';

class MessageAttachmentDto extends Equatable {
  const MessageAttachmentDto({
    required this.id,
    required this.fileName,
    required this.fileSize,
    required this.mimeType,
    required this.fileUrl,
    this.thumbnailUrl,
    this.width,
    this.height,
  });

  final String id;
  final String fileName;
  final int fileSize;
  final String mimeType;
  final String fileUrl;
  final String? thumbnailUrl;
  final int? width;
  final int? height;

  factory MessageAttachmentDto.fromJson(final Map<String, dynamic> json) {
    return MessageAttachmentDto(
      id: json['id']?.toString() ?? '',
      fileName: json['file_name'] ?? '',
      fileSize: json['file_size'] ?? 0,
      mimeType: json['mime_type'] ?? '',
      fileUrl: json['file_url'] ?? '',
      thumbnailUrl: json['thumbnail_url'],
      width: json['width'],
      height: json['height'],
    );
  }

  factory MessageAttachmentDto.fromMap(final Map<String, dynamic> json) => MessageAttachmentDto.fromJson(json);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file_name': fileName,
      'file_size': fileSize,
      'mime_type': mimeType,
      'file_url': fileUrl,
      'thumbnail_url': thumbnailUrl,
      'width': width,
      'height': height,
    };
  }

  @override
  List<Object?> get props => [id, fileName, fileSize, mimeType, fileUrl, thumbnailUrl, width, height];
}

