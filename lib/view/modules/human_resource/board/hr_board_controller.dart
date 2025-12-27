import 'package:bermooda_business/core/utils/enums/enums.dart';
import 'package:u/utilities.dart';

import '../../../../core/core.dart';
import '../../../../core/navigator/navigator.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../core/widgets/kanban_board/kanban_board.dart';
import '../../../../core/services/websocket_service.dart';
import '../../../../data/data.dart';
import '../../members/invite/invite_member_page.dart';

class HRBoardController extends GetxController {
  HRBoardController({
    required this.department,
  });

  HRDepartmentReadDto department;
  final KanbanDatasource _kanbanDatasource = Get.find<KanbanDatasource>();
  final webSocketService = WebSocketService();
  late final StreamSubscription _wsSub;
  late final Worker _worker;
  final PageController pageController = PageController();
  late final KanbanController<HRSectionReadDto, BoardMemberReadDto> kanbanController;
  final bool haveAdminAccess = Get.find<PermissionService>().haveHRAdminAccess;

  final Rx<Section<HRSectionReadDto, BoardMemberReadDto>?> pendingList = Rx(
    null as Section<HRSectionReadDto, BoardMemberReadDto>?,
  );
  final Rx<bool> isWebSocketConnect = RxBool(true);

  // سکشن مربوط به ایجاد سکشن جدید
  final _addNewSectionWidget = Section<HRSectionReadDto, BoardMemberReadDto>(
    slug: 'add_section',
    isAddSectionPage: true,
  );

  @override
  void onInit() {
    super.onInit();
    kanbanController = KanbanController<HRSectionReadDto, BoardMemberReadDto>(
      externalPageController: pageController,
      onItemMoved: _moveCard,
    );

    _wsSub = webSocketService.messages.listen((final jsonData) {
      if (jsonData["status"] == "ping") return;

      final dataType = jsonData['data_type'] as String?;
      final queryType = ModuleType.fromString(jsonData["data"]?['query_object'] as String?);
      final folderSlug = jsonData["data"]?['folder_slug'] as String?;
      // if event is not for this board
      if (department.slug != folderSlug || queryType != ModuleType.humanResources) return;
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
    _wsSub.cancel();
    _worker.dispose();
    kanbanController.onClose();
    debugPrint("HRBoardController closed!!!");
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
    final HRSectionReadDto? sectionData = sectionDataJson == null ? null : HRSectionReadDto.fromMap(sectionDataJson);
    if (sectionData == null || sectionSlug == null) return;
    final newSection = Section<HRSectionReadDto, BoardMemberReadDto>(
      slug: sectionSlug.toString(),
      data: sectionData,
    );

    if (kanbanController.sections.subject.isClosed) return;
    try {
      final targetSection = kanbanController.sections[targetSectionIndex];

      if (targetSection.isAddSectionPage) {
        // add at end of list
        kanbanController.addSection(newSection);
      } else if (targetSection.slug == sectionSlug) {
        // update with new data
        kanbanController.updateSection(newSection);
      } else {
        // insert new Section at target index
        kanbanController.addSectionAt(targetSectionIndex, newSection);
      }
    } catch (e) {
      // add at end of list
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
    _kanbanDatasource.getAllBoardSectionsAndItems<HRSectionReadDto, BoardMemberReadDto>(
      slug: department.slug ?? '',
      requestType: KanbanRequestType.human_recource,
      sectionFromMap: (final x) => HRSectionReadDto.fromMap(x),
      itemListFromMap: (final list) => list.map(_parseItemFromMap).toList(),
      onResponse: (final response) {
        List<Section<HRSectionReadDto, BoardMemberReadDto>> sections = response;
        final pendingIndex = sections.indexWhere((final s) => s.data?.slug == null);
        if (pendingIndex != -1) {
          pendingList(sections.removeAt(pendingIndex));
        }
        if (haveAdminAccess) {
          sections.add(_addNewSectionWidget);
        }
        kanbanController.updateBoardFromSocket(sections);
      },
      onError: (final errorResponse) {
        kanbanController.updateBoardFromSocket([]);
      },
      withRetry: true,
    );
  }

  void _moveCard(
    final Item<BoardMemberReadDto> item,
    final int fromSection,
    final int fromIndex,
    final int toSection,
    final int toIndex,
    final Section<HRSectionReadDto, BoardMemberReadDto> targetSection,
  ) {
    String? getBeforeCardSlug() {
      try {
        final item = kanbanController.sections[toSection].children[toIndex - 1];
        return item.slug;
      } catch (e) {
        return null;
      }
    }

    String? getAfterCardSlug() {
      try {
        final item = kanbanController.sections[toSection].children[toIndex];
        return item.slug;
      } catch (e) {
        return null;
      }
    }

    if (webSocketService.isConnected.value) {
      final targetSectionSlug = kanbanController.sections[toSection].slug;
      _kanbanDatasource.moveACard(
        cardSlug: item.slug,
        targetSectionSlug: targetSectionSlug,
        beforeCardSlug: getBeforeCardSlug(),
        afterCardSlug: getAfterCardSlug(),
        onResponse: (final response) {},
        onError: (final errorResponse) {},
      );
    } else {
      AppNavigator.snackbarRed(title: s.error, subtitle: s.connectionLost);
    }
  }

  Item<BoardMemberReadDto> _parseItemFromMap(final dynamic json) {
    final cardSlug = json["slug"];
    final relatedObject = json["related_obj"]?["data"];
    final item = BoardMemberReadDto.fromMap(relatedObject);
    return Item<BoardMemberReadDto>(id: item.id.toString(), slug: cardSlug, data: item);
  }

  /// For add new member
  void navigateToInviteMemberPage() {
    UNavigator.push(
      InviteMemberPage(
        department: department,
        onResponse: (final member) {},
      ),
    );
  }
}
