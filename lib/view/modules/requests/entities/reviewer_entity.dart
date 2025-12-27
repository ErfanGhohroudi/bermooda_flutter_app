import '../../../../core/utils/extensions/date_extensions.dart';
import '../../../../data/data.dart';

class ReviewerEntity {
  ReviewerEntity({
    required this.user,
    this.reviewDeadlineDate,
  });

  final UserReadDto user;
  final DateTime? reviewDeadlineDate;

  bool validate() {
    if (reviewDeadlineDate == null) return false;
    return true;
  }

  ReviewerEntity copyWith({
    final UserReadDto? user,
    final DateTime? reviewDeadlineDate,
  }) =>
      ReviewerEntity(
        user: user ?? this.user,
        reviewDeadlineDate: reviewDeadlineDate ?? this.reviewDeadlineDate,
      );

  factory ReviewerEntity.from(final AcceptorUserReadDto model) => ReviewerEntity(
        user: model.user,
        reviewDeadlineDate: model.reviewDeadlineDate,
      );

  Map<String, dynamic> toMap(final int index) => {
        "id": user.id,
        "order": index,
        "review_date": reviewDeadlineDate?.toCompactIso8601,
      };
}
