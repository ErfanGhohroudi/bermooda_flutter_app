part of '../../data.dart';

enum KanbanRequestType { human_recource, project_board, crm, contract}

class KanbanDatasource {
  final ApiClient _apiClient = Get.find();
  final core = Get.find<Core>();

  void getAllBoardSectionsAndItems<S, T>({
    required final String slug,
    required final KanbanRequestType requestType,
    required final S Function(Map<String, dynamic>) sectionFromMap,
    required final List<Item<T>> Function(List<dynamic>) itemListFromMap,
    required final Function(List<Section<S, T>> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/KanbanBoard/ColumnManager/",
        queryParameters: {
          "query_id": slug,
          "request_type": requestType.name,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        final List<dynamic> data = response.data["data"] ?? [];
        final List<Section<S, T>> sections = data.map((final x) {
          return Section<S, T>.fromMap(
            x,
            sectionFromMap: sectionFromMap,
            itemListFromMap: itemListFromMap,
          );
        }).toList();
        onResponse(sections);
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void moveACard({
    required final String cardSlug,
    required final String targetSectionSlug,
    final String? beforeCardSlug,
    final String? afterCardSlug,
    required final Function(GenericResponse<BoardMemberReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/KanbanBoard/CardManager/MoveACard/",
        data: {
          "dest_column_slug": targetSectionSlug, // required
          "card_slug": cardSlug, // required
          "before_card_slug": beforeCardSlug, // optional
          "after_card_slug": afterCardSlug, // optional
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<BoardMemberReadDto>.fromJson(response.data, fromMap: BoardMemberReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  void addMemberToHRBoard({
    required final int memberId,
    required final String? sectionSlug,
    required final Function(GenericResponse<BoardMemberReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/KanbanBoard/CardManager/AddMemberToBoard/",
        data: {
          "member_id": memberId,
          "category_slug": sectionSlug,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<BoardMemberReadDto>.fromJson(response.data, fromMap: BoardMemberReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }
}
