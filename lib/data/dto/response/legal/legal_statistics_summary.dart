part of '../../../data.dart';

class LegalStatisticsSummary extends Equatable {
  const LegalStatisticsSummary({
    required this.total,
    required this.running,
    required this.inProgress,
    required this.overdue,
    required this.successful,
    required this.totalContracts,
    required this.signedContracts,
    required this.pendingContracts,
    required this.rejectedContracts,
  });

  final LegalStatisticsItem total;
  final LegalStatisticsItem running;
  final LegalStatisticsItem inProgress;
  final LegalStatisticsItem overdue;
  final LegalStatisticsItem successful;
  final int totalContracts;
  final int signedContracts;
  final int pendingContracts;
  final int rejectedContracts;

  factory LegalStatisticsSummary.fromJson(final String str) =>
      LegalStatisticsSummary.fromMap(json.decode(str));

  factory LegalStatisticsSummary.fromMap(final Map<String, dynamic> json) =>
      LegalStatisticsSummary(
        total: LegalStatisticsItem.fromMap(json["total"] ?? {}),
        running: LegalStatisticsItem.fromMap(json["running"] ?? {}),
        inProgress: LegalStatisticsItem.fromMap(json["in_progress"] ?? {}),
        overdue: LegalStatisticsItem.fromMap(json["overdue"] ?? {}),
        successful: LegalStatisticsItem.fromMap(json["successful"] ?? {}),
        totalContracts: json["total_contracts"] ?? 0,
        signedContracts: json["signed_contracts"] ?? 0,
        pendingContracts: json["pending_contracts"] ?? 0,
        rejectedContracts: json["rejected_contracts"] ?? 0,
      );

  @override
  List<Object?> get props => [
        total,
        running,
        inProgress,
        overdue,
        successful,
        totalContracts,
        signedContracts,
        pendingContracts,
        rejectedContracts,
      ];
}

class LegalStatisticsItem extends Equatable {
  const LegalStatisticsItem({
    required this.total,
    required this.tracking,
    required this.checklist,
  });

  final int total;
  final int tracking;
  final int checklist;

  factory LegalStatisticsItem.fromMap(final Map<String, dynamic> json) =>
      LegalStatisticsItem(
        total: json["total"] ?? 0,
        tracking: json["tracking"] ?? 0,
        checklist: json["checklist"] ?? 0,
      );

  @override
  List<Object?> get props => [total, tracking, checklist];
}

