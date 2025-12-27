import '../../../../core/utils/enums/enums.dart';
import '../../../../view/modules/reports/models/report_params.dart';
import '../../../data.dart';

abstract class IReportDatasource {
  Future<void> getAllReports({
    required final int? sourceId,
    required final int pageNumber,
    required final ReportType filter,
    required final Function(GenericResponse<IReportReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  });

  Future<void> create({
    required final int? sourceId,
    required final IReportParams params,
    required final Function(GenericResponse<IReportReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  });
}