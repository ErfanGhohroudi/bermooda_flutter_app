import '../entities/warehouse.dart';
import '../repositories/warehouse_repository.dart';

/// UseCase for updating warehouse
class UpdateWarehousesOrdersUseCase {
  UpdateWarehousesOrdersUseCase(this.repository);

  final WarehouseRepository repository;

  Future<List<Warehouse>> call(final List<int> warehouseIds) =>
      repository.updateWarehousesOrders(warehouseIds);
}
