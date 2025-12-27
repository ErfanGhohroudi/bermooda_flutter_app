import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:u/utilities.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'package:bermooda_business/view/modules/conversation/data/datasources/professional_chat_remote_datasource.dart';
import 'package:bermooda_business/core/services/websocket_service.dart';
import 'package:bermooda_business/view/modules/conversation/data/dto/conversation_dtos.dart';

import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/core.dart';
import '../../../../../../core/loading/loading.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../data/data.dart';
import '../../../data/repositories/professional_chat_repository_impl.dart';
import '../../../domain/repositories/professional_chat_repository.dart';
import '../conversations/conversations_list_controller.dart';
import 'helpers/message_websocket_handler.dart';
import 'helpers/message_scroll_manager.dart';
import 'helpers/voice_recorder_manager.dart';
import 'helpers/media_upload_manager.dart';
import 'helpers/message_search_manager.dart';
import 'helpers/pinned_messages_manager.dart';
import 'helpers/multi_select_manager.dart';
import 'helpers/reply_edit_manager.dart';
import 'helpers/typing_indicator_manager.dart';
import 'helpers/group_conversation_manager.dart';
import 'anonymous_feedback_bottom_sheet/anonymous_feedback_bottom_sheet.dart';

class ConversationMessagesController extends GetxController {
  ConversationMessagesController({required this.conversation});

  late Rx<ConversationDto> conversation;

  final ProfessionalChatRepository repository = ProfessionalChatRepositoryImpl(
    webSocketService: WebSocketService(),
    remoteDataSource: Get.find<ProfessionalChatRemoteDataSource>(),
    memberDataSource: Get.find<MemberDatasource>(),
  );

  // Helper managers
  late final MessageWebSocketHandler websocketHandler;
  late final MessageScrollManager scrollManager;
  late final VoiceRecorderManager voiceRecorderManager;
  late final MediaUploadManager mediaUploadManager;
  late final MessageSearchManager searchManager;
  late final PinnedMessagesManager pinnedMessagesManager;
  late final MultiSelectManager multiSelectManager;
  late final ReplyEditManager replyEditManager;
  late final TypingIndicatorManager typingManager;
  late final GroupConversationManager groupManager;

  final Core core = Get.find();
  final AutoScrollController scrollController = AutoScrollController();
  final Rx<PageState> pageState = PageState.initial.obs;
  final Rx<ChatConnectionType> connectionState = ChatConnectionType.done.obs;
  final RxList<MessageEntity> messages = <MessageEntity>[].obs;
  final TextEditingController messageController = TextEditingController();
  final Rxn<MessageDto?> repliedMessage = Rxn<MessageDto?>(null);
  final Rxn<MessageDto?> editingMessage = Rxn<MessageDto?>(null);
  final Rx<bool> showScrollToTop = false.obs;
  final RxBool isTyping = false.obs;
  final RxMap<String, bool> typingUsers = <String, bool>{}.obs;

  // Pinned messages
  final RxList<MessageDto> pinnedMessages = <MessageDto>[].obs;
  final RxInt currentPinnedIndex = 0.obs;

  int chatMessagesCount = 0;
  int currentPage = 1;
  final RxBool isLoadingMore = false.obs;

  bool get hasMoreMessage => currentPage > 0;

  /// if != null: Enable Auto Searching mode
  ///
  /// if == null: Disable Auto Searching mode
  String? searchingForMessageId;

  // record voice variables
  late final RecorderController recorderController;
  final Rx<bool> isRecording = false.obs;
  final RxString recordingVoiceElapsedSeconds = ''.obs;
  final Rxn<String> recordedVoicePath = Rxn<String>(null);
  final Rxn<int> recordedVoiceDuration = Rxn<int>(null);

  // search variables
  final TextEditingController searchCtrl = TextEditingController();
  final RxBool showSearchBox = false.obs;
  final RxInt currentSearchResultIndex = 0.obs;
  final RxList<MessageDto> searchResults = <MessageDto>[].obs;

  // Multi-select variables
  final RxSet<String> selectedMessageIds = <String>{}.obs;
  final RxBool isMultiSelectMode = false.obs;

  bool get isGroup => conversation.value.type == ConversationType.group;

  bool get isAnonymousBot => conversation.value.type == ConversationType.bot;

  bool get isGroupOwner =>
      conversation.value.members.firstWhereOrNull((final m) {
        return m.user.id == core.userReadDto.value.id;
      })?.role ==
      MemberRole.owner;

  bool get isGroupAdmin =>
      conversation.value.members.firstWhereOrNull((final m) {
        return m.user.id == core.userReadDto.value.id;
      })?.role ==
      MemberRole.admin;

  bool get haveAdminAccess => isGroupOwner || isGroupAdmin;

  @override
  void onInit() {
    recorderController = RecorderController();

    // Initialize helpers
    websocketHandler = MessageWebSocketHandler(this);
    scrollManager = MessageScrollManager(this);
    voiceRecorderManager = VoiceRecorderManager(this);
    mediaUploadManager = MediaUploadManager(this);
    searchManager = MessageSearchManager(this);
    pinnedMessagesManager = PinnedMessagesManager(this);
    multiSelectManager = MultiSelectManager(this);
    replyEditManager = ReplyEditManager(this);
    typingManager = TypingIndicatorManager(this);
    groupManager = GroupConversationManager(this);

    scrollManager.setupScrollListener();
    websocketHandler.setupWebSocketListeners();
    getMessages();
    getPinnedMessages();
    super.onInit();
  }

  // Internal methods for helpers (accessible to helpers)
  Future<void> addOrUpdateMessage(final MessageDto message) async {
    if (isAnonymousBot) return;
    final index = messages.cast<MessageDto>().indexWhere(
      (final m) => m.clientId != null && m.clientId == message.clientId,
    );

    if (index != -1) {
      messages[index] = message.copyWith(
        uploadProgress: null,
        localFilePath: null,
        uploadError: null,
      );
    } else {
      chatMessagesCount++;
      messages.insert(0, message);
    }
  }

  void updateMessage(final MessageDto message) {
    final index = messages.indexWhere((final m) => m.id == message.id);
    if (index != -1) {
      messages[index] = message;
    }
  }

  void getMessages() {
    currentPage = 1;
    if (isAnonymousBot) {
      repository.getAnonymousFeedbacks(currentPage);
    } else {
      repository.getMessages(conversation.value.id, page: currentPage);
    }
  }

  void getPinnedMessages() => pinnedMessagesManager.getPinnedMessages();

  // Public methods that delegate to helpers
  void toggleSearchBoxVisible() => searchManager.toggleSearchBoxVisible();

  Future<void> searchInMessages() async => searchManager.searchInMessages();

  void nextSearchResult() => searchManager.nextSearchResult();

  void previousSearchResult() => searchManager.previousSearchResult();

  void showNextPinnedMessage() => pinnedMessagesManager.showNextPinnedMessage();

  void showPreviousPinnedMessage() => pinnedMessagesManager.showPreviousPinnedMessage();

  MessageDto? get currentPinnedMessage => pinnedMessagesManager.currentPinnedMessage;

  void setReplyMessage(final MessageDto? message) => replyEditManager.setReplyMessage(message);

  void setReplyMessageByMessageId(final String messageId) => replyEditManager.setReplyMessageByMessageId(messageId);

  void clearReplyMessage() => replyEditManager.clearReplyMessage();

  void setEditingMessage(final MessageDto? message) => replyEditManager.setEditingMessage(message);

  void clearEditingMessage() => replyEditManager.clearEditingMessage();

  Future<void> startRecording() async => voiceRecorderManager.startRecording();

  Future<void> stopRecording() async => voiceRecorderManager.stopRecording();

  void sendRecordedVoice() => voiceRecorderManager.sendRecordedVoice();

  void clearVoicePreview() => voiceRecorderManager.clearVoicePreview();

  Future<void> sendImage(final File imageFile) async => mediaUploadManager.sendImage(imageFile);

  Future<void> sendVideo(final File videoFile) async => mediaUploadManager.sendVideo(videoFile);

  Future<void> sendFile(final File file, final String fileName) async => mediaUploadManager.sendFile(file, fileName);

  Future<void> sendVoice(final File voiceFile, [final int? duration]) async => mediaUploadManager.sendVoice(voiceFile, duration);

  void cancelUpload(final String clientId) => mediaUploadManager.cancelUpload(clientId);

  void cancelAllUploads() => mediaUploadManager.cancelAllUploads();

  Future<void> retryUpload(final String clientId) async => mediaUploadManager.retryUpload(clientId);

  void enterMultiSelectMode() => multiSelectManager.enterMultiSelectMode();

  void exitMultiSelectMode() => multiSelectManager.exitMultiSelectMode();

  void toggleMessageSelection(final String messageId) => multiSelectManager.toggleMessageSelection(messageId);

  void selectAllMessages() => multiSelectManager.selectAllMessages();

  void deselectAllMessages() => multiSelectManager.deselectAllMessages();

  void copySelectedMessagesTexts() => multiSelectManager.copySelectedMessagesTexts();

  void forwardSelectedMessages() => multiSelectManager.forwardSelectedMessages();

  void forwardSelectedMessage(final MessageDto message) => multiSelectManager.forwardSelectedMessage(message);

  void deleteSelectedMessages() => multiSelectManager.deleteSelectedMessages();

  void sendTypingStatus(final bool typingStatus) => typingManager.sendTypingStatus(typingStatus);

  void navigateToGroupSettingsPage() => groupManager.navigateToGroupSettingsPage();

  void removeMember(final ConversationMemberDto member) => groupManager.removeMember(member);

  void leaveGroup() => groupManager.leaveGroup();

  void updateConversation(final ConversationDto updatedConversation) => groupManager.updateConversation(updatedConversation);

  void pinMessage(final MessageDto message) => pinnedMessagesManager.pinMessage(message);

  void unpinMessage(final MessageDto message) => pinnedMessagesManager.unpinMessage(message);

  void scrollToRepliedMessage(final String messageId) => scrollManager.scrollToMessage(messageId);

  void scrollToPinnedMessage(final String messageId) => scrollManager.scrollToMessage(messageId);

  void scrollToEditingMessage(final String messageId) => scrollManager.scrollToMessage(messageId);

  Future<List<FeedbackCategoryDto>?> getFeedbackCategories() async {
    if (!isAnonymousBot) return null;
    AppLoading.showLoading();
    List<FeedbackCategoryDto>? categories;
    try {
      final controller = Get.find<ConversationsListController>();
      if (controller.feedbackCategories.isEmpty) {
        controller.feedbackCategories(await repository.getAllFeedbackCategories());
      }
      categories = controller.feedbackCategories;
    } catch (e) {
      debugPrint("getFeedbackCategories error: $e");
    }
    AppLoading.dismissLoading();
    return categories;
  }

  void sendMessage() {
    if (isAnonymousBot) return;
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    // Check if we're in edit mode
    if (editingMessage.value != null) {
      return _editMessage(editingMessage.value!.id, text);
    }

    final clientId = 'client_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(100000)}';
    final replyToId = repliedMessage.value?.id;

    // Optimistic update
    final optimisticMessage = MessageDto(
      id: clientId,
      conversationId: conversation.value.id,
      sender: UserBasicDto(
        id: core.userReadDto.value.id, // Will be replaced by server
        fullName: core.userReadDto.value.fullName,
        avatarUrl: core.userReadDto.value.avatarUrl ?? core.userReadDto.value.avatar?.url,
      ),
      type: MessageType.text,
      text: text,
      replyTo: repliedMessage.value != null
          ? ReplyToMessageDto(
              id: repliedMessage.value!.id,
              sender: repliedMessage.value!.sender,
              type: repliedMessage.value!.type,
              text: repliedMessage.value!.text,
              createdAt: repliedMessage.value!.createdAt,
            )
          : null,
      repliesCount: 0,
      forwardCount: 0,
      status: MessageStatus.sending,
      createdAt: DateTime.now(),
      isEdited: false,
      isPinned: false,
      isOwn: true,
      clientId: clientId,
    );

    messages.insert(0, optimisticMessage);
    chatMessagesCount++;
    clearReplyMessage();
    scrollManager.scrollToBottom();

    if (replyToId != null) {
      repository.replyToMessage(
        conversationId: conversation.value.id,
        replyToId: replyToId,
        text: text,
        clientId: clientId,
      );
    } else {
      repository.sendMessage(
        conversationId: conversation.value.id,
        text: text,
        type: MessageType.text,
        clientId: clientId,
      );
    }
  }

  void _editMessage(final String messageId, final String newText) {
    if (isAnonymousBot) return;
    repository.editMessage(messageId, newText);
    clearEditingMessage();
  }

  void deleteMessageDialog(final String messageId) {
    appShowYesCancelDialog(
      title: s.delete,
      description: s.areYouSureYouWantToDeleteItem,
      onYesButtonTap: () {
        UNavigator.back();
        deleteMessage(messageId);
      },
    );
  }

  void deleteMessage(final String messageId) {
    if (isAnonymousBot) return;
    repository.deleteMessage(messageId);
  }

  void addReaction(final MessageDto message, final String emoji) {
    if (isAnonymousBot) return;
    repository.addReaction(message.id, emoji);
  }

  void removeReaction(final MessageDto message, final String emoji) {
    if (isAnonymousBot) return;
    repository.removeReaction(message.id, emoji);
  }

  //----------------------------------------------------------------
  // Attachment methods
  //----------------------------------------------------------------
  void handleAttachmentPressed() {
    if (isAnonymousBot) return;
    bottomSheet(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: navigatorKey.currentContext!.width,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.start,
            spacing: 20,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.green,
                    ),
                    child: const Icon(
                      Icons.camera,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(s.camera).bodyMedium(),
                ],
              ).onTap(
                () {
                  Navigator.pop(navigatorKey.currentContext!);
                  handleImageSelection(pickFromCamera: true);
                },
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor,
                    ),
                    child: const UImage(
                      AppIcons.galleryOutline,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(s.photo).bodyMedium(),
                ],
              ).onTap(
                () {
                  Navigator.pop(navigatorKey.currentContext!);
                  handleImageSelection();
                },
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.orange,
                    ),
                    child: const UImage(
                      AppIcons.fileOutline,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(s.file).bodyMedium(),
                ],
              ).onTap(
                () {
                  Navigator.pop(navigatorKey.currentContext!);
                  handleFileSelection();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleFileSelection() async {
    if (isAnonymousBot) return;
    AppLoading.showLoading();
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      compressionQuality: 30,
    );

    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      final fileName = result.files.single.name;

      if (filePath.isVideoFileName) {
        sendVideo(File(filePath));
      } else if (filePath.isImageFileName) {
        sendImage(File(filePath));
      } else {
        sendFile(File(filePath), fileName);
      }
    }
    AppLoading.dismissLoading();
  }

  void handleImageSelection({final bool? pickFromCamera}) async {
    if (isAnonymousBot) return;
    final XFile? result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: (pickFromCamera ?? false) ? ImageSource.camera : ImageSource.gallery,
    );

    if (result != null) {
      sendImage(File(result.path));
    }
  }

  //------------------------------------------------------------------
  // Anonymous bot methods
  //------------------------------------------------------------------
  void openSendAnonymousMessageBottomSheet() async {
    bottomSheetWithNoScroll(
      child: AnonymousFeedbackBottomSheet(controller: this),
    );
  }

  void onPopScope() {
    if (isAnonymousBot) return UNavigator.back();
    if (selectedMessageIds.isNotEmpty) {
      return exitMultiSelectMode();
    }

    final haveUploadingFile = messages.cast<MessageDto>().any((final m) => m.isSending);
    if (haveUploadingFile == false) return UNavigator.back();

    appShowYesCancelDialog(
      title: s.warning,
      description: s.exitConversationMessagesPageWarningDescription,
      onYesButtonTap: () async {
        UNavigator.back();
        cancelAllUploads();
        await Future.delayed(50.milliseconds, () => UNavigator.back());
      },
    );
  }

  @override
  void onClose() {
    typingManager.dispose();
    voiceRecorderManager.dispose();
    scrollManager.dispose();
    websocketHandler.dispose();
    scrollController.dispose();
    messageController.dispose();
    searchCtrl.dispose();
    recorderController.dispose();
    super.onClose();
  }
}
