part of 'widgets.dart';

class WBannerSlider extends StatefulWidget {
  const WBannerSlider({
    required this.imageUrls,
    super.key,
  });

  final List<String> imageUrls;

  @override
  State<WBannerSlider> createState() => _WBannerSliderState();
}

class _WBannerSliderState extends State<WBannerSlider> {
  late List<String> imageUrls;
  int _currentSlide = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  bool get isMoreThanOne => imageUrls.length > 1;

  @override
  void initState() {
    imageUrls = widget.imageUrls;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant final WBannerSlider oldWidget) {
    if (oldWidget.imageUrls != widget.imageUrls) {
      setState(() {
        imageUrls = widget.imageUrls;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _controller,
          items: imageUrls
              .map((final url) => ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      progressIndicatorBuilder: (final context, final url, final DownloadProgress progress) => Container(
                        color: Colors.grey.shade300,
                        child: Center(
                          child: WCircularLoading(color: Colors.grey, value: progress.progress),
                        ),
                      ),
                      errorWidget: (final context, final url, final error) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(child: Icon(Icons.error, color: Colors.grey, size: 30)),
                      ),
                    ),
                  ))
              .toList(),
          options: CarouselOptions(
            autoPlay: isMoreThanOne ? true : false,
            enlargeCenterPage: true,
            viewportFraction: isMoreThanOne ? 0.85 : 0.9,
            // aspectRatio: 30 / 9,
            aspectRatio: 18 / 9,
            autoPlayInterval: const Duration(seconds: 7),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            onPageChanged: (final index, final reason) {
              setState(() {
                _currentSlide = index;
              });
            },
          ),
        ),

        /// Indicator Dots
        if (isMoreThanOne)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imageUrls.asMap().entries.map((final entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key), // پرش به اسلاید با کلیک
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _currentSlide == entry.key ? 24.0 : 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: context.theme.hintColor.withAlpha(_currentSlide == entry.key ? 255 : 100),
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
