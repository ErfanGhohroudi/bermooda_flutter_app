import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:bermooda_business/view/modules/support/domain/enums/message_type.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../domain/entities/support_message.dart';
import '../../domain/entities/support_room_entity.dart';
import '../../domain/enums/room_connection_state.dart';
import '../../domain/repositories/support_chat_repository.dart';
import '../chat_helpers/support_media_manager.dart';
import '../chat_helpers/support_message_scroll_manager.dart';
import '../chat_helpers/support_typing_manager.dart';
import '../chat_helpers/support_voice_manager.dart';
import '../chat_helpers/support_websocket_handler.dart';

class SupportChatController extends GetxController {
  final SupportRoomEntity room;
  final SupportChatRepository repository;

  SupportChatController({
    required this.room,
    required this.repository,
  });

  // websocket connection state
  final Rx<RoomConnectionState> connectionState = RoomConnectionState.done.obs;

  // Helper managers
  late final SupportWebSocketHandler websocketHandler;
  late final SupportMessageScrollManager scrollManager;
  late final SupportVoiceManager voiceManager;
  late final SupportMediaManager mediaManager;
  late final SupportTypingManager typingManager;

  int chatMessagesCount = 0;
  final RxList<SupportMessage> messages = <SupportMessage>[].obs;
  final TextEditingController messageController = TextEditingController();
  final RxBool isTyping = false.obs;
  final RxBool isLoadingPage = true.obs;
  final AutoScrollController scrollController = AutoScrollController();

  // For typing indicator of other party (customer)
  final RxBool isCustomerTyping = false.obs;

  // For reply
  final Rx<SupportMessage?> replyToMessage = Rx<SupportMessage?>(null);

  // Pagination
  int currentPage = 1;
  final RxBool isLoadingMore = false.obs;
  bool hasMoreMessage = true;
  final RxBool showScrollToTop = false.obs;

  /// if != null: Enable Auto Searching mode
  String? searchingForMessageId;

  void cancelAllUploads() => mediaManager.cancelAllUploads();

  RxBool get isRecording => voiceManager.isRecording;
  Rxn<String> get recordedVoicePath => voiceManager.recordedVoicePath;
  RxString get recordingVoiceElapsedSeconds => voiceManager.recordingVoiceElapsedSeconds;
  RecorderController get recorderController => voiceManager.recorderController;


  @override
  void onInit() {
    super.onInit();

    // Initialize helpers
    websocketHandler = SupportWebSocketHandler(this);
    scrollManager = SupportMessageScrollManager(this);
    voiceManager = SupportVoiceManager(this);
    mediaManager = SupportMediaManager(this);
    typingManager = SupportTypingManager(this);

    voiceManager.onInit();
    
    openRoom();
    websocketHandler.setupWebSocketListeners();
    scrollManager.setupScrollListener();

    // Add listener for typing
    messageController.addListener(typingManager.onTextChanged);

    getMessages();
  }

  @override
  void onClose() {
    voiceManager.onClose();
    typingManager.dispose();
    scrollManager.dispose();
    websocketHandler.dispose();

    repository.closeRoom(room.id);
    messageController.removeListener(typingManager.onTextChanged);
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // Internal methods for helpers (accessible to helpers)
  Future<void> addOrUpdateMessage(final SupportMessage message) async {
    final index = messages.indexWhere(
          (final m) => m.clientId != null && m.clientId == message.clientId,
    );

    if (index != -1) {
      messages[index] = message.copyWith(
        uploadProgress: null,
        uploadError: null,
      );
    } else {
      chatMessagesCount++;
      messages.insert(0, message);
    }
  }

  void openRoom() => repository.openRoom(room.id);

  void getMessages({final int page = 1}) {
    if (page != 1) {
      isLoadingMore.value = true;
    }
    repository.getMessages(room.id, page: page);
  }

  void markAsRead() {
    final unreadMessages = messages
        .where((final m) => !m.isOperator && !m.readStatus)
        .map((final m) => m.id)
        .toList();

    if (unreadMessages.isNotEmpty) {
      repository.markAsRead(room.id, unreadMessages);

      // Optimistically update local state
      final updatedList = messages.map((final m) {
        if (unreadMessages.contains(m.id)) {
          return m.copyWith(readStatus: true);
        }
        return m;
      }).toList();

      messages.assignAll(updatedList);
    }
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    final clientId = 'client_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(100000)}';
    final replyToId = replyToMessage.value?.id;
    // Optimistic update
    final optimisticMessage = SupportMessage(
      id: clientId,
      type: SupportMessageType.text,
      operatorUser: Get.find<Core>().userReadDto.value,
      body: text,
      reply: replyToMessage.value,
      created: DateTime.now(),
      isOperator: true,
      isSending: true,
      readStatus: true,
      clientId: clientId,
    );

    messages.insert(0, optimisticMessage);
    chatMessagesCount++;
    replyToMessage.value = null;
    scrollManager.scrollToBottom();

    repository.sendMessage(
      roomId: room.id,
      clientId: clientId,
      message: text,
      replyToId: replyToId,
    );
    messageController.clear();
    cancelReply();
  }

  void setReplyMessage(final SupportMessage message) {
    replyToMessage.value = message;
  }

  void cancelReply() {
    replyToMessage.value = null;
  }

  // Delegated methods
  Future<void> startRecording() => voiceManager.startRecording();
  Future<void> stopRecording() => voiceManager.stopRecording();
  void sendRecordedVoice() => voiceManager.sendRecordedVoice();
  void clearVoicePreview() => voiceManager.clearVoicePreview();
  
  void handleAttachmentPressed() => mediaManager.handleAttachmentPressed();
  Future<void> retryUpload(final String clientId) async => mediaManager.retryUpload(clientId);
  void cancelUpload(final String clientId) => mediaManager.cancelUpload(clientId);

  void scrollToRepliedMessage(final String messageId) => scrollManager.scrollToMessage(messageId);

  void onPopScope() {
    final haveUploadingFile = messages.any((final SupportMessage m) => m.isSending);
    if (haveUploadingFile == false) return AppNavigator.back();

    appShowYesCancelDialog(
      title: s.warning,
      description: s.exitConversationMessagesPageWarningDescription,
      onYesButtonTap: () async {
        AppNavigator.back();
        cancelAllUploads();
        await Future.delayed(50.milliseconds, () => AppNavigator.back());
      },
    );
  }
}
