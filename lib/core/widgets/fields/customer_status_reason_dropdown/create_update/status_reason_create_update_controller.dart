import 'package:u/utilities.dart';

import '../../../../utils/enums/enums.dart';
import '../../../../../data/data.dart';

mixin StatusReasonCreateUpdateController {
  StatusReasonReadDto? statusReason;
  late String categoryId;
  late CustomerStatus type;
  final GlobalKey<FormState> formKey = GlobalKey();
  final CustomerStatusReasonDatasource _statusReasonDatasource = Get.find<CustomerStatusReasonDatasource>();
  final TextEditingController titleController = TextEditingController();
  LabelColors selectedColor = LabelColors.values.first;

  void callApi({required final Function(StatusReasonReadDto reason) onResponse}) {
    validateForm(
      key: formKey,
      action: () {
        if (statusReason == null) {
          create(onResponse: onResponse);
        } else {
          update(onResponse: onResponse);
        }
      },
    );
  }

  void create({required final Function(StatusReasonReadDto reason) onResponse}) {
    _statusReasonDatasource.create(
      type: type,
      crmCategoryId: categoryId,
      title: titleController.text.trim(),
      color: selectedColor,
      onResponse: (final response) {
        onResponse(response.result!);
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void update({required final Function(StatusReasonReadDto reason) onResponse}) {
    _statusReasonDatasource.update(
      slug: statusReason?.slug,
      title: titleController.text.trim(),
      color: selectedColor,
      onResponse: (final response) {
        onResponse(response.result!);
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }
}
