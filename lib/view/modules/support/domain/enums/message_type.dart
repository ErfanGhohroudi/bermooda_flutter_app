import '../../../../../core/core.dart';

enum SupportMessageType {
  text,
  image,
  voice,
  file;

  static SupportMessageType fromString(final String? value) {
    switch(value) {
      case 'text':
        return SupportMessageType.text;
      case 'image':
        return SupportMessageType.image;
      case 'voice':
        return SupportMessageType.voice;
      case 'file':
        return SupportMessageType.file;
      default:
        return SupportMessageType.text;
    }
  }

  String? get title {
    switch (this) {
      case SupportMessageType.text:
        return null;
      case SupportMessageType.image:
        return '📷 ${s.image}';
      case SupportMessageType.voice:
        return '🎤 ${s.voiceMessage}';
      case SupportMessageType.file:
        return '📎 ${s.file}';
    }
  }
}