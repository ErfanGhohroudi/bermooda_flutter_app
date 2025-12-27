import 'dart:ui';

import 'package:u/utilities.dart';

import '../../core/widgets/widgets.dart';
import '../../data/data.dart';
import '../core.dart';
import '../navigator/navigator.dart';
import '../theme.dart';

class WProfileUploadAndShowImage extends StatefulWidget {
  const WProfileUploadAndShowImage({
    required this.onUploaded,
    required this.onRemove,
    required this.uploadStatus,
    this.file,
    this.itemWidth = 90,
    this.itemHeight,
    this.borderRadius = 200,
    this.addIconSize,
    this.removable = true,
    this.color,
    this.showImageFullScreen = false,
    this.protectData = false,
    this.isSignUpAvatar = false,
    this.borderWidth = 2,
    this.closeIconSize,
    super.key,
  });

  final MainFileReadDto? file;
  final Function(MainFileReadDto file) onUploaded;
  final Function(MainFileReadDto file) onRemove;
  final Function(bool value) uploadStatus;
  final double itemWidth;
  final double? itemHeight;
  final double? addIconSize;
  final double borderRadius;
  final bool removable;
  final Color? color;
  final bool showImageFullScreen;
  final bool protectData;
  final bool isSignUpAvatar;
  final double borderWidth;
  final double? closeIconSize;

  @override
  State<WProfileUploadAndShowImage> createState() => _UploadAndShowImageState();
}

class _UploadAndShowImageState extends State<WProfileUploadAndShowImage> {
  final UploadFileDatasource _uploadFileDatasource = Get.find<UploadFileDatasource>();
  MainFileReadDto? file;
  late double itemWidth;
  late double itemHeight;
  late double borderRadius = 200;

  double _progress = 0;
  bool _uploading = false;
  bool _uploadFailed = false;

  @override
  void initState() {
    itemWidth = widget.itemWidth;
    itemHeight = widget.itemHeight ?? widget.itemWidth;
    borderRadius = widget.borderRadius;
    file = widget.file;
    if (!(file?.url!.startsWith('http') ?? true)) {
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
  void didUpdateWidget(covariant final WProfileUploadAndShowImage oldWidget) {
    if (oldWidget.itemWidth != widget.itemWidth) {
      setState(() {
        itemWidth = widget.itemWidth;
      });
    }
    if (oldWidget.itemHeight != widget.itemHeight || oldWidget.itemWidth != widget.itemWidth) {
      setState(() {
        itemHeight = widget.itemHeight ?? widget.itemWidth;
      });
    }
    if (oldWidget.borderRadius != widget.borderRadius) {
      setState(() {
        borderRadius = widget.borderRadius;
      });
    }
    if (oldWidget.addIconSize != widget.addIconSize ||
        oldWidget.color != widget.color ||
        oldWidget.protectData != widget.protectData) {
      setState(() {});
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
      file: file!,
      isSignUpAvatar: widget.isSignUpAvatar,
      onProgress: (final progress) {
        if (!mounted) return;
        setState(() => _progress = progress);
        widget.uploadStatus(_uploading);
      },
      onFileUploaded: (final fileModel) {
        if (!mounted) return;
        setState(() {
          file = fileModel;
          _uploading = false;
          _uploadFailed = false;
        });
        widget.onUploaded(file!);
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
          width: itemWidth,
          height: itemHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Stack(
              alignment: Alignment.center,
              children: [
                UImage(
                  file?.url ?? '',
                  fileData: file != null && !file!.url!.startsWith('http') && file!.url!.isImageFileName
                      ? FileData(path: file!.url!)
                      : null,
                  fit: BoxFit.cover,
                  width: itemWidth,
                  height: itemHeight,
                ),

                Container(
                  width: itemWidth,
                  height: itemHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(color: widget.color ?? context.theme.primaryColor, width: widget.borderWidth),
                  ),
                ),

                if (file == null)
                  Icon(
                    Icons.add_rounded,
                    size: widget.addIconSize ?? (itemHeight / 1.7 > 30 ? 30 : itemHeight / 1.7),
                    color: widget.color ?? context.theme.primaryColor,
                  ),

                if (_uploading || _uploadFailed)
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      width: itemWidth,
                      height: itemHeight,
                      color: Colors.black26,
                    ),
                  ),

                // حالت آپلود در حال انجام
                if (_uploading)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: itemHeight / 3 + 2,
                        height: itemHeight / 3 + 2,
                        child: CircularProgressIndicator(
                          value: _progress == 0 ? null : _progress,
                          color: Colors.white,
                          strokeWidth: 4,
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Container(
                        width: itemHeight / 3,
                        height: itemHeight / 3,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(120),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close, color: Colors.white, size: itemHeight / 3 - 5),
                      ).onTap(() {
                        _uploadFileDatasource.cancelUpload();
                      }),
                    ],
                  ),

                // حالت آپلود با خطا یا کنسل شده
                if (_uploadFailed)
                  Container(
                    width: itemHeight / 3,
                    height: itemHeight / 3,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(120),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.refresh, color: Colors.white, size: itemHeight / 3 - 5),
                  ).onTap(() => _startUpload()),
              ],
            ),
          ),
        ).onTap(
          () async {
            if (file == null) {
              final result = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
              if (result != null) {
                setState(() {
                  file = MainFileReadDto(url: result.path, fileName: result.name, originalName: result.name);
                });
                _startUpload();
              }
            } else {
              if (widget.showImageFullScreen) {
                UNavigator.push(
                  ImagesViewPage(
                    protectData: widget.protectData,
                    medias: [
                      MediaReadDto(
                        url: file?.url ?? '',
                        id: file?.fileId?.toString() ?? '',
                      ),
                    ],
                  ),
                );
              }
            }
          },
        ),
        if (!_uploading && widget.removable && file != null)
          UImage(AppIcons.closeCircle, size: widget.closeIconSize ?? itemHeight / 3).onTap(
            () {
              widget.onRemove(file!);
              setState(() {
                file = null;
                _uploadFailed = false;
              });
            },
          ),
      ],
    );
  }
}
