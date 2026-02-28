import '../../../../../data/data.dart';
import '../entities/support_room_entity.dart';
import '../repositories/support_chat_repository.dart';

class GetMyAssignedRoomsUseCase {
  final SupportChatRepository repository;

  GetMyAssignedRoomsUseCase(this.repository);

  Future<GenericResponse<SupportRoomEntity>> call({
    required final int departmentId,
    required final int pageNumber,
    final int perPageCount = 20,
    final String? search,
  }) {
    return repository.getMyAssignedRooms(
      departmentId: departmentId,
      pageNumber: pageNumber,
      perPageCount: perPageCount,
      search: search,
    );
  }
}
