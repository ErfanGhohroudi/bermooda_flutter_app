import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../data/data.dart';

mixin LetterDetailController {
  final core = Get.find<Core>();
  final MailDatasource _mailDatasource = Get.find<MailDatasource>();
  final Rx<LetterReadDto> mail = LetterReadDto(recipients: []).obs;
  final double padding = 16;
  final Rx<PageState> pageState = PageState.loaded.obs;
  final Rx<PageState> buttonState = PageState.loaded.obs;

  MainFileReadDto? mySignature;

  MailStatus? selectedStatus;
  List<UserReadDto> selectedUsersList = [];

  void disposeItems() {
    mail.close();
    pageState.close();
    buttonState.close();
  }

  void getMail(final String id) {
    pageState.loading();
    _mailDatasource.getAMail(
      id: id,
      onResponse: (final response) {
        mail(response.result);
        pageState.loaded();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void addSignature({
    required final Recipient recipient,
    required final VoidCallback action,
  }) {
    if (mySignature?.fileId != null) {
      _mailDatasource.addSignature(
        id: recipient.id,
        fileId: mySignature?.fileId,
        onResponse: (final response) {
          final i = mail.value.recipients.indexWhere((final Recipient element) => element.id == response.result!.id);
          if (i != -1) {
            mail.value.recipients[i] = response.result!;
            pageState.refresh();
          }
          UNavigator.back();
          action();
        },
        onError: (final errorResponse) {},
      );
    } else {
      AppNavigator.snackbarRed(title: s.warning, subtitle: s.uploadSignatureFirst);
    }
  }

  void getCurrentStatus({
    required final Function(List<MailStatus> statusList, List<UserReadDto> userList) action,
  }) {
    selectedStatus = null;
    selectedUsersList.clear();
    _mailDatasource.getCurrentStatus(
      id: mail.value.id,
      onResponse: (final response) {
        final statusList = response.result!.statusList!;
        final userList = response.result!.userList!;
        selectedStatus = statusList.firstWhereOrNull((final e) => e.selected);
        selectedUsersList = userList.where((final e) => e.selected ?? false).toList();

        action(statusList, userList);
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void changeStatus() {
    buttonState.loading();
    _mailDatasource.changeStatus(
      id: mail.value.id,
      statusId: selectedStatus?.id,
      userIdList: selectedUsersList.map((final e) => e.id.toInt()).toList(),
      onResponse: () {
        buttonState.loaded();
        AppNavigator.snackbarGreen(title: s.done, subtitle: '');
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }
}
