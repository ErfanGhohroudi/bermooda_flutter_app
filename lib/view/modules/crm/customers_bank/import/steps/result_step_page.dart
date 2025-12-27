import 'package:bermooda_business/core/widgets/widgets.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/theme.dart';
import '../customer_exel_controller.dart';

class ResultStepPage extends StatelessWidget {
  const ResultStepPage({
    required this.ctrl,
    super.key,
  });

  final CustomerExelController ctrl;

  @override
  Widget build(final BuildContext context) {
    final exelResult = ctrl.exelResult;

    if (exelResult == null) {
      return Center(child: Text(s.fileInfoNotFullyReceived, textAlign: TextAlign.center).bodyMedium());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Center(child: UImage(AppIcons.tickCircle, color: AppColors.green, size: 70)),
        Text("${s.successfullyCompleted} 🎉").titleMedium().alignAtCenter(),
        const SizedBox(height: 24),
        GridView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 190,
            childAspectRatio: 1.5,
          ),
          children: [
            _baseCard(
              title: s.rowCount,
              value: exelResult.totalRows,
              valueColor: AppColors.blue,
            ),
            _baseCard(
              title: s.successful,
              value: exelResult.successfulImports,
              valueColor: AppColors.green,
            ),
            _baseCard(
              title: s.duplicate,
              value: exelResult.duplicatesFound,
              valueColor: AppColors.orange,
            ),
            _baseCard(
              title: s.failed,
              value: exelResult.failedImports,
              valueColor: AppColors.red,
            ),
          ],
        )
      ],
    );
  }

  Widget _baseCard({
    required final String title,
    required final int value,
    required final Color valueColor,
  }) {
    return WCard(
      showBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title).titleMedium(),
          Text(value.toString().separateNumbers3By3()).bodyLarge(
            fontSize: 24,
            color: valueColor,
          ),
        ],
      ),
    );
  }
}
