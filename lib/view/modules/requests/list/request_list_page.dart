import 'package:u/utilities.dart';

import '../../../../core/utils/enums/request_enums_extensions.dart';
import '../../../../core/theme.dart';
import '../../../../core/utils/enums/request_enums.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../data/data.dart';
import '../widgets/request_card.dart';
import 'request_list_controller.dart';
export 'request_list_controller.dart';

class RequestListPage extends StatefulWidget {
  const RequestListPage({
    required this.pageType,
    this.member,
    this.department,
    this.canEdit = true,
    super.key,
  }) : assert(
            (pageType == RequestListPageType.memberProfile && member != null) || (pageType != RequestListPageType.memberProfile && member == null),
            "If pageType is memberProfile, member must not be null. "
            "If pageType is not memberProfile, member must be null.");

  final RequestListPageType pageType;
  final MemberReadDto? member;
  final HRDepartmentReadDto? department;
  final bool canEdit;

  @override
  State<RequestListPage> createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> with RequestListController {
  late final UserReadDto? user;

  bool get canEdit => widget.canEdit && hrModuleIsActive;

  @override
  void initState() {
    user = widget.pageType == RequestListPageType.memberProfile && widget.member?.userAccount?.id != null
        ? UserReadDto(
            id: widget.member?.userAccount?.id.toString() ?? '',
            fullName: widget.member?.fullName,
            avatar: widget.member?.userAccount?.avatarUrlMain,
            avatarUrl: widget.member?.userAccount?.avatarUrlMain?.url,
          )
        : null;
    initialController(
      pageType: widget.pageType,
      memberId: widget.member?.id,
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
      floatingActionButtonLocation: isPersianLang ? FloatingActionButtonLocation.startFloat : FloatingActionButtonLocation.endFloat,
      floatingActionButton: canEdit && showNewRequestFAB
          ? FloatingActionButton(
              heroTag: hashCode.toString(),
              tooltip: s.submitRequest,
              child: const Icon(Icons.add_rounded, color: Colors.white),
              onPressed: () => createRequest(user),
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter and Search
          if (showFilter)
            Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsetsDirectional.only(start: 16, end: 16, top: 10),
                child: Row(
                  spacing: 6,
                  children: StatusFilter.values.map(
                    (final filter) {
                      final isSelected = selectedFilter.value == filter;

                      return FilterChip(
                        label: Text(filter.getTitle()),
                        labelStyle: context.textTheme.bodyMedium?.copyWith(color: isSelected ? Colors.white : null),
                        selected: isSelected,
                        onSelected: (final value) => switchFilter(filter),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          Expanded(
            child: Stack(
              children: [
                Obx(
                  () => pageState.isLoaded() && requests.isEmpty ? const WEmptyWidget().alignAtCenter() : const SizedBox(),
                ),
                Obx(
                  () => WSmartRefresher(
                    controller: refreshController,
                    scrollController: scrollController,
                    onRefresh: refreshRequests,
                    onLoading: loadMoreRequests,
                    enablePullUp: pageState.isLoaded(),
                    enablePullDown: pageState.isLoaded(),
                    child: pageState.isLoaded()
                        ? ListView.separated(
                            itemCount: requests.length,
                            padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: isAtEnd ? 100 : 10),
                            separatorBuilder: (final context, final index) => const SizedBox(height: 5),
                            itemBuilder: (final context, final index) => _getItemCard(requests[index]),
                          )
                        : ListView.separated(
                            itemCount: 5,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 100),
                            separatorBuilder: (final context, final index) => const SizedBox(height: 5),
                            itemBuilder: (final context, final index) => const WCard(child: SizedBox(height: 200)),
                          ).shimmer(),
                  ),
                ),
                WScrollToTopButton(
                  scrollController: scrollController,
                  show: showScrollToTop,
                  bottomMargin: canEdit && showNewRequestFAB ? 90 : 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getItemCard(final IRequestReadDto request) {
    switch (pageType) {
      case RequestListPageType.memberProfile:
        return _memberProfileRequestItemCard(request);
      case RequestListPageType.myRequests:
        return _myRequestItemCard(request);
      case RequestListPageType.myReviews:
        return _myRequestItemCard(request);
      case RequestListPageType.archive:
        return _myRequestItemCard(request);
    }
  }

  Widget _myRequestItemCard(final IRequestReadDto request) => WRequestCard(
        request: request,
        onSelectedNewStatus: (final status) => callChangeStatus(request, status),
        canEdit: canEdit,
      );

  Widget _memberProfileRequestItemCard(final IRequestReadDto request) {
    return WRequestCard(
      request: request,
      showRequestingUser: false,
      canEdit: canEdit,
      onSelectedNewStatus: (final status) => callChangeStatus(request, status),
      addReviewersButton: UElevatedButton(
        width: double.infinity,
        title: s.addReviewers,
        backgroundColor: AppColors.brown,
        onTap: () => onTapAddReviewers(request),
      ),
    );
  }
}
