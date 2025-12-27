import 'package:flutter/cupertino.dart';
import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../data/data.dart';
import 'imported_costumer_list_controller.dart';

class ImportedCostumerListPage extends StatefulWidget {
  const ImportedCostumerListPage({
    required this.categoryId,
    required this.documentId,
    required this.documentTitle,
    super.key,
  });

  final String categoryId;
  final int? documentId;
  final String? documentTitle;

  @override
  State<ImportedCostumerListPage> createState() => _ImportedCostumerListPageState();
}

class _ImportedCostumerListPageState extends State<ImportedCostumerListPage> with ImportedCostumerListController {
  @override
  void initState() {
    initialController(
      categoryId: widget.categoryId,
      documentId: widget.documentId,
    );
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
      appBar: AppBar(title: Text(widget.documentTitle ?? '- -')),
      bottomNavigationBar: Obx(
        () {
          return AnimatedSize(
            duration: 200.milliseconds,
            curve: Curves.easeInOut,
            child: SizedBox(
              child: selectedCustomerIds.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
                      child: Row(
                        spacing: 10,
                        children: [
                          UElevatedButton(
                            title: s.sendToBoard,
                            onTap: () => sendToBoard(),
                          ).expanded(),
                          UElevatedButton(
                            title: s.delete,
                            backgroundColor: AppColors.red,
                            onTap: () => delete(),
                          ).expanded(),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          );
        },
      ),
      body: Stack(
        children: [
          Obx(
            () {
              /// Empty Widget
              if (pageState.isLoaded() && customers.isEmpty) {
                return const Center(child: WEmptyWidget());
              }
              return const SizedBox.shrink();
            },
          ),
          Column(
            children: [
              /// Search
              WSearchField(
                controller: searchCtrl,
                borderRadius: 0,
                height: 50,
                onChanged: (final value) => onSearch(),
              ),

              /// Selection Actions
              _buildSelectionActions(),
              Expanded(
                child: Obx(
                  () {
                    if (pageState.isInitial() || pageState.isLoading()) {
                      /// Loading
                      return _buildLoadingScroll();
                    }

                    /// Customers
                    return WSmartRefresher(
                      controller: refreshController,
                      onRefresh: onRefresh,
                      onLoading: onLoadMore,
                      child: ListView.separated(
                        itemCount: customers.length,
                        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: haveNoMoreData ? 100 : 0),
                        separatorBuilder: (final context, final index) => const SizedBox(height: 5),
                        itemBuilder: (final context, final index) {
                          final customer = customers[index];

                          /// Customer Item
                          return _buildItem(customer);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItem(final CustomerReadDto customer) {
    final name = customer.fullNameOrCompanyName;
    final phoneNumber = customer.phoneNumber;
    final landline = customer.landline;
    final state = customer.state?.title;
    final city = customer.city?.title;
    final address = customer.address;

    final locationSummary = _composeLocation(state, city);

    return Obx(
      () {
        final canSelect = customer.id != null;
        final isSelected = canSelect ? isCustomerSelected(customer) : false;
        final highlightColor = isSelected ? context.theme.primaryColor.withValues(alpha: 0.06) : context.theme.cardColor;

        final showSendToBoardButton = selectedCustomerIds.isEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: WCard(
            onTap: canSelect ? () => toggleCustomerSelection(customer) : null,
            showBorder: isSelected,
            borderColor: context.theme.primaryColor.withValues(alpha: 0.4),
            color: highlightColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (canSelect)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 4),
                        child: WCheckBox(
                          isChecked: isSelected,
                          onChanged: (final _) => toggleCustomerSelection(customer),
                          size: 18,
                        ),
                      ),
                    Expanded(
                      child: WCircleAvatar(
                        user: UserReadDto(id: '', fullName: name),
                        subTitle: locationSummary.isEmpty ? null : Text(locationSummary).bodySmall(color: context.theme.hintColor),
                        showFullName: true,
                        maxLines: 2,
                        size: 40,
                      ),
                    ),
                    if (showSendToBoardButton)
                      WMoreButtonIcon(
                        items: [
                          WPopupMenuItem(
                            title: s.sendToBoard,
                            icon: AppIcons.forwardMessage,
                            onTap: () => sendToBoard(id: customer.id),
                          ),
                          WPopupMenuItem(
                            title: s.delete,
                            icon: AppIcons.delete,
                            titleColor: AppColors.red,
                            iconColor: AppColors.red,
                            onTap: () => delete(id: customer.id),
                          ),
                        ],
                      ),
                  ],
                ),
                Row(
                  spacing: 10,
                  children: [
                    _buildInfoTile(
                      icon: CupertinoIcons.device_phone_portrait,
                      title: s.phoneNumber,
                      value: phoneNumber,
                    ).expanded(),
                    _buildInfoTile(
                      icon: CupertinoIcons.phone,
                      title: s.landline,
                      value: landline,
                    ).expanded(),
                  ],
                ),
                Row(
                  spacing: 10,
                  children: [
                    _buildInfoTile(
                      icon: CupertinoIcons.placemark,
                      title: s.state,
                      value: state,
                    ).expanded(),
                    _buildInfoTile(
                      icon: CupertinoIcons.placemark,
                      title: s.city,
                      value: city,
                    ).expanded(),
                  ],
                ),
                Row(
                  children: [
                    _buildInfoTile(
                      icon: CupertinoIcons.map,
                      title: s.address,
                      value: address,
                    ).expanded(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoTile({
    required final IconData icon,
    required final String title,
    required final String? value,
  }) {
    final hasValue = value != null && value.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: context.theme.hintColor.withValues(alpha: 0.05),
        border: Border.all(color: context.theme.hintColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          Row(
            spacing: 8,
            children: [
              Icon(icon, size: 18, color: context.theme.hintColor),
              Flexible(child: Text(title).bodySmall(fontWeight: FontWeight.bold, color: context.theme.hintColor)),
            ],
          ),
          Text(
            hasValue ? value : '- -',
            maxLines: 1,
          ).bodyMedium(
            color: hasValue ? context.theme.hintColor : context.theme.hintColor.withValues(alpha: 0.5),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _composeLocation(final String? state, final String? city) {
    final items = <String>[];
    if (state != null) {
      items.add(state);
    }
    if (city != null) {
      items.add(city);
    }
    return items.join(' • ');
  }

  Widget _buildSelectionActions() {
    return Obx(
      () {
        final selectableCount = customers.length;
        final selectedCount = selectedCustomerIds.length;
        final allSelected = selectableCount > 0 && selectedCount == selectableCount;

        if (pageState.isLoaded() == false || (pageState.isLoaded() && customers.isEmpty) || searchCtrl.text.isNotEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 50,
          decoration: BoxDecoration(color: context.theme.cardColor),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 10,
              children: [
                WCheckBox(
                  isChecked: allSelected,
                  onChanged: (final value) => toggleSelectAllCustomers(),
                  title: 'انتخاب همه',
                ).expanded(),
                Flexible(
                  child: Text(
                    selectableCount == 0
                        ? 'هیچ مشتری قابل انتخابی وجود ندارد'
                        : selectedCount == 0
                            ? ''
                            : '$selectedCount مورد انتخاب شده',
                    maxLines: 1,
                  ).bodySmall(
                    color: selectedCount == 0 ? context.theme.hintColor : context.theme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingScroll() {
    return ListView.separated(
      itemCount: 10,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 10),
      separatorBuilder: (final context, final index) => const SizedBox(height: 5),
      itemBuilder: (final context, final index) => const WCard(child: SizedBox(height: 100)),
    ).shimmer();
  }
}
