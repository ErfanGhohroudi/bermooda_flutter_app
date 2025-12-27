import 'package:u/utilities.dart';

import '../../../../../data/remote_datasource/label/interfaces/label_interface.dart';
import '../../../../utils/enums/enums.dart';
import '../../../../../data/data.dart';

mixin LabelCreateUpdateController {
  LabelReadDto? label;
  late String sourceId;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final ILabelDatasource datasource;
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
    datasource.createLabel(
      sourceId: sourceId,
      title: titleController.text.trim(),
      colorCode: selectedColor?.colorCode,
      onResponse: (final response) {
        if (response.result == null) return;
        onResponse(response.result!);
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void update({required final Function(LabelReadDto label) onResponse}) {
    datasource.updateLabel(
      slug: label?.slug,
      sourceId: sourceId,
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
