import 'package:decimal/decimal.dart';
import 'package:u/utils/extensions/string_extension.dart';

import '../../utils/extensions/string_extensions.dart';
import '../../core.dart';

extension MoneyExtentions<T> on String {
  String toTomanMoney() => trim().isEmpty ? s.free : "${trim().separateNumbers3By3()} ${s.toman}";

  String toRialMoney() => trim().isEmpty ? s.free : "${trim().separateNumbers3By3()} ${s.rial}";

  String ibanFormat({final bool separate = false}) => "${"IR"}${separate ? trim().groupedBy4 : trim()}";
}

extension DecimalMoneyExtentions<T> on Decimal {
  String toTomanMoney() => this == 0.toDecimal() ? s.free : "${toString().separateNumbers3By3()} ${s.toman}";

  String toRialMoney() => this == 0.toDecimal() ? s.free : "${toString().separateNumbers3By3()} ${s.rial}";
}

extension DiscountPercentageExtentions<T> on double? {
  String get percentageFormatted => this == null ? '' : (this! % 1 == 0) ? this!.toStringAsFixed(0) : this!.toStringAsFixed(1);
}
