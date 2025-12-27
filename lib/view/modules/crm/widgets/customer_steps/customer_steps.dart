import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/utils/extensions/color_extension.dart';
import '../../../../../core/widgets/chevron_painter.dart';
import '../../../../../data/data.dart';

class CustomerSteps extends StatelessWidget {
  const CustomerSteps({
    required this.customer,
    required this.onStepChanged,
    this.canEdit = true,
    super.key,
  });

  final CustomerReadDto customer;
  final Function(CustomerReadDto model) onStepChanged;
  final bool canEdit;

  bool get haveFollowup => customer.followUpsOwners.any((final e) => e.id == Get.find<Core>().userReadDto.value.id);

  void changeCustomerStepStatus({
    required final StepReadDto step,
    required final Function(CustomerReadDto customer) onResponse,
  }) => appShowYesCancelDialog(
    description: s.changeStep.replaceAll('#', step.title?.trim() ?? '--'),
    onYesButtonTap: () {
      UNavigator.back();
      Get.find<CustomerDatasource>().changeCustomerStep(
        customerId: customer.id,
        step: step.step,
        onResponse: (final response) => onResponse(response.result!),
        onError: (final errorResponse) {},
      );
    },
  );

  @override
  Widget build(final BuildContext context) {
    if (customer.section?.labelStep?.steps == null) {
      return const SizedBox();
    }

    final steps = customer.section!.labelStep!.steps!;
    steps.sort((final a, final b) => a.step!.compareTo(b.step!));

    return SizedBox(
      height: 22,
      child: Row(
        children: List.generate(customer.section!.labelStep!.steps!.length, (final i) {
          bool isActive = i < (customer.stepStatus ?? 0);
          return CustomPaint(
            painter: ChevronPainter(
              color: isActive ? customer.section!.colorCode.toColor() : navigatorKey.currentContext!.theme.dividerColor,
            ),
            child: SizedBox(
              height: 30,
              child: Center(
                widthFactor: 1,
                heightFactor: 1,
                child: Text(
                  steps[i].title ?? '',
                  maxLines: 1,
                ).bodySmall(fontSize: 11, color: Colors.white, overflow: TextOverflow.ellipsis).bold().pSymmetric(horizontal: 7),
              ),
            ), // تنظیم ارتفاع هر مرحله
          ).withTooltip(steps[i].title ?? '').onTap(
            () {
              if (!canEdit) return;

              bool isCurrentStep = i == (customer.stepStatus ?? 0) - 1;
              bool canChange = i > (customer.stepStatus ?? 0) - 1;
              StepReadDto step = steps[i];

              if (!customer.isFollowed && haveFollowup) {
                if (isCurrentStep) {
                  return;
                }

                if (canChange) {
                  changeCustomerStepStatus(
                    step: step,
                    onResponse: (final customer) => onStepChanged(customer),
                  );
                } else {
                  AppNavigator.snackbarRed(title: s.warning, subtitle: s.cannotChangeStep);
                }
              } else {
                if (customer.isFollowed) return AppNavigator.snackbarRed(title: s.error, subtitle: s.notAllowChangeStatus);
                if (!haveFollowup) return AppNavigator.snackbarRed(title: s.error, subtitle: s.haveNoAssigneeFollowup);
              }
            },
          ).expanded();
        }),
      ),
    );
  }
}
