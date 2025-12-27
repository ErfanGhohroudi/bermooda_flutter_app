import 'package:u/utilities.dart';

import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/core.dart';
import '../../../../../../core/theme.dart';
import '../../../../requests/list/request_list_page.dart';
import '../../profile_controller.dart';

class RequestsTab extends StatelessWidget {
  const RequestsTab({
    required this.controller,
    super.key,
  });

  final ProfileController controller;

  @override
  Widget build(final BuildContext context) {
    if (controller.hrModuleIsActive == false) {
      return Center(
        child: WErrorWidget(
          iconString: AppIcons.info,
          iconColor: context.theme.hintColor,
          errorTitle: s.hRModuleIsRequired,
          size: 50,
          onTapButton: () {},
        ),
      );
    }

    return RequestListPage(
      pageType: RequestListPageType.memberProfile,
      member: controller.currentMember.value,
      department: controller.department,
      canEdit: controller.canEdit,
    );
  }
}
