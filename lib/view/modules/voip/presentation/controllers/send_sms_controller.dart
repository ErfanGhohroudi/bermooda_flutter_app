import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/loading/loading.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../data/repositories/voip_repository_imp.dart';
import '../../domain/entity/sms_panel_number.dart';
import '../../domain/usecases/sms_usecases/get_numbers_with_user_access.dart';
import '../../domain/usecases/sms_usecases/send_sms.dart';

class SendSmsController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final VoipRepositoryImpl _smsRepository = VoipRepositoryImpl();

  late final _sendSmsUseCase = SendSmsUseCase(_smsRepository);
  late final _getNumbersWithUserAccessUseCase = GetNumbersWithUserAccessUseCase(_smsRepository);

  final Rx<PageState> pageState = PageState.loading.obs;
  final RxList<SmsPanelNumber> numbers = <SmsPanelNumber>[].obs;
  final RxBool isLoading = false.obs;

  final TextEditingController contentController = TextEditingController();
  SmsPanelNumber? selectedNumber;

  @override
  void onInit() {
    getNumbers();
    super.onInit();
  }

  void getNumbers() async {
    try {
      pageState.loading();
      final list = await _getNumbersWithUserAccessUseCase();
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
    required final String recipientPhoneNumber,
  }) async {
    if (!formKey.currentState!.validate()) return;

    isLoading(true);
    AppLoading.showLoading();
    try {
      await _sendSmsUseCase(
        content: contentController.text.trim(),
        recipientPhoneNumber: recipientPhoneNumber,
        senderId: selectedNumber?.id ?? 0,
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