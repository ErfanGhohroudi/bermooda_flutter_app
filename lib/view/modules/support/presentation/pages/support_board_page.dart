import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/utils/extensions/color_extension.dart';
import '../../../../../core/widgets/kanban_board/kanban_board.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../domain/entities/support_customer_entity.dart';
import '../../domain/entities/support_department.dart';
import '../controllers/support_board_controller.dart';
import '../sheets/support_department_add_member_sheet.dart';
import '../widgets/support_customer_card.dart';
import '../../domain/entities/support_section.dart';

import '../sheets/support_create_update_section_sheet.dart';

/// must pass SupportBoardBinding(department: department) to binding in Navigator.
class SupportBoardPage extends GetView<SupportBoardController> {
  const SupportBoardPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.theme.primaryColorDark),
        title: Obx(
          () => Text(
            "${controller.department.title}${controller.isWebSocketConnect.value ? "" : " (${s.connecting})"}",
          ).bodyMedium(color: context.theme.primaryColorDark),
        ),
        backgroundColor: context.theme.cardColor,
      ),
      body: Obx(
        () => controller.kanbanController.sections.isEmpty
            ? _kanbanBoardShimmer()
            : WKanbanBoard<SupportSection, SupportCustomer>(
                controller: controller.kanbanController,
                headerOfAddNewSectionPage: _addSectionHeaderBuilder(context),
                addNewSectionPageBody: _addSectionPage(context),
                sectionHeaderBuilder: (final section) => _sectionHeaderBuilder(context, section),
                itemBuilder: (final section, final item, final outerScrollController) => SupportCustomerCard(
                  customer: item.data,
                  onTap: (final room) => controller.onCardTap(room),
                ),
              ),
      ),
    );
  }

  Widget _sectionBuilder(final BuildContext context, final Section<SupportSection, SupportCustomer> section) => Container(
    width: context.width,
    color: section.data?.colorCode?.toColor() ?? Colors.grey,
    child: ListTile(
      leading: section.data?.icon != null ? UImage(section.data!.icon!.url ?? '', size: 30, color: Colors.white) : null,
      title: Text(section.data?.title ?? '', maxLines: 2).bodyLarge(color: Colors.white),
      trailing:
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(s.edit).bodySmall(color: Colors.white),
          ).onTap(
            () => bottomSheet(
              title: s.editSection,
              child: SupportCreateUpdateSectionSheet(
                departmentId: controller.department.id,
                controller: controller,
                section: section,
              ),
            ),
          ),
    ),
  );

  Widget _sectionHeaderBuilder(final BuildContext context, final Section<SupportSection, SupportCustomer> section) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      _sectionBuilder(context, section),
    ],
  );

  Widget? _addSectionPage(final BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 24,
      children: [
        const SizedBox(height: 100),
        UImage(AppImages.team, size: 200, color: context.theme.hintColor),
        UElevatedButton(
          width: 200,
          title: s.addMember,
          backgroundColor: AppColors.green,
          onTap: () async {
            final updatedDepartment = await bottomSheet<SupportDepartment>(
              title: s.addMember,
              child: SupportDepartmentAddMemberSheet(department: controller.department),
            );

            if (updatedDepartment != null) {
              controller.department = updatedDepartment;
            }
          },
        ),
      ],
    );
  }

  Widget _addSectionHeaderBuilder(final BuildContext context) => Container(
    width: context.width,
    margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
    decoration: BoxDecoration(
      color: Colors.blueGrey,
      borderRadius: BorderRadius.circular(15),
    ),
    child: ListTile(
      leading: const Icon(Icons.add, size: 30, color: Colors.white),
      title: Text(s.newSection).bodyLarge(color: Colors.white),
      onTap: () {
        bottomSheet(
          title: s.newSection,
          child: SupportCreateUpdateSectionSheet(
            departmentId: controller.department.id,
            controller: controller,
          ),
        );
      },
    ),
  );

  Widget _kanbanBoardShimmer() => SingleChildScrollView(
    physics: const NeverScrollableScrollPhysics(),
    child: Column(
      children: [
        Container(
          width: double.maxFinite,
          height: 60,
          color: Colors.grey,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: 3,
          separatorBuilder: (final context, final index) => const SizedBox(height: 10),
          itemBuilder: (final context, final index) => Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                Container(
                  width: double.infinity,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey,
                  ),
                ),
                ListView.separated(
                  itemCount: 2,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (final context, final index) => const SizedBox(height: 5),
                  itemBuilder: (final context, final index) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      spacing: 15,
                      children: [
                        Container(
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey,
                          ),
                        ).expanded(),
                        const CircleAvatar(radius: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ).shimmer();
}
