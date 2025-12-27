import 'package:u/utilities.dart';

import '../../../widgets.dart';
import '../../../../core.dart';
import '../../../../../data/data.dart';
import 'currency_dropdown_field_controller.dart';

class CurrencyDropdownField extends StatefulWidget {
  const CurrencyDropdownField({
    required this.onChanged,
    this.value,
    this.required = true,
    this.showRequiredIcon,
    this.dropdownMenuWidth,
    super.key,
  });

  final CurrencyUnitReadDto? value;
  final bool required;
  final bool? showRequiredIcon;
  final double? dropdownMenuWidth;
  final Function(CurrencyUnitReadDto? value) onChanged;

  @override
  State<CurrencyDropdownField> createState() => _CurrencyDropdownFieldState();
}

class _CurrencyDropdownFieldState extends State<CurrencyDropdownField> with CurrencyDropdownFieldController {
  @override
  void initState() {
    getCurrencies(
      action: () => widget.onChanged(selected),
    );
    super.initState();
  }

  @override
  void dispose() {
    listState.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => WDropDownFormField<CurrencyUnitReadDto>(
        value: selected,
        required: widget.required,
        showRequiredIcon: widget.showRequiredIcon,
        labelText: listState.isLoaded() ? s.currency : s.loading,
        showSearchField: true,
        dropdownMenuWidth: widget.dropdownMenuWidth,
        searchMatchFn: (final item, final searchValue) {
          final value = "${item.value?.currencyName ?? ''} ${item.value?.country ?? ''}";

          return value.toLowerCase().contains(searchValue.toLowerCase());
        },
        items: currencies
            .map(
              (final e) => DropdownMenuItem<CurrencyUnitReadDto>(
                value: e,
                child: WDropdownItemText(text: "${e.currencyName ?? ''} (${e.country ?? ''})"),
              ),
            )
            .toList(),
        onChanged: (final value) {
          selected = value;
          widget.onChanged(selected);
        },
      ),
    );
  }
}
