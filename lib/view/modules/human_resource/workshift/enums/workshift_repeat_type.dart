import '../../../../../core/core.dart';

enum WorkshiftRepeatType {
  singleDay,
  weekly,
  monthly;

  String get title {
    switch (this) {
      case WorkshiftRepeatType.singleDay:
        return s.onlyThisDay;
      case WorkshiftRepeatType.weekly:
        return s.weekly;
      case WorkshiftRepeatType.monthly:
        return s.monthly;
    }
  }
}