import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../../core/navigator/navigator.dart';
import '../../domain/entities/support_room_entity.dart';
import '../../domain/repositories/support_chat_repository.dart';
import '../../domain/usecases/get_my_assigned_rooms.dart';
import '../bindings/support_chat_binding.dart';
import '../pages/support_chat_messages_page.dart';

class SupportMyChatsListController extends GetxController {
  SupportMyChatsListController({
    required this.departmentId,
    required this.repository,
  });

  final int departmentId;
  final SupportChatRepository repository;

  late final GetMyAssignedRoomsUseCase _getMyAssignedRoomsUseCase = GetMyAssignedRoomsUseCase(repository);

  final TextEditingController searchController = TextEditingController();
  final RefreshController refreshController = RefreshController();
  final ScrollController scrollController = ScrollController();
  final Rx<bool> showScrollToTop = false.obs;
  final RxBool isReorderEnabled = false.obs;
  final Rx<PageState> pageState = PageState.initial.obs;
  bool isEndOfList = false;
  int pageNumber = 1;
  final RxList<SupportRoomEntity> rooms = <SupportRoomEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    _getDepartments();
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    searchController.dispose();
    refreshController.dispose();
    isReorderEnabled.close();
    pageState.close();
    rooms.close();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.offset > 350 && !showScrollToTop.value) {
      showScrollToTop(true);
    } else if (scrollController.offset <= 350 && showScrollToTop.value) {
      showScrollToTop(false);
    }
  }

  void toggleReorder() {
    isReorderEnabled(!isReorderEnabled.value);
    pageState.refresh();
  }

  void onSearch() {
    pageState.loading();
    onRefresh();
  }

  void onTryAgain() {
    pageState.initial();
    onRefresh();
  }

  void onRefresh() {
    pageNumber = 1;
    _getDepartments();
  }

  void loadMore() {
    pageNumber++;
    _getDepartments();
  }

  Future<void> _getDepartments() async {
    try {
      final response = await _getMyAssignedRoomsUseCase(
        departmentId: departmentId,
        pageNumber: pageNumber,
        search: searchController.text.trim().isNotEmpty ? searchController.text.trim() : null,
      );

      if (rooms.subject.isClosed) return;
      if (pageNumber == 1) {
        rooms.assignAll(response.resultList ?? []);
        refreshController.refreshCompleted();
      } else {
        rooms.addAll(response.resultList ?? []);
      }

      if (response.extra?.next == null || (response.resultList?.isEmpty ?? true)) {
        refreshController.loadNoData();
        isEndOfList = true;
      } else {
        refreshController.loadComplete();
        isEndOfList = false;
      }

      pageState.loaded();
    } catch (e) {
      if (pageState.isInitial()) {
        pageState.error();
      }
      if (pageNumber == 1) {
        refreshController.refreshFailed();
      } else {
        refreshController.loadFailed();
      }
    }
  }

  SupportRoomEntity? updateItem(final SupportRoomEntity room) {
    final index = rooms.indexWhere((final d) => d.id == room.id);
    if (index == -1) return null;
    rooms[index] = room;
    rooms.refresh();
    return room;
  }

  void insertItem(final SupportRoomEntity newRoom) {
    rooms.insert(0, newRoom);
  }

  void onTapRoom(final SupportRoomEntity room) {
    AppNavigator.push(
      SupportChatMessagesPage(room: room),
      binding: SupportChatBinding(room: room),
    );
  }
}
