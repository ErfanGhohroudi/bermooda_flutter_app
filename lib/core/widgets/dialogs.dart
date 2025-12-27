part of "widgets.dart";

Future<T?> showAppDialog<T>(
  final Widget page, {
  final bool barrierDismissible = true,
  final bool useSafeArea = false,
  final VoidCallback? onDismiss,
  final Color? barrierColor,
}) async =>
    await Get.dialog<T>(
      page,
      useSafeArea: useSafeArea,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor ?? navigatorKey.currentContext!.theme.dialogTheme.barrierColor,
    ).then(
      (final value) {
        onDismiss != null ? onDismiss() : null;
        return value;
      },
    );

Future<void> appShowYesCancelDialog({
  required final String description,
  required final VoidCallback onYesButtonTap,
  final String title = '',
  final TextStyle? descriptionTextStyle,
  final String? cancelButtonTitle,
  final VoidCallback? onCancelButtonTap,
  final String? yesButtonTitle,
  final Color? cancelBackgroundColor,
  final Color? yesBackgroundColor,
  final bool barrierDismissible = true,
  final TextAlign? descriptionTextAlign,
}) async =>
    await showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: barrierDismissible,
      builder: (final BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: title != '' ? Text(title).titleMedium() : null,
        content: Text(description, style: descriptionTextStyle ?? context.textTheme.bodyMedium!, textAlign: descriptionTextAlign),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          SizedBox(
            child: UElevatedButton(
              width: navigatorKey.currentContext!.width / 4,
              backgroundColor: cancelBackgroundColor ?? context.theme.hintColor,
              onTap: onCancelButtonTap ?? UNavigator.back,
              title: cancelButtonTitle ?? s.cancel,
              textStyle: context.textTheme.bodyMedium!.copyWith(color: Colors.white),
            ),
          ),
          SizedBox(
            child: UElevatedButton(
              width: navigatorKey.currentContext!.width / 4,
              backgroundColor: yesBackgroundColor,
              onTap: onYesButtonTap,
              title: yesButtonTitle ?? s.yes,
              textStyle: context.textTheme.bodyMedium!.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );

void showWorkspaceIsNotAuthenticatedDialog({final VoidCallback? onPop}) {
  final core = Get.find<Core>();

  if (!core.currentWorkspace.value.authStatus.isAuth() && core.currentWorkspace.value.type.isOwner()) {
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      showAppDialog(
        barrierDismissible: true,
        AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const UImage(AppLottie.error, size: 100),
              Text(
                s.authenticationNeedsDialogText.replaceAll('#', core.userReadDto.value.fullName ?? ''),
                textAlign: TextAlign.center,
              ).titleMedium().marginOnly(bottom: 30),
              UElevatedButton(
                width: navigatorKey.currentContext!.width,
                title: s.settings,
                onTap: () {
                  UNavigator.back();
                  delay(
                    50,
                    () {
                      UNavigator.push(WorkspaceListPage(
                        push: true,
                        onPop: () {
                          if (core.currentWorkspace.value.authStatus.isAuth()) {
                            UNavigator.back();
                          }
                          onPop?.call();
                        },
                      ));
                    },
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}

void showUploadSignatureDialog({
  required final MainFileReadDto? file,
  required final VoidCallback onSaved,
  required final Function(MainFileReadDto? file) onFileUpdated,
}) {
  bool isUploadingFile = false;
  MainFileReadDto? signature = file;
  UniqueKey imageKey = UniqueKey();

  showAppDialog(
    barrierDismissible: false,
    useSafeArea: true,
    barrierColor: navigatorKey.currentContext!.theme.dialogTheme.barrierColor,
    AlertDialog(
      content: StatefulBuilder(
        builder: (final context, final setState) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              UImage(AppIcons.closeCircle, size: 30, color: context.theme.primaryColorDark).onTap(UNavigator.back),
              const Divider().marginOnly(bottom: 12),
              Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                children: [
                  UElevatedButton(
                    title: s.uploadSignature,
                    width: context.width,
                    backgroundColor: context.isDarkMode ? Colors.white : Colors.black87,
                    titleColor: !context.isDarkMode ? Colors.white : Colors.black87,
                    icon: Icon(Icons.add_circle_outline_rounded, color: !context.isDarkMode ? Colors.white : Colors.black87, size: 25),
                    onTap: () async {
                      final result = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
                      if (result != null) {
                        setState(() {
                          signature = MainFileReadDto(url: result.path, fileName: result.name, originalName: result.name);
                          imageKey = UniqueKey();
                        });
                      }
                    },
                  ),
                  Text(s.or).titleMedium(color: context.theme.hintColor),
                  UElevatedButton(
                    width: context.width,
                    title: s.drawSignature,
                    backgroundColor: AppColors.orange,
                    icon: const Icon(Icons.draw_outlined, color: Colors.white, size: 25),
                    onTap: () {
                      showAppDialog(
                        barrierDismissible: false,
                        AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SignaturePad(
                                pixelRatio: 3.0,
                                saveButtonText: s.save,
                                clearButtonText: s.clear,
                                onSave: (final fileData, final isEmpty) {
                                  if (isEmpty) {
                                    AppNavigator.snackbarRed(title: s.warning, subtitle: s.uploadSignatureFirst);
                                    return;
                                  }
                                  setState(() {
                                    signature = MainFileReadDto(
                                      url: fileData.path,
                                      originalName: 'Signature.png',
                                    );
                                    imageKey = UniqueKey();
                                  });
                                  UNavigator.back();
                                },
                              ),
                              UElevatedButton(
                                title: s.cancel,
                                width: context.width,
                                backgroundColor: context.theme.hintColor,
                                onTap: UNavigator.back,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ).marginOnly(bottom: signature != null ? 12 : 0),
              if (signature != null)
                WProfileUploadAndShowImage(
                  key: imageKey,
                  file: signature,
                  itemWidth: 300,
                  itemHeight: 200,
                  borderRadius: 15,
                  closeIconSize: 35,
                  onUploaded: (final file) {
                    signature = file;
                    onFileUpdated(signature);
                  },
                  onRemove: (final file) {
                    setState(() {
                      signature = null;
                    });
                    onFileUpdated(signature);
                  },
                  uploadStatus: (final value) {
                    isUploadingFile = value;
                  },
                ).marginOnly(bottom: 12),
              if (signature != null)
                UElevatedButton(
                  title: s.save,
                  width: context.width,
                  onTap: () {
                    WImageFiles.checkFileUploading(
                      isUploadingFile: isUploadingFile,
                      action: () {
                        appShowYesCancelDialog(
                          description: s.wantToSubmitSignature,
                          onYesButtonTap: () {
                            UNavigator.back();
                            onSaved();
                          },
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
