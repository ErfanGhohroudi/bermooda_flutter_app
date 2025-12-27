part of '../../data.dart';

class EmployeeRequestDatasource {
  final ApiClient _apiClient = Get.find();

  /// Create request
  void create({
    required final IRequestCreateParams dto,
    required final Function(GenericResponse<IRequestReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/HumanResourcesManager/EmployeeRequestManager/",
        data: dto.toJson(),
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<IRequestReadDto>.fromJson(response.data, fromMap: RequestEntityFactory.createResponseFromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  /// Change Request Status
  void changeRequestStatus({
    required final String slug,
    required final StatusType status,
    required final Function(GenericResponse<IRequestReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/HumanResourcesManager/EmployeeRequestManager/$slug/IsChecked/",
        data: {
          "accepted_status": status.name, // approved or rejected
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<IRequestReadDto>.fromJson(response.data, fromMap: RequestEntityFactory.createResponseFromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  /// Add Users as Acceptors
  void addAcceptorUsers({
    required final String slug,
    required final List<ReviewerEntity> reviewerList,
    required final Function(GenericResponse<IRequestReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/HumanResourcesManager/EmployeeRequestManager/$slug/AddAccepterUsers/",
        data: {
          "accepter_user_list": reviewerList.mapIndexed((final index, final reviewer) => reviewer.toMap(index)).toList(),
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<IRequestReadDto>.fromJson(response.data, fromMap: RequestEntityFactory.createResponseFromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  /// Get all requests
  void getAllRequest({
    required final RequestListPageType pageType,
    required final int pageNumber,
    final int? memberId,
    final bool myRequests = false,
    final bool isArchive = false,
    final bool myReviews = false,
    final StatusFilter? filter,
    required final Function(GenericResponse<IRequestReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    final mainURL = pageType == RequestListPageType.memberProfile
        ? "/v1/HumanResourcesManager/EmployeeRequestManager/"
        : "/v1/HumanResourcesManager/EmployeeRequestManager/GetFullData/";

    try {
      final response = await _apiClient.get(
        "$mainURL"
        "?page_number=$pageNumber"
        "${memberId != null ? "&member_id=$memberId" : ''}"
        "${myRequests ? "&my_requests=$myRequests" : ''}"
        "${isArchive ? "&is_archive=$isArchive" : ''}"
        "${myReviews ? "&my_reviews=$myReviews" : ''}"
        "${filter != null ? filter.value.map((final status) => "&status=${status.name}").join('') : ''}",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<IRequestReadDto>.fromJson(response.data, fromMap: RequestEntityFactory.createResponseFromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  /// Get a single request
  void getARequest({
    required final String? slug,
    required final Function(GenericResponse<IRequestReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/HumanResourcesManager/EmployeeRequestManager/$slug/",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<IRequestReadDto>.fromJson(response.data, fromMap: RequestEntityFactory.createResponseFromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void getMyReviews({
    required final String? slug,
    required final int pageNumber,
    required final Function(GenericResponse<IRequestReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final int perPageCount = 20,
    final String? query,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/HumanResourcesManager/EmployeeRequestManager/MyReviews/",
        queryParameters: {
          "folder_slug": slug,
          "page_number": pageNumber,
          "per_page_count": perPageCount,
          if (query != null && query.isNotEmpty) "search": query,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<IRequestReadDto>.fromJson(response.data, fromMap: RequestEntityFactory.createResponseFromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void getDecidedUsers({
    required final int? memberId,
    required final Function(GenericResponse<UserReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.get(
        "/v1/HumanResourcesManager/EmployeeRequestManager/GetDecidedUsers/",
        queryParameters: {"member_id": memberId},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<UserReadDto>.fromJson(response.data, fromMap: UserReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }
}
