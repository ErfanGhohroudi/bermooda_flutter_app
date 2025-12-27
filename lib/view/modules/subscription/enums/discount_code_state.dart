import 'package:u/utilities.dart';

import '../../../../core/core.dart';
import '../../../../core/theme.dart';

enum DiscountCodeState {
  empty,
  notEmpty,
  applying,
  applied,
  invalid;

  //------------------------------------------------------------
  // Helper
  //------------------------------------------------------------
  String? get helperText => switch (this) {
    DiscountCodeState.empty => null,
    DiscountCodeState.notEmpty => null,
    DiscountCodeState.applying => null,
    DiscountCodeState.applied => s.promoCodeApplied,
    DiscountCodeState.invalid => s.invalidPromoCode,
  };

  TextStyle? helperStyle(final BuildContext context) => switch (this) {
    DiscountCodeState.empty => null,
    DiscountCodeState.notEmpty => null,
    DiscountCodeState.applying => null,
    DiscountCodeState.applied => context.textTheme.bodySmall?.copyWith(color: AppColors.green),
    DiscountCodeState.invalid => context.textTheme.bodySmall?.copyWith(color: AppColors.red),
  };

  //------------------------------------------------------------
  // Button
  //------------------------------------------------------------
  String get buttonText => switch (this) {
    DiscountCodeState.empty => s.apply,
    DiscountCodeState.notEmpty => s.apply,
    DiscountCodeState.applying => s.apply,
    DiscountCodeState.applied => s.clear,
    DiscountCodeState.invalid => s.clear,
  };

  Color get buttonColor => switch (this) {
    DiscountCodeState.empty => AppColors.green,
    DiscountCodeState.notEmpty => AppColors.green,
    DiscountCodeState.applying => AppColors.green.withValues(alpha: 0.5),
    DiscountCodeState.applied => AppColors.red,
    DiscountCodeState.invalid => AppColors.red,
  };
}

extension DiscountCodeStateExtensions on Rx<DiscountCodeState> {
  bool get isEmpty => value == DiscountCodeState.empty;

  bool get isNotEmpty => value == DiscountCodeState.notEmpty;

  bool get isApplying => value == DiscountCodeState.applying;

  bool get isApplied => value == DiscountCodeState.applied;

  bool get isInvalid => value == DiscountCodeState.invalid;

  DiscountCodeState empty() => this(DiscountCodeState.empty);

  DiscountCodeState notEmpty() => this(DiscountCodeState.notEmpty);

  DiscountCodeState applying() => this(DiscountCodeState.applying);

  DiscountCodeState applied() => this(DiscountCodeState.applied);

  DiscountCodeState invalid() => this(DiscountCodeState.invalid);
}
