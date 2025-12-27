part of '../../../data.dart';

class CrmStatisticsSummary extends Equatable {
  const CrmStatisticsSummary({
    required this.totalFollowUpsCount,
    required this.followingUpsCount,
    required this.successfulSaleCount,
    required this.delayedFollowUpsCount,
    required this.totalSeconds,
  });

  final int totalFollowUpsCount;
  final int followingUpsCount;
  final int successfulSaleCount;
  final int delayedFollowUpsCount;
  final String totalSeconds;

  factory CrmStatisticsSummary.fromJson(final String str) =>
      CrmStatisticsSummary.fromMap(json.decode(str));

  factory CrmStatisticsSummary.fromMap(final Map<String, dynamic> json) =>
      CrmStatisticsSummary(
        totalFollowUpsCount: json["total_group_tracking"] ?? 0,
        followingUpsCount: json["running_tracking"] ?? 0,
        successfulSaleCount: json["success_full_tracking"] ?? 0,
        delayedFollowUpsCount: json["total_overdue_tracking"] ?? 0,
        totalSeconds: json["total_duration"] ?? "00:00:00",
      );

  @override
  List<Object?> get props => [
    totalFollowUpsCount,
    followingUpsCount,
    successfulSaleCount,
    delayedFollowUpsCount,
    totalSeconds,
  ];
}
