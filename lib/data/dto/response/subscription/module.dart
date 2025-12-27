part of '../../../data.dart';

class ModuleReadDto extends Equatable {
  const ModuleReadDto({
    required this.slug,
    required this.titleFa,
    required this.subTitle,
    required this.description,
    this.type,
    this.iconData,
    this.isActive = false,
    this.isEnable = false,
    this.price,
    this.finalPrice,
    this.isDiscount = false,
    this.discountPercentage = 0,
  });

  final String slug;
  final String titleFa;
  final String subTitle;
  final String description;
  final ModuleType? type;
  final String? iconData;
  final bool isActive;
  final bool isEnable;
  final int? price;
  final int? finalPrice;
  final bool isDiscount;
  final double discountPercentage;

  ModuleReadDto copyWith({
    final String? slug,
    final ModuleType? type,
    final String? titleFa,
    final String? subTitle,
    final String? description,
    final String? iconData,
    final bool? isActive,
    final bool? isEnable,
    final int? price,
    final int? finalPrice,
    final bool? isDiscount,
    final double? discountPercentage,
  }) {
    return ModuleReadDto(
      slug: slug ?? this.slug,
      type: type ?? this.type,
      titleFa: titleFa ?? this.titleFa,
      subTitle: subTitle ?? this.subTitle,
      description: description ?? this.description,
      iconData: iconData ?? this.iconData,
      isActive: isActive ?? this.isActive,
      isEnable: isEnable ?? this.isEnable,
      price: price ?? this.price,
      finalPrice: finalPrice ?? this.finalPrice,
      isDiscount: isDiscount ?? this.isDiscount,
      discountPercentage: discountPercentage ?? this.discountPercentage,
    );
  }

  factory ModuleReadDto.fromJson(final String str) => ModuleReadDto.fromMap(json.decode(str));

  factory ModuleReadDto.fromMap(final Map<String, dynamic> json) => ModuleReadDto(
        slug: json["slug"].toString(),
        titleFa: json["title"].toString(),
        subTitle: json["sub_title"].toString(),
        description: json["description"].toString(),
        type: ModuleType.fromString(json["module_type_enum"] as String?),
        iconData: json["icon_data"],
        isActive: json["is_active"] ?? false,
        isEnable: json["is_enable"] ?? false,
        price: json["price"]?.toString().numericOnly().toInt(),
        finalPrice: json["final_price"]?.toString().numericOnly().toInt(),
        isDiscount: json["is_discount"] ?? false,
        discountPercentage: json["discount_percentage"]?.toInt() ?? 0,
      );

  String get title => type?.title ?? titleFa;

  @override
  List<Object?> get props => [
        slug,
        type,
        titleFa,
        subTitle,
        description,
        iconData,
        isActive,
        isEnable,
        price,
        finalPrice,
        isDiscount,
        discountPercentage,
      ];
}
