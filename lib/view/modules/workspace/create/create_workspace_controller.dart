import 'package:u/utilities.dart';

import '../../../../core/core.dart';
import '../../../../core/functions/init_app_functions.dart';
import '../../../../core/services/websocket_service.dart';
import '../../../../data/data.dart';

mixin CreateWorkspaceController {
  final WorkspaceDatasource _datasource = Get.find<WorkspaceDatasource>();
  final webSocketService = WebSocketService();
  final core = Get.find<Core>();
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController titleController = TextEditingController();
  final Rx<PageState> buttonState = PageState.loaded.obs;

  void createWorkspace({final Function(WorkspaceReadDto workspace)? action}) {
    validateForm(
      key: formKey,
      action: () {
        buttonState.loading();

        _datasource.create(
          title: titleController.text.trim(),
          onResponse: (final response) {
            if (webSocketService.isConnected.value) return;
            final hadAnyWorkspaces = core.workspaces.isNotEmpty;
            final hadCurrentWorkspace = core.currentWorkspace.value.id.isNotEmpty;
            final isFirstWorkspace = hadAnyWorkspaces == false && hadCurrentWorkspace == false;

            core.addToWorkspaces(response.result);
            core.updateCurrentWorkspace(response.result);
            if (action != null) {
              action(response.result!);
            } else {
              initApp(
                currentWorkspaceChanged: !isFirstWorkspace,
                withConnectWS: isFirstWorkspace,
              );
            }
          },
          onError: (final errorResponse) {
            buttonState.loaded();
          },
        );
      },
    );
  }
}
