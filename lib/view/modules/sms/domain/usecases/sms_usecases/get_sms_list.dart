import '../../../../../../data/data.dart';
import '../../entity/sms.dart';
import '../../enums/enums.dart';
import '../../repositories/sms_panel_repository.dart';

/// UseCase for getting list of single sms
class GetSmsListUseCase {
  GetSmsListUseCase(this.repository);

  final SmsPanelRepository repository;

  Future<GenericResponse<SmsEntity>> call({
    required final int departmentId,
    required final int pageNumber,
    final int perPageCount = 20,
    final String? search,
    final SMSStatus? status,
  }) => repository.getSmsList(
    departmentId: departmentId,
    pageNumber: pageNumber,
    perPageCount: perPageCount,
    search: search,
    status: status,
  );
}
