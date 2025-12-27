import 'dart:ui';

import 'package:bermooda_business/core/utils/extensions/url_extensions.dart';
import 'package:open_filex/open_filex.dart';
import 'package:u/utilities.dart';

import '../../data/data.dart';
import '../core.dart';
import '../helpers/open_file_helpers.dart';
import '../navigator/navigator.dart';
import '../theme.dart';

class WUploadAndShowImage extends StatefulWidget {
  const WUploadAndShowImage({
    required this.file,
    required this.onUploaded,
    required this.onRemove,
    required this.uploadStatus,
    this.itemSize = 70,
    this.removable = true,
    super.key,
  });

  final MainFileReadDto file;
  final Function(MainFileReadDto file) onUploaded;
  final Function(MainFileReadDto file) onRemove;
  final Function(bool value) uploadStatus;
  final double itemSize;
  final bool removable;

  @override
  State<WUploadAndShowImage> createState() => _UploadAndShowImageState();
}

class _UploadAndShowImageState extends State<WUploadAndShowImage> {
  final UploadFileDatasource _uploadFileDatasource = Get.find<UploadFileDatasource>();
  late MainFileReadDto file;
  late double itemSize = 70;

  double _progress = 0;
  bool _uploading = false;
  bool _uploadFailed = false;

  @override
  void initState() {
    itemSize = widget.itemSize;
    file = widget.file;
    debugPrint("this File added => ${file.originalName}");
    if (!file.url!.startsWith('http')) {
      _startUpload();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (_uploading && mounted) {
      _uploadFileDatasource.cancelUpload();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant final WUploadAndShowImage oldWidget) {
    if (oldWidget.itemSize != widget.itemSize) {
      setState(() {
        itemSize = widget.itemSize;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  void _startUpload() {
    if (!mounted) return;
    setState(() {
      _uploading = true;
      _uploadFailed = false;
      widget.uploadStatus(_uploading);
    });

    _uploadFileDatasource.uploadFile(
      file: file,
      onProgress: (final progress) {
        if (!mounted) return;
        setState(() => _progress = progress);
        widget.uploadStatus(_uploading);
      },
      onFileUploaded: (final fileModel) {
        if (!mounted) return;
        setState(() {
          debugPrint("file uploaded => ${fileModel.originalName}");
          file = fileModel;
          _uploading = false;
          _uploadFailed = false;
        });
        widget.onUploaded(file);
        widget.uploadStatus(_uploading);
      },
      onError: (final fileModel, final response) {
        if (!mounted) return;
        setState(() {
          _uploading = false;
          _uploadFailed = true;
        });
        widget.uploadStatus(_uploading);
        AppNavigator.snackbarRed(title: s.error, subtitle: "${s.failed}: ${fileModel.originalName}");
      },
      onCancel: () {
        if (!mounted) return;
        setState(() {
          _uploading = false;
          _uploadFailed = true;
          _progress = 0;
        });
        widget.uploadStatus(_uploading);
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Stack(
      alignment: isPersianLang ? Alignment.topRight : Alignment.topLeft,
      children: [
        SizedBox(
          width: itemSize,
          height: itemSize,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: itemSize,
                  height: itemSize,
                  color: context.theme.dividerColor,
                ),
                UImage(
                  file.iconOrImage ?? '',
                  fileData: !file.url!.isWebUrl && file.url!.isImageFileName ? FileData(path: file.url!) : null,
                  fit: BoxFit.cover,
                  size: itemSize,
                ),

                if (_uploading || _uploadFailed)
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      width: itemSize,
                      height: itemSize,
                      color: Colors.black26,
                    ),
                  ),

                Positioned(
                  bottom: 0,
                  child: Container(
                    width: itemSize,
                    color: context.theme.hintColor,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Center(
                      widthFactor: 1,
                      heightFactor: 1,
                      child: Text(
                        file.originalName ?? '',
                        maxLines: 1,
                        textDirection: TextDirection.ltr,
                      ).bodySmall(color: Colors.white, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ),

                // حالت آپلود در حال انجام
                if (_uploading)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          value: _progress == 0 ? null : _progress,
                          color: Colors.white,
                          strokeWidth: 4,
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(120),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 25),
                      ).onTap(() {
                        _uploadFileDatasource.cancelUpload();
                      }),
                    ],
                  ),

                // حالت آپلود با خطا یا کنسل شده
                if (_uploadFailed)
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(120),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.refresh, color: Colors.white, size: 25),
                  ).onTap(() => _startUpload()),
              ],
            ),
          ),
        ).onTap(
          () async {
            if (file.url.isWebUrl) {
              if (UApp.isMobile) {
                final filePath = await OpenFileHelpers.showDownloadDialog(file.url!, file.fileName ?? '');
                if (filePath != null) {
                  await OpenFilex.open(filePath); // باز کردن فایل بعد از دانلود
                }
              } else {
                file.url.launchMyUrl();
              }
            } else if (file.url!.isImageFileName ||
                file.url!.isVideoFileName ||
                file.url!.isAudioFileName ||
                file.url!.isPDFFileName ||
                file.url!.isPPTFileName ||
                file.url!.isDocumentFileName ||
                file.url!.isExcelFileName ||
                file.url!.isTxtFileName) {
              await OpenFilex.open(file.url!);
            }
          },
        ),
        if (!_uploading && widget.removable)
          const UImage(AppIcons.closeCircle, size: 30).onTap(
            () {
              widget.onRemove(file);
            },
          ),
      ],
    );
  }
}
