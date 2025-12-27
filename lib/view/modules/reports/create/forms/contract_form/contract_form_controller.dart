import 'package:u/utilities.dart';

import '../../../../../../core/widgets/image_files.dart';
import '../../../../../../core/core.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../data/data.dart';
import '../../../../../../data/remote_datasource/label/interfaces/label_interface.dart';
import '../../../models/report_params.dart';
import '../base_form_controller.dart';

class ContractFormController extends BaseFormController {
  ContractFormController({
    required this.sourceId,
    required this.labelDatasource,
  });

  final String? sourceId;
  final ILabelDatasource labelDatasource;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleCtrl = TextEditingController();
  LabelReadDto? selectedContractType;
  Jalali? selectedStartDate;
  Jalali? selectedEndDate;
  final TextEditingController amountCtrl = TextEditingController();
  List<MainFileReadDto> selectedFiles = [];
  bool isUploadingFile = false;

  @override
  void onClose() {
    titleCtrl.dispose();
    amountCtrl.dispose();
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
            if (selectedStartDate != null && selectedEndDate != null) {
              if (selectedEndDate!.isBefore(selectedStartDate!)) {
                AppNavigator.snackbarRed(title: s.error, subtitle: s.endTimeMustBeAfterStartTime);
                return;
              }
            }

            params = ReportContractParams(
              title: titleCtrl.text.trim(),
              contractType: selectedContractType,
              startDate: selectedStartDate?.toUtcDateTime(),
              endDate: selectedEndDate?.toUtcDateTime(),
              amount: amountCtrl.text.trim().isNotEmpty ? amountCtrl.text.trim() : null,
              files: selectedFiles,
            );
          },
        );
      },
    );
    return params;
  }
}
