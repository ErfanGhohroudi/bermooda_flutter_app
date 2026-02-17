import '../../entity/sms_panel_number.dart';
import '../../enums/enums.dart';
import '../../repositories/sms_panel_repository.dart';

/// UseCase for create a new number
class CreateNumberUseCase {
  CreateNumberUseCase(this.repository);

  final SmsPanelRepository repository;

  Future<SmsPanelNumber> call({
    required final String number,
    required final String providerName,
    required final ProviderType providerType,
    required final String apiKey,
  }) => repository.createNumber(
    number: number,
    providerName: providerName,
    providerType: providerType,
    apiKey: apiKey,
  );
}
