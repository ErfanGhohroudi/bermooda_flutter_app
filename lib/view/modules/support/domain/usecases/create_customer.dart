import '../entities/support_customer_entity.dart';
import '../repositories/support_board_repository.dart';

class CreateCustomerUseCase {
  final SupportBoardRepository repository;

  CreateCustomerUseCase(this.repository);

  Future<SupportCustomer> call({
    required final int departmentId,
    required final int sectionId,
    required final String fullName,
    required final String phoneNumber,
  }) {
    return repository.createCustomer(
      departmentId: departmentId,
      sectionId: sectionId,
      fullName: fullName,
      phoneNumber: phoneNumber,
    );
  }
}
