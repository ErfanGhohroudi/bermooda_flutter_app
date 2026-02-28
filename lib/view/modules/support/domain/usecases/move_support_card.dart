import '../../../../../data/data.dart';
import '../repositories/support_board_repository.dart';

class MoveSupportCardUseCase {
  final SupportBoardRepository repository;

  MoveSupportCardUseCase(this.repository);

  void call({
    required final String cardSlug,
    required final String targetSectionSlug,
    required final String? previousCardSlug,
    required final String? nextCardSlug,
    required final Function(GenericResponse<dynamic> response) onResponse,
    required final Function(GenericResponse<dynamic> error) onError,
  }) {
    repository.moveCard(
      cardSlug: cardSlug,
      targetSectionSlug: targetSectionSlug,
      previousCardSlug: previousCardSlug,
      nextCardSlug: nextCardSlug,
      onResponse: onResponse,
      onError: onError,
    );
  }
}
