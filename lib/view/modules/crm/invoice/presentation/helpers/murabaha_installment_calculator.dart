import 'package:decimal/decimal.dart';
import 'package:u/utils/shamsi_date/src/jalali/jalali_date.dart';

import '../../../../../../data/data.dart';

class MurabahaInstallmentCalculator {
  final Decimal principalAmount; // قیمت نقدی
  final Decimal annualRate; // درصد سود سالانه (مثلاً 18)
  final Jalali invoiceDate;
  final List<Jalali> dueDates;

  const MurabahaInstallmentCalculator({
    required this.principalAmount,
    required this.annualRate,
    required this.invoiceDate,
    required this.dueDates,
  });

  List<InstallmentResult> calculate() {
    final List<InstallmentResult> schedule = [];

    if (dueDates.isEmpty) return schedule;

    final int installmentCount = dueDates.length;

    // تعداد کل روزهای قرارداد
    final int totalDays = dueDates.last.distanceTo(invoiceDate).abs();

    // مدت قرارداد به سال (365 روزه)
    final Decimal durationInYears = (totalDays.toDecimal().toRational() / 365.toDecimal().toRational()).toDecimal(
      scaleOnInfinitePrecision: 12,
    );

    // سود کل مرابحه (ثابت)
    final Decimal totalProfit =
        (principalAmount.toRational() * annualRate.toRational() * durationInYears.toRational() / 100.toDecimal().toRational())
            .toDecimal()
            .round(scale: 0);

    // اصل هر قسط
    final Decimal principalPerInstallment =
    (principalAmount / Decimal.fromInt(installmentCount))
        .toDecimal(scaleOnInfinitePrecision: 0);

    // سود هر قسط
    final Decimal profitPerInstallment =
    (totalProfit / Decimal.fromInt(installmentCount))
        .toDecimal(scaleOnInfinitePrecision: 0);

    Decimal paidPrincipal = Decimal.zero;
    Decimal paidProfit = Decimal.zero;

    for (int i = 0; i < installmentCount; i++) {
      final bool isLast = i == installmentCount - 1;

      final Decimal principalForThisInstallment =
      isLast ? principalAmount - paidPrincipal : principalPerInstallment;

      final Decimal profitForThisInstallment =
      isLast ? totalProfit - paidProfit : profitPerInstallment;

      schedule.add(
        InstallmentResult(
          dateToPay: dueDates[i],
          principalAmount: principalForThisInstallment,
          profitAmount: profitForThisInstallment,
        ),
      );

      paidPrincipal += principalForThisInstallment;
      paidProfit += profitForThisInstallment;
    }

    return schedule;
  }

  /// سود کل قرارداد (قطعی – مرابحه)
  Decimal getTotalInterestAmount() {
    if (dueDates.isEmpty) return Decimal.zero;

    // تعداد کل روزهای قرارداد
    final int totalDays = dueDates.last.distanceTo(invoiceDate).abs();

    // مدت قرارداد به سال (365 روزه)
    final Decimal durationInYears = (totalDays.toDecimal().toRational() / 365.toDecimal().toRational()).toDecimal(
      scaleOnInfinitePrecision: 12,
    );

    return (principalAmount.toRational() *
        annualRate.toRational() *
        durationInYears.toRational() /
        100.toDecimal().toRational())
        .toDecimal()
        .round(scale: 0);
  }

  Decimal getFinalAmountWithInterest() {
    // تعداد کل روزهای قرارداد
    final int totalDays = dueDates.last.distanceTo(invoiceDate).abs();

    // مدت قرارداد به سال (365 روزه)
    final Decimal durationInYears = (totalDays.toDecimal().toRational() / 365.toDecimal().toRational()).toDecimal(
      scaleOnInfinitePrecision: 12,
    );

    // سود کل مرابحه (ثابت)
    final Decimal totalProfit =
    (principalAmount.toRational() * annualRate.toRational() * durationInYears.toRational() / 100.toDecimal().toRational())
        .toDecimal()
        .round(scale: 0);

    return principalAmount + totalProfit;
  }
}
