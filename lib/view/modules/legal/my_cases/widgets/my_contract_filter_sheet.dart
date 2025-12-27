import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/widgets/fields/fields.dart';
import '../../../../../core/widgets/fields/labels_dropdown_new/labels_dropdown_new.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../data/data.dart';
import '../my_cases_controller.dart';

class MyContractFilterSheet extends StatefulWidget {
  const MyContractFilterSheet({
    required this.controller,
    super.key,
  });

  final MyCasesController controller;

  @override
  State<MyContractFilterSheet> createState() => _MyContractFilterSheetState();
}

class _MyContractFilterSheetState extends State<MyContractFilterSheet> {
  String? _itemType;
  String? _fromDate;
  String? _toDate;
  String? _fromDueDate;
  String? _toDueDate;
  UserReadDto? _selectedResponsibleMember;
  final RxList<UserReadDto> _members = <UserReadDto>[].obs;
  final Rx<PageState> _membersState = PageState.loading.obs;
  LabelReadDto? _selectedLabel;
  late final LegalLabelDatasource _labelDatasource;

  @override
  void initState() {
    super.initState();
    _itemType = widget.controller.filterItemType;
    _fromDate = widget.controller.filterFromDate;
    _toDate = widget.controller.filterToDate;
    _fromDueDate = widget.controller.filterFromDueDate;
    _toDueDate = widget.controller.filterToDueDate;
    _labelDatasource = LegalLabelDatasource();
    if (widget.controller.filterLabelId != null) {
      _selectedLabel = LabelReadDto(id: widget.controller.filterLabelId);
    }
    _loadMembers();
  }

  void _loadMembers() {
    final MemberDatasource datasource = Get.find<MemberDatasource>();
    _membersState.loading();
    datasource.getSourceMembers(
      sourceType: MemberSourceType.legalDepartment,
      sourceId: widget.controller.legalDepartmentId.toString(),
      onResponse: (final response) {
        if (!mounted) return;
        _members.assignAll(response.resultList ?? []);
        if (widget.controller.filterResponsibleId != null) {
          _selectedResponsibleMember = _members.firstWhereOrNull(
            (final member) => member.id == widget.controller.filterResponsibleId?.toString(),
          );
        }
        _membersState.loaded();
      },
      onError: (final errorResponse) {
        if (!mounted) return;
        _membersState.loaded();
      },
      withRetry: true,
    );
  }

  @override
  void dispose() {
    _members.close();
    _membersState.close();
    super.dispose();
  }

  void _applyFilters() {
    widget.controller.applyAdvancedFilters(
      itemType: _itemType,
      fromDate: _fromDate,
      toDate: _toDate,
      fromDueDate: _fromDueDate,
      toDueDate: _toDueDate,
      responsibleId: _selectedResponsibleMember?.id != null ? int.tryParse(_selectedResponsibleMember!.id) : null,
      labelId: _selectedLabel?.id,
    );
    UNavigator.back();
  }

  void _clearFilters() {
    setState(() {
      _itemType = null;
      _fromDate = null;
      _toDate = null;
      _fromDueDate = null;
      _toDueDate = null;
      _selectedResponsibleMember = null;
      _selectedLabel = null;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 18,
      children: [
        // Item Type
        WDropDownFormField<String?>(
          labelText: s.type,
          value: _itemType,
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: WDropdownItemText(text: s.all),
            ),
            DropdownMenuItem<String?>(
              value: 'tracking',
              child: WDropdownItemText(text: s.followUp),
            ),
            DropdownMenuItem<String?>(
              value: 'checklist',
              child: WDropdownItemText(text: s.task),
            ),
          ],
          onChanged: (final value) {
            setState(() {
              _itemType = value;
            });
          },
        ),

        // Responsible Member
        if (widget.controller.haveAdminAccess)
          Obx(
            () => WDropDownFormField<String>(
              labelText: _membersState.isLoaded() ? s.assignee : s.loading,
              value: _selectedResponsibleMember?.id,
              items: _members
                  .map(
                    (final UserReadDto member) => DropdownMenuItem<String>(
                      value: member.id,
                      child: WCircleAvatar(
                        user: member,
                        showFullName: true,
                        size: 30,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (final memberId) {
                setState(() {
                  _selectedResponsibleMember = _members.firstWhereOrNull(
                    (final member) => member.id == memberId,
                  );
                });
              },
            ),
          ),

        // Label
        WLabelsDropDownFormFieldNew(
          sourceId: widget.controller.legalDepartmentId.toString(),
          datasource: _labelDatasource,
          labelText: s.label,
          value: _selectedLabel,
          onChanged: (final value) {
            setState(() {
              _selectedLabel = value;
            });
          },
        ),

        // Tracking Date Range
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.startDate).bodyMedium().bold(),
            const SizedBox(height: 8),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: WDatePickerField(
                    initialValue: _fromDate,
                    labelText: s.from,
                    showYearSelector: true,
                    onConfirm: (final date, final compactDate) {
                      setState(() => _fromDate = compactDate);
                    },
                  ),
                ),
                Expanded(
                  child: WDatePickerField(
                    initialValue: _toDate,
                    labelText: s.to,
                    showYearSelector: true,
                    onConfirm: (final date, final compactDate) {
                      setState(() => _toDate = compactDate);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),

        // Due Date Range
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.dueDate).bodyMedium().bold(),
            const SizedBox(height: 8),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: WDatePickerField(
                    initialValue: _fromDueDate,
                    labelText: s.from,
                    showYearSelector: true,
                    onConfirm: (final date, final compactDate) {
                      setState(() => _fromDueDate = compactDate);
                    },
                  ),
                ),
                Expanded(
                  child: WDatePickerField(
                    initialValue: _toDueDate,
                    labelText: s.to,
                    showYearSelector: true,
                    onConfirm: (final date, final compactDate) {
                      setState(() => _toDueDate = compactDate);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),

        // Buttons
        Row(
          spacing: 12,
          children: [
            Expanded(
              child: UElevatedButton(
                title: s.clear,
                backgroundColor: context.theme.hintColor,
                onTap: _clearFilters,
              ),
            ),
            Expanded(
              child: UElevatedButton(
                title: s.apply,
                onTap: _applyFilters,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
