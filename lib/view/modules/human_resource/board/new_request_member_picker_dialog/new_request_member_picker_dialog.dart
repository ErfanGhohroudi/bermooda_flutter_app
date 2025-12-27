import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../data/data.dart';
import '../hr_board_controller.dart';
import 'new_request_member_picker_controller.dart';

Future<MemberReadDto?> showRequestMemberPickerDialog(final HRDepartmentReadDto department, final HRBoardController boardCtrl) async {
  final result = await bottomSheetWithNoScroll<MemberReadDto>(
    title: s.membersList,
    child: _NewRequestMemberPickerDialog(
      department: department,
      boardCtrl: boardCtrl,
    ),
  );
  return result;
}

class _NewRequestMemberPickerDialog extends StatefulWidget {
  const _NewRequestMemberPickerDialog({
    required this.department,
    required this.boardCtrl,
  });

  final HRDepartmentReadDto department;
  final HRBoardController boardCtrl;

  @override
  State<_NewRequestMemberPickerDialog> createState() => _NewRequestMemberPickerDialogState();
}

class _NewRequestMemberPickerDialogState extends State<_NewRequestMemberPickerDialog> with NewRequestMemberPickerController {
  @override
  void initState() {
    initialController(widget.department);
    super.initState();
  }

  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      height: context.height / 2,
      child: UScaffold(
        bottomNavigationBar: Obx(
          () {
            if (!pageState.isLoaded()) {
              return const SizedBox.shrink();
            }
            return UElevatedButton(
              enable: selectedMember != null,
              title: s.select,
              onTap: () {
                Navigator.pop(context, selectedMember);
              },
            );
          },
        ),
        body: Obx(
          () {
            if (!pageState.isLoaded()) {
              return _buildLoadingList();
            }
            return _buildMembersList();
          },
        ),
      ),
    );
  }

  Widget _buildMembersList() => Obx(
        () {
          if (members.isEmpty) {
            return const Center(child: WEmptyWidget());
          }
          return WSmartRefresher(
            controller: refreshController,
            enablePullDown: false,
            onLoading: loadNextListPage,
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (final context, final index) {
                final member = members[index];
                final memberFullName = member.fullName;

                final isSelected = member.id == selectedMember?.id;

                return _buildCheckboxListTile(
                  selected: isSelected,
                  child: WCircleAvatar(
                    size: 50,
                    user: UserReadDto(
                      id: member.userAccount?.id.toString() ?? '',
                      avatarUrl: member.userAccount?.avatarUrlMain?.url,
                      fullName: memberFullName,
                    ),
                    showFullName: true,
                    maxLines: 2,
                  ),
                  onChanged: (final value) {
                    if ((value ?? false) == false) return;
                    setState(() => setSelectedMember(member));
                  },
                );
              },
            ),
          );
        },
      );

  Widget _buildLoadingList() => ListView.builder(
        itemCount: 15,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (final context, final index) => _buildCheckboxListTile(
          onChanged: (final value) {},
          child: Row(
            spacing: 10,
            children: [
              const WCircleAvatar(
                user: UserReadDto(id: ''),
                size: 50,
              ),
              Container(
                height: 10,
                width: context.width / 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ).shimmer();

  Widget _buildCheckboxListTile({
    required final Function(bool? value) onChanged,
    final bool selected = false,
    final Widget? child,
  }) =>
      CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        side: WidgetStateBorderSide.resolveWith(
          (final states) {
            if (states.contains(WidgetState.selected)) {
              return const BorderSide(color: AppColors.green, width: 2);
            }
            return const BorderSide(
              color: Colors.grey,
              width: 2,
            );
          },
        ),
        checkboxShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        checkColor: Colors.white,
        activeColor: AppColors.green,
        value: selected,
        selected: selected,
        checkboxScaleFactor: 1.2,
        title: child,
        onChanged: onChanged,
      );
}
