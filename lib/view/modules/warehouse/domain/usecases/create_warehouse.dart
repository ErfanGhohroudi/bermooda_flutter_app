import '../entities/warehouse.dart';
import '../repositories/warehouse_repository.dart';

/// UseCase for creating warehouse
class CreateWarehouseUseCase {
  CreateWarehouseUseCase(this.repository);

  final WarehouseRepository repository;

  Future<Warehouse> call(Map<String, dynamic> params) =>
      repository.createWarehouse(params);
}
