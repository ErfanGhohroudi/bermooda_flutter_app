import 'package:u/utilities.dart';

import '../../../core.dart';
import 'amount_field.dart';

class WAmountCurrencyField extends StatelessWidget {
  const WAmountCurrencyField({
    required this.controller,
    required this.labelText,
    // required this.onChangedCurrency,
    // this.initialCurrency,
    this.required = false,
    this.showRequired,
    super.key,
  });

  final TextEditingController controller;
  final String labelText;
  // final CurrencyUnitReadDto? initialCurrency;
  final bool required;
  final bool? showRequired;
  // final Function(CurrencyUnitReadDto? currency) onChangedCurrency;

  @override
  Widget build(final BuildContext context) {
    return WAmountField(
      controller: controller,
      labelText: labelText,
      currencyText: s.toman,
      required: required,
      showRequired: showRequired,
    );
    // return Row(
    //   spacing: 10,
    //   children: [
    //     WAmountField(
    //       controller: controller,
    //       labelText: labelText,
    //       required: required,
    //       showRequired: showRequired,
    //     ).expanded(flex: 4),
    //     CurrencyDropdownField(
    //       value: initialCurrency,
    //       dropdownMenuWidth: context.width / 2,
    //       required: controller.text.isNotEmpty,
    //       onChanged: onChangedCurrency,
    //     ).expanded(flex: 3),
    //   ],
    // );
  }
}
