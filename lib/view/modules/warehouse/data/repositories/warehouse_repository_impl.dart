import 'package:u/utilities.dart';

import '../../../../../data/data.dart';
import '../../domain/entities/warehouse.dart';
import '../../domain/repositories/warehouse_repository.dart';

/// Repository Implementation
/// Converts DTOs to Domain Entities (Data Layer to Domain Layer)
class WarehouseRepositoryImpl implements WarehouseRepository {
  WarehouseRepositoryImpl();

  WarehouseDatasource get _warehouseDatasource => Get.find<WarehouseDatasource>();

  @override
  Future<List<Warehouse>> getWarehouses({
    final int page = 0,
    final String? search,
  }) async {
    final completer = Completer<List<Warehouse>>();
    _warehouseDatasource.getWarehouses(
      page: page,
      search: search,
      onResponse: (final response) {
        final warehouses = (response.resultList ?? [])
            .map((final dto) => _mapWarehouseDtoToEntity(dto))
            .toList();
        completer.complete(warehouses);
      },
      onError: (final error) {
        completer.completeError(error);
      },
    );
    return completer.future;
  }

  @override
  Future<Warehouse> getWarehouseById(final int id) async {
    final completer = Completer<Warehouse>();
    _warehouseDatasource.getWarehouseById(
      warehouseId: id,
      onResponse: (final response) {
        completer.complete(_mapWarehouseDtoToEntity(response.result!));
      },
      onError: (final error) {
        completer.completeError(error);
      },
    );
    return completer.future;
  }

  @override
  Future<Warehouse> createWarehouse(final Map<String, dynamic> params) async {
    final completer = Completer<Warehouse>();
    _warehouseDatasource.createWarehouse(
      data: params,
      onResponse: (final response) {
        completer.complete(_mapWarehouseDtoToEntity(response.result!));
      },
      onError: (final error) {
        completer.completeError(error);
      },
    );
    return completer.future;
  }

  @override
  Future<Warehouse> updateWarehouse(final int id, final Map<String, dynamic> params) async {
    final completer = Completer<Warehouse>();
    _warehouseDatasource.updateWarehouse(
      warehouseId: id,
      data: params,
      onResponse: (final response) {
        completer.complete(_mapWarehouseDtoToEntity(response.result!));
      },
      onError: (final error) {
        completer.completeError(error);
      },
    );
    return completer.future;
  }

  @override
  Future<List<Warehouse>> updateWarehousesOrders(final List<int> warehouseIds) async {
    final completer = Completer<List<Warehouse>>();
    _warehouseDatasource.updateOrders(
      warehouseIds: warehouseIds,
      onResponse: (final response) {
        final list = (response.resultList ?? []).map((final dto) => _mapWarehouseDtoToEntity(dto)).toList();
        completer.complete(list);
      },
      onError: (final error) {
        completer.completeError(error);
      },
      withRetry: true,
    );
    return completer.future;
  }

  @override
  Future<void> deleteWarehouse(final int id) async {
    final completer = Completer<void>();
    _warehouseDatasource.deleteWarehouse(
      warehouseId: id,
      onResponse: () {
        completer.complete();
      },
      onError: (final error) {
        completer.completeError(error);
      },
    );
    return completer.future;
  }

  /// Map WarehouseReadDto to Warehouse Entity
  Warehouse _mapWarehouseDtoToEntity(final WarehouseReadDto dto) {
    return Warehouse(
      id: dto.id ?? 0,
      workspace: dto.workspace,
      workSpaceId: dto.workSpaceId,
      owner: dto.owner,
      ownerId: dto.ownerId,
      title: dto.title,
      code: dto.code,
      capacity: dto.capacity,
      description: dto.description,
      state: dto.state,
      stateId: dto.stateId,
      city: dto.city,
      cityId: dto.cityId,
      stateName: dto.stateName,
      cityName: dto.cityName,
      latitude: dto.latitude,
      longitude: dto.longitude,
      mainCategory: dto.mainCategory,
      mainCategoryId: dto.mainCategoryId,
      avatar: dto.avatar,
      avatarId: dto.avatarId,
      avatarUrl: dto.avatarFile?.url,
      members: dto.members,
      created: dto.created,
    );
  }
}
