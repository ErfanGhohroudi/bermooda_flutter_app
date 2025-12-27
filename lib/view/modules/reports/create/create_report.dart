import 'package:u/utilities.dart';

import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/core.dart';
import '../../../../data/remote_datasource/label/interfaces/label_interface.dart';
import '../controllers/interfaces/report_controller.dart';
import 'create_report_controller.dart';

class CreateReportForm extends StatefulWidget {
  const CreateReportForm({
    required this.reportController,
    required this.invoiceLabelDatasource,
    required this.contractLabelDatasource,
    super.key,
  });

  final ReportController reportController;
  final ILabelDatasource? invoiceLabelDatasource;
  final ILabelDatasource? contractLabelDatasource;

  @override
  State<CreateReportForm> createState() => _CreateReportFormState();
}

class _CreateReportFormState extends State<CreateReportForm> with SingleTickerProviderStateMixin {
  late final CreateReportController ctrl;

  @override
  void initState() {
    ctrl = Get.put(CreateReportController(
      reportController: widget.reportController,
      invoiceLabelDatasource: widget.invoiceLabelDatasource,
      contractLabelDatasource: widget.contractLabelDatasource,
    ));
    ctrl.tabController = TabController(length: ctrl.tabs.length, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<CreateReportController>();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      body: Column(
        children: [
          WTabBar(
            controller: ctrl.tabController,
            tabs: ctrl.tabs,
            backgroundColor: context.theme.scaffoldBackgroundColor,
            isScrollable: true,
            dividerColor: context.theme.dividerColor.withAlpha(100),
            horizontalPadding: 10,
            horizontalLabelPadding: 10,
          ),
          WTabBarView(
            controller: ctrl.tabController,
            pages: ctrl.pages.map((final page) => LazyKeepAliveTabView(builder: () => page)).toList(),
          ).expanded(),
        ],
      ),
      bottomNavigationBar: Obx(
        () => UElevatedButton(
          title: s.submit,
          isLoading: ctrl.buttonState.isLoading(),
          onTap: ctrl.onSubmit,
        ),
      ),
    );
  }
}
