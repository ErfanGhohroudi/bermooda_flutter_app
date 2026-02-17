import '../../entity/sms_panel_number.dart';
import '../../enums/enums.dart';
import '../../repositories/sms_panel_repository.dart';

/// UseCase for create a new number
class CreateNumberUseCase {
  CreateNumberUseCase(this.repository);

  final VoipRepository repository;

  Future<SmsPanelNumber> call({
    required final int departmentId,
    required final String number,
    required final String providerName,
    required final ProviderType providerType,
    required final String apiKey,
  }) => repository.createNumber(
    departmentId: departmentId,
    number: number,
    providerName: providerName,
    providerType: providerType,
    apiKey: apiKey,
  );
}
