import 'package:u/utilities.dart';

import '../../../../../../core/widgets/image_files.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../data/data.dart';
import '../../../../../../data/remote_datasource/label/interfaces/label_interface.dart';
import '../../../models/report_params.dart';
import '../base_form_controller.dart';

class InvoiceFormController extends BaseFormController {
  InvoiceFormController({
    required this.sourceId,
    required this.labelDatasource,
  });

  final String? sourceId;
  final ILabelDatasource labelDatasource;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController amountCtrl = TextEditingController();
  InvoiceType? type;
  InvoiceStatusType? status;
  final TextEditingController idCtrl = TextEditingController();
  List<Jalali> reminderDates = [];
  List<LabelReadDto> selectedLabels = [];
  List<MainFileReadDto> selectedFiles = [];
  bool isUploadingFile = false;

  @override
  void onClose() {
    amountCtrl.dispose();
    idCtrl.dispose();
    super.onClose();
  }

  @override
  IReportParams? getParams() {
    IReportParams? params;
    validateForm(
      key: formKey,
      action: () {
        WImageFiles.checkFileUploading(
          isUploadingFile: isUploadingFile,
          action: () {
            if (type == null || status == null) return;
            params = ReportInvoiceParams(
              invoiceType: type!,
              invoiceStatusType: status!,
              amount: amountCtrl.text.trim(),
              remindDates: reminderDates,
              labels: selectedLabels,
              files: selectedFiles,
              invoiceId: idCtrl.text.trim().isNotEmpty ? idCtrl.text.trim() : null,
            );
          },
        );
      },
    );
    return params;
  }
}
