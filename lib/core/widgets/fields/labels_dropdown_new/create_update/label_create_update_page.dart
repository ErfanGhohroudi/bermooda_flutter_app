import 'package:u/utilities.dart';

import '../../../../../data/remote_datasource/label/interfaces/label_interface.dart';
import '../../../../utils/extensions/color_extension.dart';
import '../../../widgets.dart';
import '../../fields.dart';
import '../../../../core.dart';
import '../../../../utils/enums/enums.dart';
import '../../../../../data/data.dart';
import 'label_create_update_controller.dart';

class LabelCreateUpdatePage extends StatefulWidget {
  const LabelCreateUpdatePage({
    required this.sourceId,
    required this.onResponse,
    required this.datasource,
    this.label,
    super.key,
  });

  final LabelReadDto? label;
  final String sourceId;
  final Function(LabelReadDto label) onResponse;
  final ILabelDatasource datasource;

  @override
  State<LabelCreateUpdatePage> createState() => _LabelCreateUpdatePageState();
}

class _LabelCreateUpdatePageState extends State<LabelCreateUpdatePage> with LabelCreateUpdateController {
  @override
  void initState() {
    datasource = widget.datasource;
    sourceId = widget.sourceId;
    label = widget.label;
    titleController.text = label?.title ?? '';
    selectedColor = LabelColors.values.firstWhereOrNull((final e) => e.colorCode.toLowerCase() == label?.colorCode?.toLowerCase());
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label == null ? s.newLabel : s.editLabel).titleMedium(),
        const Divider().marginOnly(bottom: 10),
        Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 18,
            children: [
              WTextField(
                controller: titleController,
                labelText: s.title,
                required: true,
                showRequired: false,
                maxLength: 20,
              ),
              WDropDownFormField<LabelColors>(
                labelText: s.color,
                value: selectedColor,
                required: true,
                showRequiredIcon: false,
                items: LabelColors.values
                    .map(
                      (final LabelColors value) => DropdownMenuItem<LabelColors>(
                        value: value,
                        child: Row(
                          spacing: 10,
                          children: [
                            Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                color: value.colorCode.toColor(),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            WDropdownItemText(text: value.getTitle()),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (final value) {
                  selectedColor = value;
                },
              ),
              Row(
                spacing: 10,
                children: [
                  UElevatedButton(
                    title: s.cancel,
                    backgroundColor: context.theme.hintColor,
                    onTap: UNavigator.back,
                  ).expanded(),
                  UElevatedButton(
                    title: s.save,
                    onTap: () => callApi(
                      onResponse: (final label) {
                        widget.onResponse(label);
                        UNavigator.back();
                      },
                    ),
                  ).expanded(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
