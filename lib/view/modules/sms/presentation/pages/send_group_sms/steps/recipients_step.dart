import 'package:u/utilities.dart';

import '../../../../../../../core/core.dart';
import '../../../../../../../core/theme.dart';
import '../../../../../../../core/utils/extensions/url_extensions.dart';
import '../../../../../../../core/widgets/fields/fields.dart';
import '../../../../../../../core/widgets/widgets.dart';
import '../../../controllers/send_group_sms_controller.dart';

class RecipientsStep extends StatelessWidget {
  const RecipientsStep({
    required this.ctrl,
    super.key,
  });

  final SendGroupSmsController ctrl;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        Obx(
          () => WDropDownFormField<GroupSmsEntryMethod>(
            labelText: s.numbersEntryMethod,
            value: ctrl.entryMethod.value,
            items: [
              DropdownMenuItem(
                value: GroupSmsEntryMethod.manual,
                child: Text(s.manualEntry),
              ),
              DropdownMenuItem(
                value: GroupSmsEntryMethod.file,
                child: Text(s.uploadFileExcelCsv),
              ),
            ],
            onChanged: (final val) {
              if (val != null) ctrl.entryMethod.value = val;
            },
          ),
        ),
        Obx(() {
          if (ctrl.entryMethod.value == GroupSmsEntryMethod.manual) {
            return _buildManualEntry(context);
          } else {
            return _buildFileEntry(context);
          }
        }),
      ],
    );
  }

  Widget _buildManualEntry(final BuildContext context) {
    return WCard(
      elevation: 0,
      margin: EdgeInsets.zero,
      showBorder: true,
      color: context.theme.scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(s.recipientsNumbers).titleMedium(color: context.theme.hintColor),
          const SizedBox(height: 10),
          Form(
            key: ctrl.manualNumberFieldFormKey,
            child: WPhoneNumberField(
              controller: ctrl.manualNumbersCtrl,
              startWith: '09',
              hintText: '09123456789',
              minLength: 11,
              maxLength: 11,
              helperText: s.tapEnterToAdd,
              helperStyle: context.textTheme.bodySmall!.copyWith(color: context.theme.primaryColor),
              suffixIcon: IconButton(
                onPressed: ctrl.onEnteredPhoneNumber,
                icon: const UImage(AppIcons.addSquareOutline, size: 25, color: AppColors.green),
              ),
              onEditingComplete: ctrl.onEnteredPhoneNumber,
            ),
          ),

          const SizedBox(height: 10),

          /// Selected Phone Numbers
          if (ctrl.manualNumbers.isNotEmpty)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List<Widget>.generate(
                ctrl.manualNumbers.length,
                (final index) => Chip(
                  label: Text(ctrl.manualNumbers[index]),
                  deleteIcon: const Icon(Icons.close_rounded),
                  onDeleted: () => ctrl.removePhoneNumber(ctrl.manualNumbers[index]),
                ),
              ),
            )
          else
            const WEmptyWidget().alignAtCenter(),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildFileEntry(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        WCard(
          showBorder: true,
          elevation: 0,
          margin: EdgeInsets.zero,
          padding: 36,
          color: context.theme.scaffoldBackgroundColor,
          child: Obx(
            () => ctrl.selectedFile.value == null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      UImage(AppIcons.addSquareOutline, size: 64, color: context.theme.hintColor),
                      const SizedBox(height: 12),
                      UElevatedButton(title: s.select, onTap: ctrl.pickFile),
                      const SizedBox(height: 8),
                      Text(s.allowedExelFormatsAndSize).bodySmall(color: context.theme.hintColor),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10,
                    children: [
                      const UImage(AppImages.exel, size: 100),
                      Text(s.fileSelectedSuccessfully).bodyMedium(),
                      Text(ctrl.selectedFile.value!.name, textDirection: TextDirection.ltr, maxLines: 1).bodySmall(),
                      Text(
                        ctrl.prettySize(ctrl.selectedFile.value!.size),
                        textDirection: TextDirection.ltr,
                      ).bodySmall(color: context.theme.hintColor),
                      UElevatedButton(title: s.selectAgain, onTap: ctrl.pickFile),
                    ],
                  ),
          ).alignAtCenter(),
        ),
        WCard(
          elevation: 0,
          margin: EdgeInsets.zero,
          showBorder: true,
          color: AppColors.blue.withValues(alpha: 0.1),
          borderColor: AppColors.blue.withValues(alpha: 0.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 8,
                children: [
                  const UImage(AppIcons.info, color: AppColors.blue, size: 25),
                  Text(s.guide).titleMedium().bold(),
                ],
              ),
              const SizedBox(height: 10),
              Text("* ${s.excelCsvFileGuideDescription}").bodySmall(color: AppColors.blue),
              const SizedBox(height: 5),
              Text("* ${s.numbersShouldStartWith09}").bodySmall(color: AppColors.blue),
              Row(
                children: [
                  const Icon(Icons.file_download_outlined, size: 25, weight: 1.5),
                  WTextButton(
                    text: s.downloadSampleFile,
                    onPressed: () {
                      ctrl.numbersSampleFileUrl.launchMyUrl();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
