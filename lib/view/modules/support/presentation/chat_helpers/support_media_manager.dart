import 'dart:developer' as developer;
import 'package:bermooda_business/data/data.dart';
import 'package:dio/dio.dart' as dio;
import 'package:bermooda_business/core/core.dart';
import 'package:bermooda_business/core/navigator/navigator.dart';
import 'package:bermooda_business/core/utils/extensions/file_extensions.dart';
import 'package:u/utilities.dart';

import '../../../../../core/constants.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../domain/entities/support_message.dart';
import '../../domain/enums/message_type.dart';
import '../controllers/support_chat_controller.dart';

class SupportMediaManager {
  SupportMediaManager(this.controller);

  final SupportChatController controller;

  final _maxFileSizeLimitInBytes = AppConstants.maxFileSizeLimitInMB.convertSizeFromMBToByte;
  final Map<String, dio.CancelToken> _uploadCancelTokens = {};

  /// Cancel all active uploads
  void cancelAllUploads() {
    developer.log(
      'Cancelling all uploads for room ${controller.room.id}',
    );

    // Cancel all cancel tokens
    for (final entry in _uploadCancelTokens.entries) {
      final cancelToken = entry.value;
      if (!cancelToken.isCancelled) {
        cancelToken.cancel('Upload cancelled');
      }
    }
    _uploadCancelTokens.clear();

    // Remove all uploading messages from list
    final uploadingMessages = controller.messages.where((final m) => m.isSending || m.isFailed).toList();
    for (final message in uploadingMessages) {
      if (message.clientId != null) {
        final index = controller.messages.indexWhere(
          (final m) => m.clientId == message.clientId,
        );
        if (index != -1) {
          controller.messages.removeAt(index);
          controller.chatMessagesCount--;
        }
      }
    }

    developer.log('Cancelled ${uploadingMessages.length} uploading messages');
  }

  void handleAttachmentPressed() {
    bottomSheet(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: navigatorKey.currentContext!.width,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.start,
            spacing: 20,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.green,
                    ),
                    child: const Icon(
                      Icons.camera,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(s.camera).bodyMedium(),
                ],
              ).onTap(
                () {
                  AppNavigator.back();
                  _pickImage(pickFromCamera: true);
                },
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor,
                    ),
                    child: const UImage(
                      AppIcons.galleryOutline,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(s.photo).bodyMedium(),
                ],
              ).onTap(
                () {
                  AppNavigator.back();
                  _pickImage();
                },
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.orange,
                    ),
                    child: const UImage(
                      AppIcons.fileOutline,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(s.file).bodyMedium(),
                ],
              ).onTap(
                () {
                  AppNavigator.back();
                  _pickFile();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage({final bool? pickFromCamera}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: (pickFromCamera ?? false) ? ImageSource.camera : ImageSource.gallery,
    );
    if (image != null) {
      uploadAndSendFile(File(image.path), SupportMessageType.image);
    }
  }

  Future<void> _pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      uploadAndSendFile(File(result.files.single.path!), SupportMessageType.file);
    }
  }

  Future<void> uploadAndSendFile(
    final File file,
    final SupportMessageType type,
  ) async {
    final fileSizeInBytes = await file.length();
    if (fileSizeInBytes > _maxFileSizeLimitInBytes) {
      _showSizeLimitError();
      return;
    }

    final clientId = 'client_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(100000)}';

    final convertedFile = MainFileReadDto(
      url: file.path,
      originalName: file.path.split('/').last,
      fileName: file.path.split('/').last,
    );

    final optimisticMessage = SupportMessage(
      id: clientId,
      isOperator: true,
      operatorUser: Get.find<Core>().userReadDto.value,
      type: type,
      isSending: true,
      created: DateTime.now(),
      clientId: clientId,
      uploadProgress: 0.0,
      file: type == SupportMessageType.file ? convertedFile : null,
      image: type == SupportMessageType.image ? convertedFile : null,
      voice: type == SupportMessageType.voice ? convertedFile : null,
      body: '',
      readStatus: false,
    );

    controller.messages.insert(0, optimisticMessage);
    controller.chatMessagesCount++;
    controller.scrollManager.scrollToBottom();

    final cancelToken = dio.CancelToken();
    _uploadCancelTokens[clientId] = cancelToken;

    try {
      final uploadedFile = await controller.repository.uploadFile(
        file.path,
        onSendProgress: (final progress) {
          _updateMessageProgress(clientId, progress);
        },
        cancelToken: cancelToken,
      );

      _uploadCancelTokens.remove(clientId);

      if (uploadedFile != null) {
        controller.repository.sendMessage(
          roomId: controller.room.id,
          clientId: clientId,
          message: "",
          type: type,
          fileId: type == SupportMessageType.file ? uploadedFile.fileId : null,
          imageId: type == SupportMessageType.image ? uploadedFile.fileId : null,
          voiceId: type == SupportMessageType.voice ? uploadedFile.fileId : null,
          replyToId: controller.replyToMessage.value?.id,
        );
      }
    } on dio.DioException catch (e) {
      _uploadCancelTokens.remove(clientId);
      _handleUploadError(clientId, e);
    } catch (e) {
      _uploadCancelTokens.remove(clientId);
      _handleUploadError(clientId, e);
    }
  }

  void _showSizeLimitError() {
    AppSnackBar.snackbarRed(
      title: s.error,
      subtitle:
          "${s.fileSizeExceedsTheAllowedLimit} (${s.maximum} ${_maxFileSizeLimitInBytes.convertSizeFromByteToMB.floor()} MB)",
    );
  }

  void cancelUpload(final String clientId) {
    if (_uploadCancelTokens.containsKey(clientId)) {
      _uploadCancelTokens[clientId]?.cancel();
      _uploadCancelTokens.remove(clientId);
    }
    // Remove message from list
    final index = controller.messages.indexWhere(
          (final m) => m.clientId == clientId,
    );
    if (index != -1) {
      controller.messages.removeAt(index);
      controller.chatMessagesCount--;
    }
  }

  void _updateMessageProgress(final String clientId, final double progress) {
    final index = controller.messages.indexWhere(
      (final m) => m.clientId == clientId,
    );
    if (index != -1) {
      controller.messages[index] = controller.messages[index].copyWith(
        isSending: true,
        isFailed: false,
        uploadProgress: progress,
      );
    }
  }

  void _handleUploadError(
    final String clientId,
    final dynamic error,
  ) {
    String errorMessage = '';
    int? statusCode;

    if (error is dio.DioException) {
      statusCode = error.response?.statusCode;
      final responseData = error.response?.data;

      // Log detailed error information
      developer.log('=== Upload Error Details ===');
      developer.log('ClientId: $clientId');
      developer.log('StatusCode: $statusCode');
      developer.log('Error Type: ${error.type}');
      developer.log('Error Message: ${error.message}');
      developer.log('Response Data: $responseData');
      developer.log(
        'Request Path: ${error.requestOptions.baseUrl}${error.requestOptions.path}',
      );
      developer.log('===========================');

      // Handle 413 (Payload Too Large) separately
      if (statusCode == 413) {
        errorMessage = s.fileSizeExceedsTheAllowedLimit;
        AppSnackBar.snackbarRed(title: s.error, subtitle: errorMessage);
      } else {
        // Extract error message from response
        if (responseData is Map<String, dynamic>) {
          errorMessage =
              responseData['message'] ??
              responseData['error'] ??
              responseData['detail'] ??
              error.message ??
              (isPersianLang ? 'خطا در آپلود فایل' : 'File upload error');
        } else if (responseData is String) {
          errorMessage = responseData;
        } else {
          errorMessage = error.message ?? s.fileUploadError;
        }
      }
    } else {
      // Log non-DioException errors
      developer.log('=== Upload Error Details ===');
      developer.log('ClientId: $clientId');
      developer.log('Error: $error');
      developer.log('Error Type: ${error.runtimeType}');
      developer.log('===========================');

      errorMessage = error.toString();
    }

    _setMessageUploadError(clientId, errorMessage);
  }

  void _setMessageUploadError(final String clientId, final String error) {
    final index = controller.messages.indexWhere(
          (final m) => m.clientId == clientId,
    );
    if (index != -1) {
      final message = controller.messages[index];
      // Preserve upload progress for resume capability
      controller.messages[index] = message.copyWith(
        isSending: false,
        isFailed: true,
        uploadError: error,
        uploadProgress: null,
      );
    }
  }

  Future<void> retryUpload(final String clientId) async {
    final index = controller.messages.indexWhere(
          (final m) => m.clientId == clientId,
    );
    if (index == -1) return;

    final message = controller.messages[index];

    final localFilePath = switch(message.type) {
      SupportMessageType.image => message.image?.url,
      SupportMessageType.file => message.file?.url,
      SupportMessageType.voice => message.voice?.url,
      _ => null,
    };

    if (localFilePath == null) return;

    final file = File(localFilePath);
    if (!await file.exists()) {
      AppSnackBar.snackbarRed(title: s.error, subtitle: s.fileNotFound);
      return;
    }

    // Reset error state
    final updatedMessage = message.copyWith(
      isSending: true,
      isFailed: false,
      uploadProgress: 0.0,
      uploadError: null,
    );

    // Update the message in the list
    controller.messages[index] = updatedMessage;

    // Create cancel token for retry
    final cancelToken = dio.CancelToken();
    _uploadCancelTokens[clientId] = cancelToken;

    final type = message.type;

    try {
      final uploadedFile = await controller.repository.uploadFile(
        file.path,
        onSendProgress: (final progress) {
          _updateMessageProgress(clientId, progress);
        },
        cancelToken: cancelToken,
      );
      if (uploadedFile == null) return;

      _uploadCancelTokens.remove(clientId);
      controller.repository.sendMessage(
        roomId: controller.room.id,
        clientId: clientId,
        message: '',
        type: type,
        fileId: type == SupportMessageType.file ? uploadedFile.fileId : null,
        imageId: type == SupportMessageType.image ? uploadedFile.fileId : null,
        voiceId: type == SupportMessageType.voice ? uploadedFile.fileId : null,
        replyToId: controller.replyToMessage.value?.id,
      );
    } on dio.DioException catch (e) {
      _uploadCancelTokens.remove(clientId);
      _handleUploadError(clientId, e);
    } catch (e) {
      _uploadCancelTokens.remove(clientId);
      _handleUploadError(clientId, e);
    }
  }
}
