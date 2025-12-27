part of '../../../data.dart';

class CrmUserStatisticsSummary extends Equatable {
  const CrmUserStatisticsSummary({
    required this.userData,
    required this.totalFollowUpsCount,
    required this.followingUpsCount,
    required this.successfulSaleCount,
    required this.delayedFollowUpsCount,
    required this.totalSeconds,
  });

  final UserReadDto userData;
  final int totalFollowUpsCount;
  final int followingUpsCount;
  final int successfulSaleCount;
  final int delayedFollowUpsCount;
  final int totalSeconds;

  factory CrmUserStatisticsSummary.fromJson(final String str) =>
      CrmUserStatisticsSummary.fromMap(json.decode(str));

  factory CrmUserStatisticsSummary.fromMap(final Map<String, dynamic> json) =>
      CrmUserStatisticsSummary(
        userData: UserReadDto.fromMap(json["user_data"]),
        totalFollowUpsCount: json["total_follow_up_count"] ?? 0,
        followingUpsCount: json["In_negotiation_count"] ?? 0,
        successfulSaleCount: json["successful_sale_count"] ?? 0,
        delayedFollowUpsCount: json["delayed_follow_up_count"] ?? 0,
        totalSeconds: json["time_spent_second"] ?? 0,
      );

  @override
  List<Object?> get props => [
    userData,
    totalFollowUpsCount,
    followingUpsCount,
    successfulSaleCount,
    delayedFollowUpsCount,
    totalSeconds,
  ];
}
