import 'package:bermooda_business/core/core.dart';
import 'package:bermooda_business/core/services/websocket_service.dart';
import 'package:bermooda_business/core/widgets/kanban_board/kanban_board.dart';
import 'package:u/utilities.dart';

import '../../../../../core/services/permission_service.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../data/models/support_customer_dto.dart';
import '../../domain/entities/support_customer_entity.dart';
import '../../domain/usecases/get_support_board.dart';
import '../../domain/usecases/move_support_card.dart';
import '../../domain/entities/support_section.dart';
import '../../domain/entities/support_room_entity.dart';
import '../../data/models/support_section_dto.dart';
import '../../domain/entities/support_department.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../bindings/support_chat_binding.dart';
import '../pages/support_chat_messages_page.dart';

class SupportBoardController extends GetxController {
  SupportBoardController({
    required this.department,
    required this.getSupportBoardUseCase,
    required this.moveSupportCardUseCase,
  });

  late SupportDepartment department;
  final GetSupportBoardUseCase getSupportBoardUseCase;
  final MoveSupportCardUseCase moveSupportCardUseCase;

  final webSocketService = WebSocketService();
  late final StreamSubscription _wsSub;
  late final Worker _worker;
  final PageController pageController = PageController();
  late final KanbanController<SupportSection, SupportCustomer> kanbanController;

  // Permissions could be added here if needed
  final bool haveAdminAccess = Get.find<PermissionService>().haveSupportAdminAccess;

  final Rx<Section<SupportSection, SupportCustomer>?> pendingList = Rx(null);
  final Rx<bool> isWebSocketConnect = RxBool(true);

  // Section for creating new section (if needed)
  final _addNewSectionWidget = Section<SupportSection, SupportCustomer>(
    slug: 'add_section',
    isAddSectionPage: true,
  );

  @override
  void onInit() {
    super.onInit();
    kanbanController = KanbanController<SupportSection, SupportCustomer>(
      externalPageController: pageController,
      onItemMoved: _moveCard,
    );

    _wsSub = webSocketService.messages.listen((final jsonData) {
      if (jsonData["status"] == "ping") return;

      final dataType = jsonData['data_type'] as String?;
      final queryType = ModuleType.fromString(jsonData["data"]?['query_object'] as String?);
      final departmentId = jsonData["data"]?['department_id']?.toString();

      // Filter events for this board
      if (department.id.toString() != departmentId || queryType != ModuleType.support) return;

      _handleReceivedEvent(dataType, jsonData);
    });

    isWebSocketConnect(webSocketService.isConnected.value);
    _fetchBoardSections();

    _worker = ever(webSocketService.isConnected, (final isConnect) {
      isWebSocketConnect(isConnect);
      if (isConnect) {
        _fetchBoardSections();
      }
    });
  }

  @override
  void onClose() {
    _worker.dispose();
    _wsSub.cancel();
    kanbanController.onClose();
    debugPrint("SupportBoardController closed!!!");
    super.onClose();
  }

  void _handleReceivedEvent(final String? dataType, final Map<String, dynamic> data) {
    switch (dataType) {
      case 'add_or_update_a_card':
        _onAddOrUpdateItem(data);
      case 'move_a_card':
        _onMoveACard(data);
      case 'delete_a_card':
        _onDeleteACard(data);
      case 'add_or_update_a_column':
        _onAddOrUpdateSection(data);
      case 'delete_a_column':
        _onDeleteSection(data);
    }
  }

  void _onAddOrUpdateItem(final Map<String, dynamic> data) {
    if (data["data"]?["card_data"]?["related_obj"]?["data"] == null) return;

    final int sectionIndex = data["data"]?["column_index"] ?? 0;
    final String sectionSlug = (data["data"]?["target_column_slug"]).toString();
    final int itemIndex = data["data"]?["index"] ?? 0;

    if (kanbanController.sections.subject.isClosed) return;
    try {
      final itemData = _parseItemFromMap(data["data"]?["card_data"]);
      final section = kanbanController.sections[sectionIndex];
      if (section.slug == sectionSlug) {
        kanbanController.upsertItem(
          sectionIndex: sectionIndex,
          itemIndex: itemIndex,
          itemData: itemData,
        );
      }
    } catch (e) {
      return;
    }
  }

  void _onMoveACard(final Map<String, dynamic> data) async {
    final String deleteCardSlug = data["data"]?["delete_data"]?["card_slug"] ?? '';
    final String deleteSectionSlug = data["data"]?["delete_data"]?["column_slug"] ?? '';
    final int deleteSectionIndex = data["data"]?["delete_data"]?["column_index"] ?? 0;

    final int sectionIndex = data["data"]?["insert_data"]?["column_index"] ?? 0;
    final String sectionSlug = data["data"]?["insert_data"]?["target_column_slug"] ?? '';
    final int itemIndex = data["data"]?["insert_data"]?["card_index"] ?? 0;

    Future<void> deleteItem() async {
      if (kanbanController.sections.subject.isClosed) return;
      try {
        final section = kanbanController.sections[deleteSectionIndex];
        if (section.slug != deleteSectionSlug) return;
        final i = section.children.indexWhere((final item) => item.slug == deleteCardSlug);
        if (i == -1) return;
        if (kanbanController.sections.subject.isClosed) return;
        section.children.removeAt(i);
      } catch (e) {
        return;
      }
    }

    Future<void> insertItem() async {
      final itemData = _parseItemFromMap(data["data"]?["insert_data"]["data"]);
      final section = kanbanController.sections[sectionIndex];
      if (section.slug == sectionSlug) {
        kanbanController.upsertItem(
          sectionIndex: sectionIndex,
          itemIndex: itemIndex,
          itemData: itemData,
        );
      }
    }

    try {
      await deleteItem();
      insertItem();
    } catch (e) {
      return;
    }
  }

  void _onDeleteACard(final Map<String, dynamic> data) async {
    final String deleteCardSlug = data["data"]?["card_slug"] ?? '';
    final String deleteSectionSlug = data["data"]?["column_slug"] ?? '';
    final int deleteSectionIndex = data["data"]?["column_index"] ?? 0;

    if (kanbanController.sections.subject.isClosed) return;
    try {
      final section = kanbanController.sections[deleteSectionIndex];
      if (section.slug != deleteSectionSlug) return;
      final i = section.children.indexWhere((final item) => item.slug == deleteCardSlug);
      if (i == -1) return;
      if (kanbanController.sections.subject.isClosed) return;
      section.children.removeAt(i);
    } catch (e) {
      return;
    }
  }

  void _onAddOrUpdateSection(final Map<String, dynamic> data) async {
    final int targetSectionIndex = data["data"]?["column_index"] ?? 0;
    final Map<String, dynamic>? sectionDataJson = data["data"]?["data"]?["related_obj"]?["data"];
    final String? sectionSlug = data["data"]?["data"]?["slug"] as String?;

    if (sectionDataJson == null || sectionSlug == null) return;

    final sectionData = SupportSection.fromDto(SupportSectionReadDto.fromMap(sectionDataJson));
    final newSection = Section<SupportSection, SupportCustomer>(
      slug: sectionSlug.toString(),
      data: sectionData,
    );

    if (kanbanController.sections.subject.isClosed) return;
    try {
      final targetSection = kanbanController.sections[targetSectionIndex];

      if (targetSection.isAddSectionPage) {
        kanbanController.addSection(newSection);
      } else if (targetSection.slug == sectionSlug) {
        kanbanController.updateSection(newSection);
      } else {
        kanbanController.addSectionAt(targetSectionIndex, newSection);
      }
    } catch (e) {
      kanbanController.addSection(newSection);
    }
  }

  void _onDeleteSection(final Map<String, dynamic> data) async {
    final String sectionSlug = (data["data"]?["column_slug"]).toString();
    if (sectionSlug.isEmpty) return;

    try {
      kanbanController.removeSection(sectionSlug);
    } catch (e) {
      return;
    }
  }

  void _fetchBoardSections() {
    getSupportBoardUseCase(
      departmentSlug: department.id.toString(),
      onResponse: (final sections) {
        final pendingIndex = sections.indexWhere((final s) => s.data?.id == null);
        if (pendingIndex != -1) {
          pendingList(sections.removeAt(pendingIndex));
        }
        if (haveAdminAccess) {
          sections.add(_addNewSectionWidget);
        }
        kanbanController.updateBoardFromSocket(sections);
      },
      onError: (final error) {
        kanbanController.updateBoardFromSocket([]);
      },
    );
  }

  void _moveCard(
    final Item<SupportCustomer> item,
    final int fromSection,
    final int fromIndex,
    final int toSection,
    final int toIndex,
    final Section<SupportSection, SupportCustomer> targetSection,
  ) {
    String? getPreviousCardSlug() {
      try {
        final item = kanbanController.sections[toSection].children[toIndex - 1];
        return item.slug;
      } catch (e) {
        return null;
      }
    }

    String? getNextCardSlug() {
      try {
        final item = kanbanController.sections[toSection].children[toIndex];
        return item.slug;
      } catch (e) {
        return null;
      }
    }

    if (webSocketService.isConnected.value) {
      moveSupportCardUseCase(
        cardSlug: item.slug,
        targetSectionSlug: targetSection.slug,
        previousCardSlug: getPreviousCardSlug(),
        nextCardSlug: getNextCardSlug(),
        onResponse: (final response) {},
        onError: (final error) {},
      );
    } else {
      AppSnackBar.snackbarRed(title: s.error, subtitle: s.connectionLost);
    }
  }

  Item<SupportCustomer> _parseItemFromMap(final Map<String, dynamic> json) {
    final cardSlug = json["slug"] ?? '';
    final relatedObject = json["related_obj"]?["data"] ?? json;
    final item = SupportCustomer.fromDto(SupportCustomerReadDto.fromMap(relatedObject));

    return Item<SupportCustomer>(
      id: item.id.toString(),
      slug: cardSlug,
      data: item,
    );
  }

  void onCardTap(final SupportRoomEntity room) {
    AppNavigator.push(
      SupportChatMessagesPage(room: room),
      binding: SupportChatBinding(room: room),
    );
  }
}
