part of '../../../data.dart';

class HRUserStatisticsSummary extends Equatable {
  const HRUserStatisticsSummary({
    required this.userData,
    required this.totalRequestCount,
    required this.pendingReviewCount,
    required this.closedRequestCount,
    required this.delayedRequestCount,
    required this.rejectedRequestsCount,
  });

  final UserReadDto userData;
  final int totalRequestCount;
  final int pendingReviewCount;
  final int closedRequestCount;
  final int delayedRequestCount;
  final int rejectedRequestsCount;

  factory HRUserStatisticsSummary.fromJson(final String str) =>
      HRUserStatisticsSummary.fromMap(json.decode(str));

  factory HRUserStatisticsSummary.fromMap(final Map<String, dynamic> json) =>
      HRUserStatisticsSummary(
        userData: UserReadDto.fromMap(json["user_data"]),
        totalRequestCount: json["total_request_count"] ?? 0,
        pendingReviewCount: json["pending_review_count"] ?? 0,
        closedRequestCount: json["closed_request_count"] ?? 0,
        delayedRequestCount: json["delayed_request_count"] ?? 0,
        rejectedRequestsCount: json["cancelled_request"] ?? 0,
      );

  @override
  List<Object?> get props => [
        userData,
        totalRequestCount,
        pendingReviewCount,
        closedRequestCount,
        delayedRequestCount,
        rejectedRequestsCount,
      ];
}
