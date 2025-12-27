import 'package:u/utilities.dart';

import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../core/core.dart';
import '../../../../../../data/data.dart';

class AccessLevelsDialog extends StatefulWidget {
  const AccessLevelsDialog({
    required this.permissions,
    required this.onConfirmed,
    super.key,
  });

  final List<PermissionReadDto> permissions;
  final Function(List<PermissionReadDto> list) onConfirmed;

  @override
  State<AccessLevelsDialog> createState() => _AccessLevelsDialogState();
}

class _AccessLevelsDialogState extends State<AccessLevelsDialog> {
  late List<PermissionReadDto> permissions;

  @override
  void initState() {
    permissions = widget.permissions;
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: context.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: context.height / 2, minWidth: context.width),
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 18,
                  children: List<Widget>.generate(
                    permissions.length,
                    (final index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 6,
                      children: [
                        Text(permissions[index].permissionName?.getTitle() ?? '').bodyLarge(color: context.theme.primaryColor),
                        WRadioGroup<PermissionType>(
                          direction: Axis.vertical,
                          initialValue: permissions[index].permissionType ?? PermissionType.noAccess,
                          items: PermissionType.values,
                          labelBuilder: (final item) => item.getTitle(),
                          onChanged: (final value) {
                            setState(() {
                              permissions[index] = permissions[index].copyWith(permissionType: value);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UElevatedButton(
                title: s.cancel,
                backgroundColor: context.theme.hintColor,
                onTap: UNavigator.back,
              ),
              UElevatedButton(
                title: s.confirm,
                onTap: () {
                  UNavigator.back();
                  widget.onConfirmed(permissions);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
