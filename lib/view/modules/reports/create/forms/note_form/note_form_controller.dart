import 'package:u/utilities.dart';

import '../../../models/report_params.dart';
import '../base_form_controller.dart';

class NoteFormController extends BaseFormController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController noteController = TextEditingController();

  @override
  void onClose() {
    noteController.dispose();
    debugPrint("NoteFormController closed!!!");
    super.onClose();
  }

  @override
  IReportParams? getParams() {
    IReportParams? params;
    validateForm(
      key: formKey,
      action: () {
        params = ReportNoteParams(noteText: noteController.text);
      },
    );
    return params;
  }
}
