import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../data/data.dart';

Future<ExelUploadResultReadDto?> uploadExel({
  required final PlatformFile file,
  required final String categoryId,
}) async {
  final UploadCustomerExelDatasource uploadCustomerExelDatasource = Get.find<UploadCustomerExelDatasource>();
  Rx<double> progress = 0.0.obs;
  RxBool isError = false.obs;

  void upload(final BuildContext context) => uploadCustomerExelDatasource.uploadFile(
    file: file,
    categoryId: categoryId,
    onProgress: (final _progress) => progress(_progress * 100),
    onFileUploaded: (final ExelUploadResultReadDto result) => delay(1000, () {
      Navigator.pop(context, result);
    }),
    onError: (final file, final response) => isError(true),
    onCancel: () => Navigator.pop(context),
  );

  final ExelUploadResultReadDto? result = await showDialog<ExelUploadResultReadDto>(
    context: navigatorKey.currentContext!,
    barrierDismissible: false, // جلوگیری از بسته شدن دیالوگ هنگام لمس بیرون
    builder: (final context) {
      return StatefulBuilder(
        builder: (final BuildContext context, final setState) {
          upload(context);

          return AlertDialog(
            title: Obx(
              () => Text(isError.value ? s.error : s.uploading).bodyMedium(),
            ),
            backgroundColor: navigatorKey.currentContext!.theme.cardColor,
            content: Obx(
              () {
                if (isError.value) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(s.tryAgain).bodyMedium(),
                      const SizedBox(height: 10),
                      Row(
                        spacing: 10,
                        children: [
                          UElevatedButton(
                            title: s.cancel,
                            backgroundColor: context.theme.hintColor,
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ).expanded(),
                          UElevatedButton(
                            title: s.tryAgain,
                            backgroundColor: AppColors.red,
                            onTap: () {
                              isError(false);
                              upload(context);
                            },
                          ).expanded(),
                        ],
                      ),
                    ],
                  );
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LinearProgressIndicator(
                      value: progress.value / 100,
                      color: navigatorKey.currentContext!.theme.primaryColor,
                      backgroundColor: navigatorKey.currentContext!.theme.scaffoldBackgroundColor,
                    ),
                    const SizedBox(height: 10),
                    Text("${progress.value.toStringAsFixed(1)}%").bodyMedium(),
                    const SizedBox(height: 10),
                    UElevatedButton(
                      title: s.cancel,
                      backgroundColor: context.theme.hintColor,
                      onTap: () => uploadCustomerExelDatasource.cancelUpload(),
                    ),
                  ],
                );
              },
            ),
          );
        },
      );
    },
  );

  return result;
}
