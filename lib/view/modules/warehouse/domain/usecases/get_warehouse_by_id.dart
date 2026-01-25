import '../entities/warehouse.dart';
import '../repositories/warehouse_repository.dart';

/// UseCase for getting warehouse by ID
class GetWarehouseByIdUseCase {
  GetWarehouseByIdUseCase(this.repository);

  final WarehouseRepository repository;

  Future<Warehouse> call(final int id) => repository.getWarehouseById(id);
}
