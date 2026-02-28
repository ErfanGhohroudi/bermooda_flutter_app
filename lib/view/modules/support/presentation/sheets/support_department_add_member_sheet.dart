import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../domain/entities/support_department.dart';
import '../controllers/support_department_add_member_controller.dart';

class SupportDepartmentAddMemberSheet extends StatefulWidget {
  const SupportDepartmentAddMemberSheet({
    required this.department,
    super.key,
  });

  final SupportDepartment department;

  @override
  State<SupportDepartmentAddMemberSheet> createState() => _SupportDepartmentAddMemberSheetState();
}

class _SupportDepartmentAddMemberSheetState extends State<SupportDepartmentAddMemberSheet>
    with SupportDepartmentAddMemberController {
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
    return Obx(
      () => pageState.isLoaded()
          ? Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 18,
                  children: [
                    WMembersPickerFormField(
                      labelText: s.accessibleMembers,
                      helperText: s.accessibleMembersHelper(s.department.toLowerCase()),
                      members: members,
                      showSelf: false,
                      required: true,
                      selectedMembers: selectedMembers,
                      onConfirm: (final list) {
                        selectedMembers = list;
                      },
                    ),
                    Obx(
                      () => UElevatedButton(
                        width: double.maxFinite,
                        title: s.submit,
                        isLoading: buttonState.isLoading(),
                        onTap: onSubmit,
                      ),
                    ).marginOnly(top: 100),
                  ],
                ),
              ),
            ).container().onTap(
              () => FocusManager.instance.primaryFocus?.unfocus(),
            )
          : const SizedBox(height: 300, child: Center(child: WCircularLoading())),
    );
  }
}
