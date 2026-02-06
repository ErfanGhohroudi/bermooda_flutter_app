import '../entities/warehouse.dart';
import '../repositories/warehouse_repository.dart';

/// UseCase for updating warehouse
class UpdateWarehouseUseCase {
  UpdateWarehouseUseCase(this.repository);

  final WarehouseRepository repository;

  Future<Warehouse> call(final int id, final Map<String, dynamic> params) =>
      repository.updateWarehouse(id, params);
}
