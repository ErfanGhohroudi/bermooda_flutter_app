import 'package:u/utilities.dart';

import '../../../../../../../core/widgets/widgets.dart';
import '../../../../../../../core/core.dart';
import '../../../../../../../core/services/websocket_service.dart';
import '../../../../../../../data/data.dart';
import '../../../../data/datasources/professional_chat_remote_datasource.dart';
import '../../../../data/dto/conversation_dtos.dart';
import '../../../../data/repositories/professional_chat_repository_impl.dart';

class AddMemberToGroupController extends GetxController {
  AddMemberToGroupController({required this.conversation});

  final ConversationDto conversation;

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
      title: s.newMember,
      description: s.addMemberDialog,
      onYesButtonTap: () {
        UNavigator.back();
        _addMemberToChat(userId);
      },
    );
  }

  Future<void> _getUsers() async {
    try {
      final currentMembersIds = conversation.members.map((final m) => m.user.id).toList();
      _userList = await _repository.getAllMembers(currentMembersIds: currentMembersIds);
      _filteredUserList = List.from(_userList);
      pageState.loaded();
    } catch (e) {
      pageState.error();
    }
  }

  void _addMemberToChat(final String userId) {
    _repository.addMember(conversation.id, userId);
    Future.delayed(50.milliseconds, () => UNavigator.back());
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    debugPrint("AddMemberToGroupController Closed!!!");
    super.onClose();
  }
}
