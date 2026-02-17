import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../domain/entities/warehouse.dart';
import '../controllers/warehouse_list_controller.dart';
import '../widgets/warehouse_card.dart';
import 'warehouse_create_update_page.dart';

class WarehouseListPage extends StatefulWidget {
  const WarehouseListPage({super.key});

  @override
  State<WarehouseListPage> createState() => _WarehouseListPageState();
}

class _WarehouseListPageState extends State<WarehouseListPage> with WarehouseListController {
  @override
  void initState() {
    initialController();
    super.initState();
  }

  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (final didPop, final result) {
        if (didPop) return;
        if (isReorderEnabled.value) {
          toggleReorder();
        } else {
          AppNavigator.back();
        }
      },
      child: UScaffold(
        appBar: AppBar(
          title: Text(s.warehouses),
          actions: [
            Obx(
              () => IconButton(
                tooltip: isReorderEnabled.value ? s.save : s.reorder,
                icon: isReorderEnabled.value
                    ? const Icon(Icons.check, size: 25, color: Colors.white)
                    : const UImage(AppIcons.arrowSwapVert, size: 25, color: Colors.white),
                onPressed: () {
                  if (isReorderEnabled.value) {
                    updateOrders();
                    return;
                  }
                  toggleReorder();
                },
              ),
            ),
            const SizedBox(width: 6),
          ],
        ),
        floatingActionButtonLocation: isPersianLang
            ? FloatingActionButtonLocation.startFloat
            : FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          heroTag: "warehouseFAB",
          onPressed: () {
            bottomSheet(
              title: s.newWarehouse,
              child: WarehouseCreateUpdatePage(
                onResponse: (final warehouse) {
                  insertWarehouse(warehouse);
                },
              ),
            );
          },
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
        ),
        body: Column(
          children: [
            WSearchField(
              controller: searchController,
              borderRadius: 0,
              height: 50,
              onChanged: (final value) => onSearch(),
            ),
            Expanded(
              child: Obx(
                () => WSmartRefresher(
                  controller: refreshController,
                  onRefresh: onRefresh,
                  onLoading: loadMore,
                  child: pageState.isLoaded()
                      ? warehouses.isNotEmpty
                            ? CustomScrollView(
                                slivers: [
                                  SliverPadding(
                                    padding: EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                      top: 10,
                                      bottom: isEndOfList ? 100 : 0,
                                    ),
                                    sliver: SliverReorderableList(
                                      itemCount: warehouses.length,
                                      onReorder: (final oldIndex, newIndex) {
                                        if (oldIndex < newIndex) {
                                          newIndex -= 1;
                                        }
                                        final Warehouse item = warehouses.removeAt(oldIndex);
                                        warehouses.insert(newIndex, item);
                                      },
                                      itemBuilder: (final context, final index) => WarehouseCard(
                                        key: ValueKey(warehouses[index].id),
                                        index: index,
                                        warehouse: warehouses[index],
                                        isReorderEnabled: isReorderEnabled.value,
                                        showMoreIcon: true,
                                        onEdited: (final warehouse) {
                                          warehouses[index] = warehouse;
                                          warehouses.refresh();
                                        },
                                        onDelete: () => deleteWarehouse(
                                          warehouses[index],
                                          action: () {
                                            warehouses.removeAt(index);
                                            warehouses.refresh();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const Center(child: WEmptyWidget())
                      : ListView.builder(
                          itemCount: 10,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (final context, final index) => WCard(
                            child: SizedBox(
                              width: context.width,
                              height: 100,
                            ),
                          ),
                        ).shimmer(),
                ),
              ).expanded(),
            ),
          ],
        ),
      ),
    );
  }
}
