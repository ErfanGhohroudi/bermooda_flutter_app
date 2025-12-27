import 'package:u/utilities.dart';

import '../../../core/widgets/widgets.dart';
import '../../../core/core.dart';
import '../../../core/theme.dart';
import '../../../data/data.dart';
import 'subscription_invoice_list_controller.dart';

class SubscriptionInvoiceListPage extends StatefulWidget {
  const SubscriptionInvoiceListPage({
    required this.workspaceId,
    super.key,
  });

  final String workspaceId;

  @override
  State<SubscriptionInvoiceListPage> createState() => _SubscriptionInvoiceListPageState();
}

class _SubscriptionInvoiceListPageState extends State<SubscriptionInvoiceListPage> with SubscriptionInvoiceListController {
  @override
  void initState() {
    initialController(widget.workspaceId);
    super.initState();
  }

  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(title: Text(s.invoices)),
      body: Obx(
        () {
          if (pageState.isError()) {
            return Center(child: WErrorWidget(onTapButton: onTryAgain));
          }

          if (pageState.isLoaded() && invoices.isEmpty) {
            return const Center(child: WEmptyWidget());
          }

          return pageState.isLoaded()
              ? WSmartRefresher(
                  controller: refreshController,
                  onRefresh: onRefresh,
                  onLoading: onLoadMore,
                  child: ListView.separated(
                    itemCount: invoices.length,
                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 10),
                    separatorBuilder: (final context, final index) => const SizedBox(height: 5),
                    itemBuilder: (final context, final index) {
                      final invoice = invoices[index];

                      return _invoiceItem(invoice);
                    },
                  ),
                )
              : ListView.separated(
                  itemCount: 10,
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 10),
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (final context, final index) => const SizedBox(height: 5),
                  itemBuilder: (final context, final index) => const WCard(child: SizedBox(height: 50)),
                ).shimmer();
        },
      ),
    );
  }

  Widget _invoiceItem(final SubscriptionInvoiceReadDto invoice) {
    return WCard(
      onTap: () {
        if (invoice.invoiceUrl == null) return;
        ULaunch.launchURL(invoice.invoiceUrl!);
      },
      child: Row(
        spacing: 10,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.orange.withValues(alpha: 0.7),
            radius: 25,
            child: const UImage(AppIcons.invoiceOutline, color: Colors.white),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(invoice.invoiceCode).titleMedium(),
              Text(invoice.title).bodyMedium(color: context.theme.hintColor),
              if (invoice.paidAt != null) Text("${s.date}: ${invoice.paidAt!.toJalaliDateTime()}").bodySmall(color: context.theme.hintColor),
            ],
          ).expanded(),
          Icon(Icons.arrow_forward_ios_rounded, color: context.theme.hintColor),
        ],
      ),
    );
  }
}
