part of '../../data.dart';

class MyContractDatasource {
  final ApiClient _apiClient = Get.find();

  void getMyContracts({
    required final int legalDepartmentId,
    final int pageNumber = 1,
    final int perPageCount = 20,
    final String? itemType,
    final bool? isTracked,
    final bool? isCompleted,
    final int? contractId,
    final int? contractCaseId,
    final int? responsibleId,
    final int? trackerId,
    final int? labelId,
    final String? fromDate,
    final String? toDate,
    final String? fromDueDate,
    final String? toDueDate,
    final String? ordering,
    final String? search,
    required final Function(GenericResponse<dynamic> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'contract_board_id': legalDepartmentId,
        'page_number': pageNumber,
        'per_page_count': perPageCount,
        if (itemType != null && itemType.isNotEmpty) 'item_type': itemType,
        if (isTracked != null) 'is_tracked': isTracked,
        if (isCompleted != null) 'is_completed': isCompleted,
        if (contractId != null) 'contract_id': contractId,
        if (contractCaseId != null) 'contract_case_id': contractCaseId,
        if (responsibleId != null) 'responsible_id': responsibleId,
        if (trackerId != null) 'tracker_id': trackerId,
        if (labelId != null) 'label_id': labelId,
        if (fromDate != null && fromDate.isNotEmpty) 'from_date': fromDate,
        if (toDate != null && toDate.isNotEmpty) 'to_date': toDate,
        if (fromDueDate != null && fromDueDate.isNotEmpty) 'from_due_date': fromDueDate,
        if (toDueDate != null && toDueDate.isNotEmpty) 'to_due_date': toDueDate,
        if (ordering != null && ordering.isNotEmpty) 'ordering': ordering,
        if (search != null && search.isNotEmpty) 'search': search,
      };

      final response = await _apiClient.get(
        '/v1/ContractBoard/Contract/MyContract/',
        queryParameters: queryParameters,
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        // Parse mixed response based on item_type
        final jsonData = response.data;
        if (jsonData is Map<String, dynamic> && jsonData['data'] is List) {
          final items = <dynamic>[];
          for (final item in jsonData['data']) {
            if (item is Map<String, dynamic>) {
              final itemType = item['item_type']?.toString();
              if (itemType == 'tracking') {
                items.add(FollowUpReadDto.fromMap(item));
              } else if (itemType == 'checklist') {
                items.add(SubtaskReadDto.fromMap(item));
              }
            }
          }

          final parsedResponse = GenericResponse<dynamic>(
            status: jsonData['status'] == true,
            message: jsonData['message']?.toString() ?? '',
            resultList: items,
            extra: jsonData['extra'] == null ? null : ExtraReadDto.fromJson(jsonData['extra']),
          );

          onResponse(parsedResponse);
        } else {
          onResponse(GenericResponse<dynamic>.fromJson(jsonData));
        }
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }
}

