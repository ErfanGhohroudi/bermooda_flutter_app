import '../../../../../core/core.dart';

enum FollowUpFilterType {
  all,
  is_worked,
  is_done;

  String get title {
    switch (this) {
      case all:
        return s.all;
      case is_worked:
        return s.todo;
      case is_done:
        return s.doned;
    }
  }
}