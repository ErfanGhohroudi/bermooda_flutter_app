import '../../../data.dart';

abstract class ILabelDatasource {
  Future<void> getLabels({
    required final String sourceId,
    required final Function(GenericResponse<LabelReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  });

  Future<void> createLabel({
    required final String sourceId,
    required final String title,
    required final String? colorCode,
    required final Function(GenericResponse<LabelReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  });

  Future<void> updateLabel({
    required final String? slug,
    required final String sourceId,
    required final String title,
    required final String? colorCode,
    required final Function(GenericResponse<LabelReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  });

  Future<void> deleteLabel({
    required final String? slug,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  });
}
