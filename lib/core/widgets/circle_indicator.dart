part of 'widgets.dart';

class WCircleIndicator extends StatelessWidget {
  const WCircleIndicator({
    required this.items,
    required this.pageController,
    this.size = 10,
    super.key,
  });

  final List<dynamic> items;
  final PageController pageController;
  final double size;

  @override
  Widget build(final BuildContext context) {
    return (items.length == 1 || (items).isEmpty)
        ? const SizedBox()
        : Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SmoothPageIndicator(
                  controller: pageController,
                  count: items.length,
                  textDirection: TextDirection.ltr,
                  effect: WormEffect(
                    dotHeight: size,
                    dotWidth: size,
                    spacing: 4,
                    dotColor: Color(0xffa9a9a9),
                    activeDotColor: Color(0xfffffffd),
                  ),
                ),
              ),
            ),
          );
  }
}
