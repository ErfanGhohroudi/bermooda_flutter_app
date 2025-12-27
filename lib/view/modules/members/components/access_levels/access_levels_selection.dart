import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/services/subscription_service.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/data.dart';
import '../../../../../core/core.dart';
import 'dialog/access_levels_dialog.dart';

class WAccessLevelsSelection extends StatefulWidget {
  const WAccessLevelsSelection({
    required this.permissions,
    required this.onConfirmed,
    this.spacing = 10,
    this.selectable = true,
    super.key,
  });

  final List<PermissionReadDto> permissions;
  final double spacing;
  final bool selectable;
  final Function(List<PermissionReadDto> list) onConfirmed;

  @override
  State<WAccessLevelsSelection> createState() => _WAccessLevelsSelectionState();
}

class _WAccessLevelsSelectionState extends State<WAccessLevelsSelection> {
  final List<String> activeModulesTypeNames = Get.find<SubscriptionService>().activeModuleTypeNames;
  List<PermissionReadDto> notActivePermissions = [];
  List<PermissionReadDto> activePermissions = [];

  List<PermissionReadDto> get permissions => [...activePermissions, ...notActivePermissions];

  @override
  void initState() {
    _initialPermissions(widget.permissions);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant final WAccessLevelsSelection oldWidget) {
    if (oldWidget.permissions != widget.permissions && !widget.selectable) {
      setState(() {
        _initialPermissions(widget.permissions);
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  void _initialPermissions(final List<PermissionReadDto> permissions) {
    List<PermissionReadDto> perList = [];

    if (permissions.isNullOrEmpty()) {
      for (var per in PermissionName.values) {
        perList.add(PermissionReadDto(permissionName: per, permissionType: PermissionType.noAccess));
      }
      _initialActivePermissions(perList, setNotActiveList: false);
    } else {
      perList = permissions.where((final p) => p.permissionName != null && p.permissionType != null).toList();
      _initialActivePermissions(perList, setNotActiveList: true);
    }

    widget.onConfirmed(this.permissions);
  }

  void _initialActivePermissions(final List<PermissionReadDto> permissions, {final bool setNotActiveList = false}) {
    activePermissions.clear();
    for (var per in permissions) {
      if (activeModulesTypeNames.contains(per.permissionName?.name)) {
        activePermissions.add(PermissionReadDto(
          permissionName: per.permissionName,
          permissionType: per.permissionType,
        ));
      } else if (setNotActiveList) {
        notActivePermissions.add(per);
      }
    }
  }

  void _showSelectionDialog() {
    showAppDialog(
      barrierDismissible: true,
      useSafeArea: true,
      onDismiss: () => FocusManager.instance.primaryFocus!.unfocus(),
      AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(s.accessLevels).titleMedium(),
            const Divider(),
          ],
        ),
        content: AccessLevelsDialog(
          permissions: activePermissions,
          onConfirmed: (final list) {
            if (!mounted) return;
            setState(() {
              activePermissions = list;
            });
            widget.onConfirmed(permissions);
          },
        ),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final forwardIcon = Icon(
      Icons.arrow_forward_ios_rounded,
      size: 20,
      color: context.theme.hintColor,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: widget.spacing,
      children: [
        if (widget.selectable)
          FormField(
            builder: (final formFieldState) => InkWell(
              onTap: () => _showSelectionDialog(),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: s.accessLevels,
                  labelStyle: context.textTheme.bodyMedium!.copyWith(
                    fontSize: (context.textTheme.bodyMedium!.fontSize ?? 12) + 2,
                    color: context.theme.hintColor,
                  ),
                  floatingLabelStyle: context.textTheme.bodyLarge!,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  errorText: formFieldState.errorText,
                  suffixIcon: isPersianLang ? forwardIcon : null,
                  prefixIcon: !isPersianLang ? forwardIcon : null,
                ),
                isEmpty: true,
              ),
            ),
          ),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: activePermissions.map((final permission) => _buildPermissionChip(permission, context)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionChip(final PermissionReadDto permission, final BuildContext context) {
    String chipIconString = permission.permissionType?.icon ?? AppIcons.info;
    Color chipColor = permission.permissionType?.color ?? Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: chipColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          UImage(
            chipIconString,
            color: chipColor,
            size: 20,
          ),
          Flexible(
            child: Text(
              "${permission.permissionName?.getTitle() ?? "- -"} | ${permission.permissionType?.getTitle() ?? "- -"}",
            ).bodyMedium(
              fontSize: 12,
              color: chipColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
