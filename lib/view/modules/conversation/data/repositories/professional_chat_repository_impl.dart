import 'package:dio/dio.dart' as dio;
import 'package:u/utilities.dart';

import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/data.dart';
import '../../domain/repositories/professional_chat_repository.dart';
import '../datasources/professional_chat_remote_datasource.dart';
import '../../../../../core/services/websocket_service.dart';
import '../dto/conversation_dtos.dart';

class ProfessionalChatRepositoryImpl implements ProfessionalChatRepository {
  ProfessionalChatRepositoryImpl({
    required final WebSocketService webSocketService,
    required final ProfessionalChatRemoteDataSource remoteDataSource,
    required final MemberDatasource memberDataSource,
  }) : _webSocketService = webSocketService,
       _remoteDataSource = remoteDataSource,
       _memberDataSource = memberDataSource;

  final WebSocketService _webSocketService;
  final ProfessionalChatRemoteDataSource _remoteDataSource;
  final MemberDatasource _memberDataSource;

  @override
  Stream<Map<String, dynamic>> get messagesStream => _webSocketService.messages;

  @override
  RxBool get isConnected => _webSocketService.isConnected;

  @override
  Future<void> connect() async {
    _webSocketService.startLifecycleListener();
    await _webSocketService.connect();
  }

  @override
  void disconnect() {
    _webSocketService.stopLifecycleListener();
    _webSocketService.disconnect();
  }

  // WebSocket methods
  @override
  void getConversations() => _webSocketService.getConversations();

  @override
  void getMessages(final String conversationId, {final int page = 1, final int perPage = 50}) =>
      _webSocketService.getMessages(conversationId, page: page, perPage: perPage);

  @override
  void sendMessage({
    required final String conversationId,
    final String? text,
    required final MessageType type,
    final String? clientId,
    final List<String>? attachments,
    final int? duration,
  }) => _webSocketService.sendMessage(
    conversationId: conversationId,
    text: text,
    type: type,
    clientId: clientId,
    attachments: attachments,
    duration: duration,
  );

  @override
  void replyToMessage({
    required final String conversationId,
    required final String replyToId,
    required final String text,
    final String? clientId,
  }) => _webSocketService.replyToMessage(
    conversationId: conversationId,
    replyToId: replyToId,
    text: text,
    clientId: clientId,
  );

  @override
  void editMessage(final String messageId, final String text) => _webSocketService.editMessage(messageId, text);

  @override
  void deleteMessage(final String messageId) => _webSocketService.deleteMessage(messageId);

  @override
  void forwardMessages({
    required final List<String> messageIds,
    required final List<String> targetConversationIds,
    final bool withCaption = false,
    final String? caption,
  }) => _webSocketService.forwardMessages(
    messageIds: messageIds,
    targetConversationIds: targetConversationIds,
    withCaption: withCaption,
    caption: caption,
  );

  @override
  void markAsRead(final String conversationId, final List<String> messageIds) =>
      _webSocketService.markAsRead(conversationId, messageIds);

  @override
  void sendTyping(final String conversationId, final bool isTyping) => _webSocketService.sendTyping(conversationId, isTyping);

  @override
  void pinMessage(final String conversationId, final String messageId) => _webSocketService.pinMessage(conversationId, messageId);

  @override
  void unpinMessage(final String conversationId, final String messageId) =>
      _webSocketService.unpinMessage(conversationId, messageId);

  @override
  void getPinnedMessages(final String conversationId) => _webSocketService.getPinnedMessages(conversationId);

  @override
  void addReaction(final String messageId, final String emoji) => _webSocketService.addReaction(messageId, emoji);

  @override
  void removeReaction(final String messageId, final String emoji) => _webSocketService.removeReaction(messageId, emoji);

  @override
  void getMessageReplies(final String messageId) => _webSocketService.getMessageReplies(messageId);

  @override
  void sendAnonymousFeedback(
    final List<String> userIds,
    final String template,
    final int categoryId,
    final int subcategoryId,
    final FeedbackPriority priority,
  ) => _webSocketService.sendAnonymousFeedback(userIds, template, categoryId, subcategoryId, priority.name);

  @override
  void getAnonymousFeedbacks(final int pageNumber, {final int perPage = 20}) => _webSocketService.getAnonymousFeedbacks(
    page: pageNumber,
    perPage: perPage,
  );

  @override
  void addMember(final String conversationId, final String userId) => _webSocketService.addMember(conversationId, userId);

  @override
  void removeMember(final String conversationId, final String userId) => _webSocketService.removeMember(conversationId, userId);

  @override
  void leaveConversation(final String conversationId) => _webSocketService.leaveConversation(conversationId);

  //---------------------------------------------------------------------------------
  // HTTP API methods
  //---------------------------------------------------------------------------------
  @override
  Future<MessageAttachmentDto> uploadFile(
    final File file,
    final String fileType, {
    final Function(int count, int total)? onSendProgress,
    final dio.CancelToken? cancelToken,
  }) => _remoteDataSource.uploadFile(
    file,
    fileType,
    onSendProgress: onSendProgress,
    cancelToken: cancelToken,
  );

  @override
  Future<ConversationDto> createDirectChat(final String userId) => _remoteDataSource.createDirectChat(userId);

  @override
  Future<ConversationDto> createGroup({
    required final String title,
    required final List<int> memberIds,
    final String? description,
    final String? avatarUrl,
  }) => _remoteDataSource.createGroup(
    title: title,
    memberIds: memberIds,
    description: description,
    avatarUrl: avatarUrl,
  );

  @override
  Future<ConversationDto> updateGroup(
    final String groupId, {
    final String? title,
    final String? description,
    final MainFileReadDto? avatar,
  }) => _remoteDataSource.updateGroup(
    groupId,
    title: title,
    description: description,
    avatar: avatar,
  );

  @override
  Future<List<MessageDto>> searchMessages({
    required final String query,
    final String? conversationId,
    final int perPage = 20,
  }) async => await _remoteDataSource.searchMessages(
    query: query,
    conversationId: conversationId,
    perPage: perPage,
  );

  @override
  Future<List<FeedbackCategoryDto>> getAllFeedbackCategories() async => await _remoteDataSource.getAllFeedbackCategories();

  @override
  Future<Map<String, dynamic>> getConversationAnalytics(final String conversationId) =>
      _remoteDataSource.getConversationAnalytics(conversationId);

  @override
  Future<Map<String, dynamic>> getWorkspaceAnalytics() => _remoteDataSource.getWorkspaceAnalytics();

  @override
  Future<List<UserReadDto>> getAllMembers({
    final List<String> currentMembersIds = const [],
  }) {
    final completer = Completer<List<UserReadDto>>();
    _memberDataSource.getAllMembers(
      onResponse: (final response) {
        final list = (response.resultList ?? [])
            .where((final user) => (user.isSelf ?? false) == false && !currentMembersIds.contains(user.id))
            .toList();
        completer.complete(list);
      },
      onError: (final errorResponse) {
        completer.completeError(errorResponse);
      },
    );
    return completer.future;
  }
}
