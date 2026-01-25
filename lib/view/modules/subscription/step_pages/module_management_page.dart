import 'package:flutter/cupertino.dart';
import 'package:u/utilities.dart';

import '../../../../core/utils/enums/enums.dart';
import '../../../../core/utils/extensions/money_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/theme.dart';
import '../../../../data/data.dart';
import '../enums/max_contract_count.dart';
import '../subscription_controller.dart';

class ModuleManagementPage extends StatelessWidget {
  const ModuleManagementPage({
    required this.ctrl,
    super.key,
  });

  final SubscriptionController ctrl;

  @override
  Widget build(final BuildContext context) {
    return Obx(() => ctrl.availableModules.isEmpty ? const Center(child: WCircularLoading()) : _buildModulesList());
  }

  Widget _buildModulesList() {
    return Obx(
      () => ListView.builder(
        itemCount: ctrl.availableModules.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (final context, final index) {
          final module = ctrl.availableModules.elementAt(index);
          final isActive = ctrl.isModuleActive(module);
          final isMandatory = false;
          final canDeselect = module.isActive == false;

          return _buildModuleCard(context, module, isActive, isMandatory, canDeselect);
        },
      ),
    );
  }

  Widget _buildModuleCard(
    final BuildContext context,
    final ModuleReadDto module,
    final bool isActive,
    final bool isMandatory,
    final bool canDeselect,
  ) {
    return Opacity(
      opacity: module.isEnable ? 1 : 0.5,
      child: WCard(
        showBorder: true,
        onTap: () => _showDetails(context, module),
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
              subtitle:
                  Text(
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
                            ctrl.toggleModule(module);
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

            // Contract count for legal Module
            AnimatedSize(
              duration: 500.milliseconds,
              curve: Curves.easeInOut,
              child: SizedBox(
                width: double.maxFinite,
                child: module.isEnable && module.type == ModuleType.legal && isActive
                    ? _buildMaxContractCountSection(context)
                    : null,
              ),
            ),

            if (module.isEnable)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: _buildModulePrice(context, module),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildModulePrice(final BuildContext context, final ModuleReadDto module) {
    final isFree = module.price == 0 || module.price == null;

    final mainPrice = module.price.toString();
    final finalPrice = module.finalPrice.toString();
    final discountPercentage = '${module.discountPercentage.percentageFormatted}%';

    Text buildPrice(final String price, {final bool isFinal = true}) {
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
          Flexible(child: buildPrice(s.free))
        else if (!module.isDiscount)
          Flexible(child: buildPrice(mainPrice.toTomanMoney()))
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
                    Flexible(child: buildPrice(mainPrice, isFinal: false)),
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
                buildPrice(finalPrice.toTomanMoney()),
              ],
            ),
          ),
      ],
    );
  }

  void _showDetails(final BuildContext context, final ModuleReadDto module) async {
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

  Widget _buildMaxContractCountSection(final BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Text(s.contractCount).bodyMedium(),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              showAppDialog(
                AlertDialog.adaptive(
                  title: Text(s.contractCount).titleMedium(),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 24,
                    children: [
                      Text(s.contractCountInfo).bodyMedium(),
                      UElevatedButton(
                        width: double.infinity,
                        title: s.ok,
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              );
            },
            icon: Icon(CupertinoIcons.info, color: context.theme.primaryColor, size: 22),
            style: IconButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const Spacer(),
          DropdownButton<MaxContractCount>(
            key: ctrl.maxContractDropdownUniqueKey.value,
            value: ctrl.selectedMaxContractCount.value,
            selectedItemBuilder: (final context) {
              return MaxContractCount.values.map((final count) {
                return DropdownMenuItem<MaxContractCount>(
                  value: count,
                  child: WDropdownItemText(
                    text: count.title,
                    color: AppColors.red,
                  ),
                );
              }).toList();
            },
            items: MaxContractCount.values.map((final count) {
              return DropdownMenuItem<MaxContractCount>(
                value: count,
                child: WDropdownItemText(text: count.title),
              );
            }).toList(),
            dropdownColor: context.theme.cardColor,
            borderRadius: BorderRadius.circular(8),
            underline: const SizedBox.shrink(),
            icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.red, size: 30),
            onChanged: (final value) {
              if (value == null) return;
              ctrl.updateMaxContractCount(value);
            },
          ),
        ],
      ),
    );
  }
}
