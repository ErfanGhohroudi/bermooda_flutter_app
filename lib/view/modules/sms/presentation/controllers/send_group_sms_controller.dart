import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../data/data.dart';
import '../../data/repositories/sms_panel_repository_imp.dart';
import '../../domain/entity/sms_panel_number.dart';
import '../../domain/entity/validation_numbers_result.dart';
import '../../domain/usecases/sms_usecases/get_numbers_by_department.dart';
import '../../domain/usecases/sms_usecases/send_group_sms.dart';
import '../../domain/usecases/sms_usecases/send_test_sms.dart';
import '../../domain/usecases/sms_usecases/validate_file_phone_numbers.dart';
import '../../domain/usecases/sms_usecases/validate_phone_numbers.dart';
import '../dialogs/upload_excel_dialog.dart';

enum GroupSmsEntryMethod { manual, file }

class SendGroupSmsController extends GetxController {
  SendGroupSmsController({
    required this.departmentId,
  });

  final int departmentId;

  String get numbersSampleFileUrl => 'https://google.com';

  final SmsPanelRepositoryImpl _repository = SmsPanelRepositoryImpl();

  late final GetSmsNumbersByDepartmentUseCase _getNumbersByDepartmentUseCase = GetSmsNumbersByDepartmentUseCase(_repository);

  late final SendGroupSmsUseCase _sendGroupSmsUseCase = SendGroupSmsUseCase(_repository);

  late final SendTestSmsUseCase _testSmsUseCase = SendTestSmsUseCase(_repository);

  late final ValidatePhoneNumbersUseCase _validatePhoneNumbersUseCase = ValidatePhoneNumbersUseCase(_repository);

  late final ValidateFilePhoneNumbersUseCase _validateFilePhoneNumbersUseCase = ValidateFilePhoneNumbersUseCase(_repository);

  final Rx<PageState> pageState = PageState.initial.obs;

  final GlobalKey<FormState> manualNumberFieldFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> contentAndSettingsStepFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> sendTestFormKey = GlobalKey<FormState>();

  // Step 1: Recipients
  final Rx<GroupSmsEntryMethod> entryMethod = GroupSmsEntryMethod.manual.obs;
  final TextEditingController manualNumbersCtrl = TextEditingController();
  final RxList<String> manualNumbers = <String>[].obs;
  final Rxn<PlatformFile> selectedFile = Rxn(null);
  final List<String> allowedExtensions = ['xlsx', 'xls', 'csv'];
  final int maxBytes = 10 * 1024 * 1024; // 10 MB
  int? _uploadedFileId;

  // Step 2: Content & Settings
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController contentCtrl = TextEditingController();
  final Rxn<SmsPanelNumber> selectedSender = Rxn(null);
  final RxList<SmsPanelNumber> senderNumbers = <SmsPanelNumber>[].obs;
  final Rxn<Jalali> scheduledDate = Rxn(null);

  // Step 3: Review
  final Rxn<ValidationNumbersResultEntity> validationResult = Rxn(null);
  final TextEditingController testNumberCtrl = TextEditingController();
  final RxBool isCalculatingCost = false.obs;

  // Stepper
  final RxInt currentStep = 0.obs;

  bool get isLastStep => currentStep.value == 2;

  bool get canBack => currentStep.value > 0;

  @override
  void onInit() {
    super.onInit();
    fetchSenderNumbers();
  }

  @override
  void onClose() {
    manualNumbersCtrl.dispose();
    titleCtrl.dispose();
    contentCtrl.dispose();
    testNumberCtrl.dispose();
    super.onClose();
  }

  Future<void> fetchSenderNumbers() async {
    try {
      pageState.initial();
      final result = await _getNumbersByDepartmentUseCase(
        departmentId: departmentId,
        pageNumber: 1,
      );
      senderNumbers.assignAll(result.resultList ?? []);
      pageState.loaded();
    } catch (e) {
      pageState.error();
    }
  }

  void onNext() {
    if (currentStep.value == 0) {
      if (!_validateStep1()) return;
      _validateRecipientsAndProceed();
    } else if (currentStep.value == 1) {
      if (!_validateStep2()) return;
      currentStep.value++;
    } else if (currentStep.value == 2) {
      _sendGroupSms();
    }
  }

  void onBack() {
    if (canBack) {
      currentStep.value--;
    } else {
      AppNavigator.back();
    }
  }

  bool _validateStep1() {
    if (entryMethod.value == GroupSmsEntryMethod.manual && manualNumbers.isEmpty) {
      AppSnackBar.snackbarRed(title: s.error, subtitle: s.isRequired(s.recipientsNumbers));
      return false;
    }
    if (entryMethod.value == GroupSmsEntryMethod.file && selectedFile.value == null) {
      AppSnackBar.snackbarRed(title: s.error, subtitle: s.isRequired(s.file));
      return false;
    }
    return true;
  }

  bool _validateStep2() {
    if (!contentAndSettingsStepFormKey.currentState!.validate()) return false;
    return true;
  }

  void onEnteredPhoneNumber() {
    if (!manualNumberFieldFormKey.currentState!.validate()) return;

    if (manualNumbersCtrl.text.isPhoneNumber) {
      final i = manualNumbers.indexOf(manualNumbersCtrl.text);
      if (i != -1) {
        AppSnackBar.snackbarRed(title: s.warning, subtitle: s.thisIsExist(s.phoneNumber));
        return;
      }
      manualNumbers.add(manualNumbersCtrl.text);
      manualNumbersCtrl.clear();
    } else if (manualNumbersCtrl.text == '') {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  void removePhoneNumber(final String value) {
    final i = manualNumbers.indexOf(value);
    if (i != -1) {
      manualNumbers.remove(value);
    }
  }

  Future<void> _validateRecipientsAndProceed() async {
    if (entryMethod.value == GroupSmsEntryMethod.manual) {
      final numbers = manualNumbers;
      final result = await _validatePhoneNumbersUseCase(numbers);
      validationResult.value = result;
      currentStep.value++;
    } else {
      _uploadFileAndValidate();
    }
  }

  Future<void> _uploadFileAndValidate() async {
    if (selectedFile.value == null) return;

    final result = await uploadExel(
      file: MainFileReadDto(
        url: selectedFile.value!.path,
        originalName: selectedFile.value!.name,
        fileName: selectedFile.value!.name,
      ),
    );
    _uploadedFileId = result?.fileId;
    if (_uploadedFileId == null) return;
    await _validateFileNumbers(_uploadedFileId!);
  }

  Future<void> _validateFileNumbers(final int fileId) async {
    try {
      final result = await _validateFilePhoneNumbersUseCase(fileId);
      validationResult.value = result;
    } catch (e) {
      // Error
    }
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final ext = (file.extension ?? '').toLowerCase();
    final size = file.size;

    if (!allowedExtensions.contains(ext)) {
      AppSnackBar.snackbarRed(title: s.error, subtitle: s.formatIsNotAllowed);
      return;
    }

    if (size > maxBytes) {
      AppSnackBar.snackbarRed(title: s.error, subtitle: "${s.fileSizeExceedsTheAllowedLimit} (${s.maximum} 10 MB)");
      return;
    }

    selectedFile.value = file;
  }

  String prettySize(final int bytes) {
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(1)} KB";
    return "${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB";
  }

  Future<void> sendTestSms() async {
    if (!sendTestFormKey.currentState!.validate()) return;
    if (selectedSender.value == null) return;

    try {
      await _testSmsUseCase(
        recipientPhoneNumber: testNumberCtrl.text.trim(),
        content: contentCtrl.text.trim(),
        senderId: selectedSender.value!.id,
      );
      AppSnackBar.snackbarGreen(title: s.done, subtitle: s.messageSentSuccessfully);
    } catch (e) {
      // Error
    }
  }

  Future<void> _sendGroupSms() async {
    if (manualNumbers.isEmpty && _uploadedFileId == null) return;

    if (scheduledDate.value != null && scheduledDate.value!.isBefore(Jalali.now())) {
      AppSnackBar.snackbarRed(title: s.error, subtitle: s.timeMustBeSetInFuture);
      return;
    }

    try {
      final result = await _sendGroupSmsUseCase(
        campaignTitle: titleCtrl.text,
        content: contentCtrl.text,
        recipientsPhoneNumbers: entryMethod.value == GroupSmsEntryMethod.manual ? manualNumbers : null,
        fileId: entryMethod.value == GroupSmsEntryMethod.file ? _uploadedFileId : null,
        senderId: selectedSender.value!.id,
        departmentId: departmentId,
        scheduledAt: scheduledDate.value,
      );

      AppNavigator.back(result: result);
    } catch (e) {
      // Error
    }
  }
}
