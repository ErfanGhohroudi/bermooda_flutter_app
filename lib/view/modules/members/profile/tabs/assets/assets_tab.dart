import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/theme.dart';
import '../../profile_controller.dart';

class AssetsTab extends StatelessWidget {
  const AssetsTab({
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
                  "s.assets",
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: controller.assignAsset,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text("s.assignAsset"),
                ),
              ],
            ),
          ),

          // Asset Statistics
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildAssetStat(
                    "s.totalAssets",
                    '${controller.assignedAssets.length}',
                    Icons.inventory_outlined,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAssetStat(
                    "s.assignedAssets",
                    '${_getAssignedCount()}',
                    Icons.check_circle_outline,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAssetStat(
                    "s.returnedAssets",
                    '${_getReturnedCount()}',
                    Icons.undo_outlined,
                    Colors.orange,
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
                      hintText: "s.searchAssets",
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
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text("s.all")),
                    DropdownMenuItem(
                        value: 'assigned', child: Text("s.assigned")),
                    DropdownMenuItem(
                        value: 'returned', child: Text("s.returned")),
                    DropdownMenuItem(
                        value: 'maintenance', child: Text("s.maintenance")),
                  ],
                  onChanged: (final value) {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Assets List
          Expanded(
            child: controller.assignedAssets.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_outlined,
                          size: 64,
                          color: context.theme.hintColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "s.noAssetsAssigned",
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: context.theme.hintColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "s.assignFirstAsset",
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.theme.hintColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.assignedAssets.length,
                    itemBuilder: (final context, final index) {
                      final asset = controller.assignedAssets[index];
                      return _buildAssetCard(asset, context);
                    },
                  ),
          ),
        ],
      );
    });
  }

  Widget _buildAssetStat(
      final String label, final String value, final IconData icon, final Color color) {
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

  Widget _buildAssetCard(final Map<String, dynamic> asset, final BuildContext context) {
    return WCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildAssetIcon(asset['category'] ?? ''),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset['name'] ?? "- -",
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${"s.serialNumber"}: ${asset['serialNumber'] ?? "- -"}',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              _buildAssetStatusChip(asset['status'] ?? "- -"),
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
                "s.assignedOn",
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.theme.hintColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                asset['assignDate'] ?? "- -",
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              if (asset['status']?.toLowerCase() == 'assigned')
                TextButton.icon(
                  onPressed: () => _returnAsset(asset),
                  icon: const Icon(Icons.undo_outlined, size: 16),
                  label: const Text("s.returnAsset"),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.orange,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.category_outlined,
                size: 16,
                color: context.theme.hintColor,
              ),
              const SizedBox(width: 4),
              Text(
                s.category,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.theme.hintColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                asset['category'] ?? "- -",
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              WMoreButtonIcon<String>(
                onSelected: (final value) {
                  switch (value) {
                    case 'view':
                      _viewAsset(asset);
                      break;
                    case 'edit':
                      _editAsset(asset);
                      break;
                    case 'maintenance':
                      _requestMaintenance(asset);
                      break;
                    case 'return':
                      _returnAsset(asset);
                      break;
                    case 'delete':
                      _deleteAsset(asset);
                      break;
                  }
                },
                items: [
                  const PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.visibility_outlined, size: 20),
                        SizedBox(width: 8),
                        Text("s.view"),
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
                  const PopupMenuItem(
                    value: 'maintenance',
                    child: Row(
                      children: [
                        Icon(Icons.build_outlined, size: 20),
                        SizedBox(width: 8),
                        Text("s.requestMaintenance"),
                      ],
                    ),
                  ),
                  if (asset['status']?.toLowerCase() == 'assigned')
                    const PopupMenuItem(
                      value: 'return',
                      child: Row(
                        children: [
                          Icon(Icons.undo_outlined,
                              size: 20, color: Colors.orange),
                          SizedBox(width: 8),
                          Text("s.returnAsset",
                              style: TextStyle(color: Colors.orange)),
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
        ],
      ),
    );
  }

  Widget _buildAssetIcon(final String category) {
    IconData icon;
    Color color;

    switch (category.toLowerCase()) {
      case 'laptop':
        icon = Icons.laptop_outlined;
        color = Colors.blue;
        break;
      case 'mobile':
        icon = Icons.phone_android_outlined;
        color = Colors.green;
        break;
      case 'desktop':
        icon = Icons.desktop_windows_outlined;
        color = Colors.purple;
        break;
      case 'tablet':
        icon = Icons.tablet_outlined;
        color = Colors.orange;
        break;
      case 'monitor':
        icon = Icons.monitor_outlined;
        color = Colors.teal;
        break;
      default:
        icon = Icons.device_hub_outlined;
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

  Widget _buildAssetStatusChip(final String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'assigned':
        color = Colors.green;
        break;
      case 'returned':
        color = Colors.orange;
        break;
      case 'maintenance':
        color = Colors.red;
        break;
      case 'lost':
        color = Colors.red;
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

  int _getAssignedCount() {
    return controller.assignedAssets
        .where((final asset) => asset['status']?.toLowerCase() == 'assigned')
        .length;
  }

  int _getReturnedCount() {
    return controller.assignedAssets
        .where((final asset) => asset['status']?.toLowerCase() == 'returned')
        .length;
  }

  void _viewAsset(final Map<String, dynamic> asset) {
    showDialog(
      context: Get.context!,
      builder: (final context) => AlertDialog(
        title: Text(asset['name'] ?? "s.asset"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow("s.name", asset['name']),
              _buildDetailRow("s.serialNumber", asset['serialNumber']),
              _buildDetailRow(s.category, asset['category']),
              _buildDetailRow(s.status, asset['status']),
              _buildDetailRow("s.assignedOn", asset['assignDate']),
              _buildDetailRow("s.condition", asset['condition'] ?? "s.good"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("s.close"),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(final String label, final String? value) {
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
            child: Text(value ?? "- -"),
          ),
        ],
      ),
    );
  }

  void _editAsset(final Map<String, dynamic> asset) {
    // Navigate to edit asset page
    controller.showSuccess("s.assetEdited");
  }

  void _requestMaintenance(final Map<String, dynamic> asset) {
    showDialog(
      context: Get.context!,
      builder: (final context) => AlertDialog(
        title: const Text("s.requestMaintenance"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("s.maintenanceRequestDescription"),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: s.description,
                hintText: "s.enterMaintenanceDescription",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(s.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.showSuccess("s.maintenanceRequested");
            },
            child: Text(s.submit),
          ),
        ],
      ),
    );
  }

  void _returnAsset(final Map<String, dynamic> asset) {
    showDialog(
      context: Get.context!,
      builder: (final context) => AlertDialog(
        title: const Text("s.returnAsset"),
        content: const Text("s.returnAssetConfirmation"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(s.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.returnAsset(asset);
              controller.showSuccess("s.assetReturned");
            },
            child: const Text("s.returnAsset",
                style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _deleteAsset(final Map<String, dynamic> asset) {
    showDialog(
      context: Get.context!,
      builder: (final context) => AlertDialog(
        title: const Text("s.deleteAsset"),
        content: const Text("s.deleteAssetConfirmation"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(s.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.assignedAssets.remove(asset);
              controller.showSuccess("s.assetDeleted");
            },
            child: Text(s.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
