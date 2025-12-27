part of '../../../data.dart';

class SubscriptionReadDto extends Equatable {
  const SubscriptionReadDto({
    required this.slug,
    this.userCount = 10,
    this.storage = 5,
    this.maxOnlineContract = MaxContractCount.fifty,
    this.purchaseDate,
    this.purchaseType = SubscriptionPurchaseType.no_purchase,
    this.expireDate,
    this.isExpired = true,
    this.modules = const [],
    this.price = 0,
    this.remainingDays = 0,
    this.period = SubscriptionPeriod.twelveMonths,
  });

  final String slug;
  final int userCount;
  final int storage; // in GB
  final MaxContractCount maxOnlineContract;
  final DateTime? purchaseDate;
  final SubscriptionPurchaseType purchaseType;
  final DateTime? expireDate;
  final bool isExpired;
  final List<ModuleReadDto> modules;
  final int price;
  final int remainingDays;
  final SubscriptionPeriod period;

  SubscriptionReadDto copyWith({
    final int? userCount,
    final int? storage,
    final MaxContractCount? maxOnlineContract,
    final DateTime? purchaseDate,
    final SubscriptionPurchaseType? purchaseType,
    final DateTime? expireDate,
    final bool? isExpired,
    final List<ModuleReadDto>? modules,
    final int? price,
    final int? remainingDays,
    final SubscriptionPeriod? period,
  }) {
    return SubscriptionReadDto(
      slug: slug,
      userCount: userCount ?? this.userCount,
      storage: storage ?? this.storage,
      maxOnlineContract: maxOnlineContract ?? this.maxOnlineContract,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      purchaseType: purchaseType ?? this.purchaseType,
      expireDate: expireDate ?? this.expireDate,
      isExpired: isExpired ?? this.isExpired,
      modules: modules ?? this.modules,
      price: price ?? this.price,
      remainingDays: remainingDays ?? this.remainingDays,
      period: period ?? this.period,
    );
  }

  factory SubscriptionReadDto.fromJson(final String str) => SubscriptionReadDto.fromMap(json.decode(str));

  factory SubscriptionReadDto.fromMap(final Map<String, dynamic> json) => SubscriptionReadDto(
    slug: json["slug"].toString(),
    userCount: json["max_member"] ?? 10,
    storage: json["max_volume"] ?? 5,
    maxOnlineContract: MaxContractCount.fromCount(json["max_online_contract"]),
    purchaseDate: json["purchase_date"] == null ? null : DateTime.tryParse(json["purchase_date"]),
    purchaseType: json["purchase_type"] == null
        ? SubscriptionPurchaseType.no_purchase
        : SubscriptionPurchaseType.values.firstWhereOrNull((final e) => e.name == json["purchase_type"]) ??
              SubscriptionPurchaseType.no_purchase,
    expireDate: json["expire_date"] == null ? null : DateTime.tryParse(json["expire_date"]),
    isExpired: json["is_expire"] ?? true,
    modules: json["module_data"] == null
        ? []
        : List<ModuleReadDto>.from(json["module_data"]!.map((final x) => ModuleReadDto.fromMap(x))),
    price: json["sub_price"]?.toString().numericOnly().toInt() ?? 0,
    remainingDays: json["remaining_days"]?.toInt() ?? 0,
    period: json["period_days"] == null
        ? SubscriptionPeriod.twelveMonths
        : SubscriptionPeriod.values.firstWhereOrNull((final e) => e.days == json["period_days"]) ??
              SubscriptionPeriod.twelveMonths,
  );

  // Helper methods
  SubscriptionStatus get status {
    if (isExpired) {
      return SubscriptionStatus.expired;
    } else if (remainingDays <= 7) {
      return SubscriptionStatus.expiringSoon;
    } else {
      return SubscriptionStatus.active;
    }
  }

  bool get isNoPurchase => purchaseType == SubscriptionPurchaseType.no_purchase;

  bool get isTrial => purchaseType == SubscriptionPurchaseType.trial;

  bool get isPurchase => purchaseType == SubscriptionPurchaseType.subscription;

  @override
  List<Object?> get props => [
    slug,
    userCount,
    storage,
    maxOnlineContract,
    purchaseDate,
    purchaseType,
    expireDate,
    isExpired,
    modules,
    price,
    remainingDays,
    period,
  ];
}

class SubscriptionPriceReadDto extends Equatable {
  SubscriptionPriceReadDto({
    required this.daysToAdd,
    required this.totalPrice,
    required this.totalModulePrice,
    required this.totalUserPrice,
    required this.totalStoragePrice,
    required this.totalContractPrice,
    required this.discountPercentage,
    required this.discountPrice,
    required this.finalPrice,
    this.modulePriceList = const [],
    this.redirectUrl,
    this.isWorkspaceInfoCompleted = false,
    this.hasDiscountCodeExist = false,
  }) : discountPercentageFormatted = discountPercentage.percentageFormatted;

  final int daysToAdd;
  final int totalPrice;
  final int totalModulePrice;
  final int totalUserPrice;
  final int totalStoragePrice;
  final int totalContractPrice;
  final double discountPercentage;
  final int discountPrice;
  final int finalPrice;
  final List<ModulePriceReadDto> modulePriceList;
  final String? redirectUrl;
  final bool isWorkspaceInfoCompleted;
  final bool hasDiscountCodeExist;

  final String discountPercentageFormatted;

  factory SubscriptionPriceReadDto.fromMap(final Map<String, dynamic> json) => SubscriptionPriceReadDto(
    daysToAdd: json["invoice_summery"]?["invoice_data"]?["days_to_add"] ?? 0,
    totalPrice: json["invoice_summery"]?["total_price"] ?? 0,
    totalModulePrice: json["invoice_summery"]?["total_module_price"] ?? 0,
    totalUserPrice: json["invoice_summery"]?["total_member_price"] ?? 0,
    totalStoragePrice: json["invoice_summery"]?["total_volume_price"] ?? 0,
    totalContractPrice: json["invoice_summery"]?["total_contract_price"] ?? 0,
    discountPercentage: json["invoice_summery"]?["discount_percentage"]?.toDouble() ?? 0,
    discountPrice: json["invoice_summery"]?["discount_amount"] ?? 0,
    finalPrice: json["invoice_summery"]?["payable_price"] ?? 0,
    modulePriceList: json["invoice_summery"]?["module_price_list"] == null
        ? []
        : List<ModulePriceReadDto>.from(
            json["invoice_summery"]!["module_price_list"].map((final x) => ModulePriceReadDto.fromMap(x)),
          ),
    redirectUrl: json["redirect_url"],
    isWorkspaceInfoCompleted: json["invoice_summery"]?["is_complete"] ?? false,
    hasDiscountCodeExist: json["invoice_summery"]?["has_discount_exsist"] ?? false,
  );

  @override
  List<Object?> get props => [
    daysToAdd,
    totalPrice,
    totalModulePrice,
    totalUserPrice,
    totalStoragePrice,
    totalContractPrice,
    discountPercentage,
    discountPrice,
    finalPrice,
    modulePriceList,
    redirectUrl,
    isWorkspaceInfoCompleted,
    hasDiscountCodeExist,
  ];
}

class ModulePriceReadDto extends Equatable {
  ModulePriceReadDto({
    required this.module,
    required this.totalPrice,
    required this.discountPercentage,
    required this.finalPrice,
  }) : discountPercentageFormatted = discountPercentage.percentageFormatted,
       discountPrice = totalPrice < finalPrice ? 0 : totalPrice - finalPrice;

  final ModuleReadDto module;
  final int totalPrice;
  final double discountPercentage;
  final int finalPrice;

  final int discountPrice;
  final String discountPercentageFormatted;

  factory ModulePriceReadDto.fromMap(final Map<String, dynamic> json) => ModulePriceReadDto(
    module: json["module_data"] == null
        ? const ModuleReadDto(slug: '', titleFa: '', subTitle: '', description: '')
        : ModuleReadDto.fromMap(json["module_data"]),
    totalPrice: json["price"]?.toInt() ?? 0,
    discountPercentage: json["discount"]?.toDouble() ?? 0,
    finalPrice: json["final_price"]?.toInt() ?? 0,
  );

  @override
  List<Object?> get props => [
    module,
    totalPrice,
    discountPercentage,
    discountPrice,
    finalPrice,
  ];
}
