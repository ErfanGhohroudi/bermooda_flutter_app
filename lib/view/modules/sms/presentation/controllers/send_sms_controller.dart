import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/loading/loading.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../data/repositories/sms_panel_repository_imp.dart';
import '../../domain/entity/sms_panel_number.dart';
import '../../domain/usecases/sms_usecases/get_numbers_by_department.dart';
import '../../domain/usecases/sms_usecases/get_numbers_with_user_access.dart';
import '../../domain/usecases/sms_usecases/send_sms.dart';

class SendSmsController extends GetxController {
  SendSmsController({this.departmentId});

  final int? departmentId;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final SmsPanelRepositoryImpl _smsRepository = SmsPanelRepositoryImpl();

  late final _sendSmsUseCase = SendSmsUseCase(_smsRepository);
  late final _getNumbersWithUserAccessUseCase = GetSmsNumbersWithUserAccessUseCase(_smsRepository);
  late final _getNumbersByDepartmentUseCase = GetSmsNumbersByDepartmentUseCase(_smsRepository);

  final Rx<PageState> pageState = PageState.loading.obs;
  final RxList<SmsPanelNumber> numbers = <SmsPanelNumber>[].obs;
  final RxBool isLoading = false.obs;

  final TextEditingController recipientPhoneNumberCtrl = TextEditingController();
  final TextEditingController contentCtrl = TextEditingController();
  Jalali? scheduledAt;
  SmsPanelNumber? selectedNumber;

  @override
  void onInit() {
    getNumbers();
    super.onInit();
  }

  @override
  void onClose() {
    recipientPhoneNumberCtrl.dispose();
    contentCtrl.dispose();
    super.onClose();
  }

  void getNumbers() async {
    try {
      pageState.loading();
      List<SmsPanelNumber> list = [];
      if (departmentId != null) {
        final res = await _getNumbersByDepartmentUseCase(departmentId: departmentId!, pageNumber: 1);
        list = res.resultList ?? [];
      } else {
        list = await _getNumbersWithUserAccessUseCase();
      }
      numbers.assignAll(list);
      if (numbers.isEmpty) {
        pageState.emptying();
        return;
      }
      pageState.loaded();
    } catch(e) {
      pageState.error();
    }
  }

  Future<void> sendSMS({
    final String? recipientPhoneNumber,
  }) async {
    if (!formKey.currentState!.validate()) return;

    if (scheduledAt != null && scheduledAt!.isBefore(Jalali.now())) {
      AppSnackBar.snackbarRed(title: s.error, subtitle: s.timeMustBeSetInFuture);
      return;
    }

    isLoading(true);
    AppLoading.showLoading();
    try {
      await _sendSmsUseCase(
        content: contentCtrl.text.trim(),
        recipientPhoneNumber: recipientPhoneNumber ?? recipientPhoneNumberCtrl.text.trim(),
        senderId: selectedNumber?.id ?? 0,
        scheduledAt: scheduledAt,
      );
      AppSnackBar.snackbarGreen(title: s.done, subtitle: s.smsSentSuccessfully);
      isLoading(false);
      AppLoading.dismissLoading();
      AppNavigator.back();
    } catch (e) {
      isLoading(false);
      AppLoading.dismissLoading();
    }
  }
}