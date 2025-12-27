import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/widgets/fields/fields.dart';
import '../../../../data/data.dart';
import '../../../../core/core.dart';
import 'create_workspace_controller.dart';

void showCreateWorkspaceDialog({
  final bool barrierDismissible = true,
  final Color? barrierColor,
  final Function(WorkspaceReadDto workspace)? action,
}) {
  showAppDialog(
    useSafeArea: true,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    AlertDialog(
      content: CreateWorkspacePage(action: action),
      contentPadding: const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 24),
      // title: const Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [UImage(AppLottie.error, size: 70)],
      // ),
      // titlePadding: const EdgeInsets.only(top: 10),
      // content: SizedBox(
      //   width: double.maxFinite,
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     spacing: 10,
      //     children: [
      //       const Text("لیست کسب\u200Cوکار های شما خالییست.").bodyMedium().bold(),
      //       const Text(
      //         "لطفا با استفاده از رایانه و یا لپ تاپ از طریق سایت با نشانی (office.bermooda.app) جهت ایجاد کسب\u200Cوکار اقدام فرمایید.",
      //         textAlign: TextAlign.justify,
      //       ).bodyMedium(),
      //       UElevatedButton(
      //         width: double.maxFinite,
      //         title: "متوجه شدم",
      //         onTap: () {
      //           SystemNavigator.pop(); // Exit the app
      //         },
      //       ),
      //     ],
      //   ),
      // ),
    ),
  );
}

class CreateWorkspacePage extends StatefulWidget {
  const CreateWorkspacePage({
    this.action,
    super.key,
  });

  final Function(WorkspaceReadDto workspace)? action;

  @override
  State<CreateWorkspacePage> createState() => _CreateWorkspacePageState();
}

class _CreateWorkspacePageState extends State<CreateWorkspacePage> with CreateWorkspaceController {
  @override
  void dispose() {
    titleController.dispose();
    buttonState.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(s.newWorkspace).titleMedium(),
          const Divider().marginOnly(bottom: 50),
          WTextField(
            controller: titleController,
            labelText: s.workspaceTitle,
            required: true,
            showRequired: false,
            minLength: 3,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ).marginOnly(bottom: 50),
          Obx(
            () => UElevatedButton(
              width: context.width,
              title: s.confirm,
              isLoading: buttonState.isLoading(),
              onTap: () => createWorkspace(action: widget.action),
            ),
          ),
        ],
      ),
    );
  }
}
