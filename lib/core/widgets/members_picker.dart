part of 'widgets.dart';

class WMembersPickerFormField extends StatefulWidget {
  const WMembersPickerFormField({
    required this.labelText,
    required this.selectedMembers,
    required this.onConfirm,
    this.members,
    this.helperText,
    this.required = false,
    this.showSelf = false,
    this.filterByPermissionName,
    super.key,
  }) : assert(
         members == null || filterByPermissionName == null,
         'WMembersPickerFormField => Cannot provide both members and filterByPermissionName.',
       );

  final String labelText;
  final String? helperText;
  final List<UserReadDto>? members;
  final List<UserReadDto> selectedMembers;
  final Function(List<UserReadDto> list) onConfirm;
  final bool required;
  final bool showSelf;
  final PermissionName? filterByPermissionName;

  @override
  State<WMembersPickerFormField> createState() => _WMembersPickerFormFieldState();
}

class _WMembersPickerFormFieldState extends State<WMembersPickerFormField> {
  List<UserReadDto> members = [];
  List<UserReadDto> selectedMembers = [];
  bool isLoaded = false;

  @override
  void initState() {
    selectedMembers = widget.selectedMembers;
    if (widget.members != null) {
      members = widget.members ?? [];
      isLoaded = true;
    } else {
      _getAllMembers();
    }
    super.initState();
  }

  void _getAllMembers() {
    Get.find<MemberDatasource>().getAllMembers(
      perName: widget.filterByPermissionName,
      onResponse: (final response) {
        if (!mounted) return;
        setState(() {
          members.assignAll(response.resultList ?? []);
          isLoaded = true;
        });
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  // متدی برای باز کردن دیالوگ انتخاب
  void _openSelectionDialog(final FormFieldState<List<UserReadDto>> state) async {
    // اگر لیبل‌ها هنوز لود نشده‌اند، کاری نکن
    if (isLoaded == false) return;

    final List<UserReadDto> result = await showMemberPickerMultiSelectDialog(
      members: widget.showSelf ? members : members.where((final user) => (user.isSelf ?? false) == false).toList(),
      initialMembers: selectedMembers,
      showAccessType: widget.filterByPermissionName != null,
    );

    state.didChange(result);
    selectedMembers = result;
    widget.onConfirm(selectedMembers);
  }

  @override
  void didUpdateWidget(covariant final WMembersPickerFormField oldWidget) {
    if (oldWidget.selectedMembers != widget.selectedMembers) {
      setState(() {
        selectedMembers = widget.selectedMembers;
      });
    }
    if (oldWidget.members != widget.members && widget.members != null) {
      setState(() {
        members = widget.members ?? [];
        isLoaded = true;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(final BuildContext context) {
    return FormField<List<UserReadDto>>(
      initialValue: selectedMembers,
      validator: widget.required ? validateNotEmpty(requiredMessage: s.requiredField) : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (final formFieldState) => InkWell(
        onTap: () => _openSelectionDialog(formFieldState),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: isLoaded ? widget.labelText : s.loading,
            labelStyle: context.textTheme.bodyMedium!.copyWith(
              fontSize: (context.textTheme.bodyMedium!.fontSize ?? 12) + 2,
              color: context.theme.hintColor,
            ),
            helperText: widget.helperText,
            helperStyle: context.textTheme.bodySmall?.copyWith(color: context.theme.hintColor),
            helperMaxLines: 2,
            floatingLabelStyle: context.textTheme.bodyLarge!,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            errorText: formFieldState.errorText,
            suffixIcon: Container(
              margin: const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
              child: const Icon(Icons.arrow_drop_down_rounded, size: 30),
            ),
          ),
          isEmpty: selectedMembers.isEmpty,
          child: selectedMembers.isEmpty
              ? const SizedBox.shrink()
              : Wrap(
                  spacing: 6.0,
                  runSpacing: 6.0,
                  children: selectedMembers.map((final user) {
                    return WLabel(
                      user: user,
                      color: context.theme.primaryColor,
                    );
                  }).toList(),
                ),
        ),
      ),
    );
  }
}
