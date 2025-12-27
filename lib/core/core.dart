import 'package:u/utilities.dart';

import '../data/data.dart';
import '../generated/l10n.dart';
import 'constants.dart';

S s = S.of(navigatorKey.currentContext!);

bool get isPersianLang => (Get.locale ?? defaultLocale).languageCode == "fa";

class Core extends GetxService {
  final Rx<UserReadDto> userReadDto = const UserReadDto(id: '').obs;
  final Rx<WorkspaceReadDto> currentWorkspace = const WorkspaceReadDto(id: '').obs;
  final RxList<WorkspaceReadDto> workspaces = <WorkspaceReadDto>[].obs;
  final RxList<String> bannerUrls = <String>[].obs;
  final RxInt unreadNotificationsCount = 0.obs;
  final RxInt unreadChatMessagesCount = 0.obs;
  final Rx<bool> haveNotAcceptedWorkspace = false.obs;

  //////////////////////////////////////////////////////////////////////////////////////
  void updateUser(final UserReadDto? model) {
    userReadDto(model);
  }

  //////////////////////////////////////////////////////////////////////////////////////
  void updateCurrentWorkspace(final WorkspaceReadDto? model) {
    currentWorkspace(model);
  }

  //////////////////////////////////////////////////////////////////////////////////////
  void updateWorkspaces(final List<WorkspaceReadDto>? list) {
    if (list == null) return;
    workspaces.assignAll(list);
  }

  void addToWorkspaces(final WorkspaceReadDto? model) {
    if (model == null) return;
    workspaces.add(model);
  }

  void clearWorkspaces() {
    workspaces.clear();
  }

  //////////////////////////////////////////////////////////////////////////////////////
  void updateBannerUrls(final List<String>? list) {
    if (list == null) return;
    bannerUrls.assignAll(list);
  }

  //////////////////////////////////////////////////////////////////////////////////////
  void increaseUnreadNotificationsCount() {
    unreadNotificationsCount(unreadNotificationsCount.value + 1);
  }

  void resetUnreadNotificationsCount() {
    unreadNotificationsCount(0);
  }

  void updateUnreadNotificationsCount(final int count) {
    unreadNotificationsCount(count);
  }

  //////////////////////////////////////////////////////////////////////////////////////
  void increaseUnreadChatMessagesCount() {
    unreadChatMessagesCount(unreadChatMessagesCount.value + 1);
  }

  void resetUnreadChatMessagesCount() {
    unreadChatMessagesCount(0);
  }

  void updateUnreadChatMessagesCount(final int count) {
    unreadChatMessagesCount(count);
  }

  //////////////////////////////////////////////////////////////////////////////////////
  void setHaveNotAcceptedWorkspace(final bool value) {
    haveNotAcceptedWorkspace(value);
  }

  @override
  void onClose() {
    userReadDto.close();
    currentWorkspace.close();
    workspaces.close();
    bannerUrls.close();
    unreadNotificationsCount.close();
    unreadChatMessagesCount.close();
    haveNotAcceptedWorkspace.close();
    super.onClose();
  }
}
