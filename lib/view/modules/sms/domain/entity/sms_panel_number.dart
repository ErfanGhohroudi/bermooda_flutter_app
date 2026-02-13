import 'package:equatable/equatable.dart';

import '../../../sms/data/dto/response/sms_panel_number.dart';

class SmsPanelNumber extends Equatable {
  const SmsPanelNumber({
    this.id,
    this.number,
    this.providerName,
    // this.status,
    // this.balance,
    // this.dailyLimit,
    // this.monthlyLimit,
    // this.usedToday,
    // this.usedThisMonth,
    // this.planType,
    // this.planTypeDisplay,
    // this.planName,
    // this.planDescription,
    // this.planPrice,
    // this.planDurationDays,
    // this.messageType,
    // this.departments,
    // this.lastUsed,
    // this.createdAt,
    // this.updatedAt,
    // this.createdBy,
  });

  final int? id;
  final String? number;
  final String? providerName;
  // final String? status;
  // final String? balance;
  // final int? dailyLimit;
  // final int? monthlyLimit;
  // final int? usedToday;
  // final int? usedThisMonth;
  // final String? planType; // enum
  // final String? planTypeDisplay;
  // final String? planName;
  // final String? planDescription;
  // final String? planPrice;
  // final int? planDurationDays;
  // final String? messageType;
  // final List<dynamic>? departments;
  // final DateTime? lastUsed;
  // final DateTime? createdAt;
  // final DateTime? updatedAt;
  // final int? createdBy;

  factory SmsPanelNumber.fromDto(final SmsPanelNumberReadDto dto) {
    return SmsPanelNumber(
      id: dto.id,
      number: dto.number,
      providerName: dto.providerName,
      // status: dto.status,
      // balance: dto.balance,
      // dailyLimit: dto.dailyLimit,
      // monthlyLimit: dto.monthlyLimit,
      // usedToday: dto.usedToday,
      // usedThisMonth: dto.usedThisMonth,
      // planType: dto.planType,
      // planTypeDisplay: dto.planTypeDisplay,
      // planName: dto.planName,
      // planDescription: dto.planDescription,
      // planPrice: dto.planPrice,
      // planDurationDays: dto.planDurationDays,
      // messageType: dto.messageType,
      // departments: dto.departments,
      // lastUsed: dto.lastUsed,
      // createdAt: dto.createdAt,
      // updatedAt: dto.updatedAt,
      // createdBy: dto.createdBy,
    );
  }

  @override
  List<Object?> get props => [
    id,
    number,
    providerName,
    // status,
    // balance,
    // dailyLimit,
    // monthlyLimit,
    // usedToday,
    // usedThisMonth,
    // planType,
    // planTypeDisplay,
    // planName,
    // planDescription,
    // planPrice,
    // planDurationDays,
    // messageType,
    // departments,
    // lastUsed,
    // createdAt,
    // updatedAt,
    // createdBy,
  ];
}
