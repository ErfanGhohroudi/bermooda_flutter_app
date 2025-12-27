import 'package:u/utilities.dart';

import '../../../../data/data.dart';
import '../../widgets.dart';
import 'create_update/customer_industry_subcategory_create_update_page.dart';

mixin CustomerCategoryDropdownController {
  late String categoryId;
  DropdownItemReadDto? industry;
  final CustomerIndustrySubCategoryDatasource _subcategoryDatasource = Get.find<CustomerIndustrySubCategoryDatasource>();
  Rx<UniqueKey> dropdownKey = UniqueKey().obs;
  final Rx<PageState> listState = PageState.loaded.obs;
  final RxList<DropdownItemReadDto> categories = <DropdownItemReadDto>[].obs;
  DropdownItemReadDto? selectedCategory;

  bool get industryIsNotEmpty => industry?.id != null;

  void getCategories() {
    categories.clear();
    listState.loading();
    _subcategoryDatasource.getCategories(
      crmCategoryId: categoryId,
      industryId: industry?.id,
      onResponse: (final response) {
        if (categories.subject.isClosed) return;
        if (industryIsNotEmpty) categories(response.resultList);
        listState.loaded();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void deleteCategory(final DropdownItemReadDto category, {required final VoidCallback action}) {
    _subcategoryDatasource.delete(
      id: category.id,
      onResponse: () {
        action();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void showCreateUpdateDialog({
    final DropdownItemReadDto? category,
  }) {
    if (industry?.id == null) return;
    showAppDialog(
      barrierDismissible: false,
      AlertDialog(
        content: CustomerIndustrySubCategoryCreateUpdatePage(
          model: category,
          crmCategoryId: categoryId,
          industryId: industry!.id!,
          onResponse: (final model) {
            if (category == null) {
              categories.add(model);
            } else {
              final i = categories.indexWhere((final e) => e.id == model.id);
              if (i != -1) {
                categories[i] = model;
                if (selectedCategory?.id == model.id) {
                  selectedCategory = model;
                  dropdownKey(UniqueKey());
                }
              }
            }
            listState.refresh();
          },
        ),
      ),
    );
  }
}
