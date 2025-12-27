import 'package:u/utilities.dart';

import '../../../../../data/data.dart';

mixin CustomerIndustrySubCategoryCreateUpdateController {
  late final String crmCategoryId;
  late final int industryId;
  final GlobalKey<FormState> formKey = GlobalKey();
  final CustomerIndustrySubCategoryDatasource _categoryDatasource = Get.find<CustomerIndustrySubCategoryDatasource>();
  final TextEditingController titleController = TextEditingController();
  DropdownItemReadDto? model;
  final Rx<PageState> buttonState = PageState.initial.obs;

  void onSubmit(final Function(DropdownItemReadDto model) action) {
    validateForm(
      key: formKey,
      action: () {
        buttonState.loading();
        if (model == null) {
          create(action);
        } else {
          update(action);
        }
      },
    );
  }

  void create(final Function(DropdownItemReadDto model) action) {
    _categoryDatasource.create(
      crmCategoryId: crmCategoryId,
      industryId: industryId,
      title: titleController.text,
      onResponse: (final response) {
        if (response.result != null) {
          return action(response.result!);
        }
      },
      onError: (final errorResponse) {
        buttonState.loaded();
      },
      withRetry: true,
    );
  }

  void update(final Function(DropdownItemReadDto model) action) {
    _categoryDatasource.update(
      id: model?.id,
      title: titleController.text,
      onResponse: (final response) {
        if (response.result != null) {
          return action(response.result!);
        }
      },
      onError: (final errorResponse) {
        buttonState.loaded();
      },
      withRetry: true,
    );
  }
}
