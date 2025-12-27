import 'package:u/utilities.dart';

import '../../../../core/theme.dart';
import '../../../../data/remote_datasource/label/interfaces/label_interface.dart';
import '../controllers/interfaces/report_controller.dart';
import 'forms/base_form_controller.dart';
import 'forms/contract_form/contract_form.dart';
import 'forms/contract_form/contract_form_controller.dart';
import 'forms/invoice_form/invoice_form.dart';
import 'forms/invoice_form/invoice_form_controller.dart';
import 'forms/note_form/note_form.dart';
import 'forms/note_form/note_form_controller.dart';

class CreateReportController extends GetxController {
  CreateReportController({
    required this.reportController,
    required this.invoiceLabelDatasource,
    required this.contractLabelDatasource,
  });

  final ReportController reportController;
  final ILabelDatasource? invoiceLabelDatasource;
  final ILabelDatasource? contractLabelDatasource;
  late final TabController tabController;
  final Rx<PageState> buttonState = PageState.loaded.obs;

  late final List<Tab> tabs;

  late final List<Widget> pages;

  @override
  void onInit() {
    tabs = [
      const Tab(icon: UImage(AppIcons.noteOutline, size: 30)),
      if (invoiceLabelDatasource != null) const Tab(icon: UImage(AppIcons.invoiceOutline, size: 30)),
      if (contractLabelDatasource != null) const Tab(icon: UImage(AppIcons.contractOutline, size: 30)),
    ];

    pages = [
      NoteForm(
        ctrl: Get.put(NoteFormController()),
      ),
      if (invoiceLabelDatasource != null)
        InvoiceForm(
          ctrl: Get.put(
            InvoiceFormController(
              sourceId: reportController.sourceId?.toString(),
              labelDatasource: invoiceLabelDatasource!,
            ),
          ),
        ),
      if (contractLabelDatasource != null)
        ContractForm(
          ctrl: Get.put(
            ContractFormController(
              sourceId: reportController.sourceId?.toString(),
              labelDatasource: contractLabelDatasource!,
            ),
          ),
        ),
    ];
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    Get.delete<NoteFormController>();
    Get.delete<InvoiceFormController>();
    Get.delete<ContractFormController>();
    super.onClose();
  }

  BaseFormController? _activeFormController() {
    if (tabController.index == 0 && Get.isRegistered<NoteFormController>()) {
      return Get.find<NoteFormController>();
    } else if (tabController.index == 1 && Get.isRegistered<InvoiceFormController>()) {
      return Get.find<InvoiceFormController>();
    } else if (tabController.index == 2 && Get.isRegistered<ContractFormController>()) {
      return Get.find<ContractFormController>();
    } else {
      return null;
    }
  }

  void onSubmit() {
    // ۲. متد getParams را به صورت Polymorphic فراخوانی می‌کنیم.
    // ما نمی‌دانیم نوع دقیق کنترلر چیست و برایمان مهم هم نیست!
    final params = _activeFormController()?.getParams();

    if (params != null) {
      buttonState.loading();
      reportController.createNewHistory(
        params,
        onResponse: () {
          buttonState.loaded();
          UNavigator.back();
        },
        onError: () {
          buttonState.loaded();
        },
      );
    }
  }
}
