import 'package:u/utilities.dart';

import '../../../../core/widgets/chevron_painter.dart';
import '../../../../core/utils/extensions/color_extension.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/widgets/kanban_board/kanban_board.dart';
import '../../../../core/core.dart';
import '../../../../core/theme.dart';
import '../../../../data/data.dart';
import 'category_add_member/crm_category_add_member_page.dart';
import '../../crm/board/pending_list/crm_pending_list_page.dart';
import 'widgets/customer_card/customer_card.dart';
import 'create_update_section/crm_create_update_section_page.dart';
import 'crm_board_controller.dart';
import 'widgets/create_customer_field/create_customer_field.dart';

class CrmBoardPage extends StatefulWidget {
  const CrmBoardPage({
    required this.category,
    this.onEdited,
    super.key,
  });

  final CrmCategoryReadDto category;
  final Function(CrmCategoryReadDto model)? onEdited;

  @override
  State<CrmBoardPage> createState() => _CrmBoardPageState();
}

class _CrmBoardPageState extends State<CrmBoardPage> {
  late final CrmBoardController ctrl;

  @override
  void initState() {
    ctrl = Get.put(CrmBoardController(category: widget.category));
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.theme.primaryColorDark),
        title: Obx(
          () => Text("${ctrl.category.title ?? '- -'}${ctrl.isWebSocketConnect.value ? "" : " (${s.connecting})"}").bodyMedium(color: context.theme.primaryColorDark),
        ),
        backgroundColor: context.theme.cardColor,
        actions: [
          Obx(
            () => ctrl.pendingList.value != null ? _pendingListActionButton() : const SizedBox(),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Obx(
        () => ctrl.kanbanController.sections.isEmpty
            ? _kanbanBoardShimmer()
            : WKanbanBoard<CrmSectionReadDto, CustomerReadDto>(
                controller: ctrl.kanbanController,
                headerOfAddNewSectionPage: _addSectionHeaderBuilder(),
                addNewSectionPageBody: _addSectionPage(),
                sectionHeaderBuilder: (final section) => _sectionHeaderBuilder(section),
                itemBuilder: (final section, final item, final outerScrollController) => WCustomerCard(
                  customer: item.data,
                  outerScrollController: outerScrollController,
                  onChangedCheckBox: (final customer) {},
                  onStepChanged: (final customer) {},
                  onEdit: (final customer) {},
                  onDelete: (final customer) {},
                ),
              ),
      ),
    );
  }

  Widget _pendingListActionButton() => UBadge(
        badgeContent: Text(
          ctrl.pendingList.value!.children.isNotEmpty ? (ctrl.pendingList.value!.children.length).toString() : '',
          style: context.textTheme.bodyMedium!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        showBadge: ctrl.pendingList.value!.children.isNotEmpty,
        animationType: BadgeAnimationType.fade,
        position: const BadgePosition(top: -5, start: -12),
        child: UImage(AppIcons.pendingListOutline, size: 30, color: context.theme.primaryColorDark),
      )
          .withTooltip(
            "${ctrl.pendingList.value!.data?.title}\n${ctrl.pendingList.value!.children.length} ${s.task}",
            textStyle: context.textTheme.bodyMedium!.copyWith(color: Colors.white),
          )
          .onTap(
            () => UNavigator.push(CrmPendingListPage(controller: ctrl)),
          );

  Widget _sectionBuilder(final Section<CrmSectionReadDto, CustomerReadDto> section) => Container(
        width: context.width,
        color: section.data?.colorCode?.toColor() ?? Colors.grey,
        child: ListTile(
          leading: section.data?.icon != null ? UImage(section.data!.icon!.url ?? '', size: 30, color: Colors.white) : null,
          title: Text(section.data?.title ?? '', maxLines: 2).bodyLarge(color: Colors.white),
          trailing: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(s.edit).bodySmall(color: Colors.white),
          ).onTap(() {
            bottomSheet(
              title: s.editSection,
              child: CrmCreateUpdateSectionPage(
                categoryId: widget.category.id ?? '',
                controller: ctrl,
                section: section,
              ),
            );
          }),
        ),
      );

  Widget _addCustomerButton(final Section<CrmSectionReadDto, CustomerReadDto> section) {
    if (!ctrl.haveAdminAccess) {
      return const SizedBox();
    }

    return Obx(
      () {
        final bool showNewCustomerField = ctrl.sectionIdWithOpenField.value == section.slug;

        return showNewCustomerField
            ? Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
                child: CreateCustomerField(
                  key: ValueKey(section.slug),
                  categoryId: ctrl.category.id ?? '',
                  section: section.data,
                  onResponse: (final task) => ctrl.hideOpenField(),
                  onUnFocus: () => ctrl.hideOpenField(),
                ),
              )
            : Container(
                width: context.width,
                height: 40,
                margin: const EdgeInsets.only(left: 16, right: 16, top: 10),
                decoration: BoxDecoration(
                  color: context.theme.hintColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_rounded, size: 25, color: Colors.white),
                    Text(s.newCustomer).bodyMedium(color: Colors.white),
                  ],
                ),
              ).onTap(() => ctrl.showFieldFor(section.slug));
      },
    );
  }

  Widget _sectionHeaderBuilder(final Section<CrmSectionReadDto, CustomerReadDto> section) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _sectionBuilder(section),
          _addCustomerButton(section),
        ],
      );

  Widget? _addSectionPage() {
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
          onTap: () {
            bottomSheet(
              title: s.addMember,
              child: CrmCategoryAddMemberPage(
                category: ctrl.category,
                onResponse: (final group) {
                  ctrl.category = group;
                  widget.onEdited?.call(group);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _addSectionHeaderBuilder() => Container(
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
              child: CrmCreateUpdateSectionPage(
                categoryId: widget.category.id ?? '',
                controller: ctrl,
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
                    Row(
                      spacing: 15,
                      children: [
                        WCheckBox(
                          isChecked: false,
                          size: 20,
                          onChanged: (final value) {},
                        ),
                        const CircleAvatar(radius: 15),
                        Container(
                          width: context.width / 2,
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        const UImage(AppIcons.callOutline, size: 30),
                        Container(
                          width: context.width / 4,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
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
                            WCheckBox(
                              isChecked: false,
                              size: 20,
                              onChanged: (final value) {},
                            ),
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
                    SizedBox(
                      width: context.width,
                      height: 30,
                      child: Row(
                        children: List.generate(4, (final i) {
                          return CustomPaint(
                            painter: ChevronPainter(
                              color: Colors.grey,
                            ),
                            child: const SizedBox(
                              height: 20,
                              child: Center(
                                widthFactor: 1,
                                heightFactor: 1,
                                child: SizedBox.shrink(),
                              ),
                            ), // تنظیم ارتفاع هر مرحله
                          ).expanded();
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ).shimmer(),
      );
}
