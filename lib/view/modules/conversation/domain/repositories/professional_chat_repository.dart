import 'package:dio/dio.dart' as dio;
import 'package:u/utilities.dart';

import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/data.dart';
import '../../data/dto/conversation_dtos.dart';

abstract class ProfessionalChatRepository {
  // WebSocket methods
  Stream<Map<String, dynamic>> get messagesStream;

  RxBool get isConnected;

  Future<void> connect();

  void disconnect();

  void getConversations();

  void getMessages(final String conversationId, {final int page = 1, final int perPage = 50});

  void sendMessage({
    required final String conversationId,
    final String? text,
    required final MessageType type,
    final String? clientId,
    final List<String>? attachments,
    final int? duration,
  });

  void replyToMessage({
    required final String conversationId,
    required final String replyToId,
    required final String text,
    final String? clientId,
  });

  void editMessage(final String messageId, final String text);

  void deleteMessage(final String messageId);

  void forwardMessages({
    required final List<String> messageIds,
    required final List<String> targetConversationIds,
    final bool withCaption = false,
    final String? caption,
  });

  void markAsRead(final String conversationId, final List<String> messageIds);

  void sendTyping(final String conversationId, final bool isTyping);

  void pinMessage(final String conversationId, final String messageId);

  void unpinMessage(final String conversationId, final String messageId);

  void getPinnedMessages(final String conversationId);

  void addReaction(final String messageId, final String emoji);

  void removeReaction(final String messageId, final String emoji);

  void getMessageReplies(final String messageId);

  void sendAnonymousFeedback(
    final List<String> userIds,
    final String template,
    final int categoryId,
    final int subcategoryId,
    final FeedbackPriority priority,
  );

  void getAnonymousFeedbacks(final int pageNumber, {final int perPage = 20});

  void addMember(final String conversationId, final String userId);

  void removeMember(final String conversationId, final String userId);

  void leaveConversation(final String conversationId);

  // HTTP API methods
  Future<MessageAttachmentDto> uploadFile(
    final File file,
    final String fileType, {
    final Function(int count, int total)? onSendProgress,
    final dio.CancelToken? cancelToken,
  });

  Future<ConversationDto> createDirectChat(final String userId);

  Future<ConversationDto> createGroup({
    required final String title,
    required final List<int> memberIds,
    final String? description,
    final String? avatarUrl,
  });

  Future<ConversationDto> updateGroup(
    final String groupId, {
    final String? title,
    final String? description,
    final MainFileReadDto? avatar,
  });

  Future<List<MessageDto>> searchMessages({
    required final String query,
    final String? conversationId,
    final int perPage = 20,
  });

  Future<Map<String, dynamic>> getConversationAnalytics(final String conversationId);

  Future<Map<String, dynamic>> getWorkspaceAnalytics();

  Future<List<UserReadDto>> getAllMembers();

  Future<List<FeedbackCategoryDto>> getAllFeedbackCategories();
}
