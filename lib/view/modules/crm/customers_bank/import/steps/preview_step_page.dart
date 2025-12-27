import 'package:u/utilities.dart';

import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/core.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../data/data.dart';
import '../customer_exel_controller.dart';

class PreviewStepPage extends StatelessWidget {
  const PreviewStepPage({
    required this.ctrl,
    super.key,
  });

  final CustomerExelController ctrl;

  @override
  Widget build(final BuildContext context) {
    final exelMappingResult = ctrl.exelMappingResult;

    if (exelMappingResult == null) {
      return Center(child: Text(s.fileInfoNotFullyReceived, textAlign: TextAlign.center).bodyMedium());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (exelMappingResult.errorFile?.url != null && exelMappingResult.errorList.isNotEmpty) ...[
          Row(
            spacing: 5,
            children: [
              const UImage(AppIcons.info, size: 15, color: AppColors.blue),
              Text('${s.detectedErrors}:').bodyMedium(),
              Text(exelMappingResult.errorList.length.toString().separateNumbers3By3()).bodyLarge(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              UElevatedButton(
                title: s.downloadErrorFile,
                icon: const Icon(Icons.download, color: Colors.white),
                backgroundColor: AppColors.red,
                onTap: () {
                  ULaunch.launchURL(exelMappingResult.errorFile!.url!);
                },
              ),
            ],
          ),
        ],
        Text(s.dataPreview).titleMedium().marginSymmetric(vertical: 10),
        _PreviewTable(previewRows: exelMappingResult.preview),
      ],
    );
  }
}

class _PreviewTable extends StatelessWidget {
  const _PreviewTable({
    required this.previewRows,
  });

  final List<ExelPreviewRow> previewRows;

  @override
  Widget build(final BuildContext context) {
    if (previewRows.isEmpty) {
      return Center(child: Text(s.noRecordsToDisplay).bodyMedium());
    }

    final columnItems = _collectColumnItems();
    final columnTitles = columnItems.map((final e) => e.title ?? '-');
    final columnKeys = columnItems.map((final e) => e.slug ?? '-').toList();
    final columnHeaders = <String>[
      '#',
      ...columnTitles,
      s.status,
      s.error,
    ];

    final tableRows = <TableRow>[
      _buildHeaderRow(context, columnHeaders),
      ...previewRows.take(10).map((final row) => _buildDataRow(context, row, columnKeys)),
    ];

    final defaultColumnWidth = const MinColumnWidth(
      FixedColumnWidth(150),
      MaxColumnWidth(
        FixedColumnWidth(30),
        IntrinsicColumnWidth(),
      ),
    );

    return Theme(
      data: ThemeData(
        scrollbarTheme: context.theme.scrollbarTheme.copyWith(
          trackColor: WidgetStatePropertyAll(context.theme.hintColor),
          thumbColor: WidgetStatePropertyAll(context.theme.scaffoldBackgroundColor),
        ),
      ),
      child: Scrollbar(
        trackVisibility: true,
        thumbVisibility: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            border: TableBorder.all(
              color: context.theme.primaryColorDark,
              borderRadius: BorderRadius.circular(12),
            ),
            defaultColumnWidth: defaultColumnWidth,
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: tableRows,
          ).marginOnly(bottom: 16),
        ),
      ),
    );
  }

  List<DropdownItemReadDto> _collectColumnItems() {
    final exelFields = CustomerParams().getExelFields();
    final items = <DropdownItemReadDto>[];
    for (final row in previewRows) {
      final data = row.data;
      if (data == null) {
        continue;
      }
      for (final entry in data.entries) {
        final entryTitle = exelFields.firstWhereOrNull((final e) => e.slug == entry.key);
        if (entryTitle != null && !items.contains(entryTitle)) {
          items.add(entryTitle);
        }
      }
    }
    return items;
  }

  TableRow _buildHeaderRow(final BuildContext context, final List<String> headers) {
    return TableRow(
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      children: headers
          .map(
            (final title) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Text(
                title,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ).labelLarge().bold(),
            ),
          )
          .toList(growable: false),
    );
  }

  TableRow _buildDataRow(final BuildContext context, final ExelPreviewRow row, final List<String> columnKeys) {
    final data = row.data ?? <String, dynamic>{};
    final statusCell = _buildStatusCell(context, row.validationErrors);
    final errorCell = _buildErrorCell(context, row.validationErrors);

    final dataCells = columnKeys
        .map(
          (final key) => _TableCellContent(
            value: data[key]?.toString() ?? '-',
          ),
        )
        .toList(growable: true);

    final rowNumberCell = _TableCellContent(
      value: (row.rowNumber ?? '-').toString(),
    );

    return TableRow(
      children: [
        rowNumberCell,
        ...dataCells,
        statusCell,
        errorCell,
      ],
    );
  }

  Widget _buildStatusCell(final BuildContext context, final List<String> validationErrors) {
    final isValid = validationErrors.isEmpty;
    final backgroundColor = (isValid ? AppColors.green : AppColors.red).withValues(alpha: 0.12);
    final textColor = isValid ? AppColors.green : AppColors.red;
    final icon = isValid ? Icons.check_rounded : Icons.warning_amber_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      margin: const EdgeInsetsDirectional.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: textColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              isValid ? 'OK' : s.error,
              style: context.textTheme.bodySmall?.copyWith(color: textColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    ).withTooltip(validationErrors.join("\n"));
  }

  Widget _buildErrorCell(final BuildContext context, final List<String> validationErrors) {
    if (validationErrors.isEmpty) {
      return const SizedBox.shrink();
    }
    return IconButton(
      icon: Text(s.show).bodySmall(
        color: context.theme.primaryColor,
        decoration: TextDecoration.underline,
        decorationColor: context.theme.primaryColor,
      ),
      // icon: Icon(Icons.remove_red_eye_rounded, color: context.theme.hintColor),
      onPressed: () {
        showAppDialog(
          AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 24,
                children: [
                  Text(validationErrors.join("\n")).bodyMedium(),
                  UElevatedButton(
                    width: double.infinity,
                    backgroundColor: context.theme.hintColor,
                    title: s.close,
                    onTap: () => UNavigator.back(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TableCellContent extends StatelessWidget {
  const _TableCellContent({
    required this.value,
  });

  final String value;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Text(
        value.isEmpty ? '-' : value,
        style: context.textTheme.bodyMedium,
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
      ).bodyMedium(),
    );
  }
}
