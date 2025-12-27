import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/functions/init_app_functions.dart';
import '../../../../core/theme.dart';
import '../../../../data/data.dart';

mixin WorkspaceListController {
  final core = Get.find<Core>();
  final WorkspaceDatasource _workspaceDatasource = Get.find<WorkspaceDatasource>();
  final TextEditingController searchController = TextEditingController();
  final RefreshController refreshController = RefreshController();
  final Rx<PageState> pageState = PageState.initial.obs;
  final RxList<WorkspaceInfoReadDto> workspaces = <WorkspaceInfoReadDto>[].obs;

  void getWorkspacesInfo({final Function(List<WorkspaceInfoReadDto> list)? action}) {
    pageState.loading();
    _workspaceDatasource.getAllWorkspaceWithInfo(
      onResponse: (final response) {
        workspaces(response);
        refreshController.refreshCompleted();
        pageState.loaded();
        action?.call(workspaces);
      },
      onError: (final errorResponse) {
        refreshController.refreshFailed();
        pageState.error();
      },
      withRetry: true,
    );
  }

  void deleteWorkspace({
    required final String id,
    required final VoidCallback action,
  }) {
    if (kDebugMode) {
      appShowYesCancelDialog(
        title: s.delete,
        description: s.areYouSureToDeleteBusiness,
        yesButtonTitle: s.delete,
        yesBackgroundColor: AppColors.red,
        onYesButtonTap: () {
          UNavigator.back();
          _delete(id: id, action: action);
        },
      );
    }
  }

  void _delete({
    required final String id,
    required final VoidCallback action,
  }) {
    _workspaceDatasource.delete(
      id: id,
      onResponse: () {
        if (core.currentWorkspace.value.id == id) {
          initApp(currentWorkspaceChanged: true);
          return;
        } else {
          core.workspaces.removeWhere((final e) => e.id == id);
        }
        action();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }
}
