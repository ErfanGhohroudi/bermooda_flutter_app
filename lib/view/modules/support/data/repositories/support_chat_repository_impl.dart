import 'package:dio/dio.dart' as dio;
import 'package:bermooda_business/data/data.dart';
import 'package:bermooda_business/core/services/websocket_service.dart';
import 'package:u/utilities.dart';

import '../../domain/entities/support_room_entity.dart';
import '../../domain/enums/message_type.dart';
import '../../domain/repositories/support_chat_repository.dart';
import '../datasources/support_datasource.dart';

class SupportChatRepositoryImpl implements SupportChatRepository {
  final WebSocketService _wsService = WebSocketService();
  final UploadFileDatasource _uploadFileDatasource = Get.find<UploadFileDatasource>();
  final SupportDatasource _supportDatasource = Get.find<SupportDatasource>();

  @override
  Stream<Map<String, dynamic>> get messages => _wsService.messages;

  @override
  RxBool get isConnected => _wsService.isConnected;

  @override
  void openRoom(final int roomId) {
    _wsService.send('open_support_room', {'room_id': roomId});
  }

  @override
  void closeRoom(final int roomId) {
    _wsService.send('close_support_room', {'room_id': roomId});
  }

  @override
  void sendMessage({
    required final int roomId,
    required final String message,
    final String? clientId,
    final String? replyToId,
    final SupportMessageType? type,
    final int? fileId,
    final int? imageId,
    final int? voiceId,
  }) {
    final data = {
      'room_id': roomId,
      'text': message,
      'type': "operator",
    };

    if (clientId != null) {
      data['client_id'] = clientId;
    }

    if (type != null) {
      data['message_data'] = type.name;
    }

    if (replyToId != null) {
      data['reply_to_id'] = replyToId;
    }

    if (fileId != null) {
      data['file_id'] = fileId;
    }

    if (imageId != null) {
      data['image_id'] = imageId;
    }

    if (voiceId != null) {
      data['voice_id'] = voiceId;
    }

    _wsService.send('create new message', data);
  }

  @override
  Future<MainFileReadDto?> uploadFile(
    final String filePath, {
    final Function(double progress)? onSendProgress,
    final dio.CancelToken? cancelToken,
  }) async {
    final completer = Completer<MainFileReadDto?>();

    final fileDto = MainFileReadDto(
      url: filePath,
      fileName: filePath.split('/').last,
    );

    await _uploadFileDatasource.uploadFile(
      file: fileDto,
      cancelToken: cancelToken,
      onProgress: (final progress) {
        onSendProgress?.call(progress);
      },
      onFileUploaded: (final uploadedFile) {
        completer.complete(uploadedFile);
      },
      onError: (final file, final response) {
        completer.completeError(response?.statusMessage ?? 'Upload failed');
      },
    );

    return completer.future;
  }

  @override
  void sendTyping(final int roomId) {
    _wsService.send('typing', {
      'room_id': roomId,
      'is_typing': true,
      'type': 'operator',
    });
  }

  @override
  void stopTyping(final int roomId) {
    _wsService.send('typing', {
      'room_id': roomId,
      'is_typing': false,
      'type': 'operator',
    });
  }

  @override
  void markAsRead(final int roomId, final List<String> messageIds) {
    _wsService.send('read_status_messages', {
      'room_id': roomId,
      'message_ids': messageIds,
    });
  }

  @override
  void getMessages(final int roomId, {required final int page}) {
    _wsService.send('read room messages', {
      'room_id': roomId,
      'page': page,
    });
  }

  @override
  Future<GenericResponse<SupportRoomEntity>> getMyAssignedRooms({
    required final int departmentId,
    required final int pageNumber,
    required final int perPageCount,
    required final String? search,
  }) {
    final completer = Completer<GenericResponse<SupportRoomEntity>>();

    _supportDatasource.getMyAssignedRooms(
      departmentId: departmentId,
      pageNumber: pageNumber,
      perPageCount: perPageCount,
      search: search,
      onResponse: (final response) {
        final GenericResponse<SupportRoomEntity> res = GenericResponse(
          status: response.status,
          message: response.message,
          resultList: (response.resultList??[]).map(SupportRoomEntity.fromDto).toList(),
          extra: response.extra,
        );
        completer.complete(res);
      },
      onError: (final response) {
        completer.completeError(response);
      },
    );

    return completer.future;
  }

  @override
  Future<SupportRoomEntity> transferRoomToAnotherOperator({
    required final int roomId,
    required final int operatorId,
    required final String? note,
  }) {
    final completer = Completer<SupportRoomEntity>();

    _supportDatasource.transferRoomToAnotherOperator(
      roomId: roomId,
      operatorId: operatorId,
      note: note,
      onResponse: (final response) {
        if (response.result == null) return completer.completeError(response);
        final res = SupportRoomEntity.fromDto(response.result!);
        completer.complete(res);
      },
      onError: (final response) {
        completer.completeError(response);
      },
    );

    return completer.future;
  }
}
