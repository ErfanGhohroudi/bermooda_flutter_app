import 'package:get/get.dart';

import '../../view/modules/conversation/data/datasources/professional_chat_remote_datasource.dart';

class ConversationDatasources {
  static void init() {
    // --- Conversation Data Sources ---
    Get.lazyPut<ProfessionalChatRemoteDataSource>(() => ProfessionalChatRemoteDataSource(), fenix: true);
  }
}
