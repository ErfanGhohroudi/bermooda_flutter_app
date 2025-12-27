import 'package:u/utilities.dart';

import '../../../../../../../core/widgets/widgets.dart';
import '../../../../../../../core/widgets/fields/fields.dart';
import '../../../../../../../core/core.dart';
import '../../../../../../../core/theme.dart';
import '../../../../data/dto/conversation_dtos.dart';
import '../conversation_messages_controller.dart';
import 'anonymous_feedback_bottom_sheet_controller.dart';

class AnonymousFeedbackBottomSheet extends StatefulWidget {
  const AnonymousFeedbackBottomSheet({
    required this.controller,
    super.key,
  });

  final ConversationMessagesController controller;

  @override
  State<AnonymousFeedbackBottomSheet> createState() => _AnonymousFeedbackBottomSheetState();
}

class _AnonymousFeedbackBottomSheetState extends State<AnonymousFeedbackBottomSheet> {
  late final AnonymousFeedbackBottomSheetController sheetController;

  @override
  void initState() {
    sheetController = Get.put(AnonymousFeedbackBottomSheetController(widget.controller));
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<AnonymousFeedbackBottomSheetController>();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildCurrentStep(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(final BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: sheetController.currentStep.value > 0 ? null : Colors.transparent),
          onPressed: sheetController.currentStep.value > 0 ? sheetController.goToPreviousStep : null,
        ),
        Text(s.sendAnonymousMessage).titleMedium(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildCurrentStep(final BuildContext context) {
    if (sheetController.isCustomTextMode.value) {
      return Column(
        children: [
          const Spacer(),
          Form(
            key: sheetController.formKey,
            child: WTextField(
              controller: sheetController.customTextController,
              labelText: s.messageText,
              hintText: s.writeYourMessage,
              required: true,
              showRequired: false,
              multiLine: true,
              showCounter: true,
              minLines: 4,
              maxLines: 8,
              maxLength: 500,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ),
          const SizedBox(height: 16),
          UElevatedButton(
            title: s.send,
            width: double.maxFinite,
            onTap: sheetController.confirmCustomText,
          ),
        ],
      );
    }

    switch (sheetController.currentStep.value) {
      case 0:
        return const _Step1CategorySelection(key: ValueKey(0));
      case 1:
        return const _Step2SubcategorySelection(key: ValueKey(1));
      case 2:
        return const _Step3TemplateSelection(key: ValueKey(2));
      case 3:
        return const _Step4RecipientSelection(key: ValueKey(3));
      case 4:
        return const _Step5PrioritySelection(key: ValueKey(4));
      default:
        return const SizedBox.shrink();
    }
  }
}

// Step 1: Category Selection
class _Step1CategorySelection extends StatelessWidget {
  const _Step1CategorySelection({super.key});

  @override
  Widget build(final BuildContext context) {
    final controller = Get.find<AnonymousFeedbackBottomSheetController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Text(s.category).titleMedium().pSymmetric(horizontal: 16),
        Expanded(
          child: Obx(
            () {
              if (controller.categoriesState.isInitial() || controller.categoriesState.isLoading()) {
                return const Center(child: WCircularLoading());
              }

              if (controller.categoriesState.isError()) {
                return Center(child: WErrorWidget(onTapButton: controller.loadCategories));
              }

              if (controller.categories.isEmpty) {
                return const Center(child: WEmptyWidget());
              }

              return ListView.separated(
                itemCount: controller.categories.length,
                padding: const EdgeInsets.only(bottom: 60),
                separatorBuilder: (final context, final index) => const SizedBox(height: 5),
                itemBuilder: (final context, final index) {
                  final category = controller.categories[index];
                  return WCard(
                    padding: 16,
                    onTap: () => controller.selectCategory(category),
                    child: Row(
                      spacing: 16,
                      children: [
                        if (category.icon.isNotEmpty) Text(category.icon, style: const TextStyle(fontSize: 24)),
                        Expanded(
                          child: Text(category.displayTitle).titleMedium(),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// Step 2: Subcategory Selection
class _Step2SubcategorySelection extends StatelessWidget {
  const _Step2SubcategorySelection({super.key});

  @override
  Widget build(final BuildContext context) {
    final controller = Get.find<AnonymousFeedbackBottomSheetController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Text(s.subcategory).titleMedium().pSymmetric(horizontal: 16),
        Expanded(
          child: Obx(
            () {
              final subcategories = controller.selectedCategory.value?.subCategories ?? [];
              if (subcategories.isEmpty) {
                return const Center(child: WEmptyWidget());
              }

              return ListView.separated(
                itemCount: subcategories.length,
                padding: const EdgeInsets.only(bottom: 60),
                separatorBuilder: (final context, final index) => const SizedBox(height: 5),
                itemBuilder: (final context, final index) {
                  final subcategory = subcategories[index];
                  return WCard(
                    padding: 16,
                    onTap: () => controller.selectSubcategory(subcategory),
                    child: Row(
                      spacing: 16,
                      children: [
                        Expanded(
                          child: Text(subcategory.displayTitle).titleMedium(),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// Step 3: Template Selection
class _Step3TemplateSelection extends StatelessWidget {
  const _Step3TemplateSelection({super.key});

  @override
  Widget build(final BuildContext context) {
    final controller = Get.find<AnonymousFeedbackBottomSheetController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Text(s.messageText).titleMedium().pSymmetric(horizontal: 16),
        Expanded(
          child: Obx(
            () {
              final templates = controller.templates;

              if (templates.isEmpty) {
                return const Center(child: WEmptyWidget());
              }

              return ListView.separated(
                itemCount: templates.length,
                padding: const EdgeInsets.only(bottom: 60),
                separatorBuilder: (final context, final index) => const SizedBox(height: 5),
                itemBuilder: (final context, final index) {
                  final template = templates[index];
                  return WCard(
                    padding: 16,
                    onTap: () => controller.selectTemplate(template),
                    child: Text(template.displayTitle).titleMedium(),
                  );
                },
              );
            },
          ),
        ),
        UElevatedButton(
          title: s.customMessageText,
          width: double.maxFinite,
          icon: const UImage(AppIcons.editOutline, size: 20, color: Colors.white),
          backgroundColor: AppColors.green,
          onTap: controller.openCustomTextMod,
        ),
      ],
    );
  }
}

// Step 4: Recipient Selection
class _Step4RecipientSelection extends StatelessWidget {
  const _Step4RecipientSelection({super.key});

  @override
  Widget build(final BuildContext context) {
    final controller = Get.find<AnonymousFeedbackBottomSheetController>();
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Text(s.recipients).titleMedium().pSymmetric(horizontal: 16),
          Expanded(
            child: Obx(
              () {
                if (controller.membersState.isInitial() || controller.membersState.isLoading()) {
                  return const Center(child: WCircularLoading());
                }

                if (controller.membersState.isError()) {
                  return Center(child: WErrorWidget(onTapButton: controller.loadCategories));
                }

                if (controller.members.isEmpty) {
                  return const Center(child: WEmptyWidget());
                }

                return ListView.separated(
                  itemCount: controller.members.length,
                  padding: const EdgeInsets.only(bottom: 60),
                  separatorBuilder: (final context, final index) => const SizedBox(height: 5),
                  itemBuilder: (final context, final index) {
                    final member = controller.members[index];
                    final isSelected = controller.selectedRecipients.contains(member);

                    return CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: isSelected,
                      selected: isSelected,
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
                      selectedTileColor: AppColors.green,
                      title: WCircleAvatar(
                        user: member,
                        showFullName: true,
                        size: 40,
                        subTitle: member.type != null
                            ? Text(member.type?.getTitle() ?? '').bodySmall(color: context.theme.hintColor)
                            : null,
                      ),
                      onChanged: (final value) {
                        if (value == true) {
                          controller.selectedRecipients.add(member);
                        } else {
                          controller.selectedRecipients.remove(member);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
          UElevatedButton(
            enable: controller.selectedRecipients.isNotEmpty,
            title: s.next,
            width: double.maxFinite,
            onTap: controller.goToNextStep,
          ),
        ],
      ),
    );
  }
}

// Step 5: Priority Selection
class _Step5PrioritySelection extends StatelessWidget {
  const _Step5PrioritySelection({super.key});

  @override
  Widget build(final BuildContext context) {
    final controller = Get.find<AnonymousFeedbackBottomSheetController>();
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.priority).titleMedium().pSymmetric(horizontal: 16),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: FeedbackPriority.values.map(
              (final priority) {
                final selected = controller.selectedPriority.value == priority;
                return FilterChip(
                  label: Text(priority.getTitle()).bodyMedium(color: selected ? Colors.white : priority.color),
                  selected: selected,
                  onSelected: (final value) {
                    controller.selectedPriority.value = priority;
                  },
                  selectedColor: priority.color,
                  checkmarkColor: Colors.white,
                );
              },
            ).toList(),
          ),
          const SizedBox(height: 16),
          _buildSummaryCard(context, controller),
          const Spacer(),
          UElevatedButton(
            title: s.sendAnonymousMessage,
            width: double.maxFinite,
            onTap: controller.sendFeedback,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(final BuildContext context, final AnonymousFeedbackBottomSheetController controller) {
    return WCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          _buildSummaryRow(
            context,
            s.category,
            controller.selectedCategory.value?.displayTitle ?? '',
          ),
          _buildSummaryRow(
            context,
            s.subcategory,
            controller.selectedSubcategory.value?.displayTitle ?? '',
          ),
          _buildSummaryRow(
            context,
            s.recipients,
            "${controller.selectedRecipients.length.toString().separateNumbers3By3()} "
            "${controller.selectedRecipients.length <= 1 && !isPersianLang ? s.user.removeLast() : s.user}",
          ),
          _buildSummaryRow(
            context,
            s.priority,
            controller.selectedPriority.value.getTitle(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(final BuildContext context, final String label, final String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 100, child: Text("$label:").bodyMedium(color: context.theme.hintColor)),
        Flexible(child: Text(value).bodyMedium()),
      ],
    );
  }
}
