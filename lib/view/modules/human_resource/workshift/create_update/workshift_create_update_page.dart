import 'package:u/utilities.dart';

import '../../../../../core/widgets/fields/fields.dart';
import '../../../../../core/core.dart';
import '../../../../../data/data.dart';
import 'workshift_create_update_controller.dart';

class WorkshiftCreateUpdatePage extends StatefulWidget {
  const WorkshiftCreateUpdatePage({
    required this.departmentSlug,
    this.workShift,
    super.key,
  });

  final String departmentSlug;
  final WorkShiftReadDto? workShift;

  @override
  State<WorkshiftCreateUpdatePage> createState() => _WorkshiftCreateUpdatePageState();
}

class _WorkshiftCreateUpdatePageState extends State<WorkshiftCreateUpdatePage> with WorkshiftCreateUpdateController {
  @override
  void initState() {
    initialController(
      workShift: widget.workShift,
      departmentSlug: widget.departmentSlug,
    );
    super.initState();
  }

  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WTextField(
            controller: titleCtrl,
            labelText: s.title,
            required: true,
            showRequired: false,
          ).marginOnly(bottom: 24),
          Text(s.monthlySettings).titleMedium(color: context.theme.hintColor).marginOnly(bottom: 18),
          Column(
            spacing: 18,
            children: [
              UTextFormField(
                controller: overtimeHoursCtrl,
                labelText: '${s.overtimeLimit} (${s.hours})',
                hintText: s.hours,
                keyboardType: TextInputType.number,
                formatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              UTextFormField(
                controller: missionHoursCtrl,
                labelText: '${s.missionLimit} (${s.hours})',
                hintText: s.hours,
                keyboardType: TextInputType.number,
                formatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              UTextFormField(
                controller: leaveHoursCtrl,
                labelText: '${s.leaveEntitlement} (${s.hours})',
                hintText: s.hours,
                keyboardType: TextInputType.number,
                formatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              UTextFormField(
                controller: overdueHoursCtrl,
                labelText: '${s.tardinessAllowance} (${s.hours})',
                hintText: s.hours,
                keyboardType: TextInputType.number,
                formatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              UTextFormField(
                controller: leaveEarlyHoursCtrl,
                labelText: '${s.earlyOutAllowance} (${s.hours})',
                hintText: s.hours,
                keyboardType: TextInputType.number,
                formatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
          ),
          Obx(
            () => UElevatedButton(
              title: s.next,
              width: double.maxFinite,
              isLoading: buttonState.isLoading(),
              onTap: onSubmit,
            ),
          ).marginOnly(top: 24),
        ],
      ),
    );
  }
}
