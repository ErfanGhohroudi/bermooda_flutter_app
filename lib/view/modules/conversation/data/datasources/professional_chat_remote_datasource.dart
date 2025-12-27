import 'package:u/utilities.dart';
import 'package:dio/dio.dart' as dio;

import '../../../../../data/api_client.dart';
import '../../../../../data/data.dart';
import '../dto/conversation_dtos.dart';

class ProfessionalChatRemoteDataSource {
  final ApiClient _apiClient = Get.find();

  // Upload File

  Future<MessageAttachmentDto> uploadFile(
    final File file,
    final String fileType, {
    final Function(int count, int total)? onSendProgress,
    final dio.CancelToken? cancelToken,
  }) async {
    final formData = dio.FormData.fromMap({
      'file': await dio.MultipartFile.fromFile(file.path),
      'file_type': fileType,
    });

    final response = await _apiClient.post(
      '/api/professional-chat/upload-file-complete/',
      data: formData,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
      skipRetry: true,
    );

    return MessageAttachmentDto.fromJson(response.data);
  }

  // Create Direct Chat
  Future<ConversationDto> createDirectChat(final String userId) async {
    final response = await _apiClient.post(
      '/api/professional-chat/conversations/create-direct/',
      data: {'user_id': userId},
      skipRetry: true,
    );

    return ConversationDto.fromMap(response.data);
  }

  // Create Group
  Future<ConversationDto> createGroup({
    required final String title,
    required final List<int> memberIds,
    final String? description,
    final String? avatarUrl,
  }) async {
    final data = {
      'title': title,
      'member_ids': memberIds,
      if (description != null) 'description': description,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
    };

    final response = await _apiClient.post(
      '/api/professional-chat/conversations/create-group/',
      data: data,
    );

    return ConversationDto.fromMap(response.data);
  }

  // Update Group
  Future<ConversationDto> updateGroup(
    final String groupId, {
    final String? title,
    final String? description,
    final MainFileReadDto? avatar,
  }) async {
    Map<String, dynamic>? avatarData() {
      if (avatar == null) {
        /// if don't have avatar
        return {'avatar_id': null};
      } else if (avatar.fileId != null) {
        /// if avatar changed
        return {'avatar_id': avatar.fileId};
      }

      /// if avatar not changed
      return null;
    }

    final data = <String, dynamic>{
      ...?avatarData(),
      'title': title,
      'description': description,
    };

    final response = await _apiClient.put(
      '/v1/ChatManager/update/conversation/$groupId/',
      data: data,
    );

    return ConversationDto.fromMap(response.data);
  }

  // Search Messages
  Future<List<MessageDto>> searchMessages({
    required final String query,
    final String? conversationId,
    final int perPage = 20,
  }) async {
    final response = await _apiClient.get(
      '/api/professional-chat/search/messages/',
      queryParameters: {
        "q": query,
        "per_page": perPage,
        if (conversationId != null) "conversation_id": conversationId,
      },
      skipRetry: true,
    );

    return List<MessageDto>.from((response.data["results"] as List<dynamic>? ?? []).map((final x) => MessageDto.fromMap(x)));
  }

  // Feedback Categories
  Future<List<FeedbackCategoryDto>> getAllFeedbackCategories() async {
    final response = await _apiClient.get(
      '/v1/ChatManager/anonymous-messages/categories/',
      skipRetry: true,
    );

    return List<FeedbackCategoryDto>.from(
      (response.data["data"] as List<dynamic>? ?? []).map((final x) => FeedbackCategoryDto.fromMap(x)),
    );
  }

  // Get Conversation Analytics
  Future<Map<String, dynamic>> getConversationAnalytics(final String conversationId) async {
    final response = await _apiClient.get(
      '/api/professional-chat/analytics/conversation/$conversationId/',
      skipRetry: true,
    );

    return response.data;
  }

  // Get Workspace Analytics
  Future<Map<String, dynamic>> getWorkspaceAnalytics() async {
    final response = await _apiClient.get(
      '/api/professional-chat/analytics/workspace/',
      skipRetry: true,
    );

    return response.data;
  }
}
