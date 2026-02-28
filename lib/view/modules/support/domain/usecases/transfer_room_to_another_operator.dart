import '../entities/support_room_entity.dart';
import '../repositories/support_chat_repository.dart';

class TransferRoomToAnotherOperatorUseCase {
  final SupportChatRepository repository;

  TransferRoomToAnotherOperatorUseCase(this.repository);

  Future<SupportRoomEntity> call({
    required final int roomId,
    required final int operatorId,
    final String? note,
  }) {
    return repository.transferRoomToAnotherOperator(
      roomId: roomId,
      operatorId: operatorId,
      note: note,
    );
  }
}
