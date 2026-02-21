import '../../../../../../data/data.dart';
import '../../entity/group_sms.dart';
import '../../enums/enums.dart';
import '../../repositories/sms_panel_repository.dart';

/// UseCase for getting list of group sms
class GetGroupSmsListUseCase {
  GetGroupSmsListUseCase(this.repository);

  final SmsPanelRepository repository;

  Future<GenericResponse<GroupSmsEntity>> call({
    required final int departmentId,
    required final int pageNumber,
    final int perPageCount = 20,
    final String? search,
    final GroupSMSStatus? status,
  }) => repository.getGroupSmsList(
    departmentId: departmentId,
    pageNumber: pageNumber,
    perPageCount: perPageCount,
    search: search,
    status: status,
  );
}
