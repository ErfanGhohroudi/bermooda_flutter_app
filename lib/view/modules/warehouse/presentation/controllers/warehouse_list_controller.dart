import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../data/repositories/warehouse_repository_impl.dart';
import '../../domain/entities/warehouse.dart';
import '../../domain/usecases/get_warehouses.dart';
import '../../domain/usecases/delete_warehouse.dart';
import '../../domain/usecases/update_warehouses_orders.dart';

mixin WarehouseListController {
  final WarehouseRepositoryImpl _repository = WarehouseRepositoryImpl();
  late final GetWarehousesUseCase _getWarehousesUseCase = GetWarehousesUseCase(_repository);
  late final UpdateWarehousesOrdersUseCase _updateWarehousesOrdersUseCase = UpdateWarehousesOrdersUseCase(_repository);
  late final DeleteWarehouseUseCase _deleteWarehouseUseCase = DeleteWarehouseUseCase(_repository);

  final TextEditingController searchController = TextEditingController();
  final RefreshController refreshController = RefreshController();
  final RxBool isReorderEnabled = false.obs;
  final Rx<PageState> pageState = PageState.initial.obs;
  bool isEndOfList = false;
  int pageNumber = 0; // API uses 0-based pagination
  final RxList<Warehouse> warehouses = <Warehouse>[].obs;

  void disposeItems() {
    searchController.dispose();
    refreshController.dispose();
    isReorderEnabled.close();
    pageState.close();
    warehouses.close();
  }

  void initialController() {
    _getWarehouses();
  }

  void onSearch() {
    pageState.loading();
    onRefresh();
  }

  void onRefresh() {
    pageNumber = 0;
    _getWarehouses();
  }

  void loadMore() {
    pageNumber++;
    _getWarehouses();
  }

  Future<void> _getWarehouses() async {
    try {
      final result = await _getWarehousesUseCase(
        page: pageNumber,
        search: searchController.text.trim().isEmpty ? null : searchController.text.trim(),
      );

      if (warehouses.subject.isClosed) return;

      if (pageNumber == 0) {
        warehouses.assignAll(result);
        refreshController.refreshCompleted();
      } else {
        warehouses.addAll(result);
      }

      if (result.isEmpty) {
        refreshController.loadNoData();
        isEndOfList = true;
      } else {
        refreshController.loadComplete();
        isEndOfList = false;
      }

      pageState.loaded();
    } catch (e) {
      if (pageNumber == 0) {
        refreshController.refreshFailed();
        pageState.error();
      } else {
        refreshController.loadFailed();
      }
    }
  }

  void deleteWarehouse(
    final Warehouse warehouse, {
    required final VoidCallback action,
  }) {
    appShowYesCancelDialog(
      title: s.delete,
      description: s.areYouSureToDeleteWarehouse,
      yesButtonTitle: s.delete,
      yesBackgroundColor: AppColors.red,
      onYesButtonTap: () {
        AppNavigator.back();
        _delete(warehouse, action: action);
      },
    );
  }

  Future<void> _delete(
    final Warehouse warehouse, {
    required final VoidCallback action,
  }) async {
    try {
      await _deleteWarehouseUseCase(warehouse.id);
      action();
    } catch (e) {
      // Error handling
    }
  }

  void insertWarehouse(final Warehouse newWarehouse) {
    warehouses.insert(0, newWarehouse);
  }

  void toggleReorder() {
    isReorderEnabled(!isReorderEnabled.value);
    pageState.refresh();
  }

  Future<void> updateOrders() async {
    final warehouseIds = warehouses.map((final e) => e.id).whereType<int>().toList();
    try {
      await _updateWarehousesOrdersUseCase(warehouseIds);
      isReorderEnabled(!isReorderEnabled.value);
      AppSnackBar.snackbarGreen(title: s.done, subtitle: s.changesSaved);
      pageState.refresh();
    } catch (e) {
      // Error handling
    }
  }
}
