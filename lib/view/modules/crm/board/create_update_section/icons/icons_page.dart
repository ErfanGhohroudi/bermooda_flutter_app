import 'package:u/utilities.dart';

import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../data/data.dart';

class IconsPage extends StatefulWidget {
  const IconsPage({
    required this.icons,
    required this.selectedColor,
    required this.onSelected,
    this.selectedIcon,
    super.key,
  });

  final List<MainFileReadDto> icons;
  final LabelColors selectedColor;
  final Function(MainFileReadDto icon) onSelected;
  final MainFileReadDto? selectedIcon;

  @override
  State<IconsPage> createState() => _IconsPageState();
}

class _IconsPageState extends State<IconsPage> {
  MainFileReadDto? selectedIcon;
  late LabelColors selectedColor;

  @override
  void initState() {
    selectedIcon = widget.selectedIcon;
    selectedColor = widget.selectedColor;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant final IconsPage oldWidget) {
    if (oldWidget.selectedIcon != widget.selectedIcon || oldWidget.selectedColor != widget.selectedColor) {
      setState(() {
        selectedIcon = widget.selectedIcon;
        selectedColor = widget.selectedColor;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(final BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (final didPop, final result) {
        if (selectedIcon != null) {
          widget.onSelected(selectedIcon!);
        }
      },
      child: UScaffold(
        appBar: AppBar(
          title: const Text("انتخاب نماد"),
        ),
        body: GridView.builder(
          itemCount: widget.icons.length,
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 1,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          itemBuilder: (final context, final index) => _iconItem(widget.icons[index], selectedColor),
        ),
      ),
    );
  }

  Widget _iconItem(final MainFileReadDto icon, final LabelColors color) {
    final isSelected = selectedIcon?.fileId == icon.fileId;

    return WCard(
      color: isSelected ? color.color : (context.isDarkMode ? Colors.white30 : Colors.black12),
      child: UImage(icon.url ?? '', size: 30, color: isSelected ? Colors.white : context.theme.primaryColorDark),
      onTap: () {
        setState(() {
          selectedIcon = icon;
        });
      },
    );
  }
}
