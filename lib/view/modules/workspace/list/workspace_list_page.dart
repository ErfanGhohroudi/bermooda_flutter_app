import 'package:bermooda_business/core/utils/enums/enums.dart';
import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/theme.dart';
import '../../../../data/data.dart';
import '../../subscription_invoice/subscription_invoice_list_page.dart';
import '../update/workspace_update_page.dart';
import '../../subscription/subscription_page.dart';
import '../create/create_workspace_page.dart';
import 'workspace_list_controller.dart';

class WorkspaceListPage extends StatefulWidget {
  const WorkspaceListPage({
    this.push = false,
    this.onPop,
    super.key,
  });

  final bool push;
  final Function()? onPop;

  @override
  State<WorkspaceListPage> createState() => _WorkspaceListPageState();
}

class _WorkspaceListPageState extends State<WorkspaceListPage> with WorkspaceListController, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    getWorkspacesInfo(
      action: (final list) {
        if (widget.push) {
          final workspaceInfo = list.firstWhereOrNull((final workspace) => workspace.id == core.currentWorkspace.value.id);
          if (workspaceInfo != null) {
            UNavigator.push(
              WorkspaceUpdatePage(
                workspaceInfo: workspaceInfo,
                onResponse: (final workspaceInfo) {
                  final i = workspaces.indexOf(workspaces.firstWhereOrNull((final e) => e.id == workspaceInfo.id));
                  if (i != -1) {
                    workspaces[i] = workspaceInfo;
                  }
                },
              ),
            );
          }
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    refreshController.dispose();
    pageState.close();
    workspaces.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return PopScope(
      onPopInvokedWithResult: (final didPop, final result) {
        if (widget.onPop != null) {
          widget.onPop?.call();
        }
      },
      child: UScaffold(
        appBar: AppBar(title: Text(s.myBusinessList)),
        floatingActionButtonLocation: isPersianLang
            ? FloatingActionButtonLocation.startFloat
            : FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          heroTag: "workspaceListFAB",
          tooltip: s.newWorkspace,
          onPressed: () => showCreateWorkspaceDialog(),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
        ),
        body: Column(
          children: [
            // Container(
            //   width: context.width,
            //   color: context.theme.cardColor,
            //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            //   child: WSearchField(
            //     controller: searchController,
            //     onChanged: (final value) {},
            //   ),
            // ),
            Flexible(
              child: WSmartRefresher(
                controller: refreshController,
                onRefresh: getWorkspacesInfo,
                enablePullUp: false,
                child: SingleChildScrollView(
                  child: Obx(
                    () {
                      if (pageState.isInitial() || pageState.isLoading()) {
                        return ListView.separated(
                          itemCount: 5,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 16, bottom: 100),
                          separatorBuilder: (final context, final index) => const SizedBox(height: 5),
                          itemBuilder: (final context, final index) => const WCard(child: SizedBox(height: 120)),
                        ).shimmer().pSymmetric(horizontal: 16);
                      }

                      if (pageState.isError()) {
                        return Center(child: WErrorWidget(onTapButton: () => getWorkspacesInfo()));
                      }

                      if (pageState.isLoaded() && workspaces.isEmpty) {
                        return const Center(child: WEmptyWidget());
                      }

                      return ListView.separated(
                        itemCount: workspaces.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 10, bottom: 100),
                        separatorBuilder: (final context, final index) => const SizedBox(height: 5),
                        itemBuilder: (final context, final index) => _itemWidget(
                          workspace: workspaces[index],
                          onEdit: (final workspace) {
                            workspaces[index] = workspace;
                            workspaces.refresh();
                          },
                          onDelete: () {
                            workspaces.removeAt(index);
                          },
                        ),
                      ).pSymmetric(horizontal: 16);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemWidget({
    required final WorkspaceInfoReadDto workspace,
    required final Function(WorkspaceInfoReadDto workspace) onEdit,
    required final VoidCallback onDelete,
  }) {
    final SubscriptionReadDto? sub = workspace.subscription;
    final SubscriptionStatus? subStatus = sub?.status;

    return WCard(
      showBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: context.theme.primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: context.theme.primaryColor.withAlpha(100),
                  foregroundImage: CachedNetworkImageProvider(workspace.avatar?.url ?? ''),
                  child: Text(
                    (workspace.title ?? '').length < 2
                        ? (workspace.title ?? '')
                        : (workspace.title ?? '').substring(0, 2).split('').join('\u200C'),
                  ).bodyMedium(color: Colors.white),
                ),
              ),
              Text(
                workspace.title ?? '',
                maxLines: 2,
              ).bodyMedium(overflow: TextOverflow.ellipsis).pSymmetric(horizontal: 10).expanded(),
              const Icon(Icons.arrow_forward_ios_rounded, size: 20),
            ],
          ),
          _subInfo(workspace, sub, subStatus),
          Row(
            spacing: 10,
            children: [
              UElevatedButton(
                title: s.buySubscription,
                backgroundColor: context.theme.primaryColor,
                onTap: () {
                  UNavigator.push(SubscriptionPage(workspaceId: workspace.id));
                },
              ).expanded(),
              InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () => UNavigator.push(SubscriptionInvoiceListPage(workspaceId: workspace.id)),
                child: Ink(
                  decoration: BoxDecoration(
                    color: AppColors.orange.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  width: 45,
                  height: 45,
                  padding: const EdgeInsets.all(10),
                  child: const UImage(AppIcons.invoiceOutline, color: Colors.white),
                ).withTooltip(s.invoices),
              ),
            ],
          ).marginOnly(top: 10),
          if (kDebugMode)
            UElevatedButton(
              title: s.delete,
              backgroundColor: AppColors.red,
              onTap: () {
                deleteWorkspace(id: workspace.id, action: onDelete);
              },
            ),
        ],
      ),
      onTap: () {
        UNavigator.push(
          WorkspaceUpdatePage(
            workspaceInfo: workspace,
            onResponse: onEdit,
          ),
        );
      },
    );
  }

  Widget _subInfo(
    final WorkspaceInfoReadDto workspace,
    final SubscriptionReadDto? sub,
    final SubscriptionStatus? subStatus,
  ) {
    if (subStatus == null || sub == null || sub.isNoPurchase) return const SizedBox.shrink();

    return Column(
      spacing: 6,
      children: [
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(isPersianLang ? "${s.status} ${s.subscription}:" : "${s.subscription} ${s.status}:").bodyMedium(),
            WLabel(
              text: subStatus.title,
              color: subStatus.color,
            ),
          ],
        ),
        if (sub.isExpired == false)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${s.remaining}:").bodyMedium(),
              Text("${sub.remainingDays} ${s.days}").bodyMedium(),
            ],
          ),
      ],
    );
  }
}
