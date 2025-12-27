import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../data/data.dart';
import 'project_add_member_controller.dart';

class ProjectAddMemberPage extends StatefulWidget {
  const ProjectAddMemberPage({
    required this.project,
    required this.onResponse,
    super.key,
  });

  final ProjectReadDto project;
  final Function(ProjectReadDto project) onResponse;

  @override
  State<ProjectAddMemberPage> createState() => _ProjectAddMemberPageState();
}

class _ProjectAddMemberPageState extends State<ProjectAddMemberPage> with ProjectAddMemberController {
  @override
  void initState() {
    project = widget.project;
    getMembers();
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
            ).container().onTap(() => FocusManager.instance.primaryFocus?.unfocus(),)
          : const SizedBox(height: 300, child: Center(child: WCircularLoading())),
    );
  }
}
