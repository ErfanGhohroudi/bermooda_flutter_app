import 'dart:developer' as developer;
import 'package:bermooda_business/core/utils/extensions/file_extensions.dart';
import 'package:dio/dio.dart' as dio;
import 'package:u/utilities.dart';

import '../../../../../../../../core/core.dart';
import '../../../../../../../../core/navigator/navigator.dart';
import '../../../../../../../../core/utils/enums/enums.dart';
import '../../../../../../../core/constants.dart';
import '../../../../data/dto/conversation_dtos.dart';
import '../conversation_messages_controller.dart';

class MediaUploadManager {
  MediaUploadManager(this.controller);

  final ConversationMessagesController controller;

  final _maxFileSizeLimitInBytes = AppConstants.maxFileSizeLimitInMB.convertSizeFromMBToByte;

  final Map<String, dio.CancelToken> _uploadCancelTokens = {};

  Future<void> sendImage(final File imageFile) async {
    if (controller.isAnonymousBot) return;
    final fileSizeInBytes = await imageFile.length();
    if (fileSizeInBytes > _maxFileSizeLimitInBytes) {
      return _showSizeLimitError();
    }

    final clientId = 'client_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(100000)}';

    // Create optimistic message
    final optimisticMessage = MessageDto(
      id: clientId,
      conversationId: controller.conversation.value.id,
      sender: UserBasicDto(
        id: controller.core.userReadDto.value.id,
        fullName: controller.core.userReadDto.value.fullName,
        avatarUrl: controller.core.userReadDto.value.avatarUrl ?? controller.core.userReadDto.value.avatar?.url,
      ),
      type: MessageType.image,
      status: MessageStatus.sending,
      createdAt: DateTime.now(),
      isEdited: false,
      isPinned: false,
      isOwn: true,
      clientId: clientId,
      uploadProgress: 0.0,
      localFilePath: imageFile.path,
      repliesCount: 0,
      forwardCount: 0,
    );

    controller.messages.insert(0, optimisticMessage);
    controller.chatMessagesCount++;
    controller.scrollManager.scrollToBottom();

    // Create cancel token
    final cancelToken = dio.CancelToken();
    _uploadCancelTokens[clientId] = cancelToken;

    try {
      final attachment = await controller.repository.uploadFile(
        imageFile,
        MessageType.image.name,
        onSendProgress: (final count, final total) {
          final progress = count / total;
          _updateMessageProgress(clientId, progress);
        },
        cancelToken: cancelToken,
      );

      // Remove cancel token on success
      _uploadCancelTokens.remove(clientId);

      // Send message via WebSocket
      controller.repository.sendMessage(
        conversationId: controller.conversation.value.id,
        type: MessageType.image,
        clientId: clientId,
        attachments: [attachment.id],
      );
    } on dio.DioException catch (e) {
      _uploadCancelTokens.remove(clientId);
      _handleUploadError(clientId, e, 'sendImage');
    } catch (e) {
      _uploadCancelTokens.remove(clientId);
      _handleUploadError(clientId, e, 'sendImage');
    }
  }

  Future<void> sendVideo(final File videoFile) async {
    if (controller.isAnonymousBot) return;
    final fileSizeInBytes = await videoFile.length();
    if (fileSizeInBytes > _maxFileSizeLimitInBytes) {
      return _showSizeLimitError();
    }

    final clientId = 'client_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(100000)}';

    // Create optimistic message
    final optimisticMessage = MessageDto(
      id: clientId,
      conversationId: controller.conversation.value.id,
      sender: UserBasicDto(
        id: controller.core.userReadDto.value.id,
        fullName: controller.core.userReadDto.value.fullName,
        avatarUrl: controller.core.userReadDto.value.avatarUrl ?? controller.core.userReadDto.value.avatar?.url,
      ),
      type: MessageType.video,
      status: MessageStatus.sending,
      createdAt: DateTime.now(),
      isEdited: false,
      isPinned: false,
      isOwn: true,
      clientId: clientId,
      uploadProgress: 0.0,
      localFilePath: videoFile.path,
      repliesCount: 0,
      forwardCount: 0,
    );

    controller.messages.insert(0, optimisticMessage);
    controller.chatMessagesCount++;
    controller.scrollManager.scrollToBottom();

    // Create cancel token
    final cancelToken = dio.CancelToken();
    _uploadCancelTokens[clientId] = cancelToken;

    try {
      final attachment = await controller.repository.uploadFile(
        videoFile,
        MessageType.video.name,
        onSendProgress: (final count, final total) {
          final progress = count / total;
          _updateMessageProgress(clientId, progress);
        },
        cancelToken: cancelToken,
      );

      // Remove cancel token on success
      _uploadCancelTokens.remove(clientId);

      // Send message via WebSocket
      controller.repository.sendMessage(
        conversationId: controller.conversation.value.id,
        type: MessageType.video,
        clientId: clientId,
        attachments: [attachment.id],
      );
    } on dio.DioException catch (e) {
      _uploadCancelTokens.remove(clientId);
      _handleUploadError(clientId, e, 'sendVideo');
    } catch (e) {
      _uploadCancelTokens.remove(clientId);
      _handleUploadError(clientId, e, 'sendVideo');
    }
  }

  Future<void> sendFile(final File file, final String fileName) async {
    if (controller.isAnonymousBot) return;
    final fileSizeInBytes = await file.length();
    if (fileSizeInBytes > _maxFileSizeLimitInBytes) {
      return _showSizeLimitError();
    }

    final clientId = 'client_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(100000)}';

    // Determine file type
    MessageType messageType = MessageType.file;
    String fileType = 'file';

    if (file.path.isVideoFileName) {
      messageType = MessageType.video;
      fileType = MessageType.video.name;
    } else if (file.path.isAudioFileName) {
      messageType = MessageType.audio;
      fileType = MessageType.audio.name;
    } else if (file.path.isImageFileName) {
      messageType = MessageType.image;
      fileType = MessageType.image.name;
    } else {
      fileType = MessageType.file.name;
    }

    // Create optimistic message
    final optimisticMessage = MessageDto(
      id: clientId,
      conversationId: controller.conversation.value.id,
      sender: UserBasicDto(
        id: controller.core.userReadDto.value.id,
        fullName: controller.core.userReadDto.value.fullName,
        avatarUrl: controller.core.userReadDto.value.avatarUrl ?? controller.core.userReadDto.value.avatar?.url,
      ),
      type: messageType,
      status: MessageStatus.sending,
      createdAt: DateTime.now(),
      isEdited: false,
      isPinned: false,
      isOwn: true,
      clientId: clientId,
      uploadProgress: 0.0,
      localFilePath: file.path,
      repliesCount: 0,
      forwardCount: 0,
    );

    controller.messages.insert(0, optimisticMessage);
    controller.chatMessagesCount++;
    controller.scrollManager.scrollToBottom();

    // Create cancel token
    final cancelToken = dio.CancelToken();
    _uploadCancelTokens[clientId] = cancelToken;

    try {
      final attachment = await controller.repository.uploadFile(
        file,
        fileType,
        onSendProgress: (final count, final total) {
          final progress = count / total;
          _updateMessageProgress(clientId, progress);
        },
        cancelToken: cancelToken,
      );

      // Remove cancel token on success
      _uploadCancelTokens.remove(clientId);

      // Send message via WebSocket
      controller.repository.sendMessage(
        conversationId: controller.conversation.value.id,
        type: messageType,
        clientId: clientId,
        attachments: [attachment.id],
      );
    } on dio.DioException catch (e) {
      _uploadCancelTokens.remove(clientId);
      _handleUploadError(clientId, e, 'sendFile');
    } catch (e) {
      _uploadCancelTokens.remove(clientId);
      _handleUploadError(clientId, e, 'sendFile');
    }
  }

  Future<void> sendVoice(final File voiceFile, [final int? duration]) async {
    if (controller.isAnonymousBot) return;
    final fileSizeInBytes = await voiceFile.length();
    if (fileSizeInBytes > _maxFileSizeLimitInBytes) {
      return _showSizeLimitError();
    }

    final clientId = 'client_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(100000)}';

    // Create optimistic message
    final optimisticMessage = MessageDto(
      id: clientId,
      conversationId: controller.conversation.value.id,
      sender: UserBasicDto(
        id: controller.core.userReadDto.value.id,
        fullName: controller.core.userReadDto.value.fullName,
        avatarUrl: controller.core.userReadDto.value.avatarUrl ?? controller.core.userReadDto.value.avatar?.url,
      ),
      type: MessageType.voice,
      status: MessageStatus.sending,
      createdAt: DateTime.now(),
      isEdited: false,
      isPinned: false,
      isOwn: true,
      clientId: clientId,
      uploadProgress: 0.0,
      localFilePath: voiceFile.path,
      duration: duration,
      repliesCount: 0,
      forwardCount: 0,
    );

    controller.messages.insert(0, optimisticMessage);
    controller.chatMessagesCount++;
    controller.scrollManager.scrollToBottom();

    // Create cancel token
    final cancelToken = dio.CancelToken();
    _uploadCancelTokens[clientId] = cancelToken;

    try {
      final attachment = await controller.repository.uploadFile(
        voiceFile,
        MessageType.voice.name,
        onSendProgress: (final count, final total) {
          final progress = count / total;
          _updateMessageProgress(clientId, progress);
        },
        cancelToken: cancelToken,
      );

      // Remove cancel token on success
      _uploadCancelTokens.remove(clientId);

      // Send voice message via WebSocket
      controller.repository.sendMessage(
        conversationId: controller.conversation.value.id,
        type: MessageType.voice,
        clientId: clientId,
        attachments: [attachment.id],
        duration: duration,
      );
    } on dio.DioException catch (e) {
      _uploadCancelTokens.remove(clientId);
      _handleUploadError(clientId, e, 'sendVoice');
    } catch (e) {
      _uploadCancelTokens.remove(clientId);
      _handleUploadError(clientId, e, 'sendVoice');
    }
  }

  void _showSizeLimitError() {
    AppNavigator.snackbarRed(
      title: s.error,
      subtitle:
          "${s.fileSizeExceedsTheAllowedLimit} "
          "(${s.maximum} ${_maxFileSizeLimitInBytes.convertSizeFromByteToMB.floor()} MB)",
    );
  }

  void _updateMessageProgress(final String clientId, final double progress) {
    if (controller.isAnonymousBot) return;
    final index = controller.messages.cast<MessageDto>().indexWhere(
      (final m) => m.clientId == clientId,
    );
    if (index != -1) {
      controller.messages[index] = controller.messages.cast<MessageDto>()[index].copyWith(
        status: MessageStatus.sending,
        uploadProgress: progress,
      );
    }
  }

  void _setMessageUploadError(final String clientId, final String error) {
    if (controller.isAnonymousBot) return;
    final index = controller.messages.cast<MessageDto>().indexWhere(
      (final m) => m.clientId == clientId,
    );
    if (index != -1) {
      final message = controller.messages.cast<MessageDto>()[index];
      // Preserve upload progress for resume capability
      controller.messages[index] = message.copyWith(
        status: MessageStatus.failed,
        uploadError: error,
        uploadProgress: null,
      );
    }
  }

  void _handleUploadError(
    final String clientId,
    final dynamic error,
    final String methodName,
  ) {
    String errorMessage = '';
    int? statusCode;

    if (error is dio.DioException) {
      statusCode = error.response?.statusCode;
      final responseData = error.response?.data;

      // Log detailed error information
      developer.log('=== Upload Error Details ===');
      developer.log('Method: $methodName');
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
        AppNavigator.snackbarRed(title: s.error, subtitle: errorMessage);
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
      developer.log('Method: $methodName');
      developer.log('ClientId: $clientId');
      developer.log('Error: $error');
      developer.log('Error Type: ${error.runtimeType}');
      developer.log('===========================');

      errorMessage = error.toString();
    }

    _setMessageUploadError(clientId, errorMessage);
  }

  void cancelUpload(final String clientId) {
    final cancelToken = _uploadCancelTokens[clientId];
    if (cancelToken != null && !cancelToken.isCancelled) {
      cancelToken.cancel('Upload cancelled by user');
      _uploadCancelTokens.remove(clientId);
    }

    if (controller.isAnonymousBot) return;
    // Remove message from list
    final index = controller.messages.cast<MessageDto>().indexWhere(
      (final m) => m.clientId == clientId,
    );
    if (index != -1) {
      controller.messages.removeAt(index);
      controller.chatMessagesCount--;
    }
  }

  /// Cancel all active uploads
  void cancelAllUploads() {
    developer.log(
      'Cancelling all uploads for conversation ${controller.conversation.value.id}',
    );

    // Cancel all cancel tokens
    for (final entry in _uploadCancelTokens.entries) {
      final cancelToken = entry.value;
      if (!cancelToken.isCancelled) {
        cancelToken.cancel('Upload cancelled');
      }
    }
    _uploadCancelTokens.clear();

    if (controller.isAnonymousBot) return;
    // Remove all uploading messages from list
    final uploadingMessages = controller.messages.cast<MessageDto>().where((final m) => m.isSending || m.isFailed).toList();
    for (final message in uploadingMessages) {
      if (message.clientId != null) {
        final index = controller.messages.cast<MessageDto>().indexWhere(
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

  Future<void> retryUpload(final String clientId) async {
    if (controller.isAnonymousBot) return;
    final index = controller.messages.cast<MessageDto>().indexWhere(
      (final m) => m.clientId == clientId,
    );
    if (index == -1) return;

    final message = controller.messages.cast<MessageDto>()[index];
    if (message.localFilePath == null) return;

    final file = File(message.localFilePath!);
    if (!await file.exists()) {
      AppNavigator.snackbarRed(title: s.error, subtitle: s.fileNotFound);
      return;
    }

    // Reset error state
    final updatedMessage = message.copyWith(
      status: MessageStatus.sending,
      uploadProgress: 0.0,
      uploadError: null,
    );

    // Update the message in the list
    controller.messages[index] = updatedMessage;

    // Create cancel token for retry
    final cancelToken = dio.CancelToken();
    _uploadCancelTokens[clientId] = cancelToken;

    try {
      final attachment = await controller.repository.uploadFile(
        file,
        message.type.name,
        onSendProgress: (final count, final total) {
          final progress = count / total;
          _updateMessageProgress(clientId, progress);
        },
        cancelToken: cancelToken,
      );
      _uploadCancelTokens.remove(clientId);
      controller.repository.sendMessage(
        conversationId: controller.conversation.value.id,
        type: message.type,
        clientId: clientId,
        attachments: [attachment.id],
        duration: message.duration,
        text: message.text,
      );
    } on dio.DioException catch (e) {
      _uploadCancelTokens.remove(clientId);
      _handleUploadError(clientId, e, 'retryUpload');
    } catch (e) {
      _uploadCancelTokens.remove(clientId);
      _handleUploadError(clientId, e, 'retryUpload');
    }
  }
}
