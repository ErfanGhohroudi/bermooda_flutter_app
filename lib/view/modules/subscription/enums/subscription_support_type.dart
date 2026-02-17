import '../../../../core/core.dart';

enum SubscriptionSupportType {
  standard("Standard", "استاندارد"),
  advanced("Premium", "پیشرفته"),
  custom("Enterprise", "اختصاصی");

  const SubscriptionSupportType(this.tEn, this.tFa);

  final String tEn;
  final String tFa;

  String get title => isPersianLang ? tFa : tEn;

  static SubscriptionSupportType? fromString(final String? value) {
    switch (value) {
      case 'standard':
        return SubscriptionSupportType.standard;
      case 'advance':
        return SubscriptionSupportType.advanced;
      case 'custom':
        return SubscriptionSupportType.custom;
      default:
        return null;
    }
  }
}