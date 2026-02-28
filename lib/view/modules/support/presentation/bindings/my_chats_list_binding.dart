import 'package:get/get.dart';
import '../../data/datasources/support_datasource.dart';
import '../../domain/repositories/support_chat_repository.dart';
import '../../data/repositories/support_chat_repository_impl.dart';
import '../controllers/my_chats_list_controller.dart';

class SupportMyChatsListBinding extends Bindings {
  final int departmentId;

  SupportMyChatsListBinding({required this.departmentId});

  @override
  void dependencies() {
    if (!Get.isRegistered<SupportDatasource>()) {
      Get.lazyPut<SupportDatasource>(() => SupportDatasource());
    }
    if (!Get.isRegistered<SupportChatRepository>()) {
      Get.lazyPut<SupportChatRepository>(() => SupportChatRepositoryImpl());
    }

    Get.put<SupportMyChatsListController>(
      SupportMyChatsListController(
        departmentId: departmentId,
        repository: Get.find(),
      ),
    );
  }
}
