import 'package:u/utilities.dart';

import '../../../../utils/enums/enums.dart';
import '../../../../../data/data.dart';

mixin LabelCreateUpdateController {
  LabelReadDto? label;
  late String sourceId;
  final GlobalKey<FormState> formKey = GlobalKey();
  final LabelDatasource _labelDatasource = Get.find<LabelDatasource>();
  final TextEditingController titleController = TextEditingController();
  LabelColors? selectedColor;

  void initialController({
    required final LabelReadDto? label,
    required final String sourceId,
  }) {
    this.sourceId = sourceId;
    this.label = label;
    titleController.text = label?.title ?? '';
    selectedColor = LabelColors.values.firstWhereOrNull(
      (final e) => e.colorCode.toLowerCase() == label?.colorCode?.toLowerCase(),
    );
  }

  void callApi(
    final LabelDataSourceType dataSourceType, {
    required final Function(LabelReadDto label) onResponse,
  }) {
    validateForm(
      key: formKey,
      action: () {
        if (label == null) {
          create(dataSourceType, onResponse: onResponse);
        } else {
          update(dataSourceType, onResponse: onResponse);
        }
      },
    );
  }

  void create(
    final LabelDataSourceType dataSourceType, {
    required final Function(LabelReadDto label) onResponse,
  }) {
    _labelDatasource.createLabel(
      dataSourceType: dataSourceType,
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

  void update(
    final LabelDataSourceType dataSourceType, {
    required final Function(LabelReadDto label) onResponse,
  }) {
    _labelDatasource.updateLabel(
      dataSourceType: dataSourceType,
      id: label?.id,
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
