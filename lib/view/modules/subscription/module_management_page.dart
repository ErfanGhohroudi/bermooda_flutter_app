import 'package:u/utilities.dart';

import '../../../core/utils/extensions/money_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/core.dart';
import '../../../core/theme.dart';
import '../../../data/data.dart';
import 'subscription_controller.dart';

class ModuleManagementPage extends StatefulWidget {
  const ModuleManagementPage({
    required this.ctrl,
    super.key,
  });

  final SubscriptionController ctrl;

  @override
  State<ModuleManagementPage> createState() => _ModuleManagementPageState();
}

class _ModuleManagementPageState extends State<ModuleManagementPage> {
  SubscriptionController get ctrl => widget.ctrl;
  final RxList<ModuleReadDto> newSelectedModules = <ModuleReadDto>[].obs;

  @override
  void initState() {
    if (ctrl.availableModules.isEmpty) {
      ctrl.getAvailableModules();
    }
    super.initState();
  }

  @override
  void dispose() {
    newSelectedModules.close();
    super.dispose();
  }

  void _toggleModule(final ModuleReadDto module) {
    if (ctrl.selectedModules.contains(module)) {
      return;
    }

    if (newSelectedModules.contains(module)) {
      newSelectedModules.remove(module);
    } else {
      newSelectedModules.add(module);
    }
    ctrl.availableModules.refresh();
  }

  void _onSave() {
    ctrl.selectedModules.addAll(newSelectedModules);
    if (ctrl.selectedModules.isEmpty) {
      ctrl.showEmptyModulesSnackBar();
      return;
    }
    ctrl.calculatePrice();
    Navigator.pop(context);
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(title: Text(s.moduleManagement)),
      bottomNavigationBar: Obx(
        () {
          if (ctrl.availableModules.isEmpty) return const SizedBox.shrink();
          return UElevatedButton(
            title: s.save,
            onTap: _onSave,
          ).pOnly(left: 16, right: 16, bottom: 24);
        },
      ),
      body: Obx(() => ctrl.availableModules.isEmpty ? const Center(child: WCircularLoading()) : _buildModulesList()),
    );
  }

  Widget _buildModulesList() {
    return Obx(
      () => ListView.builder(
        itemCount: ctrl.availableModules.length,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 10),
        itemBuilder: (final context, final index) {
          final module = ctrl.availableModules[index];
          final isActive = newSelectedModules.contains(module) || ctrl.selectedModules.contains(module);
          final isMandatory = false;
          final canDeselect = module.isActive == false;

          return _buildModuleCard(module, isActive, isMandatory, canDeselect);
        },
      ),
    );
  }

  Widget _buildModuleCard(final ModuleReadDto module, final bool isActive, final bool isMandatory, final bool canDeselect) {
    return Opacity(
      opacity: module.isEnable ? 1 : 0.5,
      child: WCard(
        showBorder: true,
        onTap: () => _showDetails(module),
        // onTap: isMandatory ? null : () => _toggleModule(module),
        horPadding: 12,
        verPadding: 6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: SizedBox(
                width: 50,
                child: Center(
                  child: UImage(
                    module.iconData ?? '',
                    size: 48,
                  ),
                ),
              ),
              title: Text(
                module.title,
                maxLines: 1,
              ).titleMedium(overflow: TextOverflow.ellipsis).bold(),
              subtitle: Text(
                module.subTitle,
                maxLines: 2,
              ).bodyMedium(
                color: context.theme.hintColor,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: !module.isEnable
                  ? Text(s.soon).bodyMedium()
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isMandatory)
                          const WLabel(
                            color: AppColors.orange,
                            text: 'اجباری',
                          ),
                        WSwitch(
                          value: isActive,
                          onChanged: (final value) {
                            if (isMandatory || !canDeselect) return;
                            _toggleModule(module);
                          },
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                          color: context.theme.dividerColor,
                        ),
                      ],
                    ),
            ),
            if (module.isEnable)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: _buildModulePrice(module),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildModulePrice(final ModuleReadDto module) {
    final isFree = module.price == 0 || module.price == null;

    final mainPrice = module.price.toString();
    final finalPrice = module.finalPrice.toString();
    final discountPercentage = '${module.discountPercentage.percentageFormatted}%';

    Text _buildPrice(final String price, {final bool isFinal = true}) {
      return Text(
        price,
        maxLines: 1,
        style: (isFinal ? context.textTheme.bodyMedium : context.textTheme.bodySmall)?.copyWith(
          color: isFinal ? context.theme.hintColor : context.theme.dividerColor,
          overflow: TextOverflow.ellipsis,
          decoration: isFinal ? null : TextDecoration.lineThrough,
          decorationColor: context.theme.hintColor,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isFree == false) ...[
          Text(s.daily).bodyMedium(
            color: context.theme.hintColor,
            overflow: TextOverflow.ellipsis,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: const Text("/").bodyMedium(color: context.theme.hintColor),
          ),
        ],
        if (isFree == true)
          Flexible(child: _buildPrice(s.free))
        else if (!module.isDiscount)
          Flexible(child: _buildPrice(mainPrice.toTomanMoney()))
        else
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 5,
                  children: [
                    Flexible(child: _buildPrice(mainPrice, isFinal: false)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(discountPercentage).bodySmall(color: Colors.white),
                    ),
                  ],
                ),
                _buildPrice(finalPrice.toTomanMoney()),
              ],
            ),
          ),
      ],
    );
  }

  void _showDetails(final ModuleReadDto module) async {
    Widget item(final String title, final String value) => RichText(
          text: TextSpan(
            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, height: 1.5),
            children: [
              TextSpan(text: "$title:  "),
              TextSpan(
                style: context.textTheme.bodyMedium?.copyWith(color: context.theme.hintColor, height: 1.5),
                text: value,
              ),
            ],
          ),
        );

    return await bottomSheet(
      title: s.details,
      minHeight: context.height / 1.5,
      child: Builder(
        builder: (final context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              if (module.iconData != null)
                SizedBox(
                  width: context.width,
                  child: Center(child: UImage(module.iconData!, size: 100)),
                ).marginOnly(bottom: 12),
              item(s.title, "${module.title.trim()} (${module.subTitle.trim()})"),
              item(s.price, module.price.toString().toTomanMoney()),
              item(s.description, module.description.trim()),
            ],
          );
        },
      ),
    );
  }
}
