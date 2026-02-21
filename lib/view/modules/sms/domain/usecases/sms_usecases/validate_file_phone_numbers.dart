import '../../entity/validation_numbers_result.dart';
import '../../repositories/sms_panel_repository.dart';

/// UseCase for validate file recipient phone numbers
class ValidateFilePhoneNumbersUseCase {
  ValidateFilePhoneNumbersUseCase(this.repository);

  final SmsPanelRepository repository;

  Future<ValidationNumbersResultEntity> call(final int fileId) => repository.validateFilePhoneNumberList(fileId);
}
