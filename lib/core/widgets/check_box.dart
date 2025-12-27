part of 'widgets.dart';

class WCheckBox extends StatefulWidget {
  const WCheckBox({
    required this.isChecked,
    required this.onChanged,
    this.title,
    this.size = 20,
    this.activeColor,
    this.borderColor,
    this.borderWidth = 2,
    super.key,
  });

  final bool isChecked;
  final ValueChanged<bool> onChanged;
  final String? title; // Optional title to display next to the checkbox
  final double size;
  final Color? activeColor;
  final Color? borderColor;
  final double borderWidth;

  @override
  State<WCheckBox> createState() => _WCheckBoxState();
}

class _WCheckBoxState extends State<WCheckBox> {
  @override
  Widget build(final BuildContext context) {
    return InkWell(
      // Handle tap events to toggle the checkbox state
      onTap: () {
        // Notify the parent widget about the state change
        widget.onChanged(!widget.isChecked);
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            // Animated container for the checkbox
            AnimatedContainer(
              // Duration for the container's animation
              duration: const Duration(milliseconds: 200),
              // Width of the checkbox
              width: widget.size,
              // Height of the checkbox
              height: widget.size,
              // Decoration for the checkbox (background, border, shape)
              decoration: BoxDecoration(
                color: widget.isChecked ? widget.activeColor ?? AppColors.green : Colors.transparent, // Background color
                border: Border.all(
                  color: widget.isChecked ? (widget.activeColor ?? AppColors.green) : (widget.borderColor ?? AppColors.green), // Border color
                  width: widget.borderWidth, // Border width
                ),
                borderRadius: BorderRadius.circular(6),
                shape: BoxShape.rectangle, // Circular shape for the checkbox
              ),
              child: Center(
                // Animated scaling effect for the check icon
                child: TweenAnimationBuilder<double>(
                  // Duration for the scaling animation
                  duration: const Duration(milliseconds: 1000),
                  // Tween to animate the scale value between 0.8 and 1.2 (or 0.0 if unchecked)
                  tween: Tween<double>(begin: 0.8, end: widget.isChecked ? 1.2 : 0.0),
                  // Animation curve for a bounce effect
                  curve: Curves.elasticOut,
                  // Builder function to apply the scale transformation
                  builder: (final context, final value, final child) {
                    return Transform.scale(
                      scale: value, // Apply the scale value
                      child: child, // Child widget to be scaled
                    );
                  },
                  // Child widget (the check icon)
                  child: widget.isChecked
                      ? Icon(
                          Icons.check_rounded, // Check icon
                          color: Colors.white, // Icon color
                          size: widget.size * 0.7, // Icon size
                        )
                      : null, // No child when unchecked
                ),
              ),
            ),
            // Display the title if it is provided
            if (widget.title != null)
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Add some spacing between the checkbox and the title
                    const SizedBox(width: 10),
                    // Flexible widget to handle text overflow
                    Flexible(
                      child: Text(
                        widget.title!, // Title text
                        style: context.textTheme.bodyMedium!.copyWith(overflow: TextOverflow.ellipsis), // Text style with ellipsis for overflow
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
