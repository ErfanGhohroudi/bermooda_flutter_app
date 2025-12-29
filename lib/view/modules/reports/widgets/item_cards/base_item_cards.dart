import 'package:u/utilities.dart';

import '../../../../../core/utils/extensions/color_extension.dart';
import '../../../../../core/widgets/image_files.dart';
import '../../../../../core/services/permission_service.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/utils/extensions/money_extensions.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../data/data.dart';
import '../../../crm/customer/customer_info/customer_info_controller.dart';
import '../../../followup/follow_up_card/follow_up_details/follow_up_details_page.dart';
import '../../../followup/list/followup_list_controller.dart';
import '../../../subtask/list/subtask_list_controller.dart';
import '../../controllers/crm/crm_customer_reports_controller.dart';
import '../../controllers/legal/legal_case_reports_controller.dart';
import '../../../project/task/create_update/create_update_task_controller.dart';
import '../../../subtask/subtask_card/subtask_details/subtask_details_page.dart';
import '../../controllers/project/project_task_reports_controller.dart';

part 'contract_card.dart';

part 'followup_archive_card.dart';

part 'invoice_card.dart';

part 'note_card.dart';

part 'subtask_archive_card.dart';

part 'update_card.dart';

Widget baseCard({
  required final bool showStartMargin,
  required final List<Widget> children,
  final VoidCallback? onTap,
}) {
  return WCard(
    onTap: onTap,
    margin: EdgeInsetsDirectional.only(start: showStartMargin ? 10 : 0, bottom: 16),
    showBorder: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: children,
    ),
  );
}

Widget baseHeader(
  final BuildContext context,
  final IReportReadDto item, {
  final bool showArrow = false,
}) => Row(
  spacing: 10,
  children: [
    WCircleAvatar(user: item.creator, showFullName: true, size: 30).expanded(),
    Text(item.persianDateTimeString ?? '').bodyMedium(color: context.theme.hintColor),
    if (showArrow) Icon(Icons.arrow_forward_ios_rounded, color: context.theme.dividerColor, size: 15),
  ],
);

Widget baseBodyText(final BuildContext context, final IReportReadDto item) {
  return Text(item.body ?? '').bodyMedium();
}

Widget buildRowInfo({
  required final BuildContext context,
  required final String title,
  required final Widget value,
}) => Row(
  children: [
    Text("$title: ").bodyMedium(color: context.theme.hintColor),
    value.expanded(),
  ],
);
