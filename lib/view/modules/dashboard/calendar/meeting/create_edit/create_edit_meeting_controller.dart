import 'package:u/utilities.dart';

import '../../../../../../../core/widgets/image_files.dart';
import '../../../../../../../core/core.dart';
import '../../../../../../../core/utils/enums/enums.dart';
import '../../../../../../../data/data.dart';
import '../../../../../../core/navigator/navigator.dart';

mixin CreateEditMeetingController {
  final MeetingDatasource _meetingDatasource = Get.find<MeetingDatasource>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Rx<PageState> buttonState = PageState.loaded.obs;
  late final ActionApiType actionApiType;
  MeetingReadDto? meeting;

  final RxList<LabelReadDto> labelList = <LabelReadDto>[].obs;
  final Rx<LabelReadDto> selectedLabel = LabelReadDto().obs;

  final TextEditingController titleController = TextEditingController();

  late Jalali selectedTime;
  final TextEditingController dateController = TextEditingController();
  String? selectedStartTime;
  String? selectedEndTime;

  final TextEditingController descriptionController = TextEditingController();

  bool isUploadingFile = false;
  List<MainFileReadDto> files = <MainFileReadDto>[];

  final Rx<bool> additionalInfoSwitch = false.obs;

  late ReminderTimeType selectedReminderTime;
  late RepeatType repeatType;

  final TextEditingController linkController = TextEditingController();

  List<UserReadDto> selectedMembers = <UserReadDto>[];

  final TextEditingController phoneNumberController = TextEditingController();
  final RxList<String> selectedPhoneNumbersList = <String>[].obs;

  final TextEditingController emailController = TextEditingController();
  final RxList<String> selectedEmailsList = <String>[].obs;

  void disposeItems() {
    buttonState.close();
    labelList.close();
    selectedLabel.close();
    titleController.dispose();
    dateController.dispose();
    descriptionController.dispose();
    additionalInfoSwitch.close();
    linkController.dispose();
    phoneNumberController.dispose();
    selectedPhoneNumbersList.close();
    emailController.dispose();
    selectedEmailsList.close();
  }

  void initValues({required final MeetingReadDto? model, required final Jalali? time}) {
    meeting = model;
    actionApiType = meeting?.id == null ? ActionApiType.create : ActionApiType.update;
    selectedLabel(meeting?.label);
    titleController.text = meeting?.title ?? '';
    selectedTime = meeting?.dateToStart ?? time ?? Jalali.now();
    dateController.text = selectedTime.formatCompactDate();
    selectedStartTime = meeting?.startMeetingTime;
    selectedEndTime = meeting?.endMeetingTime;
    descriptionController.text = meeting?.description ?? '';
    files = meeting?.files ?? [];
    additionalInfoSwitch(meeting?.moreInformation);
    selectedReminderTime = meeting?.reminderTimeType ?? ReminderTimeType.halfHour;
    repeatType = meeting?.repeatType ?? RepeatType.values.first;
    linkController.text = meeting?.link ?? '';
    selectedMembers =
        meeting?.members?.where((final user) => user.id != Get.find<Core>().userReadDto.value.id).toList() ?? selectedMembers;
    selectedPhoneNumbersList(meeting?.meetingPhoneNumbers?.map((final e) => e.phoneNumber ?? '').toList());
    selectedEmailsList(meeting?.meetingEmails?.map((final e) => e.email ?? '').toList());
  }

  void onSubmit({required final Function(MeetingReadDto model) onResponse}) {
    phoneNumberController.clear();
    emailController.clear();
    validateForm(
      key: formKey,
      action: () {
        checkValidation(
          action: () {
            WImageFiles.checkFileUploading(
              isUploadingFile: isUploadingFile,
              action: () {
                buttonState.loading();
                _callAPI(onResponse: onResponse);
              },
            );
          },
        );
      },
    );
  }

  void checkValidation({required final VoidCallback action}) {
    final startValues = selectedStartTime?.split(":");
    final startHour = startValues?.first.toInt();
    final startMinute = startValues?.last.toInt();

    final endValues = selectedEndTime?.split(":");
    final endHour = endValues?.first.toInt();
    final endMinute = endValues?.last.toInt();

    final startDate = Jalali(selectedTime.year, selectedTime.month, selectedTime.day, startHour ?? 0, startMinute ?? 0);
    final endDate = Jalali(selectedTime.year, selectedTime.month, selectedTime.day, endHour ?? 0, endMinute ?? 0);

    bool isOk() => startDate.isAfter(Jalali.now()) && startDate.isBefore(endDate);

    if (dateController.text != '' && selectedStartTime != null && selectedEndTime != null) {
      if (isOk()) {
        action();
      } else {
        if (startDate.isBefore(Jalali.now())) {
          return AppNavigator.snackbarRed(title: s.warning, subtitle: s.startTimeMustBeSetInFuture);
        }
        if (endDate.isBefore(startDate) || startDate == endDate) {
          return AppNavigator.snackbarRed(title: s.warning, subtitle: s.endTimeMustBeAfterStartTime);
        }
      }
    } else {
      final subtitle = [
        if (dateController.text == '') s.date,
        if (selectedStartTime == null) s.startTime,
        if (selectedEndTime == null) s.endTime,
      ];
      AppNavigator.snackbarRed(title: s.warning, subtitle: s.isRequired.replaceAll("#", "(${subtitle.join(" , ")})"));
    }
  }

  void _callAPI({required final Function(MeetingReadDto model) onResponse}) {
    if (actionApiType.isCreate()) _create(onResponse: onResponse);
    if (actionApiType.isUpdate()) _update(onResponse: onResponse);
  }

  void _create({required final Function(MeetingReadDto model) onResponse}) {
    _meetingDatasource.create(
      dto: MeetingParams(
        labelId: selectedLabel.value.id,
        title: titleController.text,
        dateToStartPersian: dateController.text,
        startMeetingTime: selectedStartTime,
        endMeetingTime: selectedEndTime,
        description: descriptionController.text,
        fileIdList: files.isNotEmpty
            ? files.where((final file) => file.fileId != null).toList().map((final e) => e.fileId!).toList()
            : null,
        moreInformation: additionalInfoSwitch.value,
        reminderTimeType: additionalInfoSwitch.value ? selectedReminderTime : null,
        reapedType: additionalInfoSwitch.value ? repeatType : null,
        link: additionalInfoSwitch.value ? linkController.text : null,
        memberIdList: additionalInfoSwitch.value ? selectedMembers.map((final user) => user.id).toList() : null,
        phoneNumberList: additionalInfoSwitch.value ? selectedPhoneNumbersList : null,
        emailList: additionalInfoSwitch.value ? selectedEmailsList : null,
      ),
      onResponse: (final response) {
        if (response.result != null) {
          onResponse(response.result!);
        }
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void _update({required final Function(MeetingReadDto model) onResponse}) {
    _meetingDatasource.update(
      id: meeting?.id,
      dto: MeetingParams(
        labelId: selectedLabel.value.id,
        title: titleController.text,
        dateToStartPersian: dateController.text,
        startMeetingTime: selectedStartTime,
        endMeetingTime: selectedEndTime,
        description: descriptionController.text,
        fileIdList: files.isNotEmpty
            ? files.where((final file) => file.fileId != null).toList().map((final e) => e.fileId!).toList()
            : null,
        moreInformation: additionalInfoSwitch.value,
        reminderTimeType: additionalInfoSwitch.value ? selectedReminderTime : null,
        reapedType: additionalInfoSwitch.value ? repeatType : null,
        link: additionalInfoSwitch.value ? linkController.text : null,
        memberIdList: additionalInfoSwitch.value ? selectedMembers.map((final user) => user.id).toList() : null,
        phoneNumberList: additionalInfoSwitch.value ? selectedPhoneNumbersList : null,
        emailList: additionalInfoSwitch.value ? selectedEmailsList : null,
      ),
      onResponse: (final response) {
        if (response.result != null) {
          onResponse(response.result!);
        }
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void getEventTypes({required final VoidCallback action}) {
    _meetingDatasource.getAllLabels(
      onResponse: (final response) {
        labelList(response.resultList?.reversed.toList());
        selectedLabel(labelList.first);
        action();
      },
      onError: (final errorResponse) {},
      withRetry: true,
      withLoading: true,
    );
  }

  void onEnteredPhoneNumber() {
    if (phoneNumberController.text.isPhoneNumber) {
      final i = selectedPhoneNumbersList.indexOf(phoneNumberController.text);
      if (i != -1) {
        return AppNavigator.snackbarRed(title: s.warning, subtitle: s.thisIsExist.replaceAll('#', s.phoneNumber));
      }
      selectedPhoneNumbersList.add(phoneNumberController.text);
      phoneNumberController.clear();
    } else if (phoneNumberController.text == '') {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  void removePhoneNumber(final String value) {
    final i = selectedPhoneNumbersList.indexOf(value);
    if (i != -1) {
      selectedPhoneNumbersList.remove(value);
    }
  }

  void onEnteredEmail() {
    if (emailController.text != '' && emailController.text.isEmail) {
      final i = selectedEmailsList.indexOf(emailController.text.toLowerCase());
      if (i != -1) {
        return AppNavigator.snackbarRed(title: s.warning, subtitle: s.thisIsExist.replaceAll('#', s.email));
      }
      emailController.text = emailController.text.replaceAll(' ', '');
      selectedEmailsList.add(emailController.text.toLowerCase());
      emailController.clear();
    } else if (emailController.text == '') {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  void removeEmail(final String value) {
    final i = selectedEmailsList.indexOf(value);
    if (i != -1) {
      selectedEmailsList.remove(value);
    }
  }

  Future<void> pickFilesWithSizeLimit() async {
    const maxFileSizeMB = 100;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null) {
      List<String> rejectedFiles = [];

      for (var file in result.files) {
        final sizeInMB = file.size / (1024 * 1024);

        if (sizeInMB <= maxFileSizeMB &&
            (file.path!.isImageFileName ||
                file.path!.isVideoFileName ||
                file.path!.isAudioFileName ||
                file.path!.isPDFFileName ||
                file.path!.isPPTFileName ||
                file.path!.isDocumentFileName ||
                file.path!.isExcelFileName ||
                file.path!.isTxtFileName)) {
          // selectedFiles.add(XFile(file.path!));
          files.add(MainFileReadDto(url: file.path, fileName: file.name));
        } else {
          rejectedFiles.add('${file.name} (${sizeInMB.toStringAsFixed(1)}MB)');
        }
      }

      if (rejectedFiles.isNotEmpty) {
        AppNavigator.snackbarRed(
          title: s.invalidFile,
          subtitle: '${s.invalidFileInfo}\n\n${rejectedFiles.join('\n')}',
        );
      }
    }
  }
}
