import 'package:u/utilities.dart';

import '../../../../../../../data/data.dart';
import '../../../../data/dto/conversation_dtos.dart';
import '../conversation_messages_controller.dart';

class AnonymousFeedbackBottomSheetController extends GetxController {
  AnonymousFeedbackBottomSheetController(this.controller);

  final ConversationMessagesController controller;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxInt currentStep = 0.obs;
  final RxList<FeedbackCategoryDto> categories = <FeedbackCategoryDto>[].obs;
  final RxList<UserReadDto> members = <UserReadDto>[].obs;
  final Rxn<FeedbackCategoryDto> selectedCategory = Rxn<FeedbackCategoryDto>(null);
  final Rxn<FeedbackSubcategoryDto> selectedSubcategory = Rxn<FeedbackSubcategoryDto>(null);
  final RxList<MessageTemplateDto> templates = <MessageTemplateDto>[].obs;
  final Rxn<MessageTemplateDto> selectedTemplate = Rxn<MessageTemplateDto>(null);
  final TextEditingController customTextController = TextEditingController();
  final RxSet<UserReadDto> selectedRecipients = <UserReadDto>{}.obs;
  final Rx<FeedbackPriority> selectedPriority = Rx<FeedbackPriority>(FeedbackPriority.values.first);
  final Rx<PageState> categoriesState = PageState.initial.obs;
  final Rx<PageState> membersState = PageState.initial.obs;
  final RxBool isCustomTextMode = false.obs;

  @override
  void onInit() {
    loadCategories();
    getAllMembers();
    super.onInit();
  }

  Future<void> loadCategories() async {
    categoriesState.loading();
    final categoriesList = await controller.getFeedbackCategories();
    if (categoriesList != null) {
      categories.assignAll(categoriesList);
      categoriesState.loaded();
    } else {
      categoriesState.error();
    }
  }

  Future<void> getAllMembers() async {
    try {
      membersState.loading();
      members.value = await controller.repository.getAllMembers();
      membersState.loaded();
    } catch (e) {
      membersState.error();
      debugPrint("Error loading members: $e");
    }
  }

  void selectCategory(final FeedbackCategoryDto category) {
    selectedCategory.value = category;
    goToNextStep();
  }

  void selectSubcategory(final FeedbackSubcategoryDto subcategory) {
    selectedSubcategory.value = subcategory;
    templates.assignAll(subcategory.templates);
    goToNextStep();
  }

  void selectTemplate(final MessageTemplateDto template) {
    selectedTemplate.value = template;
    customTextController.clear();
    isCustomTextMode.value = false;
    goToNextStep();
  }

  void openCustomTextMod() {
    customTextController.clear();
    selectedTemplate.value = null;
    isCustomTextMode.value = true;
  }

  void closeCustomTextMode() {
    isCustomTextMode.value = false;
  }

  void confirmCustomText() {
    validateForm(
      key: formKey,
      action: () {
        if (customTextController.text.trim().isNotEmpty) {
          goToNextStep();
        }
      },
    );
  }

  void goToNextStep() {
    if (currentStep.value < 4) {
      if (isCustomTextMode.value) closeCustomTextMode();
      currentStep.value++;
    }
  }

  void goToPreviousStep() {
    if (isCustomTextMode.value) {
      return closeCustomTextMode();
    }
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void sendFeedback() {
    if (selectedCategory.value == null || selectedSubcategory.value == null || selectedRecipients.isEmpty) {
      return;
    }

    final templateText = selectedTemplate.value?.displayTitle ?? customTextController.text.trim();
    if (templateText.isEmpty) return;

    controller.repository.sendAnonymousFeedback(
      selectedRecipients.map((final u) => u.id).toList(),
      templateText,
      selectedCategory.value!.id,
      selectedSubcategory.value!.id,
      selectedPriority.value,
    );

    UNavigator.back();
  }

  @override
  void onClose() {
    customTextController.dispose();
    super.onClose();
  }
}
