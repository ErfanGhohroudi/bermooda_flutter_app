import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/widgets/fields/fields.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../domain/entity/sms_panel_number.dart';
import '../controllers/send_sms_controller.dart';

class SendSmsSheet extends StatefulWidget {
  const SendSmsSheet({super.key, required this.recipientPhoneNumber});

  final String recipientPhoneNumber;

  @override
  State<SendSmsSheet> createState() => _SendSmsSheetState();
}

class _SendSmsSheetState extends State<SendSmsSheet> {
  late final SendSmsController ctrl;

  @override
  void initState() {
    ctrl = Get.put(SendSmsController());
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
              WTextField(
                controller: ctrl.contentController,
                hintText: s.messageText,
                multiLine: true,
                required: true,
                showRequired: false,
                minLines: 4,
                maxLines: 10,
                maxLength: 2000,
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
