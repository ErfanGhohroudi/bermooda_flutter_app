class SmsPanelNumberReadDto {
  const SmsPanelNumberReadDto({
    this.id,
    this.number,
    this.providerName,
    this.status,
    this.balance,
    this.dailyLimit,
    this.monthlyLimit,
    this.usedToday,
    this.usedThisMonth,
    this.planType,
    this.planTypeDisplay,
    this.planName,
    this.planDescription,
    this.planPrice,
    this.planDurationDays,
    this.messageType,
    this.departments,
    this.lastUsed,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
  });

  final int? id;
  final String? number;
  final String? providerName;
  final String? status; // enum
  final String? balance;
  final int? dailyLimit;
  final int? monthlyLimit;
  final int? usedToday;
  final int? usedThisMonth;
  final String? planType; // enum
  final String? planTypeDisplay;
  final String? planName;
  final String? planDescription;
  final String? planPrice;
  final int? planDurationDays;
  final String? messageType; // enum
  final List<dynamic>? departments;
  final DateTime? lastUsed;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? createdBy;

  factory SmsPanelNumberReadDto.fromMap(final Map<String, dynamic> json) {
    return SmsPanelNumberReadDto(
      id: json['id'] as int?,
      providerName: json['provider_name'] as String?,
      number: json['number'] as String?,
      status: json['status'] as String?,
      balance: json['balance']?.toString(),
      dailyLimit: json['daily_limit'] as int?,
      monthlyLimit: json['monthly_limit'] as int?,
      usedToday: json['used_today'] as int?,
      usedThisMonth: json['used_this_month'] as int?,
      planType: json['plan_type'] as String?,
      planTypeDisplay: json['plan_type_display'] as String?,
      planName: json['plan_name'] as String?,
      planDescription: json['plan_description'] as String?,
      planPrice: json['plan_price']?.toString(),
      planDurationDays: json['plan_duration_days'] as int?,
      messageType: json['message_type'] as String?,
      departments: json['departments'] as List<dynamic>?,
      lastUsed: json['last_used'] == null ? null : DateTime.tryParse(json['last_used'] as String),
      createdAt: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
      createdBy: json['created_by'] as int?,
    );
  }
}
