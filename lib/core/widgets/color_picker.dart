part of 'widgets.dart';

class WColorPicker extends StatefulWidget {
  final List<Color> colors;
  final ValueChanged<Color> onColorSelected;
  final Color? initialColor;
  final double circleSize;
  final double strokeWidth;

  const WColorPicker({
    required this.colors,
    required this.onColorSelected,
    this.initialColor,
    this.circleSize = 48.0,
    this.strokeWidth = 3.0,
    super.key,
  });

  // }) : assert(colors.length > 0, 'Colors is empty');

  @override
  State<WColorPicker> createState() => _WColorPickerState();
}

class _WColorPickerState extends State<WColorPicker> {
  late Color _selectedColor;

  @override
  void initState() {
    _selectedColor = widget.initialColor ?? widget.colors.first;
    super.initState();
  }

  void _handleColorTap(final Color color) {
    setState(() {
      _selectedColor = color;
    });
    widget.onColorSelected(color);
  }

  @override
  Widget build(final BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: widget.colors.map((final color) {
        return _ColorCircle(
          color: color,
          isSelected: _selectedColor == color,
          circleSize: widget.circleSize,
          strokeWidth: widget.strokeWidth,
          onTap: () => _handleColorTap(color),
        );
      }).toList(),
    );
  }
}

class _ColorCircle extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final double circleSize;
  final double strokeWidth;
  final VoidCallback onTap;

  const _ColorCircle({
    required this.color,
    required this.isSelected,
    required this.circleSize,
    required this.strokeWidth,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: circleSize,
        height: circleSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: color, width: strokeWidth) : Border.all(color: Colors.transparent, width: strokeWidth),
        ),
        child: Padding(
          padding: EdgeInsets.all(circleSize * 0.05 > 2 ? circleSize * 0.05 : 2.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
