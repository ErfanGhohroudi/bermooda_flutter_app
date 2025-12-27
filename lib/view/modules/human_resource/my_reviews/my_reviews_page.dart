import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../data/data.dart';
import '../../requests/widgets/request_card.dart';
import 'my_reviews_controller.dart';

class MyReviewsPage extends StatefulWidget {
  const MyReviewsPage({
    required this.department,
    super.key,
  });

  final HRDepartmentReadDto department;

  @override
  State<MyReviewsPage> createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends State<MyReviewsPage> with MyReviewsController {
  @override
  void initState() {
    initialController(widget.department);
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
      appBar: AppBar(title: Text(s.myReviews)),
      body: Stack(
        children: [
          Obx(
            () => pageState.isLoaded() && requests.isEmpty ? const Center(child: WEmptyWidget()) : const SizedBox.shrink(),
          ),
          Column(
            children: [
              WSearchField(
                controller: searchCtrl,
                borderRadius: 0,
                height: 50,
                onChanged: (final value) => onSearch(),
              ),
              Expanded(
                child: Obx(
                  () {
                    if (pageState.isLoading() || pageState.isInitial()) {
                      return _buildLoadingListShimmer();
                    }

                    return WSmartRefresher(
                      controller: refreshController,
                      enablePullDown: pageState.isLoaded(),
                      onRefresh: refreshListData,
                      enablePullUp: pageState.isLoaded(),
                      onLoading: loadMoreListData,
                      child: ListView.builder(
                        itemCount: requests.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        itemBuilder: (final context, final index) {
                          final request = requests[index];
                          return WRequestCard(
                            request: request,
                            onSelectedNewStatus: (final status) => callChangeStatus(request, status),
                          );
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

  Widget _buildLoadingListShimmer() {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (final context, final index) {
        return const WCard(child: SizedBox(height: 100));
      },
    ).shimmer();
  }
}
