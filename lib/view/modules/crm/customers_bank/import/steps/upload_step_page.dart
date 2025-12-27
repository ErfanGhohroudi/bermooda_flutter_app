part of '../customers_import_page.dart';

class UploadStepPage extends StatelessWidget {
  const UploadStepPage({
    required this.ctrl,
    super.key,
  });

  final CustomerExelController ctrl;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTopDownloadButton(),
        const SizedBox(height: 16),
        WCard(
          showBorder: true,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
            alignment: Alignment.center,
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
                        Text(ctrl.prettySize(ctrl.selectedFile.value!.size), textDirection: TextDirection.ltr).bodySmall(color: context.theme.hintColor),
                        UElevatedButton(title: s.selectAgain, onTap: ctrl.pickFile),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopDownloadButton() {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: UElevatedButton(
        onTap: () {
          ULaunch.launchURL(AppConstants.exampleCustomerImportExelUrl);
        },
        title: "دانلود فایل نمونه CSV",
        icon: const Icon(Icons.download_rounded, color: Colors.white),
      ),
    );
  }
}
