import 'package:u/utilities.dart';

import '../../data/data.dart';
import '../core.dart';
import '../navigator/navigator.dart';
import 'upload_and_show_image.dart';

class WImageFiles extends StatefulWidget {
  const WImageFiles({
    required this.files,
    required this.onFilesUpdated,
    required this.uploadingFileStatus,
    this.showUploadWidget = true,
    this.removable = true,
    this.itemsSize = 70,
    this.maxFilesCount = 10,
    super.key,
  });

  final List<MainFileReadDto> files;
  final Function(List<MainFileReadDto> uploadedFiles) onFilesUpdated;
  final Function(bool value) uploadingFileStatus;
  final bool showUploadWidget;
  final bool removable;
  final double itemsSize;
  final int maxFilesCount;

  static void checkFileUploading({
    required final bool isUploadingFile,
    // required final List<MainFileReadDto> files,
    required final VoidCallback action,
  }) async {
    // bool isAllFilesUploaded() {
    //   for (final file in files) {
    //     if (file.fileId == null) {
    //       return false;
    //     }
    //   }
    //   return true;
    // }

    if (isUploadingFile) return AppNavigator.snackbarRed(title: s.warning, subtitle: s.uploading);

    // if (!isAllFilesUploaded()) {
    //   appShowYesCancelDialog(
    //     description: 'همه\u2000ی فایل ها بارگذاری نشدند\nآیا میخواهید فایل های بارگذاری نشده حذف شوند؟',
    //     onYesButtonTap: () {
    //       action();
    //     },
    //   );
    // } else {
    action();
    // }
  }

  @override
  State<WImageFiles> createState() => _WImageFilesState();
}

class _WImageFilesState extends State<WImageFiles> {
  late List<MainFileReadDto> files;

  List<MainFileReadDto> get displayedList => files.where((final file) => !file.isRemoved).toList();

  List<MainFileReadDto> get uploadedFiles => files.where((final file) => !file.isRemoved && file.fileId != null).toList();

  @override
  void initState() {
    files = widget.files;
    super.initState();
  }

  Future<void> pickFilesWithSizeLimit() async {
    const maxFileSizeMB = 100;

    final remainingSlots = widget.maxFilesCount - displayedList.length;
    if (remainingSlots <= 0) {
      AppNavigator.snackbarRed(
        title: s.warning,
        subtitle: s.maximumFilesCanSelected.replaceAll('#', widget.maxFilesCount.toString()),
      );
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null) {
      List<String> rejectedFiles = [];

      bool isNotDuplicate(final String fileName) {
        final result = files.firstWhereOrNull((final file) => file.originalName == fileName && !file.isRemoved);
        return result == null;
      }

      final selectedFiles = result.files.take(remainingSlots).toList();

      for (var file in selectedFiles) {
        final sizeInMB = file.size / (1024 * 1024);

        if (sizeInMB <= maxFileSizeMB &&
            (file.path!.isImageFileName ||
                file.path!.isVideoFileName ||
                file.path!.isAudioFileName ||
                file.path!.isPDFFileName ||
                file.path!.isPPTFileName ||
                file.path!.isDocumentFileName ||
                file.path!.isExcelFileName ||
                file.path!.isTxtFileName ||
                file.path!.endsWith('.csv')) &&
            isNotDuplicate(file.name)) {
          files.add(MainFileReadDto(url: file.path, fileName: file.name, originalName: file.name));
        } else {
          rejectedFiles.add('${file.name} (${sizeInMB.toStringAsFixed(1)}${isPersianLang ? 'مگابایت' : 'MB'})');
        }
      }

      if (mounted) setState(() {});

      if (rejectedFiles.isNotEmpty) {
        AppNavigator.snackbarRed(
          title: s.invalidFile,
          subtitle: '${s.invalidFileInfo}\n\n${rejectedFiles.join('\n')}',
        );
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Wrap(
      runSpacing: 10,
      alignment: WrapAlignment.start,
      children: [
        if (widget.showUploadWidget)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: widget.itemsSize,
                height: widget.itemsSize,
                decoration: BoxDecoration(
                  border: Border.all(color: context.theme.primaryColor),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(Icons.add_rounded, size: 30, color: context.theme.primaryColor),
              ).onTap(pickFilesWithSizeLimit),
              const SizedBox(width: 10),
            ],
          ),
        ...List<Widget>.generate(
          files.length,
          (final index) => Visibility(
            key: ValueKey(files[index].hashCode),
            visible: !files[index].isRemoved,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                WUploadAndShowImage(
                  key: ValueKey(files[index].hashCode),
                  file: files[index],
                  itemSize: widget.itemsSize,
                  removable: widget.removable,
                  onUploaded: (final file) {
                    if (file.fileId != null) {
                      files[index] = file;
                      widget.onFilesUpdated(uploadedFiles);
                    }
                  },
                  onRemove: (final file) {
                    if (mounted) {
                      setState(() {
                        files[index] = files[index].copyWith(isRemoved: true);
                      });
                    }
                    widget.onFilesUpdated(uploadedFiles);
                  },
                  uploadStatus: widget.uploadingFileStatus,
                ).withTooltip(files[index].originalName ?? ''),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
