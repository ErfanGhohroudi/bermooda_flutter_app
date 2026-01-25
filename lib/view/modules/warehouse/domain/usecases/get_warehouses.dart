import '../entities/warehouse.dart';
import '../repositories/warehouse_repository.dart';

/// UseCase for getting warehouses list
class GetWarehousesUseCase {
  GetWarehousesUseCase(this.repository);

  final WarehouseRepository repository;

  Future<List<Warehouse>> call({
    final int page = 0,
    final String? search,
  }) => repository.getWarehouses(page: page, search: search);
}
