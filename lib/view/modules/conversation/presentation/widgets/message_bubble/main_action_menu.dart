part of 'message_bubble_widget.dart';

class WithMainActionMenu extends StatelessWidget {
  const WithMainActionMenu({
    required this.controller,
    required this.message,
    required this.child,
    required this.isOwn,
    super.key,
  });

  final ConversationMessagesController controller;
  final MessageDto message;
  final Widget child;
  final bool isOwn;

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () {
        final isMultiSelect = controller.isMultiSelectMode.value;

        if (isMultiSelect) {
          // In multi-select mode: tap toggles selection, long press also toggles
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTapUp: (final details) {
              controller.toggleMessageSelection(message.id);
            },
            onLongPressStart: (final details) {
              _showMessageActionsMenu(context, details.globalPosition, isOwn);
            },
            child: child,
          );
        }

        // In normal mode: tap and long press show menu
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapUp: (final details) {
            _showMessageActionsMenu(context, details.globalPosition, isOwn);
          },
          onLongPressStart: (final details) {
            controller.enterMultiSelectMode();
            controller.toggleMessageSelection(message.id);
          },
          child: child,
        );
      },
    );
  }

  void _showMessageActionsMenu(final BuildContext context, final Offset position, final bool isOwn) {
    if (message.status == MessageStatus.sending) return;
    final isNotMultiSelect = !controller.isMultiSelectMode.value;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        context.width - position.dx,
        context.height - position.dy,
      ),
      items: <PopupMenuEntry>[
        if (isNotMultiSelect) ...[
          PopupMenuItem(
            child: ReactionPickerWidget(
              onReactionSelected: (final emoji) {
                UNavigator.back();
                Future.delayed(const Duration(milliseconds: 100), () {
                  controller.addReaction(message, emoji);
                });
              },
            ).marginSymmetric(vertical: 10),
          ),
          const PopupMenuDivider(),
          WPopupMenuItem(
            title: s.reply,
            icon: AppIcons.reply,
            onTap: () {
              Future.delayed(const Duration(milliseconds: 100), () {
                controller.setReplyMessage(message);
              });
            },
          ),
          if (isOwn && message.type == MessageType.text && message.text != null && message.text!.trim().isNotEmpty)
            WPopupMenuItem(
              title: s.edit,
              icon: AppIcons.editOutline,
              onTap: () {
                Future.delayed(const Duration(milliseconds: 100), () {
                  controller.setEditingMessage(message);
                });
              },
            ),
          WPopupMenuItem(
            title: message.isPinned ? s.unpin : s.pin,
            icon: '',
            iconData: message.isPinned ? CupertinoIcons.pin_slash : CupertinoIcons.pin,
            onTap: () {
              if (message.isPinned) {
                Future.delayed(const Duration(milliseconds: 100), () {
                  controller.unpinMessage(message);
                });
              } else {
                Future.delayed(const Duration(milliseconds: 100), () {
                  controller.pinMessage(message);
                });
              }
            },
          ),
          WPopupMenuItem(
            title: s.select,
            icon: AppIcons.tickCircleOutline,
            onTap: () {
              controller.enterMultiSelectMode();
              controller.toggleMessageSelection(message.id);
            },
          ),
        ],
        if (message.text != null && message.text!.trim().isNotEmpty)
          WPopupMenuItem(
            title: s.copyText,
            icon: AppIcons.copyOutline,
            onTap: () {
              UClipboard.set(message.text!);
            },
          ),
        WPopupMenuItem(
          title: s.forward,
          icon: '',
          iconData: CupertinoIcons.arrow_turn_up_right,
          onTap: () {
            Future.delayed(const Duration(milliseconds: 100), () {
              controller.forwardSelectedMessage(message);
            });
          },
        ),
        if (isNotMultiSelect) ...[
          if (isOwn || (controller.isGroup && controller.haveAdminAccess))
            WPopupMenuItem(
              title: s.delete,
              icon: AppIcons.delete,
              titleColor: AppColors.red,
              iconColor: AppColors.red,
              onTap: () {
                Future.delayed(const Duration(milliseconds: 100), () {
                  controller.deleteMessageDialog(message.id);
                });
              },
            ),
          // Save to gallery option (for images, videos, audio, files - not voice)
          if ((UApp.isMobile || UApp.isWindows || UApp.isMacOs) &&
              (message.type == MessageType.video || message.type == MessageType.image) &&
              message.attachments != null &&
              message.attachments!.isNotEmpty)
            WPopupMenuItem(
              title: s.saveToGallery,
              icon: AppIcons.fileOutline,
              onTap: () {
                Future.delayed(const Duration(milliseconds: 100), () {
                  _saveAllToGallery();
                });
              },
            )
          else if ((message.type == MessageType.audio || message.type == MessageType.file) &&
              message.attachments != null &&
              message.attachments!.isNotEmpty)
            WPopupMenuItem(
              title: s.download,
              icon: AppIcons.fileOutline,
              onTap: () {
                Future.delayed(const Duration(milliseconds: 100), () {
                  _downloadFile(message.attachments!.first.fileUrl, message.attachments!.first.fileName);
                });
              },
            ),
        ],
      ],
    );
  }

  Future<void> _saveAllToGallery() async {
    if (UApp.isWeb || UApp.isLinux || UApp.isPwa) return;
    if (message.attachments == null || message.attachments!.isEmpty) return;

    // Request permission
    final haveAccessToGallery = await Gal.requestAccess();

    if (haveAccessToGallery) {
      for (final attachment in message.attachments!) {
        if (message.type == MessageType.image || message.type == MessageType.video) {
          await _saveToGallery(attachment, message.type);
        }
      }

      AppNavigator.snackbarGreen(title: s.saved, subtitle: '');
    } else {
      AppNavigator.snackbarRed(title: s.error, subtitle: s.galleryPermissionDenied);
    }
  }

  Future<void> _saveToGallery(final MessageAttachmentDto attachment, final MessageType type) async {
    if (UApp.isWeb || UApp.isLinux || UApp.isPwa) return;
    try {
      final filePath = await OpenFileHelpers.showDownloadDialog(attachment.fileUrl, attachment.fileName);
      if (filePath != null) {
        if (type == MessageType.image) {
          await Gal.putImage(filePath);
        } else if (type == MessageType.video) {
          await Gal.putVideo(filePath);
        }
      }
    } on GalException catch (e) {
      AppNavigator.snackbarRed(title: s.error, subtitle: e.type.message);
    } catch (e) {
      if (type == MessageType.image) {
        debugPrint("Error in Gal.putImage() => $e");
      } else if (type == MessageType.video) {
        debugPrint("Error in Gal.putVideo() => $e");
      }
    }
  }

  Future<void> _downloadFile(final String fileUrl, final String fileName) async {
    if (message.attachments == null || message.attachments!.isEmpty) return;

    final response = await http.get(Uri.parse(fileUrl));
    final bytes = response.bodyBytes;

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);

    // Use share to save
    await fileUrl.launchMyUrl();
  }
}
