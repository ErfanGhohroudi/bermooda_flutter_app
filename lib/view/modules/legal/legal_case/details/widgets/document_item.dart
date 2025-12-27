import 'package:open_filex/open_filex.dart';
import 'package:u/utilities.dart';

import '../../../../../../../core/utils/extensions/url_extensions.dart';
import '../../../../../../../core/widgets/widgets.dart';
import '../../../../../../../core/core.dart';
import '../../../../../../../core/helpers/open_file_helpers.dart';
import '../../../../../../../core/theme.dart';
import '../../../../../../../data/data.dart';
import '../legal_case_details_controller.dart';

class WDocumentItem extends StatelessWidget {
  const WDocumentItem({
    required this.document,
    required this.controller,
    required this.canEdit,
    super.key,
  });

  final LegalCaseDocumentDto document;
  final LegalCaseDetailsController controller;
  final bool canEdit;

  @override
  Widget build(final BuildContext context) {
    return _buildDocumentItem(context);
  }

  Widget _buildDocumentItem(final BuildContext context) {
    final file = document.file;
    final fileName = file.originalName ?? file.fileName ?? '- -';
    const double iconSize = 50;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 2,
      onTap: () => _openFile(file),
      title: Row(
        spacing: 6,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: UImage(
              file.iconOrImage ?? '',
              fileData: !file.url!.isWebUrl && file.url!.isImageFileName ? FileData(path: file.url!) : null,
              fit: BoxFit.cover,
              size: iconSize,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (document.title.isNotEmpty) Text(document.title).bodyMedium(),
                Text(fileName, maxLines: 1).bodySmall(overflow: TextOverflow.ellipsis, color: context.theme.hintColor),
              ],
            ),
          ),
          WMoreButtonIcon(
            items: [
              WPopupMenuItem(
                title: s.share,
                icon: '',
                iconData: Icons.share,
                onTap: () => _shareFile(file),
              ),
              if (canEdit) ...[
                WPopupMenuItem(
                  title: s.edit,
                  icon: AppIcons.editOutline,
                  titleColor: AppColors.green,
                  iconColor: AppColors.green,
                  onTap: () => controller.showUpdateDocumentBottomSheet(document),
                ),
                WPopupMenuItem(
                  title: s.delete,
                  icon: AppIcons.delete,
                  titleColor: AppColors.red,
                  iconColor: AppColors.red,
                  onTap: () => controller.deleteDocument(document),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openFile(final MainFileReadDto? file) async {
    if (file?.url == null) return;

    final url = file!.url!;
    if (UApp.isMobile) {
      final filePath = await OpenFileHelpers.showDownloadDialog(url, file.fileName ?? '');
      if (filePath != null) {
        await OpenFilex.open(filePath);
      }
    } else {
      url.launchMyUrl();
    }
  }

  Future<void> _shareFile(final MainFileReadDto? file) async {
    if (file?.url == null) return;

    final url = file!.url!;
    final fileName = file.fileName ?? file.originalName ?? 'file${uuidV4()}';

    if (UApp.isMobile) {
      final filePath = await OpenFileHelpers.showDownloadDialog(url, fileName);
      if (filePath != null) {
        ULaunch.shareFile([filePath], fileName);
      }
    } else {
      ULaunch.shareText(url, subject: fileName);
    }
  }
}
