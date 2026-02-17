import '../../repositories/sms_panel_repository.dart';

/// UseCase for restore a department
class RestoreDepartmentUseCase {
  RestoreDepartmentUseCase(this.repository);

  final SmsPanelRepository repository;

  Future<void> call(final int id) => repository.restoreDepartment(id);
}
