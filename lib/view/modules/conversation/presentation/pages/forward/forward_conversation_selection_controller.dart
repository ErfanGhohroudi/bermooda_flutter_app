import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../core/services/websocket_service.dart';
import '../../../../../../data/data.dart';
import '../../../data/datasources/professional_chat_remote_datasource.dart';
import '../../../data/dto/conversation_dtos.dart';
import '../../../data/repositories/professional_chat_repository_impl.dart';
import '../../../domain/repositories/professional_chat_repository.dart';
import '../conversations/conversations_list_controller.dart';

class ForwardConversationSelectionController extends GetxController {
  ForwardConversationSelectionController({
    required this.messageIds,
    required this.currentConversationId,
  });

  final List<String> messageIds;
  final String currentConversationId;

  final ProfessionalChatRepository _repository = ProfessionalChatRepositoryImpl(
    webSocketService: WebSocketService(),
    remoteDataSource: Get.find<ProfessionalChatRemoteDataSource>(),
    memberDataSource: Get.find<MemberDatasource>(),
  );

  final TextEditingController searchCtrl = TextEditingController();
  final RxList<ConversationDto> conversations = <ConversationDto>[].obs;
  final RxList<ConversationDto> filteredConversations = <ConversationDto>[].obs;
  final RxSet<String> selectedConversationIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadConversations();
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    debugPrint("ForwardConversationSelectionController closed!!!");
    super.onClose();
  }

  void _loadConversations() {
    // Get conversations from ConversationsListController
    if (Get.isRegistered<ConversationsListController>()) {
      final conversationsListController = Get.find<ConversationsListController>();
      // Filter out current conversation
      final filtered = conversationsListController.conversations.where((final c) => c.id != currentConversationId).toList();
      conversations.assignAll(filtered);
      filteredConversations.assignAll(filtered);
    } else {
      // If controller not found, try to get conversations directly
      // This is a fallback - ideally ConversationsListController should be available
      conversations.clear();
      filteredConversations.clear();
    }
  }

  void filterConversations() {
    final query = searchCtrl.text.trim();
    if (query.isEmpty) {
      filteredConversations.assignAll(conversations);
      return;
    }

    final lowerQuery = query.toLowerCase();
    final filtered = conversations.where((final conversation) {
      final displayName = conversation.displayName.toLowerCase();
      return displayName.contains(lowerQuery);
    }).toList();
    filteredConversations.assignAll(filtered);
  }

  void toggleConversationSelection(final String conversationId) {
    if (selectedConversationIds.contains(conversationId)) {
      selectedConversationIds.remove(conversationId);
    } else {
      selectedConversationIds.add(conversationId);
    }
  }

  void forwardMessages() {
    if (selectedConversationIds.isEmpty) {
      AppNavigator.snackbarRed(title: s.error, subtitle: s.pleaseSelectAtLeastOneConversation);
      return;
    }

    if (messageIds.isEmpty) {
      AppNavigator.snackbarRed(title: s.error, subtitle: s.noMessagesToForward);
      return;
    }

    final targetConversationIds = selectedConversationIds.toList();

    try {
      _repository.forwardMessages(
        messageIds: messageIds,
        targetConversationIds: targetConversationIds,
      );

      AppNavigator.snackbarGreen(title: s.done, subtitle: s.forwardedSuccessfully);
      UNavigator.back();
    } catch (e) {
      AppNavigator.snackbarRed(title: s.error, subtitle: '');
    }
  }
}
