import 'package:u/utilities.dart';

import 'package:bermooda_business/view/modules/conversation/data/repositories/professional_chat_repository_impl.dart';
import 'package:bermooda_business/view/modules/conversation/data/datasources/professional_chat_remote_datasource.dart';
import 'package:bermooda_business/core/services/websocket_service.dart';
import 'package:bermooda_business/view/modules/conversation/data/dto/conversation_dtos.dart';
import 'package:bermooda_business/view/modules/conversation/domain/repositories/professional_chat_repository.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../data/data.dart';
import '../../../../../../core/constants.dart';

class ConversationsListController extends GetxController {
  late StreamSubscription _wsSubscription;
  late StreamSubscription _wsConnectionSubscription;

  final ProfessionalChatRepository _repository = ProfessionalChatRepositoryImpl(
    webSocketService: WebSocketService(),
    remoteDataSource: Get.find<ProfessionalChatRemoteDataSource>(),
    memberDataSource: Get.find<MemberDatasource>(),
  );

  final core = Get.find<Core>();
  final Rx<ChatConnectionType> connectionState = ChatConnectionType.done.obs;
  final Rx<PageState> pageState = PageState.initial.obs;
  final RxList<ConversationDto> conversations = <ConversationDto>[].obs;
  final RxList<FeedbackCategoryDto> feedbackCategories = <FeedbackCategoryDto>[].obs;
  late final Worker _worker;

  @override
  void onInit() {
    super.onInit();
    pageState.initial();
    conversations.clear();

    _setupWebSocketListeners();
    _worker = ever(core.currentWorkspace, (final _) {
      debugPrint("Workspace changed, refreshing conversations...");
      getConversations();
    });
    getConversations();
  }

  void _setupWebSocketListeners() {
    // Listen to connection state
    if (_repository.isConnected.value == false) {
      connectionState(ChatConnectionType.connecting);
    }

    _wsConnectionSubscription = _repository.isConnected.listen((final connected) {
      if (connected) {
        connectionState(ChatConnectionType.update);
      } else {
        connectionState(ChatConnectionType.connecting);
      }
    });

    // Listen to WebSocket messages
    _wsSubscription = _repository.messagesStream.listen((final message) {
      _handleWebSocketMessage(message);
    });
  }

  void _handleWebSocketMessage(final Map<String, dynamic> message) {
    try {
      final type = message['type'] as String?;

      switch (type) {
        case 'conversations_list':
          final conversationsList =
              (message['conversations'] as List?)?.map((final e) => ConversationDto.fromMap(e)).toList() ?? [];
          conversations(conversationsList);
          pageState.loaded();
          delay(
            1000,
            () => connectionState(ChatConnectionType.done),
          );
          break;

        case 'conversation_created':
          final conversation = ConversationDto.fromMap(message['conversation']);
          conversations.insert(0, conversation);
          break;

        case 'messages_read':
          final conversationId = message['conversation_id'] as String?;
          if (conversationId != null) {
            _updateConversationUnreadCount(conversationId, 0);
          }
          break;

        case 'you_were_removed':
          final conversationId = message['conversation_id'];
          final index = conversations.indexWhere((final e) => e.id == conversationId);
          if (index != -1) {
            conversations.removeAt(index);
          }
          break;

        case 'conversation_update':
          final updatedConversation = message["conversation_data"] == null
              ? null
              : ConversationDto.fromMap(message["conversation_data"]);
          if (updatedConversation == null) return;
          updateConversation(updatedConversation);
          break;

        case 'error':
          final errorMessage = message['message'] as String? ?? '';
          AppNavigator.snackbarRed(title: s.error, subtitle: errorMessage);
          break;

        case 'notification':
          final notificationMessage = message['message'] as String? ?? '';
          if (notificationMessage.isNotEmpty) {
            UNotification.showLocalNotification(
              RemoteMessage(
                notification: RemoteNotification(body: notificationMessage),
                sentTime: DateTime.now(),
                data: {"type": "conversation_notification"},
              ),
              channelId: channelId,
              channelName: channelName,
              icon: notificationIcon,
            );
          }
          break;
      }
    } catch (e) {
      debugPrint('Error handling WebSocket message: $e');
    }
  }

  void _updateConversationUnreadCount(final String conversationId, final int unreadCount) {
    final index = conversations.indexWhere((final c) => c.id == conversationId);
    if (index != -1) {
      final conversation = conversations[index];
      conversations[index] = conversation.copyWith(unreadCount: unreadCount);
    }
  }

  void getConversations() {
    _repository.getConversations();
  }

  void updateConversation(final ConversationDto updatedConversation) {
    final index = conversations.indexWhere((final e) => e.id == updatedConversation.id);
    if (index != -1) {
      conversations[index] = updatedConversation;
    }
  }

  @override
  void onClose() {
    _wsSubscription.cancel();
    _wsConnectionSubscription.cancel();
    _worker.dispose();
    super.onClose();
  }
}
