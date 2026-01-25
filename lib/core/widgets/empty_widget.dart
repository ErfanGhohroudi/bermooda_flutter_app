part of 'widgets.dart';

class WEmptyWidget extends StatelessWidget {
  const WEmptyWidget({
    super.key,
    this.title,
    this.titleColor,
    this.showUploadButton = false,
    this.buttonTitle,
    this.buttonBackgroundColor,
    this.buttonIcon,
    this.onTapButton,
    this.buttonWidth,
    this.iconSize = 130,
  });

  final String? title;
  final Color? titleColor;
  final bool showUploadButton;
  final String? buttonTitle;
  final Color? buttonBackgroundColor;
  final Widget? buttonIcon;
  final VoidCallback? onTapButton;
  final double? buttonWidth;
  final double iconSize;

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        UImage(AppLottie.emptyList, size: iconSize),
        Text(title ?? s.listIsEmpty).bodyMedium(color: titleColor),
        if (showUploadButton)
          UElevatedButton(
            title: buttonTitle ?? '',
            width: buttonWidth,
            icon: buttonIcon,
            backgroundColor: buttonBackgroundColor,
            onTap: onTapButton ?? () {},
          ).marginOnly(top: 10),
      ],
    );
  }
}
