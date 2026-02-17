import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/services/permission_service.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../domain/entity/sms_department.dart';
import '../pages/numbers_list_page.dart';

class SmsDepartmentMainSheet extends StatelessWidget {
  const SmsDepartmentMainSheet({
    required this.department,
    super.key,
  });

  final SmsDepartment department;

  @override
  Widget build(final BuildContext context) {
    final haveManagerAccess = Get.find<PermissionService>().haveSMSManagerAccess;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 300),
      child: Column(
        children: [
          _item(
            context: context,
            onTap: () {
              // AppNavigator.push(MyReviewsPage(
              //   department: department,
              // ));
            },
            icon: AppIcons.listOutline,
            title: 'پیام های ارسالی',
          ),
          _item(
            context: context,
            onTap: () {
              // AppNavigator.push(MyReviewsPage(
              //   department: department,
              // ));
            },
            icon: AppIcons.listOutline,
            title: 'پیام گروهی',
          ),
          _item(
            context: context,
            onTap: () {
              // AppNavigator.push(MyReviewsPage(
              //   department: department,
              // ));
            },
            icon: AppIcons.listOutline,
            title: 'صندوق ورودی',
          ),
          if (haveManagerAccess)
            _item(
              context: context,
              onTap: () {
                AppNavigator.push(SmsNumbersListPage(
                  departmentId: department.id,
                ));
              },
              icon: AppIcons.cardSimOutline,
              title: s.numberManagement,
            ),
        ],
      ),
    );
  }

  Widget _item({
    required final BuildContext context,
    required final String icon,
    required final String title,
    required final VoidCallback onTap,
  }) => WCard(
    onTap: () {
      AppNavigator.back();
      delay(500, onTap);
    },
    child: Row(
      spacing: 12,
      children: [
        UImage(icon, size: 25, color: context.theme.hintColor),
        Expanded(child: Text(title).titleMedium()),
        Icon(Icons.arrow_forward_ios_rounded, color: context.theme.hintColor),
      ],
    ),
  );
}
