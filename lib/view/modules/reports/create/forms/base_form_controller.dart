import 'package:u/utilities.dart';

import '../../models/report_params.dart';

abstract class BaseFormController extends GetxController {
  IReportParams? getParams();
}