import '../../entity/validation_numbers_result.dart';
import '../../repositories/sms_panel_repository.dart';

/// UseCase for validate recipient phone numbers
class ValidatePhoneNumbersUseCase {
  ValidatePhoneNumbersUseCase(this.repository);

  final SmsPanelRepository repository;

  Future<ValidationNumbersResultEntity> call(final List<String> numbers) => repository.validatePhoneNumberList(numbers);
}
