import '../../repositories/sms_panel_repository.dart';

/// UseCase for delete a number
class DeleteNumberUseCase {
  DeleteNumberUseCase(this.repository);

  final VoipRepository repository;

  Future<void> call(final int id) => repository.deleteNumber(id);
}
