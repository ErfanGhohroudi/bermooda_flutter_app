part of '../../../../core/widgets/widgets.dart';

enum SelectionMode {
  single,
  multi,
}

void showReviewerSelectionBottomSheet({
  /// لیست کاربران انتخاب شده
  required final List<ReviewerEntity> selectedReviewers,

  /// لیست کاربران موجود برای انتخاب
  required final List<ReviewerEntity> availableReviewers,

  /// تابع callback که هنگام تغییر انتخاب فراخوانی می‌شود
  required final Function(List<ReviewerEntity> selectedReviewers) onSelectionChanged,

  /// حالت انتخاب: تک انتخابی یا چند انتخابی
  final SelectionMode mode = SelectionMode.multi,

  /// عنوان باتم شیت
  final String? title,

  /// زیرعنوان باتم شیت
  final String? subtitle,

  /// متن راهنما در پایین زیر عنوان
  final String? helperText,

  /// متن راهنمای فیلد جستجو
  final String? searchHint,

  /// متن دکمه تایید
  final String? confirmButtonText,

  /// متن دکمه لغو
  final String? cancelButtonText,

  /// آیا کاربران انتخاب شده نمایش داده شوند
  final bool showSelectedUsers = true,

  /// حداکثر ارتفاع لیست
  final double? maxHeight,
}) {
  bottomSheetWithNoScroll<List<ReviewerEntity>>(
    withBottomKeyboardPadding: false,
    title: title ?? '',
    backgroundColor: Colors.transparent,
    childBuilder: (final context) => _ReviewerSelectionBottomSheet(
      selectedReviewers: selectedReviewers,
      availableReviewers: availableReviewers,
      mode: mode,
      subtitle: subtitle,
      searchHint: searchHint,
      helperText: helperText,
      confirmButtonText: confirmButtonText,
      cancelButtonText: cancelButtonText,
      showSelectedUsers: showSelectedUsers,
      maxHeight: maxHeight,
      onSelectionChanged: onSelectionChanged,
    ),
  );
}

class _ReviewerSelectionBottomSheet extends StatefulWidget {
  const _ReviewerSelectionBottomSheet({
    required this.selectedReviewers,
    required this.availableReviewers,
    required this.mode,
    required this.onSelectionChanged,
    this.subtitle,
    this.helperText,
    this.searchHint,
    this.confirmButtonText,
    this.cancelButtonText,
    this.showSelectedUsers = true,
    this.maxHeight,
  });

  final List<ReviewerEntity> selectedReviewers;
  final List<ReviewerEntity> availableReviewers;
  final SelectionMode mode;
  final Function(List<ReviewerEntity> selectedReviewers) onSelectionChanged;
  final String? subtitle;
  final String? helperText;
  final String? searchHint;
  final String? confirmButtonText;
  final String? cancelButtonText;
  final bool showSelectedUsers;
  final double? maxHeight;

  @override
  State<_ReviewerSelectionBottomSheet> createState() => _ReviewerSelectionBottomSheetState();
}

class _ReviewerSelectionBottomSheetState extends State<_ReviewerSelectionBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<ReviewerEntity> _filteredReviewers = [];
  List<ReviewerEntity> _currentSelectedReviewers = [];

  @override
  void initState() {
    super.initState();
    _currentSelectedReviewers = List.from(widget.selectedReviewers);
    _filteredReviewers = List.from(widget.availableReviewers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterUsers(final String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredReviewers = List.from(widget.availableReviewers);
      } else {
        _filteredReviewers = widget.availableReviewers.where((final user) => (user.user.fullName?.toLowerCase().contains(query.toLowerCase()) ?? false)).toList();
      }
    });
  }

  void _toggleUserSelection(final ReviewerEntity reviewer) {
    setState(() {
      final isSelected = _currentSelectedReviewers.any((final selected) => selected.user.id == reviewer.user.id);

      if (isSelected) {
        // حذف کاربر از لیست انتخاب شده
        _currentSelectedReviewers.removeWhere((final selected) => selected.user.id == reviewer.user.id);
      } else {
        if (widget.mode == SelectionMode.single) {
          // در حالت تک انتخابی، فقط یک کاربر انتخاب می‌شود
          _currentSelectedReviewers.clear();
        }
        // اضافه کردن کاربر به لیست انتخاب شده
        _currentSelectedReviewers.add(reviewer);
      }
    });
  }

  void _submitSelection() {
    bool isNotValid = _currentSelectedReviewers.any((final e) => e.validate() == false);

    if (isNotValid) return AppNavigator.snackbarRed(title: s.error, subtitle: s.selectReviewDeadline);

    widget.onSelectionChanged(_currentSelectedReviewers);
    Navigator.of(context).pop(_currentSelectedReviewers);
  }

  void _cancelSelection() {
    Navigator.of(context).pop();
  }

  bool _isReviewerSelected(final ReviewerEntity reviewer) {
    return _currentSelectedReviewers.any((final selected) => selected.user.id == reviewer.user.id);
  }

  Widget? _getUserSubtitle(final ReviewerEntity reviewer) {
    if (reviewer.user.permissions == null || (reviewer.user.permissions?.isEmpty ?? false)) return null;
    List<String> subtitle = [];

    if (reviewer.user.type.isOwner()) {
      subtitle.add(reviewer.user.type!.getTitle());
    } else {
      for (var per in reviewer.user.permissions!) {
        final perName = per.permissionName?.getTitle();
        final perType = per.permissionType?.getTitle();
        final showPermission = per.permissionType == PermissionType.manager || per.permissionName == PermissionName.humanResources;

        if (perName != null && showPermission) {
          subtitle.add("$perType ($perName)");
        }
      }
    }

    return Text(subtitle.join(' , ')).bodySmall(color: context.theme.hintColor);
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            if (widget.subtitle != null) Text(widget.subtitle!).bodyMedium(color: context.theme.hintColor),
            if (widget.helperText != null)
              RichText(
                text: TextSpan(
                  style: context.textTheme.bodyMedium?.copyWith(color: context.theme.hintColor),
                  children: [
                    TextSpan(
                      text: "${s.help}: ",
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.theme.hintColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: widget.helperText!),
                  ],
                ),
              ),
          ],
        ).marginOnly(bottom: widget.subtitle != null || widget.helperText != null ? 16 : 0),

        // Search field
        WSearchField(
          controller: _searchController,
          hintText: widget.searchHint ?? s.search,
          onChanged: _filterUsers,
        ).marginOnly(bottom: 16),

        // Available users section
        Center(
          child: Text(s.userSelection).bodyMedium().bold(),
        ).marginOnly(bottom: 8),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: context.theme.dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            constraints: const BoxConstraints(minHeight: 100),
            padding: const EdgeInsetsDirectional.symmetric(vertical: 5),
            child: Scrollbar(
              child: ListView.builder(
                itemCount: _filteredReviewers.length,
                itemBuilder: (final context, final index) {
                  final reviewer = _filteredReviewers[index];
                  final isSelected = _isReviewerSelected(reviewer);

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? context.theme.primaryColor.withAlpha(30) : Colors.transparent,
                      border: Border(
                        bottom: BorderSide(
                          color: context.theme.dividerColor,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: InkWell(
                      onTap: () => _toggleUserSelection(reviewer),
                      child: Row(
                        spacing: 10,
                        children: [
                          // CheckBox
                          if (widget.mode == SelectionMode.multi)
                            WCheckBox(
                              isChecked: isSelected,
                              size: 20,
                              onChanged: (final _) => _toggleUserSelection(reviewer),
                            ),

                          // Avatar And FullName
                          WCircleAvatar(
                            user: reviewer.user,
                            size: 40,
                            showFullName: true,
                            subTitle: _getUserSubtitle(reviewer),
                          ).expanded(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ).marginOnly(bottom: 16),
        ),

        // Selected users section
        if (widget.showSelectedUsers && _currentSelectedReviewers.isNotEmpty) ...[
          Center(child: Text(s.selectedUsers).bodyMedium().bold().marginOnly(bottom: 8)),
          Container(
            constraints: BoxConstraints(maxHeight: context.height / 4),
            decoration: BoxDecoration(
              border: Border.all(color: context.theme.dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.separated(
              itemCount: _currentSelectedReviewers.length,
              shrinkWrap: _currentSelectedReviewers.length < 4,
              physics: _currentSelectedReviewers.length < 4 ? const NeverScrollableScrollPhysics() : null,
              separatorBuilder: (final context, final index) => Divider(height: 0, color: context.theme.dividerColor.withAlpha(120)),
              itemBuilder: (final context, final index) {
                final reviewer = _currentSelectedReviewers[index];

                return ListTile(
                  contentPadding: const EdgeInsetsDirectional.only(start: 16),
                  title: WCircleAvatar(
                    user: reviewer.user,
                    size: 40,
                    maxLines: 2,
                    showFullName: true,
                    subTitle: widget.mode == SelectionMode.multi ? Text('${s.priority}: ${index + 1}').bodySmall(color: context.theme.hintColor).bold() : null,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.mode == SelectionMode.multi)
                        Container(
                          padding: const EdgeInsetsDirectional.symmetric(horizontal: 6, vertical: 5),
                          decoration: BoxDecoration(
                            color: context.theme.hintColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: InkWell(
                            onTap: () async {
                              final jalaliDate = await DateAndTimeFunctions.showCustomPersianDatePicker(
                                startDate: Jalali.now(),
                                initialDate: reviewer.reviewDeadlineDate?.toJalali(),
                              );
                              if (jalaliDate != null && mounted) {
                                setState(() {
                                  _currentSelectedReviewers[index] = reviewer.copyWith(reviewDeadlineDate: jalaliDate.toDateTime());
                                });
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 3,
                              children: [
                                UImage(AppIcons.calendarOutline, size: 15, color: context.theme.hintColor),
                                Text(reviewer.reviewDeadlineDate?.toJalaliDateString ?? s.deadline).bodySmall(color: context.theme.hintColor).bold(),
                                Icon(Icons.keyboard_arrow_down_rounded, size: 15, color: context.theme.hintColor),
                              ],
                            ),
                          ),
                        ),
                      IconButton(
                        tooltip: s.remove,
                        onPressed: () => _toggleUserSelection(reviewer),
                        icon: const UImage(AppIcons.closeCircle, size: 25),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],

        // Bottom buttons
        Row(
          children: [
            UElevatedButton(
              title: widget.cancelButtonText ?? s.cancel,
              backgroundColor: context.theme.hintColor,
              onTap: _cancelSelection,
            ).expanded(),
            const SizedBox(width: 10),
            UElevatedButton(
              title: widget.confirmButtonText ?? s.confirm,
              onTap: _submitSelection,
            ).expanded(),
          ],
        ).marginOnly(top: 10),
      ],
    );
  }
}
