import 'package:u/utilities.dart';

import '../../../../../../core/events/request_event_bus.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../core/utils/enums/request_enums_extensions.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/core.dart';
import '../../../../../../core/utils/enums/request_enums.dart';
import '../../../../../../data/data.dart';
import '../../../../requests/create/create_request_page.dart';
import '../../../../requests/details/request_detail_page.dart';
import '../../../../members/profile/profile_page.dart';
import 'hr_employee_card.dart';

mixin HrEmployeeCardController {
  final EmployeeRequestDatasource _datasource = Get.find<EmployeeRequestDatasource>();
  late BoardMemberReadDto member;
  final RxList<HRSubTask> subTasks = <HRSubTask>[].obs;

  void initializeSubTasks() {
    final requestsList = member.requests.map((final request) => HRSubTask.fromModel(request)).toList();
    subTasks.assignAll(requestsList);
  }

  void removeMember() {
    appShowYesCancelDialog(
      title: s.removeMember,
      description: s.areYouSureToRemoveMember,
      onYesButtonTap: () {
        UNavigator.back();
        _archiveMember();
      },
    );
  }

  void toggleRequestStatus(final HRSubTask request) {
    if (!request.status.isPending()) return AppNavigator.snackbarRed(title: s.warning, subtitle: s.notAllowChangeStatus);
    appShowYesCancelDialog(
      title: s.changeRequestStatusDialogTitle,
      description: s.changeRequestStatusDialogContent,
      cancelButtonTitle: s.reject,
      cancelBackgroundColor: StatusType.rejected.color,
      onCancelButtonTap: () {
        UNavigator.back();
        _callChangeStatus(request, StatusType.rejected);
      },
      yesButtonTitle: s.approve,
      yesBackgroundColor: StatusType.approved.color,
      onYesButtonTap: () {
        UNavigator.back();
        _callChangeStatus(request, StatusType.approved);
      },
    );
  }

  void navigateToProfile() {
    if (member.id == null) return;
    UNavigator.push(
      ProfilePage(
        memberId: member.id,
        initialIndex: 1,
      ),
    );
  }

  void navigateToCreateRequestPage() {
    delay(300, () {
      UNavigator.push(
        CreateRequestPage(
          requestingUser: UserReadDto(
            id: member.userId.toString(),
            avatar: member.avatar,
            avatarUrl: member.avatar?.url,
            fullName: member.fullName,
          ),
          onResponse: (final request) {
            subTasks.add(HRSubTask.fromModel(request));
          },
        ),
      );
    });
  }

  void navigateToRequestDetails(final HRSubTask request) {
    final IRequestReadDto requestModel = request.request;
    requestModel.requestingUser = UserReadDto(
      id: member.userId.toString(),
      avatar: member.avatar,
      avatarUrl: member.avatar?.url,
      fullName: member.fullName,
    );
    UNavigator.push(
      RequestDetailPage(
        request: requestModel,
        showRequestingUser: true,
        onTapRequestCheckBox: (final status) => toggleRequestStatus(request),
      ),
    );
  }

  void _archiveMember() {
    if (member.id == null) return;
    Get.find<MemberDatasource>().delete(
      id: member.id!,
      onResponse: () {},
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void _callChangeStatus(final HRSubTask request, final StatusType status) {
    _datasource.changeRequestStatus(
      slug: request.slug,
      status: status,
      onResponse: (final response) {
        if (response.result == null) return;
        _emitRequestUpdated(response.result!);
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  /// ارسال رویداد به‌روزرسانی درخواست با بررسی وضعیت Event Bus
  void _emitRequestUpdated(final IRequestReadDto updatedRequest) {
    final eventBus = RequestEventBus();
    if (eventBus.isClosed) {
      eventBus.restart();
    }
    eventBus.emitRequestUpdated(updatedRequest);
  }
}
