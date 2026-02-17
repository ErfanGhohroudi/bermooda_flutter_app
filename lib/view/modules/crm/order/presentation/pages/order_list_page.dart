import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../controllers/order_list_controller.dart';
import '../widgets/order_card.dart';

class CustomerOrderListPage extends StatefulWidget {
  const CustomerOrderListPage({
    required this.customerId,
    super.key,
  });

  final int customerId;

  @override
  State<CustomerOrderListPage> createState() => _CustomerOrderListPageState();
}

class _CustomerOrderListPageState extends State<CustomerOrderListPage> {
  late final CustomerOrderListController ctrl;

  @override
  void initState() {
    ctrl = Get.put(CustomerOrderListController(customerId: widget.customerId));
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<CustomerOrderListController>();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      floatingActionButtonLocation: isPersianLang
          ? FloatingActionButtonLocation.startFloat
          : FloatingActionButtonLocation.endFloat,
      floatingActionButton: WSpeedDial(
        heroTag: "newCustomerOrderFAB",
        tooltip: s.directMessage,
        activeIcon: Icons.close,
        icon: Icons.add,
        overlayOpacity: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        children: [
          // SpeedDialChild(
          //   label: s.newContract,
          //   backgroundColor: context.theme.primaryColor,
          //   onTap: ctrl.onTapCreateContract,
          //   child: const UImage(
          //     AppIcons.contractOutline,
          //     color: Colors.white,
          //     size: 25,
          //   ),
          // ),
          SpeedDialChild(
            label: s.newInvoice,
            backgroundColor: context.theme.primaryColor,
            onTap: ctrl.onTapCreateInvoice,
            child: const UImage(
              AppIcons.invoiceOutline,
              color: Colors.white,
              size: 25,
            ),
          ),
        ],
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
      body: Obx(
        () {
          if (ctrl.pageState.isInitial() || ctrl.pageState.isLoading()) {
            return const Center(child: WCircularLoading());
          }

          if (ctrl.pageState.isError()) {
            return Center(child: WErrorWidget(onTapButton: ctrl.onRefresh));
          }

          if (ctrl.pageState.isLoaded() && ctrl.orders.isEmpty) {
            return const Center(child: WEmptyWidget());
          }

          return WSmartRefresher(
            controller: ctrl.refreshController,
            onRefresh: ctrl.onRefresh,
            enablePullUp: false,
            child: ListView.separated(
              itemCount: ctrl.orders.length,
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 100),
              separatorBuilder: (final context, final index) => const SizedBox(height: 8),
              itemBuilder: (final context, final index) {
                final order = ctrl.orders[index];
                return WOrderCard(
                  order: order,
                  ctrl: ctrl,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
