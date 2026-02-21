import 'package:u/utils/shamsi_date/src/jalali/jalali_date.dart';

import '../../../../../../data/data.dart';
import '../../entity/received_sms_entity.dart';
import '../../repositories/sms_panel_repository.dart';

class GetInboxSmsListUseCase {
  GetInboxSmsListUseCase(this.repository);

  final SmsPanelRepository repository;

  Future<GenericResponse<ReceivedSmsEntity>> call({
    required final int departmentId,
    final int? phoneId,
    final int? pageNumber,
    final int? perPageCount = 20,
    final String? search,
    final Jalali? startDate,
    final Jalali? endDate,
    final bool isExport = false,
  }) => repository.getInboxSmsList(
    departmentId: departmentId,
    phoneId: phoneId,
    pageNumber: pageNumber,
    perPageCount: perPageCount,
    search: search,
    startDate: startDate,
    endDate: endDate,
    isExport: isExport,
  );
}
