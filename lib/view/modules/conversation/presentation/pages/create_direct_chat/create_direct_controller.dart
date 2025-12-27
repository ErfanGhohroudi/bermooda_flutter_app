import 'package:u/utilities.dart';

import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/core.dart';
import '../../../../../../core/services/websocket_service.dart';
import '../../../../../../data/data.dart';
import '../../../data/datasources/professional_chat_remote_datasource.dart';
import '../../../data/repositories/professional_chat_repository_impl.dart';
import '../messages/conversation_messages_page.dart';

class CreateDirectController extends GetxController {
  final ProfessionalChatRepositoryImpl _repository = ProfessionalChatRepositoryImpl(
    webSocketService: WebSocketService(),
    remoteDataSource: Get.find<ProfessionalChatRemoteDataSource>(),
    memberDataSource: Get.find<MemberDatasource>(),
  );
  final Rx<PageState> pageState = PageState.initial.obs;
  final TextEditingController searchCtrl = TextEditingController();
  List<UserReadDto> _userList = <UserReadDto>[];
  List<UserReadDto> _filteredUserList = <UserReadDto>[];

  List<UserReadDto> get userList => _filteredUserList;

  @override
  void onInit() {
    _getUsers();
    super.onInit();
  }

  void onTryAgain() {
    _getUsers();
  }

  void onSearch() {
    final value = searchCtrl.text.trim().toLowerCase();
    if (value.isEmpty) {
      _filteredUserList = List.from(_userList);
    } else {
      _filteredUserList = _userList
          .where(
            (final user) => (user.fullName ?? '').toLowerCase().contains(value),
          )
          .toList();
    }
    pageState.refresh();
  }

  void onTapUser(final String userId) {
    appShowYesCancelDialog(
      title: s.directMessage,
      description: s.startConversationDialog,
      onYesButtonTap: () {
        UNavigator.back();
        _createDirectChat(userId);
      },
    );
  }

  Future<void> _getUsers() async {
    try {
      _userList = await _repository.getAllMembers();
      _filteredUserList = List.from(_userList);
      pageState.loaded();
    } catch (e) {
      pageState.error();
    }
  }

  Future<void> _createDirectChat(final String userId) async {
    try {
      final conversation = await _repository.createDirectChat(userId);
      UNavigator.off(ConversationMessagesPage(conversation: conversation));
    } catch (e, s) {
      debugPrint("createDirectChatHttp failed => e: $e\ns: $s");
    }
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    debugPrint("CreateDirectController Closed!!!");
    super.onClose();
  }
}
