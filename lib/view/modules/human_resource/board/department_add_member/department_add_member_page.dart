import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../data/data.dart';
import 'department_add_member_controller.dart';

class DepartmentAddMemberPage extends StatefulWidget {
  const DepartmentAddMemberPage({
    required this.department,
    required this.onResponse,
    super.key,
  });

  final HRDepartmentReadDto department;
  final Function(HRDepartmentReadDto department) onResponse;

  @override
  State<DepartmentAddMemberPage> createState() => _DepartmentAddMemberPageState();
}

class _DepartmentAddMemberPageState extends State<DepartmentAddMemberPage> with DepartmentAddMemberController {
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
                        onTap: () => onSubmit(
                          onResponse: (final project) {
                            widget.onResponse(project);
                            UNavigator.back();
                          },
                        ),
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
