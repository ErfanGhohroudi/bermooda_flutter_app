import 'package:get/get.dart';
import '../../data/datasources/support_datasource.dart';
import '../../domain/entities/support_room_entity.dart';
import '../../domain/repositories/support_chat_repository.dart';
import '../../data/repositories/support_chat_repository_impl.dart';
import '../controllers/support_chat_controller.dart';

class SupportChatBinding extends Bindings {
  final SupportRoomEntity room;

  SupportChatBinding({required this.room});

  @override
  void dependencies() {
    if (!Get.isRegistered<SupportDatasource>()) {
      Get.lazyPut<SupportDatasource>(() => SupportDatasource());
    }
    if (!Get.isRegistered<SupportChatRepository>()) {
      Get.lazyPut<SupportChatRepository>(() => SupportChatRepositoryImpl());
    }

    Get.put<SupportChatController>(
      SupportChatController(
        room: room,
        repository: Get.find(),
      ),
      tag: 'room_${room.id}',
    );
  }
}
