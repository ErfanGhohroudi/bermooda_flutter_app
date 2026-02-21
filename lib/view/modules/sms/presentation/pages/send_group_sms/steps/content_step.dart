import 'package:u/utilities.dart';

import '../../../../../../../core/core.dart';
import '../../../../../../../core/widgets/fields/fields.dart';
import '../../../../../../../core/widgets/widgets.dart';
import '../../../../domain/entity/sms_panel_number.dart';
import '../../../controllers/send_group_sms_controller.dart';

class ContentStep extends StatelessWidget {
  const ContentStep({
    required this.ctrl,
    super.key,
  });

  final SendGroupSmsController ctrl;

  @override
  Widget build(final BuildContext context) {
    return Form(
      key: ctrl.contentAndSettingsStepFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 18,
        children: [
          WTextField(
            controller: ctrl.titleCtrl,
            labelText: s.campaignTitle,
            required: true,
            hintText: "${s.example}: ${s.nowruzFestival}",
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          WDropDownFormField<SmsPanelNumber>(
            labelText: s.senderNumber,
            value: ctrl.selectedSender.value,
            items: ctrl.senderNumbers.map(
              (final SmsPanelNumber num) {
                final number = num.number;
                final providerName = num.title;
                return DropdownMenuItem<SmsPanelNumber>(
                  value: num,
                  child: WDropdownItemText(text: "$providerName ($number)"),
                );
              },
            ).toList(),
            onChanged: (final val) => ctrl.selectedSender.value = val,
            required: true,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text("${s.messageContent}*").titleMedium(color: context.theme.hintColor),
              WTextField(
                controller: ctrl.contentCtrl,
                hintText: s.enterYourMessage,
                required: true,
                multiLine: true,
                showCounter: true,
                minLines: 4,
                maxLines: 10,
                maxLength: 900,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ],
          ),
          Obx(
            () => WDatePickerField(
              initialValue: ctrl.scheduledDate.value,
              startDate: Jalali.now(),
              labelText: "${s.sendTime} ${s.optional}",
              mode: CustomDatePickerMode.dateAndTime,
              onConfirm: (final date) => ctrl.scheduledDate.value = date,
            ),
          ),
        ],
      ),
    );
  }
}
