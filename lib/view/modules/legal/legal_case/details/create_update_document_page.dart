import 'package:u/utilities.dart';

import '../../../../../core/widgets/upload_and_show_image.dart';
import '../../../../../core/widgets/fields/fields.dart';
import '../../../../../core/constants.dart';
import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/utils/extensions/file_extensions.dart';
import '../../../../../data/data.dart';
import 'legal_case_details_controller.dart';

class CreateUpdateDocumentPage extends StatefulWidget {
  const CreateUpdateDocumentPage({
    super.key,
    required this.controller,
    this.document,
  });

  final LegalCaseDetailsController controller;
  final LegalCaseDocumentDto? document;

  @override
  State<CreateUpdateDocumentPage> createState() => _CreateUpdateDocumentPageState();
}

class _CreateUpdateDocumentPageState extends State<CreateUpdateDocumentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  final RxBool _isSaving = false.obs;

  MainFileReadDto? _selectedFile;
  bool _isUploading = false;

  static const double _fileItemSize = 150;

  bool get isEditMode => widget.document != null;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.document?.title ?? '');
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _isSaving.close();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final maxFileSizeInBytes = AppConstants.maxFileSizeLimitInMB.convertSizeFromMBToByte;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.size > maxFileSizeInBytes) {
      AppNavigator.snackbarRed(
        title: s.error,
        subtitle:
            "${s.fileSizeExceedsTheAllowedLimit} "
            "(${s.maximum} ${maxFileSizeInBytes.convertSizeFromByteToMB.floor()} MB)",
      );
      return;
    }

    setState(() {
      _selectedFile = MainFileReadDto(
        url: file.path,
        fileName: file.name,
        originalName: file.name,
      );
    });
  }

  @override
  Widget build(final BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 18,
        children: [
          WTextField(
            controller: _titleController,
            labelText: s.title,
            required: true,
            showRequired: false,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          if (!isEditMode) ...[
            if (_selectedFile == null)
              Material(
                color: context.theme.scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: context.theme.primaryColor, width: 2),
                ),
                child: InkWell(
                  onTap: _pickFile,
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                    width: _fileItemSize,
                    height: _fileItemSize,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 12,
                      children: [
                        Icon(Icons.add_rounded, size: 30, color: context.theme.primaryColor),
                        Text("${s.select} ${s.file}").bodyMedium(color: context.theme.primaryColor),
                      ],
                    ),
                  ),
                ),
              )
            else
              WUploadAndShowImage(
                file: _selectedFile!,
                onUploaded: (final file) {
                  _selectedFile = file;
                },
                onRemove: (final file) {
                  setState(() {
                    _selectedFile = null;
                  });
                },
                uploadStatus: (final value) => _isUploading = value,
                itemSize: _fileItemSize,
              ).alignAtCenter(),
          ],
          const SizedBox(height: 50),
          Obx(
            () => UElevatedButton(
              width: double.infinity,
              title: isEditMode ? s.save : s.addText,
              isLoading: _isSaving.value,
              onTap: _onSubmit,
            ),
          ),
        ],
      ),
    );
  }

  void _onSubmit() {
    validateForm(
      key: _formKey,
      action: () {
        if (isEditMode) {
          _updateDocument();
        } else {
          if (_isUploading) {
            AppNavigator.snackbarRed(title: s.error, subtitle: s.uploading);
            return;
          }
          if (_selectedFile?.fileId == null) {
            AppNavigator.snackbarRed(
              title: s.error,
              subtitle: "${s.requiredField}: ${s.file}",
            );
            return;
          }
          _createDocument();
        }
      },
    );
  }

  void _createDocument() {
    if (_selectedFile?.fileId == null) return;
    _isSaving(true);
    widget.controller.createDocument(
      fileId: _selectedFile!.fileId!,
      title: _titleController.text.trim(),
      onSuccess: () {
        _isSaving(false);
        UNavigator.back();
      },
      onFailure: () => _isSaving(false),
    );
  }

  void _updateDocument() {
    if (widget.document == null) return;
    _isSaving(true);
    widget.controller.updateDocument(
      document: widget.document!,
      title: _titleController.text.trim(),
      onSuccess: () {
        _isSaving(false);
        UNavigator.back();
      },
      onFailure: () => _isSaving(false),
    );
  }
}
