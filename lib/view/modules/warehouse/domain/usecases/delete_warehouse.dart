import '../repositories/warehouse_repository.dart';

/// UseCase for deleting warehouse
class DeleteWarehouseUseCase {
  DeleteWarehouseUseCase(this.repository);

  final WarehouseRepository repository;

  Future<void> call(int id) => repository.deleteWarehouse(id);
}
