import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../core/widgets/fields/fields.dart';
import '../../../../../../core/widgets/profile_upload_and_show_image.dart';
import '../../../../../../data/data.dart';

class SuspendInvoiceSheet extends StatefulWidget {
  const SuspendInvoiceSheet({
    required this.onSubmit,
    required this.invoiceId,
    super.key,
  });

  final Future<bool> Function(int invoiceId, String reason, int? documentId) onSubmit;
  final int invoiceId;

  @override
  State<SuspendInvoiceSheet> createState() => _SuspendInvoiceSheetState();
}

class _SuspendInvoiceSheetState extends State<SuspendInvoiceSheet> {
  final TextEditingController reasonController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  MainFileReadDto? documentFile;

  bool isUploadingFile = false;

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.orange.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.orange.withValues(alpha: 0.3)),
            ),
            child: Text(s.suspensionWarning).bodySmall(color: AppColors.orange),
          ),
          const SizedBox(height: 24),
          WTextField(
            controller: reasonController,
            labelText: s.suspensionReason,
            hintText: s.pleaseEnterReason,
            required: true,
            multiLine: true,
            showCounter: true,
            minLength: 10,
            maxLines: 6,
            maxLength: 500,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const SizedBox(height: 24),
          Text(s.suspensionDocumentOptional).titleMedium(color: context.theme.hintColor),
          const SizedBox(height: 12),
          WProfileUploadAndShowImage(
            file: documentFile,
            borderRadius: 15,
            showImageFullScreen: true,
            itemWidth: 70,
            itemHeight: 70,
            onUploaded: (final file) => documentFile = file,
            onRemove: (final file) => documentFile = null,
            uploadStatus: (final value) => isUploadingFile = value,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              UElevatedButton(
                title: s.cancel,
                backgroundColor: context.theme.hintColor,
                onTap: AppNavigator.back,
              ).expanded(),
              const SizedBox(width: 10),
              UElevatedButton(
                title: s.submit,
                onTap: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    if (isUploadingFile) {
                      AppSnackBar.snackbarRed(title: s.warning, subtitle: s.uploading);
                      return;
                    }
                    final result = await widget.onSubmit(
                      widget.invoiceId,
                      reasonController.text.trim(),
                      documentFile?.fileId,
                    );

                    if (result) AppNavigator.back();
                  }
                },
              ).expanded(),
            ],
          ),
        ],
      ),
    );
  }
}
