import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/functions/direction_functions.dart';
import '../../../../../../core/helpers/open_file_helpers.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../core/utils/extensions/url_extensions.dart';
import '../../../../../../view/modules/conversation/data/dto/conversation_dtos.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/core.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../core/utils/extensions/money_extensions.dart';
import '../../pages/messages/conversation_messages_controller.dart';
import '../message_voice_widget.dart';
import '../reaction_picker_widget.dart';

part 'main_action_menu.dart';

class MessageBubbleWidget extends StatefulWidget {
  const MessageBubbleWidget({
    required this.controller,
    required this.message,
    super.key,
  });

  final ConversationMessagesController controller;
  final MessageDto message;

  @override
  State<MessageBubbleWidget> createState() => _MessageBubbleWidgetState();
}

class _MessageBubbleWidgetState extends State<MessageBubbleWidget> {
  late MessageDto _message;

  @override
  void initState() {
    super.initState();
    _message = widget.message;
  }

  @override
  void didUpdateWidget(covariant final MessageBubbleWidget oldWidget) {
    if (oldWidget.message != widget.message) {
      if (mounted) {
        setState(() {
          _message = widget.message;
        });
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(final BuildContext context) {
    final isOwn = _message.isOwner;

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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Forwarded From
              if (_message.forwardedFrom != null)
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 5,
                    children: [
                      Icon(CupertinoIcons.arrow_turn_up_right, color: context.theme.hintColor, size: 15),
                      Flexible(
                        child:
                            Text(
                              '${s.forwardedFrom} "${_message.forwardedFrom?.user.fullName ?? ''}"',
                              maxLines: 1,
                            ).bodySmall(
                              color: context.theme.hintColor,
                              overflow: TextOverflow.ellipsis,
                            ),
                      ),
                    ],
                  ).marginOnly(bottom: 5),
                ),

              /// Sender FullName
              if (!isOwn)
                Text(_message.sender.fullName ?? '', maxLines: 1)
                    .bodySmall(
                      color: context.theme.hintColor,
                      overflow: TextOverflow.ellipsis,
                    )
                    .marginOnly(bottom: 5),

              /// Replied Message
              if (_message.replyTo != null) _buildReplyPreview(context, _message.replyTo!, isOwn: isOwn),

              /// Media widgets
              ..._buildMediaWidgets(isOwn),

              /// Link preview widgets
              if (_message.text != null && _message.text!.isNotEmpty) ..._buildLinkPreview(_message.text!, isOwn),

              /// Body
              if (_message.text != null && _message.text!.isNotEmpty)
                Text(
                  _message.text!,
                  textDirection: getDirection(_message.text!),
                ).bodyMedium(color: isOwn ? Colors.white : null),

              /// Reactions
              if (_message.reactions.isNotEmpty) _buildReactionsWidget(isOwn),

              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 4,
                spacing: 4,
                children: [
                  /// status
                  if (isOwn) _buildStatusIcon(widget.message.status),

                  /// Time
                  Text(widget.message.jalaliTime ?? '').bodySmall(
                    color: isOwn ? Colors.white.withAlpha(150) : context.theme.hintColor,
                  ),

                  /// Edited
                  if (widget.message.isEdited)
                    Text(s.edited).bodySmall(
                      color: isOwn ? Colors.white.withAlpha(150) : context.theme.hintColor,
                      fontStyle: FontStyle.italic,
                    ),
                  if (widget.message.isPinned)
                    Icon(
                      CupertinoIcons.pin_fill,
                      size: 12,
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

  Widget _buildStatusIcon(final MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return const WCircularLoading(
          size: 12,
          strokeWidth: 2,
          color: Colors.white,
          backgroundColor: Colors.white24,
        );
      case MessageStatus.sent:
        return const UImage(AppIcons.unseen, size: 12, color: Colors.white);
      case MessageStatus.delivered:
        return const UImage(AppIcons.unseen, size: 12, color: Colors.white);
      case MessageStatus.read:
        return const UImage(AppIcons.seen, size: 12, color: Colors.white);
      case MessageStatus.failed:
        return const UImage(AppIcons.info, size: 12, color: Colors.red);
    }
  }

  Widget _buildReplyPreview(
    final BuildContext context,
    final ReplyToMessageDto reply, {
    required final bool isOwn,
  }) {
    return Directionality(
      textDirection: isOwn ? TextDirection.rtl : TextDirection.ltr,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (final details) => widget.controller.scrollToRepliedMessage(reply.id),
        child: Container(
          width: 150,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: isOwn ? Colors.white.withValues(alpha: 0.15) : context.theme.hintColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 40,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reply.sender.fullName ?? '').bodySmall(color: isOwn ? Colors.white : null),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      reply.type.title ?? reply.text ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ).bodySmall(color: isOwn ? Colors.white : null),
                  ),
                ],
              ).pSymmetric(horizontal: 8),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMediaWidgets(final bool isOwn) {
    final widgets = <Widget>[];

    // Handle uploading messages (no attachments yet, but has localFilePath)
    if (_message.isSending || _message.isFailed) {
      switch (_message.type) {
        case MessageType.image:
          widgets.add(_buildUploadingImageWidget(isOwn));
          break;
        case MessageType.video:
          widgets.add(_buildUploadingVideoWidget(isOwn));
          break;
        case MessageType.file || MessageType.audio:
          widgets.add(_buildUploadingFileWidget(isOwn));
          break;
        case MessageType.voice:
          widgets.add(_buildUploadingVoiceWidget(isOwn));
          break;
        default:
          break;
      }
      return widgets;
    }

    if (_message.attachments == null || _message.attachments!.isEmpty) {
      return widgets;
    }

    switch (_message.type) {
      case MessageType.image:
        for (final attachment in _message.attachments!) {
          widgets.add(_buildImageWidget(attachment, isOwn));
        }
        break;
      case MessageType.video:
        for (final attachment in _message.attachments!) {
          widgets.add(_buildVideoWidget(attachment, isOwn));
        }
        break;
      case MessageType.file || MessageType.audio:
        for (final attachment in _message.attachments!) {
          widgets.add(_buildFileWidget(attachment, isOwn));
        }
        break;
      case MessageType.voice:
        if (_message.attachments!.isNotEmpty) {
          widgets.add(
            MessageVoiceWidget(
              attachment: _message.attachments!.first,
              duration: _message.duration,
              isOwn: isOwn,
            ),
          );
        }
        break;
      case MessageType.text:
        break;
    }

    return widgets;
  }

  Widget _buildImageWidget(final MessageAttachmentDto attachment, final bool isOwn) {
    final imageUrl = attachment.thumbnailUrl ?? attachment.fileUrl;

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
            // File Size
            if (attachment.fileSize > 0)
              Positioned(
                bottom: 8,
                right: !isOwn ? 8 : null,
                left: isOwn ? 8 : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(200),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _formatFileSize(attachment.fileSize),
                    textDirection: TextDirection.ltr,
                  ).bodySmall(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoWidget(final MessageAttachmentDto attachment, final bool isOwn) {
    final thumbnailUrl = attachment.thumbnailUrl ?? attachment.fileUrl;

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
                thumbnailUrl,
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
                    CupertinoIcons.play_circle_fill,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // File Size
            if (attachment.fileSize > 0)
              Positioned(
                bottom: 8,
                right: !isOwn ? 8 : null,
                left: isOwn ? 8 : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(200),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _formatFileSize(attachment.fileSize),
                    textDirection: TextDirection.ltr,
                  ).bodySmall(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileWidget(final MessageAttachmentDto attachment, final bool isOwn) {
    final icon = _getFileIcon(attachment.fileUrl);

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
          mainAxisSize: MainAxisSize.min,
          children: [
            UImage(icon, fit: BoxFit.cover, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    attachment.fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ).bodyMedium(color: isOwn ? Colors.white : null),
                  const SizedBox(height: 4),
                  Text(
                    _formatFileSize(attachment.fileSize),
                    textDirection: TextDirection.ltr,
                  ).bodySmall(color: isOwn ? Colors.white.withAlpha(200) : null),
                ],
              ),
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
          widget.controller.messages.cast<MessageDto>().firstWhereOrNull(
            (final m) => m.clientId == _message.clientId && m.clientId != null,
          ) ??
          _message;
      return _buildUploadingMediaWidget(
        isOwn: isOwn,
        localFilePath: message.localFilePath,
        progress: message.uploadProgress ?? 0.0,
        isFailed: message.isFailed,
        errorMessage: message.uploadError,
        clientId: message.clientId,
        onRetry: message.isFailed && message.clientId != null ? () => widget.controller.retryUpload(message.clientId!) : null,
        onCancel: message.clientId != null && message.isSending ? () => widget.controller.cancelUpload(message.clientId!) : null,
        child: message.localFilePath != null
            ? Stack(
                children: [
                  UImage(
                    message.localFilePath!,
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

  Widget _buildUploadingVideoWidget(final bool isOwn) {
    return Obx(() {
      final message =
          widget.controller.messages.cast<MessageDto>().firstWhereOrNull(
            (final m) => m.clientId == _message.clientId && m.clientId != null,
          ) ??
          _message;
      return _buildUploadingMediaWidget(
        isOwn: isOwn,
        localFilePath: message.localFilePath,
        progress: message.uploadProgress ?? 0.0,
        isFailed: message.isFailed,
        errorMessage: message.uploadError,
        clientId: message.clientId,
        onRetry: message.isFailed && message.clientId != null ? () => widget.controller.retryUpload(message.clientId!) : null,
        onCancel: message.clientId != null && message.isSending ? () => widget.controller.cancelUpload(message.clientId!) : null,
        child: message.localFilePath != null
            ? Stack(
                children: [
                  UImage(
                    message.localFilePath!,
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
                      // child: const Center(
                      //   child: Icon(
                      //     Icons.play_circle_filled,
                      //     size: 60,
                      //     color: Colors.white,
                      //   ),
                      // ),
                    ),
                  ),
                ],
              )
            : Container(
                color: context.theme.dividerColor,
                child: const Icon(CupertinoIcons.videocam_circle_fill, color: Colors.grey),
              ),
      );
    });
  }

  Widget _buildUploadingVoiceWidget(final bool isOwn) {
    return Obx(() {
      final message =
          widget.controller.messages.cast<MessageDto>().firstWhereOrNull(
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
          mainAxisSize: MainAxisSize.min,
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
                onPressed: () => widget.controller.retryUpload(message.clientId!),
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
                onPressed: () => widget.controller.cancelUpload(message.clientId!),
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
          widget.controller.messages.cast<MessageDto>().firstWhereOrNull(
            (final m) => m.clientId == _message.clientId && m.clientId != null,
          ) ??
          _message;
      final fileName = message.localFilePath?.split('/').last ?? s.file;
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isOwn ? Colors.white.withAlpha(20) : context.theme.dividerColor.withAlpha(50),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
                onPressed: () => widget.controller.retryUpload(message.clientId!),
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
                onPressed: () => widget.controller.cancelUpload(message.clientId!),
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

  String _formatFileSize(final int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).percentageFormatted} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).percentageFormatted} MB';
    return '${(bytes / (1024 * 1024 * 1024)).percentageFormatted} GB';
  }

  String _getFileIcon(final String url) {
    if (url.isVideoFileName) return AppImages.video;
    if (url.isAudioFileName) return AppImages.music;
    if (url.isPDFFileName) return AppImages.pdf;
    if (url.isPPTFileName) return AppImages.powerPoint;
    if (url.isDocumentFileName || url.isTxtFileName) return AppImages.word;
    if (url.isExcelFileName || url.endsWith('.csv')) return AppImages.exel;
    return AppIcons.fileOutline;
  }

  Future<void> _downloadAndOpenFile(final MessageAttachmentDto attachment) async {
    if (UApp.isMobile) {
      final filePath = await OpenFileHelpers.showDownloadDialog(attachment.fileUrl, attachment.fileName);
      if (filePath != null) {
        await OpenFilex.open(filePath); // باز کردن فایل بعد از دانلود
      }
    } else {
      attachment.fileUrl.launchMyUrl();
    }
  }

  Widget _buildReactionsWidget(final bool isOwn) {
    if (_message.reactions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: _message.reactions.map((final reaction) {
          final emoji = reaction.emoji;
          final count = reaction.count;
          final isUserReacted = reaction.isUserIn;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTapDown: (final details) {
                if (isUserReacted) {
                  widget.controller.removeReaction(_message, emoji);
                } else {
                  widget.controller.addReaction(_message, emoji);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isUserReacted
                      ? (isOwn ? Colors.white.withAlpha(30) : context.theme.primaryColor.withAlpha(30))
                      : (isOwn ? Colors.white.withAlpha(10) : context.theme.dividerColor),
                  borderRadius: BorderRadius.circular(12),
                  border: isUserReacted
                      ? Border.all(
                          color: isOwn ? Colors.white.withAlpha(100) : context.theme.primaryColor.withAlpha(100),
                          width: 1,
                        )
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: [
                    Text(
                      emoji,
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(count.toString().separateNumbers3By3()).bodySmall(
                      fontSize: 11,
                      color: isOwn ? Colors.white.withAlpha(200) : context.theme.hintColor,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
