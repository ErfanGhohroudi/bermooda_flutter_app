import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/theme.dart';
import '../../profile_controller.dart';

class DocumentsTab extends StatelessWidget {
  const DocumentsTab({
    required this.controller,
    super.key,
  });

  final ProfileController controller;

  @override
  Widget build(final BuildContext context) {
    return Obx(() {
      if (controller.pageState.isLoading()) {
        return const Center(child: WCircularLoading());
      }

      if (controller.hrModuleIsActive == false) {
        return Center(
          child: WErrorWidget(
            iconString: AppIcons.info,
            iconColor: context.theme.hintColor,
            errorTitle: s.hRModuleIsRequired,
            size: 50,
            onTapButton: () {},
          ),
        );
      }

      return Center(
        child: WErrorWidget(
          iconString: AppIcons.info,
          iconColor: context.theme.hintColor,
          errorTitle: s.soon,
          size: 50,
          onTapButton: () {},
        ),
      );

      return Column(
        children: [
          // Header with actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "s.documents",
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: controller.uploadDocument,
                  icon: const Icon(Icons.upload_outlined, size: 18),
                  label: Text("s.uploadDocument"),
                ),
              ],
            ),
          ),

          // Document Statistics
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildDocumentStat(
                    "s.totalDocuments",
                    '${controller.documents.length}',
                    Icons.folder_outlined,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDocumentStat(
                    "s.pdfFiles",
                    '${_getPdfCount()}',
                    Icons.picture_as_pdf_outlined,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDocumentStat(
                    "s.imageFiles",
                    '${_getImageCount()}',
                    Icons.image_outlined,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Filter and Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "s.searchDocuments",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: 'all',
                  items: [
                    DropdownMenuItem(value: 'all', child: Text("s.all")),
                    DropdownMenuItem(value: 'pdf', child: Text("s.pdf")),
                    DropdownMenuItem(value: 'image', child: Text("s.image")),
                    DropdownMenuItem(value: 'word', child: Text("s.word")),
                    DropdownMenuItem(value: 'excel', child: Text("s.excel")),
                  ],
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Documents List
          Expanded(
            child: controller.documents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_outlined,
                          size: 64,
                          color: context.theme.hintColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "s.noDocumentsFound",
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: context.theme.hintColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "s.uploadFirstDocument",
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.theme.hintColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.documents.length,
                    itemBuilder: (context, index) {
                      final document = controller.documents[index];
                      return _buildDocumentCard(document, context);
                    },
                  ),
          ),
        ],
      );
    });
  }

  Widget _buildDocumentStat(
      String label, String value, IconData icon, Color color) {
    return WCard(
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Get.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Get.textTheme.bodySmall?.copyWith(
              color: Get.theme.hintColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(
      Map<String, dynamic> document, BuildContext context) {
    return WCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildDocumentIcon(document['type'] ?? ''),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document['name'] ?? "s.unknown",
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${document['type'] ?? "s.unknown"} • ${document['size'] ?? "s.unknown"}',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              WMoreButtonIcon<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'view':
                      _viewDocument(document);
                      break;
                    case 'download':
                      controller.downloadDocument(document);
                      break;
                    case 'edit':
                      _editDocument(document);
                      break;
                    case 'delete':
                      _deleteDocument(document);
                      break;
                  }
                },
                items: [
                  PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        const Icon(Icons.visibility_outlined, size: 20),
                        const SizedBox(width: 8),
                        Text("s.view"),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'download',
                    child: Row(
                      children: [
                        const Icon(Icons.download_outlined, size: 20),
                        const SizedBox(width: 8),
                        Text("s.download"),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(Icons.edit_outlined, size: 20),
                        const SizedBox(width: 8),
                        Text(s.edit),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete_outlined,
                            size: 20, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(s.delete,
                            style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: context.theme.hintColor,
              ),
              const SizedBox(width: 4),
              Text(
                "s.uploadedOn",
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.theme.hintColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                document['uploadDate'] ?? "s.unknown",
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              _buildDocumentStatusChip(document['status'] ?? "s.active"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentIcon(String type) {
    IconData icon;
    Color color;

    switch (type.toLowerCase()) {
      case 'pdf':
        icon = Icons.picture_as_pdf_outlined;
        color = Colors.red;
        break;
      case 'image':
        icon = Icons.image_outlined;
        color = Colors.green;
        break;
      case 'word':
        icon = Icons.description_outlined;
        color = Colors.blue;
        break;
      case 'excel':
        icon = Icons.table_chart_outlined;
        color = Colors.green;
        break;
      default:
        icon = Icons.insert_drive_file_outlined;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildDocumentStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'active':
        color = Colors.green;
        break;
      case 'inactive':
        color = Colors.red;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  int _getPdfCount() {
    return controller.documents
        .where((doc) => doc['type']?.toLowerCase() == 'pdf')
        .length;
  }

  int _getImageCount() {
    return controller.documents
        .where((doc) => doc['type']?.toLowerCase() == 'image')
        .length;
  }

  void _viewDocument(Map<String, dynamic> document) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text(document['name'] ?? "s.document"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow("s.name", document['name']),
              _buildDetailRow(s.type, document['type']),
              _buildDetailRow("s.size", document['size']),
              _buildDetailRow("s.uploadDate", document['uploadDate']),
              _buildDetailRow(s.status, document['status']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("s.close"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.downloadDocument(document);
            },
            child: Text("s.download"),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Get.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value ?? "s.unknown"),
          ),
        ],
      ),
    );
  }

  void _editDocument(Map<String, dynamic> document) {
    // Navigate to edit document page
    controller.showSuccess("s.documentEdited");
  }

  void _deleteDocument(Map<String, dynamic> document) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text("s.deleteDocument"),
        content: Text("s.deleteDocumentConfirmation"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(s.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteDocument(document);
              controller.showSuccess("s.documentDeleted");
            },
            child: Text(s.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
