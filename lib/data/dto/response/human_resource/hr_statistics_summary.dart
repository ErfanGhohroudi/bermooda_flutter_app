part of '../../../data.dart';

class HrStatisticsSummary extends Equatable {
  const HrStatisticsSummary({
    required this.totalRequestCount,
    required this.pendingReviewCount,
    required this.closedRequestCount,
    required this.delayedRequestCount,
    required this.unassignedRequestsCount,
  });

  final int totalRequestCount;
  final int pendingReviewCount;
  final int closedRequestCount;
  final int delayedRequestCount;
  final int unassignedRequestsCount;

  factory HrStatisticsSummary.fromJson(final String str) => HrStatisticsSummary.fromMap(json.decode(str));

  factory HrStatisticsSummary.fromMap(final Map<String, dynamic> json) => HrStatisticsSummary(
        totalRequestCount: json["total_requests"] ?? 0,
        pendingReviewCount: json["total_pending_requests"] ?? 0,
        closedRequestCount: json["total_closed_requests"] ?? 0,
        delayedRequestCount: json["total_overdue_requests"] ?? 0,
        unassignedRequestsCount: json["total_undecided_requests"] ?? 0,
      );

  @override
  List<Object?> get props => [
        totalRequestCount,
        pendingReviewCount,
        closedRequestCount,
        delayedRequestCount,
        unassignedRequestsCount,
      ];
}
