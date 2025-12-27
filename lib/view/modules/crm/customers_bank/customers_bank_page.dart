import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/theme.dart';
import '../../../../data/data.dart';
import 'customers_bank_controller.dart';
import 'import/customers_import_page.dart';

class CustomersBankPage extends StatefulWidget {
  const CustomersBankPage({
    required this.categoryId,
    super.key,
  });

  final String categoryId;

  @override
  State<CustomersBankPage> createState() => _CustomersBankPageState();
}

class _CustomersBankPageState extends State<CustomersBankPage> {
  late final CustomersBankController ctrl;

  @override
  void initState() {
    ctrl = Get.put(CustomersBankController(categoryId: widget.categoryId));
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(title: Text(s.customerDatabase)),
      floatingActionButtonLocation: isPersianLang ? FloatingActionButtonLocation.startFloat : FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: "customer_bank_fab",
        onPressed: () {
          UNavigator.push(CustomersImportPage(categoryId: ctrl.categoryId));
        },
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
      body: Obx(
        () {
          /// Error widget
          if (ctrl.pageState.isError()) {
            return Center(child: WErrorWidget(onTapButton: ctrl.onTryAgain));
          }

          return Stack(
            children: [
              /// Empty widget
              Obx(
                () {
                  if (ctrl.pageState.isLoaded() && ctrl.documents.isEmpty) {
                    return const Center(child: WEmptyWidget());
                  }
                  return const SizedBox.shrink();
                },
              ),
              Column(
                children: [
                  /// Search
                  // WSearchField(
                  //   controller: ctrl.searchCtrl,
                  //   borderRadius: 0,
                  //   height: 50,
                  //   onChanged: (final value) => ctrl.onSearch(),
                  // ),

                  /// Folders list
                  Obx(
                    () {
                      /// Loading widget
                      if (ctrl.pageState.isInitial() || ctrl.pageState.isLoading()) {
                        return _buildShimmerLoading();
                      }

                      return WSmartRefresher(
                        controller: ctrl.refreshController,
                        scrollController: ctrl.scrollController,
                        onRefresh: ctrl.onRefresh,
                        onLoading: ctrl.onLoadMore,
                        child: GridView.builder(
                          itemCount: ctrl.documents.length,
                          padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: ctrl.isAtEnd ? 100 : 10),
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 190,
                          ),
                          itemBuilder: (final context, final index) => _buildDocumentCard(ctrl.documents[index]),
                        ),
                      );
                    },
                  ).expanded(),
                ],
              ),

              /// Scroll to top button
              WScrollToTopButton(
                scrollController: ctrl.scrollController,
                show: ctrl.showScrollToTop,
                bottomMargin: 90,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDocumentCard(final CustomersBankDocument document) {
    return Stack(
      children: [
        WCard(
          showBorder: true,
          onTap: () => ctrl.navigateToDocumentImportedCustomersPage(document),
          child: Column(
            children: [
              const SizedBox(
                width: double.infinity,
                child: UImage(
                  AppImages.folder,
                  borderRadius: 15,
                ),
              ).expanded(),
              Text(
                document.exelFile?.fileName ?? '- -',
                textDirection: TextDirection.ltr,
                maxLines: 1,
              ).bodyMedium(overflow: TextOverflow.ellipsis),
            ],
          ),
        ).withTooltip(document.exelFile?.fileName ?? '- -'),
        PositionedDirectional(
          top: 10,
          end: 6,
          child: WMoreButtonIcon(
            items: [
              WPopupMenuItem(
                title: s.delete,
                icon: AppIcons.delete,
                titleColor: AppColors.red,
                iconColor: AppColors.red,
                onTap: () => ctrl.deleteDocument(document.id),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Loading widget
  Widget _buildShimmerLoading() {
    return GridView.builder(
      itemCount: 10,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 190,
      ),
      itemBuilder: (final context, final index) => const WCard(child: SizedBox.shrink()),
    ).shimmer();
  }
}
