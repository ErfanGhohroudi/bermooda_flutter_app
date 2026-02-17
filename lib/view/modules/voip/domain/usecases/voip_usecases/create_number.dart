import '../../entity/voip_number.dart';
import '../../repositories/voip_repository.dart';

/// UseCase for create a new number
class CreateNumberUseCase {
  CreateNumberUseCase(this.repository);

  final VoipRepository repository;

  Future<VoipNumber> call({
    required final int departmentId,
    required final String number,
    required final String name,
    // required final ProviderType providerType,
    required final String serviceId,
    required final String webserviceToken,
  }) => repository.createNumber(
    departmentId: departmentId,
    number: number,
    name: name,
    // providerType: providerType,
    serviceId: serviceId,
    webserviceToken: webserviceToken,
  );
}
