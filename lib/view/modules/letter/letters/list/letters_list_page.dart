import 'package:u/utilities.dart';

import '../../../../../core/utils/extensions/color_extension.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../data/data.dart';
import '../detail/letter_detail_page.dart';
import 'letters_list_controller.dart';

class LettersListPage extends StatefulWidget {
  const LettersListPage({super.key});

  @override
  State<LettersListPage> createState() => _LettersListPageState();
}

class _LettersListPageState extends State<LettersListPage> with LettersListController {
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
    return UScaffold(
      appBar: AppBar(title: Text(s.correspondence)),
      floatingActionButtonLocation: isPersianLang ? FloatingActionButtonLocation.startFloat : FloatingActionButtonLocation.endFloat,
      floatingActionButton: _buildNewLetterFAB(),
      body: Stack(
        children: [
          Obx(
            () {
              if (pageState.isError()) {
                return Center(child: WErrorWidget(onTapButton: onRefreshWithLoading));
              }

              if (pageState.isLoaded() && letters.isEmpty) {
                return const Center(child: WEmptyWidget());
              }

              return const SizedBox.shrink();
            },
          ),
          Column(
            children: [
              WSearchField(
                controller: searchCtrl,
                borderRadius: 0,
                height: 50,
                onChanged: (final value) => onRefreshWithLoading(),
              ),
              Obx(
                () {
                  if (pageState.isInitial() || pageState.isLoading()) {
                    return _buildShimmerLoading();
                  }

                  if (pageState.isError()) {
                    return const SizedBox.shrink();
                  }

                  return WSmartRefresher(
                    controller: refreshController,
                    scrollController: scrollController,
                    onRefresh: onRefresh,
                    onLoading: loadMore,
                    enablePullDown: pageState.isLoaded(),
                    enablePullUp: pageState.isLoaded(),
                    child: ListView.separated(
                      itemCount: letters.length,
                      padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: isNoMoreData ? 100 : 10),
                      separatorBuilder: (final context, final index) => const SizedBox(height: 5),
                      itemBuilder: (final context, final index) => _mailItem(
                        mail: letters[index],
                        onUpdated: (final mail) {
                          letters[index] = mail;
                          letters.refresh();
                        },
                      ),
                    ),
                  );
                },
              ).expanded(),
            ],
          ),
          WScrollToTopButton(
            scrollController: scrollController,
            show: showScrollToTop,
            bottomMargin: 90,
          ),
        ],
      ),
    );
  }

  Widget _mailItem({
    required final LetterReadDto mail,
    required final Function(LetterReadDto mail) onUpdated,
  }) =>
      WCard(
        showBorder: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              minTileHeight: 50,
              leading: const UImage(AppIcons.mailColor, size: 20),
              title: Text(
                mail.title ?? '',
                textAlign: TextAlign.justify,
                maxLines: 2,
              ).bodyMedium(overflow: TextOverflow.ellipsis).bold(),
              // subtitle: Text(
              //   mail.mailText ?? '',
              //   textAlign: TextAlign.justify,
              //   maxLines: 2,
              // ).bodyMedium(color: context.theme.hintColor, overflow: TextOverflow.ellipsis),
            ),
            const Divider(),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 6,
              children: [
                _item(
                  title: s.receivedSent,
                  value: mail.status,
                ),
                _item(
                  title: s.sender,
                  value: mail.creator?.fullName ?? '- -',
                ),
                _item(
                  title: s.date,
                  value: mail.jtime ?? '- -',
                ),
                _item(
                  title: s.status,
                  valueWidget: WLabel(
                    text: mail.signCompleted ?? false ? s.signed : s.unsigned,
                    color: mail.signCompleted ?? false ? AppColors.green : AppColors.red,
                    minWidth: context.width / 4,
                  ),
                ),
                _item(
                  title: s.label,
                  valueWidget: WLabel(
                    text: mail.label?.title ?? '- -',
                    color: mail.label?.colorCode.toColor(),
                    minWidth: context.width / 4,
                  ),
                ),
              ],
            ).marginOnly(top: 10),
          ],
        ),
        onTap: () {
          UNavigator.push(LetterDetailPage(
            mail: mail,
            onUpdated: onUpdated,
          ));
        },
      );

  Widget _item({
    required final String title,
    final String? value,
    final Widget? valueWidget,
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text("$title : ").bodyMedium(color: context.theme.hintColor)),
          if (value != null) Flexible(child: Text(value).bodyMedium()) else if (valueWidget != null) valueWidget,
        ],
      );

  FloatingActionButton _buildNewLetterFAB() {
    return FloatingActionButton(
      heroTag: "NewLetterFAB",
      tooltip: s.newLetter,
      child: const Icon(Icons.add_rounded, color: Colors.white),
      onPressed: () {},
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.separated(
      itemCount: 15,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (final context, final index) => const SizedBox(height: 5),
      itemBuilder: (final context, final index) => const WCard(
        child: SizedBox(height: 50),
      ),
    ).shimmer();
  }
}
