import 'package:u/utilities.dart';

import '../../../../../data/data.dart';

mixin CurrencyDropdownFieldController {
  final CrmDatasource _datasource = Get.find<CrmDatasource>();
  final Rx<PageState> listState = PageState.initial.obs;
  List<CurrencyUnitReadDto> currencies = [];
  CurrencyUnitReadDto? selected;

  void getCurrencies({required final VoidCallback action}) {
    listState.loading();
    _datasource.getAllCurrencies(
      onResponse: (final response) {
        if (response.resultList != null) {
          currencies.assignAll(response.resultList!);
        }

        if (selected != null) {
          selected = currencies.firstWhereOrNull((final e) => e.slug == selected?.slug);
        } else {
          selected = currencies.firstWhereOrNull((final e) => e.country == 'ایران');
        }
        action();

        listState.loaded();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }
}
