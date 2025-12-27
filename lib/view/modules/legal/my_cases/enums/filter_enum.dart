import '../../../../../core/core.dart';

enum MyContractFilterType {
  all,
  notCompleted,
  completed;

  String get title {
    switch (this) {
      case all:
        return s.all;
      case notCompleted:
        return s.todo;
      case completed:
        return s.doned;
    }
  }
}

