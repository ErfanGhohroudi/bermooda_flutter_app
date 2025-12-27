part of '../../../data.dart';

class LegalUserStatisticsSummary extends Equatable {
  const LegalUserStatisticsSummary({
    required this.userData,
    required this.total,
    required this.running,
    required this.inProgress,
    required this.successful,
    required this.delayed,
    required this.contractsCount,
  });

  final UserReadDto userData;
  final LegalStatisticsItem total;
  final LegalStatisticsItem running;
  final LegalStatisticsItem inProgress;
  final LegalStatisticsItem successful;
  final LegalStatisticsItem delayed;
  final int contractsCount;

  factory LegalUserStatisticsSummary.fromJson(final String str) =>
      LegalUserStatisticsSummary.fromMap(json.decode(str));

  factory LegalUserStatisticsSummary.fromMap(final Map<String, dynamic> json) {
    return LegalUserStatisticsSummary(
      userData: UserReadDto.fromMap(json),
      total: LegalStatisticsItem.fromMap(json["total"] ?? {}),
      running: LegalStatisticsItem.fromMap(json["running"] ?? {}),
      inProgress: LegalStatisticsItem.fromMap(json["in_progress"] ?? {}),
      successful: LegalStatisticsItem.fromMap(json["successful"] ?? {}),
      delayed: LegalStatisticsItem.fromMap(json["delayed"] ?? {}),
      contractsCount: json["contracts_count"] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        userData,
        total,
        running,
        inProgress,
        successful,
        delayed,
        contractsCount,
      ];
}

