import 'package:u/utilities.dart';

import '../utils/extensions/url_extensions.dart';
import '../../data/data.dart';
import '../core.dart';
import '../theme.dart';

class WLinks extends StatefulWidget {
  const WLinks({
    required this.links,
    required this.onChanged,
    this.showAddWidget = true,
    this.removable = true,
    this.itemsSize = 70,
    this.maxLinksCount = 10,
    super.key,
  });

  final List<LinkReadDto> links;
  final Function(List<LinkReadDto> list) onChanged;
  final bool showAddWidget;
  final bool removable;
  final double itemsSize;
  final int maxLinksCount;

  @override
  State<WLinks> createState() => _WLinksState();
}

class _WLinksState extends State<WLinks> {
  final RxList<LinkReadDto> links = RxList(<LinkReadDto>[]);

  @override
  void initState() {
    links.assignAll(widget.links);
    super.initState();
  }

  Future<void> showAddDialog() async {
    final link = await showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (final ctx) => AlertDialog(
        content: StatefulBuilder(
          builder: (final context, final builderSetState) => const _AddLinkPage(),
        ),
      ),
    );

    if (link != null) {
      links.add(LinkReadDto(link: link));
      widget.onChanged(links);
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.start,
        children: [
          if (widget.showAddWidget)
            Container(
              width: widget.itemsSize,
              height: widget.itemsSize,
              decoration: BoxDecoration(
                border: Border.all(color: context.theme.primaryColor),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(Icons.add_rounded, size: 30, color: context.theme.primaryColor),
            ).onTap(showAddDialog),
          ...List<Widget>.generate(
            links.length,
            (final index) => Stack(
              alignment: isPersianLang ? Alignment.topRight : Alignment.topLeft,
              children: [
                SizedBox(
                  width: widget.itemsSize,
                  height: widget.itemsSize,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: widget.itemsSize,
                          height: widget.itemsSize,
                          color: context.theme.dividerColor,
                        ),
                        UImage(
                          AppImages.url,
                          fit: BoxFit.cover,
                          size: widget.itemsSize,
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: widget.itemsSize,
                            color: context.theme.hintColor,
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Center(
                              widthFactor: 1,
                              heightFactor: 1,
                              child: Text(
                                links[index].link ?? '',
                                maxLines: 1,
                                textDirection: TextDirection.ltr,
                              ).bodySmall(color: Colors.white, overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ).onTap(
                  () async {
                    if (links[index].link!.isURL) {
                      links[index].link!.launchMyUrl();
                    }
                  },
                ),
                if (widget.removable)
                  const UImage(AppIcons.closeCircle, size: 30).onTap(
                    () {
                      links.removeAt(index);
                      widget.onChanged(links);
                    },
                  ),
              ],
            ).withTooltip(links[index].link ?? ''),
          ),
        ],
      ),
    );
  }
}

class _AddLinkPage extends StatefulWidget {
  const _AddLinkPage();

  @override
  State<_AddLinkPage> createState() => _AddLinkPageState();
}

class _AddLinkPageState extends State<_AddLinkPage> {
  final TextEditingController linkController = TextEditingController();
  final RxBool isWebUrl = false.obs;

  @override
  void dispose() {
    linkController.dispose();
    isWebUrl.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 18,
      children: [
        UTextFormField(
          controller: linkController,
          labelText: s.link,
          hintText: "https://example.com",
          textAlign: TextAlign.left,
          keyboardType: TextInputType.url,
          formatters: [FilteringTextInputFormatter.deny(RegExp(r'[\s\u200C\n\t]'))],
          required: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: 5,
          onChanged: (final value) {
            isWebUrl(linkController.text.isWebUrl);
          },
        ).marginOnly(top: 18),
        Row(
          spacing: 10,
          children: [
            UElevatedButton(
              title: s.cancel,
              backgroundColor: context.theme.hintColor,
              onTap: () {
                Navigator.of(context).pop(null);
              },
            ).expanded(),
            Obx(
              () => UElevatedButton(
                title: s.addText,
                backgroundColor: isWebUrl.value ? context.theme.primaryColor : context.theme.primaryColor.withAlpha(100),
                onTap: () {
                  if (isWebUrl.value) {
                    Navigator.of(context).pop(linkController.text);
                  }
                },
              ),
            ).expanded(),
          ],
        ),
      ],
    );
  }
}
