import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/widgets/fields/fields.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../domain/entity/sms_panel_number.dart';
import '../controllers/send_sms_controller.dart';

class SendSmsSheet extends StatefulWidget {
  const SendSmsSheet({
    this.recipientPhoneNumber,
    this.departmentId,
    this.showScheduledAt = true,
    super.key,
  });

  final String? recipientPhoneNumber;

  /// just SMS department's id
  final int? departmentId;
  final bool showScheduledAt;

  @override
  State<SendSmsSheet> createState() => _SendSmsSheetState();
}

class _SendSmsSheetState extends State<SendSmsSheet> {
  late final SendSmsController ctrl;

  @override
  void initState() {
    ctrl = Get.put(SendSmsController(departmentId: widget.departmentId));
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<SendSmsController>();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Form(
      key: ctrl.formKey,
      child: Obx(
        () {
          if (ctrl.pageState.isLoading()) {
            return const SizedBox(
              height: 300,
              child: Center(child: WCircularLoading()),
            );
          }

          if (ctrl.pageState.isError()) {
            return SizedBox(
              height: 300,
              child: Center(child: WErrorWidget(onTapButton: ctrl.getNumbers)),
            );
          }

          if (ctrl.pageState.isEmpty()) {
            return SizedBox(
              height: 300,
              child: WEmptyWidget(
                title: s.doNotHaveAccessToAnyNumbers,
                showUploadButton: true,
                buttonTitle: s.back,
                buttonBackgroundColor: context.theme.hintColor,
                onTapButton: AppNavigator.back,
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 18,
            children: [
              if (widget.recipientPhoneNumber != null)
                RichText(
                  text: TextSpan(
                    style: context.textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: "${s.recipient}: ",
                        style: context.textTheme.bodyMedium?.copyWith(color: context.theme.hintColor),
                      ),
                      TextSpan(text: widget.recipientPhoneNumber),
                    ],
                  ),
                )
              else
                WPhoneNumberField(
                  controller: ctrl.recipientPhoneNumberCtrl,
                  labelText: s.recipient,
                  hintText: "09123456789",
                  required: true,
                  startWith: '09',
                  minLength: 11,
                  maxLength: 11,
                ),
              WDropDownFormField<SmsPanelNumber>(
                labelText: s.senderNumber,
                value: ctrl.selectedNumber,
                required: true,
                showRequiredIcon: false,
                items: ctrl.numbers.map(
                  (final SmsPanelNumber num) {
                    final number = num.number;
                    final providerName = num.title;
                    return DropdownMenuItem<SmsPanelNumber>(
                      value: num,
                      child: WDropdownItemText(text: "$providerName ($number)"),
                    );
                  },
                ).toList(),
                onChanged: (final value) => ctrl.selectedNumber = value,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(s.messageContent).titleMedium(color: context.theme.hintColor),
                  WTextField(
                    controller: ctrl.contentCtrl,
                    hintText: s.enterYourMessage,
                    required: true,
                    showRequired: false,
                    multiLine: true,
                    showCounter: true,
                    minLines: 4,
                    maxLines: 10,
                    maxLength: 900,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ],
              ),
              if (widget.showScheduledAt)
                WDatePickerField(
                  labelText: "${s.sendTime} ${s.optional}",
                  startDate: Jalali.now(),
                  initialValue: ctrl.scheduledAt,
                  mode: CustomDatePickerMode.dateAndTime,
                  onConfirm: (final date) => ctrl.scheduledAt = date,
                ),

              Obx(
                () => UElevatedButton(
                  width: double.infinity,
                  title: s.send,
                  isLoading: ctrl.isLoading.value,
                  onTap: () => ctrl.sendSMS(recipientPhoneNumber: widget.recipientPhoneNumber),
                ),
              ).marginOnly(top: 100),
            ],
          );
        },
      ),
    );
  }
}
