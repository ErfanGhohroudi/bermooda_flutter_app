import 'package:u/utilities.dart';

import '../../../../utils/extensions/color_extension.dart';
import '../../../widgets.dart';
import '../../fields.dart';
import '../../../../core.dart';
import '../../../../utils/enums/enums.dart';
import '../../../../../data/data.dart';
import 'status_reason_create_update_controller.dart';

class StatusReasonCreateUpdatePage extends StatefulWidget {
  const StatusReasonCreateUpdatePage({
    required this.categoryId,
    required this.type,
    required this.onResponse,
    this.statusReason,
    super.key,
  });

  final StatusReasonReadDto? statusReason;
  final String categoryId;
  final CustomerStatus type;
  final Function(StatusReasonReadDto label) onResponse;

  @override
  State<StatusReasonCreateUpdatePage> createState() => _StatusReasonCreateUpdatePageState();
}

class _StatusReasonCreateUpdatePageState extends State<StatusReasonCreateUpdatePage> with StatusReasonCreateUpdateController {
  @override
  void initState() {
    categoryId = widget.categoryId;
    type = widget.type;
    statusReason = widget.statusReason;
    titleController.text = statusReason?.title ?? '';
    selectedColor = LabelColors.values.firstWhereOrNull((final e) => e.colorCode.toLowerCase() == statusReason?.colorCode?.toLowerCase()) ?? selectedColor;
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
        Text(statusReason == null ? s.newReason : s.editReason).titleMedium(),
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
                  selectedColor = value!;
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
