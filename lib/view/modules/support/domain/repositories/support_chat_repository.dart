import 'package:dio/dio.dart' as dio;
import 'package:u/utilities.dart';

import '../../../../../data/data.dart';
import '../entities/support_room_entity.dart';
import '../enums/message_type.dart';

abstract class SupportChatRepository {
  Stream<Map<String, dynamic>> get messages;

  RxBool get isConnected;

  void openRoom(final int roomId);

  void closeRoom(final int roomId);

  void sendMessage({
    required final int roomId,
    required final String message,
    final String? clientId,
    final String? replyToId,
    final SupportMessageType? type,
    final int? fileId,
    final int? imageId,
    final int? voiceId,
  });

  Future<MainFileReadDto?> uploadFile(
    final String filePath, {
    final Function(double progress)? onSendProgress,
    final dio.CancelToken? cancelToken,
  });

  void sendTyping(final int roomId);

  void stopTyping(final int roomId);

  void markAsRead(final int roomId, final List<String> messageIds);

  void getMessages(final int roomId, {required final int page});

  Future<GenericResponse<SupportRoomEntity>> getMyAssignedRooms({
    required final int departmentId,
    required final int pageNumber,
    required final int perPageCount,
    required final String? search,
  });

  Future<SupportRoomEntity> transferRoomToAnotherOperator({
    required final int roomId,
    required final int operatorId,
    required final String? note,
  });
}
