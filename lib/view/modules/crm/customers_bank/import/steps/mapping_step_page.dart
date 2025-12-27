part of '../customers_import_page.dart';

class MappingStepPage extends StatelessWidget {
  const MappingStepPage({
    required this.ctrl,
    super.key,
  });

  final CustomerExelController ctrl;

  /// Helper function to get available items for a dropdown
  /// Filters out items that are selected by other dropdowns
  /// Always includes the currently selected item for this dropdown
  List<DropdownItemReadDto> _getAvailableItems({
    required final List<DropdownItemReadDto> allFieldItems,
    required final List<ExelColumn> columns,
    required final int currentIndex,
  }) {
    // Get the currently selected slug for this dropdown
    final currentSelectedSlug = columns[currentIndex].detectedField;

    // Get all slugs selected by other dropdowns (excluding current one)
    final selectedSlugsByOthers = <String>{};
    for (var i = 0; i < columns.length; i++) {
      if (i != currentIndex && columns[i].detectedField != null) {
        selectedSlugsByOthers.add(columns[i].detectedField!);
      }
    }

    // Filter items: include items that are either:
    // 1. Not selected by other dropdowns, OR
    // 2. Currently selected by this dropdown
    return allFieldItems.where((final item) {
      if (item.slug == null) return true;
      // Always include the currently selected item for this dropdown
      if (item.slug == currentSelectedSlug) return true;
      // Include items that are not selected by other dropdowns
      return !selectedSlugsByOthers.contains(item.slug);
    }).toList();
  }

  @override
  Widget build(final BuildContext context) {
    final List<DropdownItemReadDto> fieldItems = CustomerParams().getExelFields();
    // List<List<String>> selectedFields = fields.where((final e) => e.first,).toList();

    return Obx(
      () {
        if (ctrl.exelUploadResult.value == null) {
          return Center(child: Text(s.fileInfoNotFullyReceived, textAlign: TextAlign.center).bodyMedium());
        }

        final detectedColumnsCount = ctrl.exelUploadResult.value!.columns.where((final e) => e.detectedField != null).toList().length.toString();

        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              WCard(
                margin: EdgeInsets.zero,
                elevation: 0,
                horPadding: 16,
                showBorder: true,
                child: Column(
                  spacing: 5,
                  children: [
                    _buildRowCountInfo(
                      title: s.rowCount,
                      value: ctrl.exelUploadResult.value!.totalRows.toString(),
                      color: AppColors.blue,
                    ),
                    _buildRowCountInfo(
                      title: s.detectedColumns,
                      value: detectedColumnsCount,
                      color: AppColors.green,
                    ),
                    _buildRowCountInfo(
                      title: s.potentialDuplicates,
                      value: ctrl.exelUploadResult.value!.duplicateCount.toString(),
                      color: AppColors.red,
                    ),
                  ],
                ),
              ),

              /// Columns Mapping
              Text(s.columnMapping).titleMedium().marginOnly(top: 18, bottom: 10),
              if (ctrl.exelUploadResult.value!.columns.isNotEmpty)
                ...ctrl.exelUploadResult.value!.columns.mapIndexed(
                  (final index, final _) {
                    final ExelColumn column = ctrl.exelUploadResult.value!.columns[index];
                    // Get available items for this dropdown
                    final availableItems = _getAvailableItems(
                      allFieldItems: fieldItems,
                      columns: ctrl.exelUploadResult.value!.columns,
                      currentIndex: index,
                    );

                    /// Column Item
                    return WCard(
                      showBorder: true,
                      margin: EdgeInsets.zero,
                      horPadding: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildColumnItemHeader(context, column),
                          const SizedBox(height: 18),
                          WDropDownFormField<DropdownItemReadDto>(
                            required: true,
                            labelText: s.columnDataType,
                            showSearchField: true,
                            value: availableItems.firstWhereOrNull((final item) => item.slug == column.detectedField),
                            items: getDropDownMenuItemsFromDropDownItemReadDto(menuItems: availableItems),
                            onChanged: (final DropdownItemReadDto? value) => ctrl.updateColumns(
                              index: index,
                              value: value,
                              column: column,
                            ),
                          ),
                          const SizedBox(height: 18),
                          WCard(
                            margin: EdgeInsets.zero,
                            horPadding: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${s.sampleData}:').titleMedium(),
                                const SizedBox(height: 6),
                                ...column.sampleData.take(5).map((final data) => Text(data).bodyMedium()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).marginOnly(bottom: 10);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRowCountInfo({
    required final String title,
    required final String value,
    final Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 6,
      children: [
        Flexible(child: Text("$title:").bodyMedium()),
        Text(value.separateNumbers3By3()).bodyLarge(fontSize: 21, color: color).bold(),
      ],
    );
  }

  Widget _buildColumnItemHeader(final BuildContext ctx, final ExelColumn column) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("${s.excelColumn}: ").bodyMedium(),
            Flexible(child: Text(column.originalColumn ?? '- -').bodyMedium()),
          ],
        ),
        WLabel(
          text: 'Ai: ${column.confidence}%',
          color: ctx.theme.primaryColor,
        ),
      ],
    );
  }
}
