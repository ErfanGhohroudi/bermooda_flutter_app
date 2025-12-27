part of '../../../data.dart';

class CrmSummeryReadDto extends Equatable {
  const CrmSummeryReadDto({
    this.activeCustomers = 0,
    this.totalSellAmount = 0,
    this.customerConversionRate = 0,
    this.uncompletedFollowups = 0,
    this.completedFollowups = 0,
    this.delayedFollowups = 0,
  });

  final int activeCustomers;
  final int totalSellAmount;
  final double customerConversionRate;
  final int uncompletedFollowups;
  final int completedFollowups;
  final int delayedFollowups;

  factory CrmSummeryReadDto.fromJson(final String str) => CrmSummeryReadDto.fromMap(json.decode(str));

  factory CrmSummeryReadDto.fromMap(final Map<String, dynamic> json) => CrmSummeryReadDto(
        activeCustomers: json["active_customer"] ?? 0,
        totalSellAmount: json["total_sell_amount"] ?? 0,
        customerConversionRate: json["customer_conversion_rate"]?.toDouble() ?? 0,
        uncompletedFollowups: json["un_completed_tracking"] ?? 0,
        completedFollowups: json["completed_tracking"] ?? 0,
        delayedFollowups: json["delayed_tracking"] ?? 0,
      );

  @override
  List<Object?> get props => [
        activeCustomers,
        totalSellAmount,
        customerConversionRate,
        uncompletedFollowups,
        completedFollowups,
        delayedFollowups,
      ];
}
