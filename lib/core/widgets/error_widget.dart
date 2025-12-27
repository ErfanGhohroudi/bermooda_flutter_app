part of 'widgets.dart';

class WErrorWidget extends StatelessWidget {
  const WErrorWidget({
    required this.onTapButton,
    this.buttonTitle,
    this.errorTitle,
    this.iconString,
    this.iconColor = AppColors.red,
    this.size = 130,
    super.key,
  }) : _showButton = errorTitle == null;

  final bool _showButton;
  final String? buttonTitle;
  final String? errorTitle;
  final String? iconString;
  final Color? iconColor;
  final double size;
  final VoidCallback onTapButton;

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        UImage(iconString ?? AppLottie.error, size: size, color: iconColor),
        if (_showButton)
          UElevatedButton(
            title: buttonTitle ?? s.tryAgain,
            backgroundColor: AppColors.red,
            onTap: onTapButton,
          )
        else
          Text(errorTitle!).titleMedium(),
      ],
    );
  }
}
