import 'package:u/utilities.dart';

import '../../../../data/data.dart';
import '../../../core.dart';
import '../../../theme.dart';
import '../../widgets.dart';
import 'projects_dropdown_controller.dart';

class WProjectsDropdownFormField extends StatefulWidget {
  const WProjectsDropdownFormField({
    required this.onChanged,
    this.value,
    this.required = false,
    this.showRequiredIcon,
    this.isManager = false,
    super.key,
  });

  final Function(ProjectReadDto? value) onChanged;
  final ProjectReadDto? value;
  final bool required;
  final bool? showRequiredIcon;
  final bool isManager;

  @override
  State<WProjectsDropdownFormField> createState() => _WProjectsDropdownFormFieldState();
}

class _WProjectsDropdownFormFieldState extends State<WProjectsDropdownFormField> with ProjectsDropdownController {
  @override
  void initState() {
    selectedProject = widget.value;
    getProjects();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant final WProjectsDropdownFormField oldWidget) {
    if (oldWidget.value != widget.value) {
      setState(() {
        selectedProject = widget.value;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    listState.close();
    projects.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => WDropDownFormField<ProjectReadDto>(
        key: dropdownKey.value,
        labelText: listState.isLoaded() ? s.project : s.loading,
        value: selectedProject,
        required: widget.required,
        showRequiredIcon: widget.showRequiredIcon,
        selectedItemBuilder: projects.isNotEmpty
            ? (final context) => List<DropdownMenuItem<ProjectReadDto>>.generate(
                  widget.isManager ? projects.length + 1 : projects.length,
                  (final index) {
                    final bool isOk = widget.isManager ? ((index - 1) >= 0) : true;
                    final ProjectReadDto project = widget.isManager && isOk ? projects[index - 1] : projects[index];

                    return DropdownMenuItem<ProjectReadDto>(
                      value: isOk ? project : null,
                      child: isOk ? _buildSelectedItemWidget() : const SizedBox(),
                    );
                  },
                )
            : null,
        items: listState.isLoaded()
            ? [
                if (widget.isManager) _buildCreateProjectMenuItem(),
                ...List<DropdownMenuItem<ProjectReadDto>>.generate(
                  projects.length,
                  (final index) => _buildProjectMenuItem(index),
                ),
              ]
            : [],
        onChanged: (final value) {
          if (value == null) {
            selectedProject = value;
          } else if (projects.contains(value)) {
            selectedProject = value;
          }
          widget.onChanged(selectedProject);
          listState.refresh();
        },
      ),
    );
  }

  /// متد کمکی برای ساخت ویجت آیتم انتخاب شده
  Widget _buildSelectedItemWidget() {
    return Text(
      selectedProject?.title ?? '',
      maxLines: 2,
    ).bodyMedium(
      overflow: TextOverflow.ellipsis,
      fontSize: (navigatorKey.currentContext!.textTheme.bodyMedium!.fontSize ?? 12) + 2,
    );
  }

  /// متد کمکی برای ساخت آیتم "ایجاد پروژه جدید"
  DropdownMenuItem<ProjectReadDto> _buildCreateProjectMenuItem() {
    return DropdownMenuItem<ProjectReadDto>(
      value: ProjectReadDto(),
      child: Container(
        width: context.width,
        color: Colors.transparent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Row(
                spacing: 5,
                children: [
                  Icon(Icons.add_rounded, size: 20, color: context.theme.primaryColor),
                  Text(s.newProject).titleMedium(color: context.theme.primaryColor),
                ],
              ),
              const Spacer(),
              if (projects.isNotEmpty) const Divider(),
            ],
          ),
        ),
      ).onTap(
        () {
          UNavigator.back();
          delay(
            50,
            () {
              showCreateUpdateProjectDialog();
            },
          );
        },
      ),
    );
  }

  /// متد کمکی برای ساخت هر آیتم پروژه در لیست
  DropdownMenuItem<ProjectReadDto> _buildProjectMenuItem(final int index) {
    return DropdownMenuItem<ProjectReadDto>(
      value: projects[index],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          WDropdownItemText(text: projects[index].title ?? ''),
          if (widget.isManager)
            Icon(
              Icons.more_vert_rounded,
              color: context.theme.hintColor,
            ).showMenus([
              WPopupMenuItem(
                title: s.edit,
                titleColor: AppColors.green,
                icon: AppIcons.editOutline,
                iconColor: AppColors.green,
                onTap: () {
                  UNavigator.back();
                  delay(
                    50,
                    () {
                      showCreateUpdateProjectDialog(
                        project: projects[index],
                      );
                    },
                  );
                },
              ),
              WPopupMenuItem(
                title: s.delete,
                titleColor: AppColors.red,
                icon: AppIcons.delete,
                iconColor: AppColors.red,
                onTap: () {
                  UNavigator.back();
                  delay(
                    50,
                    () {
                      appShowYesCancelDialog(
                        title: s.delete,
                        description: s.areYouSureToDeleteMessage,
                        yesButtonTitle: s.delete,
                        yesBackgroundColor: AppColors.red,
                        onYesButtonTap: () {
                          UNavigator.back();
                          deleteProject(
                            projects[index],
                            action: () {
                              if (selectedProject?.id == projects[index].id) {
                                setState(() {
                                  selectedProject = null;
                                });
                                widget.onChanged(selectedProject);
                              }
                              projects.removeAt(index);
                              listState.refresh();
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ]),
        ],
      ),
    );
  }
}
