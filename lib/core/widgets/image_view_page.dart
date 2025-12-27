part of 'widgets.dart';

class ImagesViewPage extends StatefulWidget {
  const ImagesViewPage({
    required this.medias,
    this.showAppBar = false,
    this.protectData = false,
    super.key,
  });

  final List<MediaReadDto> medias;
  final bool showAppBar;
  final bool protectData;

  @override
  State<ImagesViewPage> createState() => _ImagesViewPageState();
}

class _ImagesViewPageState extends State<ImagesViewPage> {
  final PageController pageController = PageController();

  @override
  void initState() {
    if (widget.protectData) {
      ScreenProtector.protectDataLeakageWithColor(Colors.white);
      ScreenProtector.preventScreenshotOn();
    }
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    if (widget.protectData) {
      ScreenProtector.protectDataLeakageWithColorOff();
      ScreenProtector.preventScreenshotOff();
      ScreenProtector.isRecording();
    }
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      color: Colors.black,
      appBar: widget.showAppBar
          ? AppBar(
              backgroundColor: Colors.black,
              iconTheme: const IconThemeData(color: Colors.white, size: 30),
              title: Text(s.medias).bodyMedium(fontSize: 20, color: Colors.white),
              titleSpacing: 0,
            )
          : null,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          _buildPageView(items: widget.medias),
          if (!widget.showAppBar)
            Align(
              alignment: isPersianLang ? Alignment.topRight : Alignment.topLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [const WBackIcon(color: Colors.white, size: 30), Text(s.medias).bodyMedium(fontSize: 20, color: Colors.white).marginSymmetric(horizontal: 10)],
              ),
            ).marginAll(20),
          Positioned(
            bottom: 10,
            child: WCircleIndicator(items: widget.medias, pageController: pageController).alignAtBottomCenter(),
          ),
        ],
      ),
    ).safeArea();
  }

  Widget _buildPageView({
    required final List<MediaReadDto> items,
  }) =>
      SizedBox(
        height: Get.height,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: PageView.builder(
            itemCount: items.length,
            controller: pageController,
            itemBuilder: (final BuildContext context, final int index) => ZoomOverlay(
              modalBarrierColor: Colors.transparent,
              minScale: 1,
              maxScale: 3,
              animationDuration: const Duration(milliseconds: 300),
              // Defaults to 100 Milliseconds. Recommended duration is 300 milliseconds for Curves.fastOutSlowIn
              animationCurve: Easing.emphasizedAccelerate,
              twoTouchOnly: true,
              child: CachedNetworkImage(
                width: Get.width,
                imageUrl: items[index].url,
              ),
            ),
            onPageChanged: (final int index) {},
          ),
        ),
      );
}
