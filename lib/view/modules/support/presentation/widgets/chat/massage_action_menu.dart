import 'package:http/http.dart' as http;
import 'package:gal/gal.dart';
import 'package:u/utilities.dart';
import 'package:bermooda_business/data/data.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/helpers/open_file_helpers.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../core/utils/extensions/url_extensions.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../domain/entities/support_message.dart';
import '../../controllers/support_chat_controller.dart';

class MessageActionMenu extends StatelessWidget {
  const MessageActionMenu({
    required this.controller,
    required this.message,
    required this.child,
    required this.isOwn,
    super.key,
  });

  final SupportChatController controller;
  final SupportMessage message;
  final Widget child;
  final bool isOwn;

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapUp: (final details) {
        _showMessageActionsMenu(context, details.globalPosition, isOwn);
      },
      child: child,
    );
  }

  void _showMessageActionsMenu(final BuildContext context, final Offset position, final bool isOwn) {
    if (message.isSending) return;
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        context.width - position.dx,
        context.height - position.dy,
      ),
      items: <PopupMenuEntry>[
        WPopupMenuItem(
          title: s.reply,
          icon: AppIcons.reply,
          onTap: () {
            Future.delayed(const Duration(milliseconds: 100), () {
              controller.setReplyMessage(message);
            });
          },
        ),
        if (message.body.trim().isNotEmpty)
          WPopupMenuItem(
            title: s.copyText,
            icon: AppIcons.copyOutline,
            onTap: () {
              UClipboard.set(message.body);
            },
          ),
        // Save to gallery option (for images, videos, audio, files - not voice)
        if ((UApp.isMobile || UApp.isWindows || UApp.isMacOs) &&
            ((message.file?.url ?? '').isVideoFileName || (message.image?.url ?? '').isImageFileName))
          WPopupMenuItem(
            title: s.saveToGallery,
            icon: AppIcons.fileOutline,
            onTap: () {
              Future.delayed(const Duration(milliseconds: 100), () {
                _saveAllToGallery();
              });
            },
          )
        else if (message.file?.url != null)
          WPopupMenuItem(
            title: s.download,
            icon: AppIcons.fileOutline,
            onTap: () {
              Future.delayed(const Duration(milliseconds: 100), () {
                _downloadFile(message.file!.url!, message.file!.fileName ?? message.file!.url!.split('/').last);
              });
            },
          ),
      ],
    );
  }

  Future<void> _saveAllToGallery() async {
    if (UApp.isWeb || UApp.isLinux || UApp.isPwa) return;
    if (!(message.file?.url ?? '').isVideoFileName && !(message.image?.url ?? '').isImageFileName) return;

    // Request permission
    final haveAccessToGallery = await Gal.requestAccess();

    if (haveAccessToGallery) {
      final attachment = message.file ?? message.image;
      if (attachment == null) return;
      await _saveToGallery(attachment);
      AppSnackBar.snackbarGreen(title: s.saved, subtitle: '');
    } else {
      AppSnackBar.snackbarRed(title: s.error, subtitle: s.galleryPermissionDenied);
    }
  }

  Future<void> _saveToGallery(final MainFileReadDto attachment) async {
    if (UApp.isWeb || UApp.isLinux || UApp.isPwa) return;
    final isImage = attachment.url?.isImageFileName ?? false;
    final isVideo = attachment.url?.isVideoFileName ?? false;

    try {
      final filePath = await OpenFileHelpers.showDownloadDialog(attachment.url ?? '', attachment.fileName ?? const Uuid().v4());
      if (filePath != null) {
        if (isImage) {
          await Gal.putImage(filePath);
        } else if (isVideo) {
          await Gal.putVideo(filePath);
        }
      }
    } on GalException catch (e) {
      AppSnackBar.snackbarRed(title: s.error, subtitle: e.type.message);
    } catch (e) {
      if (isImage) {
        debugPrint("Error in Gal.putImage() => $e");
      } else if (isVideo) {
        debugPrint("Error in Gal.putVideo() => $e");
      }
    }
  }

  Future<void> _downloadFile(final String fileUrl, final String fileName) async {
    if (!(message.file?.url ?? '').isVideoFileName && !(message.image?.url ?? '').isImageFileName) return;

    final response = await http.get(Uri.parse(fileUrl));
    final bytes = response.bodyBytes;

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);

    // Use share to save
    await fileUrl.launchMyUrl();
  }
}
