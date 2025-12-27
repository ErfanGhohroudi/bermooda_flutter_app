import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../data/data.dart';
import 'legal_department_add_member_controller.dart';

class LegalDepartmentAddMemberPage extends StatefulWidget {
  const LegalDepartmentAddMemberPage({
    required this.department,
    super.key,
  });

  final LegalDepartmentReadDto department;

  @override
  State<LegalDepartmentAddMemberPage> createState() => _LegalDepartmentAddMemberPageState();
}

class _LegalDepartmentAddMemberPageState extends State<LegalDepartmentAddMemberPage> with LegalDepartmentAddMemberController {
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
                      helperText: s.projectAccessibleMembersHelper,
                      members: members,
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
                        onTap: () => onSubmit(),
                      ),
                    ).marginOnly(top: 100),
                  ],
                ),
              ),
            ).container().onTap(() => FocusManager.instance.primaryFocus?.unfocus())
          : const SizedBox(height: 300, child: Center(child: WCircularLoading())),
    );
  }
}
