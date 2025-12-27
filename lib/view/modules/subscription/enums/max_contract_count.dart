import '../../../../core/core.dart';

enum MaxContractCount {
  fifty,
  hundred,
  twoHundred,
  fiveHundred,
  thousand;

  int get count => switch (this) {
    fifty => 50,
    hundred => 100,
    twoHundred => 200,
    fiveHundred => 500,
    thousand => 1000,
  };

  String get title => switch (this) {
    fifty => "50 ${isPersianLang ? s.contract : "${s.contract}s"}",
    hundred => "100 ${isPersianLang ? s.contract : "${s.contract}s"}",
    twoHundred => "200 ${isPersianLang ? s.contract : "${s.contract}s"}",
    fiveHundred => "500 ${isPersianLang ? s.contract : "${s.contract}s"}",
    thousand => "1000 ${isPersianLang ? s.contract : "${s.contract}s"}",
  };

  static MaxContractCount fromCount(final int? count) => switch (count) {
    50 => fifty,
    100 => hundred,
    200 => twoHundred,
    500 => fiveHundred,
    1000 => thousand,
    _ => fifty,
  };
}