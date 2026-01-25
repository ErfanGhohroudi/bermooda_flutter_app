import '../entities/warehouse.dart';

/// Repository interface for Warehouse operations
/// Follows Dependency Inversion Principle - depends on abstraction
abstract class WarehouseRepository {
  /// Get list of warehouses
  Future<List<Warehouse>> getWarehouses({
    final int page = 0,
    final String? search,
  });

  /// Get warehouse by ID
  Future<Warehouse> getWarehouseById(final int id);

  /// Create new warehouse
  Future<Warehouse> createWarehouse(final Map<String, dynamic> params);

  /// Update warehouse
  Future<Warehouse> updateWarehouse(final int id, final Map<String, dynamic> params);

  /// Update warehouses orders
  Future<List<Warehouse>> updateWarehousesOrders(final List<int> warehouseIds);

  /// Delete warehouse
  Future<void> deleteWarehouse(final int id);
}
