import 'package:bermooda_business/data/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:open_filex/open_filex.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/functions/direction_functions.dart';
import '../../../../../../core/helpers/open_file_helpers.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../core/utils/extensions/date_extensions.dart';
import '../../../../../../core/utils/extensions/url_extensions.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../conversation/presentation/widgets/message_voice_widget.dart';
import '../../../domain/entities/support_message.dart';
import '../../../domain/enums/message_type.dart';
import '../../controllers/support_chat_controller.dart';

class MessageBubbleWidget extends StatefulWidget {
  const MessageBubbleWidget({
    required this.controller,
    required this.message,
    super.key,
  });

  final SupportChatController controller;
  final SupportMessage message;

  @override
  State<MessageBubbleWidget> createState() => _MessageBubbleWidgetState();
}

class _MessageBubbleWidgetState extends State<MessageBubbleWidget> {
  SupportMessage get _message => widget.message;

  SupportChatController get controller => widget.controller;

  @override
  void didUpdateWidget(covariant final MessageBubbleWidget oldWidget) {
    if (oldWidget.message != _message) {
      if (mounted) {
        setState(() {});
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(final BuildContext context) {
    final isOwn = _message.isOperator;
    final messageOwnerName = isOwn
        ? _message.operatorUser?.fullName ?? ''
        : controller.room.anonymousUser?.fullName ?? controller.room.anonymousUser?.phoneNumber ?? '';

    return Directionality(
      textDirection: isOwn ? TextDirection.rtl : TextDirection.ltr,
      child: ChatBubble(
        clipper: ChatBubbleClipper5(
          type: isOwn ? BubbleType.sendBubble : BubbleType.receiverBubble,
        ),
        alignment: isOwn ? Alignment.centerRight : Alignment.centerLeft,
        backGroundColor: isOwn ? AppColors.primaryColor : context.theme.cardColor,
        shadowColor: context.theme.shadowColor,
        child: Container(
          constraints: BoxConstraints(
            minWidth: 40,
            maxWidth: context.width / 1.4,
          ),
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Sender FullName
              Text(messageOwnerName, maxLines: 1)
                  .bodySmall(
                    color: context.theme.hintColor,
                    overflow: TextOverflow.ellipsis,
                  )
                  .marginOnly(bottom: 5),

              /// Replied Message
              if (_message.reply != null) _buildReplyPreview(context, _message.reply!, isOwn: isOwn),

              /// Media widgets
              ..._buildMediaWidgets(isOwn),

              /// Link preview widgets
              if (_message.body.isNotEmpty) ..._buildLinkPreview(_message.body, isOwn),

              /// Body
              if (_message.body.isNotEmpty)
                Text(
                  _message.body,
                  textDirection: getDirection(_message.body),
                ).bodyMedium(color: isOwn ? Colors.white : null),

              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 4,
                spacing: 4,
                children: [
                  /// status
                  if (isOwn) _buildStatusIcon(_message.readStatus, _message.isSending, _message.isFailed),

                  /// Time
                  Text(_message.created.toJalaliDateTimeString).bodySmall(
                    color: isOwn ? Colors.white.withAlpha(150) : context.theme.hintColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(final bool readStatus, final bool isSending, final bool isFailed) {
    if (isFailed) {
      return const UImage(AppIcons.info, size: 12, color: Colors.red);
    } else if (isSending) {
      return const WCircularLoading(
        size: 8,
        strokeWidth: 1.5,
        color: Colors.white,
        backgroundColor: Colors.white24,
      );
    } else if (readStatus) {
      return const UImage(AppIcons.seen, size: 12, color: Colors.white);
    } else {
      return const UImage(AppIcons.unseen, size: 12, color: Colors.white);
    }
  }

  Widget _buildReplyPreview(
    final BuildContext context,
    final SupportMessage reply, {
    required final bool isOwn,
  }) {
    final messageOwnerName = isOwn
        ? reply.operatorUser?.fullName ?? ''
        : controller.room.anonymousUser?.fullName ?? controller.room.anonymousUser?.phoneNumber ?? '';

    final String replyTitle = reply.type.title ?? reply.body;

    return Directionality(
      textDirection: isOwn ? TextDirection.rtl : TextDirection.ltr,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (final details) => controller.scrollToRepliedMessage(reply.id),
        child: Container(
          width: 150,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: isOwn ? Colors.white.withValues(alpha: 0.15) : context.theme.hintColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(5),
          ),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 6,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: isOwn ? Colors.white.withAlpha(60) : context.theme.hintColor,
                          width: 3,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(messageOwnerName).bodySmall(color: isOwn ? Colors.white : null),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child:
                              Text(
                                replyTitle,
                                maxLines: 1,
                              ).bodySmall(
                                color: isOwn ? Colors.white : null,
                                overflow: TextOverflow.ellipsis,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMediaWidgets(final bool isOwn) {
    final widgets = <Widget>[];

    if (_message.file == null && _message.voice == null && _message.image == null) {
      return widgets;
    }

    // Handle uploading messages (no attachments yet, but has localFilePath)
    if (_message.isSending || _message.isFailed) {
      switch (_message.type) {
        case SupportMessageType.image:
          widgets.add(_buildUploadingImageWidget(isOwn));
          break;
        case SupportMessageType.file:
          // case SupportMessageType.file || SupportMessageType.audio:
          widgets.add(_buildUploadingFileWidget(isOwn));
          break;
        case SupportMessageType.voice:
          widgets.add(_buildUploadingVoiceWidget(isOwn));
          break;
        default:
          break;
      }
      return widgets;
    }

    if (widgets.isNotEmpty) {
      return widgets;
    }

    switch (_message.type) {
      case SupportMessageType.image:
        if (_message.image != null) {
          widgets.add(_buildImageWidget(_message.image!, isOwn));
        }
        break;
      case SupportMessageType.file:
        if (_message.file != null) {
          widgets.add(_buildFileWidget(_message.file!, isOwn));
        }
        break;
      case SupportMessageType.voice:
        if (_message.voice?.url != null) {
          widgets.add(
            MessageVoiceWidget(
              voiceUrl: _message.voice!.url!,
              fileName: _message.voice!.originalName ?? _message.voice!.fileName ?? _message.voice!.url!.split('/').last,
              duration: null,
              isOwn: isOwn,
            ),
          );
        }
        break;
      case SupportMessageType.text:
        break;
    }

    return widgets;
  }

  Widget _buildImageWidget(final MainFileReadDto attachment, final bool isOwn) {
    final imageUrl = attachment.url ?? '';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (final details) async {
        await _downloadAndOpenFile(attachment);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: context.theme.dividerColor,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: UImage(
                imageUrl,
                size: context.width / 1.4,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (final context, final url, final progress) {
                  return Center(child: WCircularLoading(value: progress.progress));
                },
              ),
            ),
            // Play icon overlay
            Positioned.fill(
              child: Container(
                width: context.width / 1.4,
                height: context.width / 1.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withAlpha(100),
                ),
                child: const Center(
                  child: Icon(
                    CupertinoIcons.photo,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileWidget(final MainFileReadDto attachment, final bool isOwn) {
    final icon = _getFileIcon(attachment.url ?? '');

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (final details) async {
        await _downloadAndOpenFile(attachment);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isOwn ? Colors.white.withAlpha(20) : context.theme.dividerColor.withAlpha(50),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            UImage(icon, fit: BoxFit.cover, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                attachment.originalName ?? attachment.fileName ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ).bodyMedium(color: isOwn ? Colors.white : null),
            ),
            Icon(
              Icons.download,
              color: isOwn ? Colors.white : context.theme.primaryColorDark,
            ),
          ],
        ),
      ),
    );
  }

  // Uploading widgets with progress
  Widget _buildUploadingImageWidget(final bool isOwn) {
    return Obx(() {
      final message =
          controller.messages.firstWhereOrNull(
            (final m) => m.clientId == _message.clientId && m.clientId != null,
          ) ??
          _message;

      final localFilePath = switch (message.type) {
        SupportMessageType.image => message.image?.url,
        SupportMessageType.voice => message.voice?.url,
        SupportMessageType.file => message.file?.url,
        _ => null,
      };

      return _buildUploadingMediaWidget(
        isOwn: isOwn,
        localFilePath: localFilePath,
        progress: message.uploadProgress ?? 0.0,
        isFailed: message.isFailed,
        errorMessage: message.uploadError,
        clientId: message.clientId,
        onRetry: message.isFailed && message.clientId != null ? () => controller.retryUpload(message.clientId!) : null,
        onCancel: message.clientId != null && message.isSending ? () => controller.cancelUpload(message.clientId!) : null,
        child: localFilePath != null
            ? Stack(
                children: [
                  UImage(
                    localFilePath,
                    size: context.width / 1.4,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: Container(
                      width: context.width / 1.4,
                      height: context.width / 1.4,
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(100),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                color: context.theme.dividerColor,
                child: const Icon(CupertinoIcons.photo, color: Colors.grey),
              ),
      );
    });
  }

  Widget _buildUploadingVoiceWidget(final bool isOwn) {
    return Obx(() {
      final message =
          controller.messages.firstWhereOrNull(
            (final m) => m.clientId == _message.clientId && m.clientId != null,
          ) ??
          _message;
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isOwn ? Colors.white.withAlpha(20) : context.theme.dividerColor.withAlpha(50),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            _buildProgressIndicator(
              progress: message.uploadProgress ?? 0.0,
              isFailed: message.isFailed,
              size: 40,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(s.voiceMessage).bodyMedium(color: isOwn ? Colors.white : null),
                  if (message.isFailed && (message.uploadError ?? '').trim().isNotEmpty)
                    Text(
                      message.uploadError!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ).bodySmall(color: AppColors.red),
                ],
              ),
            ),
            if (message.isFailed && message.clientId != null)
              IconButton(
                onPressed: () => controller.retryUpload(message.clientId!),
                icon: const Icon(Icons.refresh),
                tooltip: s.tryAgain,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white24,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(5),
                  iconSize: 30,
                ),
              )
            else if (message.clientId != null && message.isSending)
              IconButton(
                onPressed: () => controller.cancelUpload(message.clientId!),
                icon: const Icon(Icons.close),
                tooltip: s.cancel,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white24,
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildUploadingFileWidget(final bool isOwn) {
    return Obx(() {
      final message =
          controller.messages.firstWhereOrNull(
            (final m) => m.clientId == _message.clientId && m.clientId != null,
          ) ??
          _message;

      final localFile = switch (message.type) {
        SupportMessageType.image => message.image,
        SupportMessageType.voice => message.voice,
        SupportMessageType.file => message.file,
        _ => null,
      };

      final fileName = localFile?.originalName ?? localFile?.fileName ?? localFile?.url?.split('/').last ?? s.file;
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isOwn ? Colors.white.withAlpha(20) : context.theme.dividerColor.withAlpha(50),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            _buildProgressIndicator(
              progress: message.uploadProgress ?? 0.0,
              isFailed: message.isFailed,
              size: 40,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ).bodyMedium(color: isOwn ? Colors.white : null),
                  if (message.isFailed && (message.uploadError ?? '').trim().isNotEmpty)
                    Text(
                      message.uploadError!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ).bodySmall(color: AppColors.red),
                ],
              ),
            ),
            if (message.isFailed && message.clientId != null)
              IconButton(
                onPressed: () => controller.retryUpload(message.clientId!),
                icon: const Icon(Icons.refresh),
                tooltip: s.tryAgain,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white24,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(5),
                  iconSize: 30,
                ),
              )
            else if (message.clientId != null && message.isSending)
              IconButton(
                onPressed: () => controller.cancelUpload(message.clientId!),
                icon: const Icon(Icons.close),
                tooltip: s.cancel,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white24,
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildUploadingMediaWidget({
    required final bool isOwn,
    required final String? localFilePath,
    required final double progress,
    required final bool isFailed,
    final String? errorMessage,
    final String? clientId,
    required final VoidCallback? onRetry,
    final VoidCallback? onCancel,
    required final Widget child,
  }) {
    return Container(
      width: context.width / 1.4,
      height: context.width / 1.4,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.theme.dividerColor,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: child,
          ),
          // Progress overlay with cancel button
          if (!isFailed)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withAlpha(100),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: _buildProgressIndicator(
                        progress: progress,
                        isFailed: false,
                        size: 60,
                      ),
                    ),
                    // Cancel button in top-right corner
                    if (onCancel != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: onCancel,
                          tooltip: s.cancel,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white24,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          // Error overlay
          if (isFailed)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withAlpha(150),
                ),
                child: Center(
                  child: IconButton(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    tooltip: s.tryAgain,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white24,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(5),
                      iconSize: 40,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator({
    required final double progress,
    required final bool isFailed,
    required final double size,
  }) {
    if (isFailed) {
      return UImage(AppIcons.info, color: Colors.white54, size: size);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 3,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        Text(
          '${(progress * 100).toInt()}%',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildLinkPreview(final String text, final bool isOwn) {
    final links = _extractLinksFromText(text);
    if (links.isEmpty) return [];

    return links
        .map(
          (final link) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: ULinkPreviewer(
              key: ValueKey(link),
              link: link,
            ),
          ),
        )
        .toList();
  }

  List<String> _extractLinksFromText(final String text) {
    final RegExp urlRegex = RegExp(
      r'(?:(?:https?|ftp)://)?[\w/\-?=%.]+\.[\w/\-?=%.]+',
      caseSensitive: false,
    );

    final matches = urlRegex.allMatches(text);
    return matches.map((final match) {
      String url = match.group(0)!;
      if (!url.startsWith('http')) {
        url = 'https://$url';
      }
      return url;
    }).toList();
  }

  // String _formatFileSize(final int bytes) {
  //   if (bytes < 1024) return '$bytes B';
  //   if (bytes < 1024 * 1024) return '${(bytes / 1024).percentageFormatted} KB';
  //   if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).percentageFormatted} MB';
  //   return '${(bytes / (1024 * 1024 * 1024)).percentageFormatted} GB';
  // }

  String _getFileIcon(final String url) {
    if (url.isVideoFileName) return AppImages.video;
    if (url.isAudioFileName) return AppImages.music;
    if (url.isPDFFileName) return AppImages.pdf;
    if (url.isPPTFileName) return AppImages.powerPoint;
    if (url.isDocumentFileName || url.isTxtFileName) return AppImages.word;
    if (url.isExcelFileName || url.endsWith('.csv')) return AppImages.exel;
    return AppIcons.fileOutline;
  }

  Future<void> _downloadAndOpenFile(final MainFileReadDto attachment) async {
    if (UApp.isMobile) {
      final filePath = await OpenFileHelpers.showDownloadDialog(
        attachment.url ?? '',
        attachment.originalName ?? attachment.fileName ?? '',
      );
      if (filePath != null) {
        await OpenFilex.open(filePath); // باز کردن فایل بعد از دانلود
      }
    } else {
      attachment.url.launchMyUrl();
    }
  }
}
