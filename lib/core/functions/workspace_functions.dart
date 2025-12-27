import 'package:u/utilities.dart';

import '../utils/enums/enums.dart';
import '../../data/data.dart';
import '../core.dart';

/// Fetch workspaces & save list in [Core]
void getWorkspaces({
  required final VoidCallback action,
  final bool withLoading = false,
}) {
  Get.find<WorkspaceDatasource>().getAllWorkspace(
    onResponse: (final response) {
      final core = Get.find<Core>();
      core.updateWorkspaces(response.resultList);
      final notAcceptedWorkspace = core.workspaces.firstWhereOrNull(
        (final element) => !element.isAccepted && element.type.isMember(),
      );
      if (notAcceptedWorkspace != null) {
        core.setHaveNotAcceptedWorkspace(true);
      } else {
        core.setHaveNotAcceptedWorkspace(false);
      }
      action();
    },
    onError: (final errorResponse) {},
    withRetry: true,
    withLoading: withLoading,
  );
}
