import 'package:u/utilities.dart';

import '../../../../utils/enums/enums.dart';
import '../../../../../data/data.dart';

mixin CustomerLabelCreateUpdateController {
  LabelReadDto? label;
  late String crmCategoryId;
  final GlobalKey<FormState> formKey = GlobalKey();
  final CustomerLabelDatasource _datasource = Get.find<CustomerLabelDatasource>();
  final TextEditingController titleController = TextEditingController();
  LabelColors? selectedColor;

  void callApi({required final Function(LabelReadDto label) onResponse}) {
    validateForm(
      key: formKey,
      action: () {
        if (label == null) {
          create(onResponse: onResponse);
        } else {
          update(onResponse: onResponse);
        }
      },
    );
  }

  void create({required final Function(LabelReadDto label) onResponse}) {
    _datasource.create(
      crmCategoryId: crmCategoryId,
      title: titleController.text.trim(),
      colorCode: selectedColor?.colorCode,
      onResponse: (final response) {
        onResponse(response.result!);
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void update({required final Function(LabelReadDto label) onResponse}) {
    _datasource.update(
      id: label?.id,
      title: titleController.text.trim(),
      colorCode: selectedColor?.colorCode,
      onResponse: (final response) {
        onResponse(response.result!);
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }
}
