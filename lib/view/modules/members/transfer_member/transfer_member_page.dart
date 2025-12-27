import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../data/data.dart';
import 'transfer_member_controller.dart';

class TransferMemberPage extends StatefulWidget {
  const TransferMemberPage({
    required this.member,
    required this.department,
    required this.onResponse,
    super.key,
  });

  final MemberReadDto member;
  final HRDepartmentReadDto department;
  final Function(MemberReadDto member) onResponse;

  @override
  State<TransferMemberPage> createState() => _TransferMemberPageState();
}

class _TransferMemberPageState extends State<TransferMemberPage> with TransferMemberController {
  @override
  void initState() {
    setValues(
      department: widget.department,
      member: widget.member,
    );
    super.initState();
  }

  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 18,
        children: [
          Obx(
            () => WDropDownFormField<DropdownItemReadDto>(
              labelText: departmentsState.isLoaded() ? s.department : s.loading,
              value: selectedDepartment,
              required: true,
              showSearchField: true,
              items: getDropDownMenuItemsFromDropDownItemReadDto(menuItems: departments),
              onChanged: setNewDepartment,
            ),
          ),
          Obx(
            () => WDropDownFormField<DropdownItemReadDto>(
              labelText: workShiftsState.isLoaded() ? s.workShift : s.loading,
              value: selectedWorkShift,
              items: getDropDownMenuItemsFromDropDownItemReadDto(menuItems: workShifts),
              onChanged: (final value) => selectedWorkShift = value,
            ),
          ),
          Obx(
            () => UElevatedButton(
              width: double.infinity,
              title: s.submit,
              isLoading: buttonState.isLoading(),
              onTap: () => onSubmit(
                member: widget.member,
                onResponse: (final member) {
                  widget.onResponse(member);
                  UNavigator.back();
                },
              ),
            ).marginOnly(top: 100),
          ),
        ],
      ),
    );
  }
}
