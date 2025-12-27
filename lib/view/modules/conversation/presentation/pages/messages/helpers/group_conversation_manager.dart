import 'package:u/utilities.dart';

import '../../../../../../../../core/widgets/widgets.dart';
import '../../../../../../../../core/core.dart';
import '../../../../../../../../core/navigator/navigator.dart';
import '../../../../../../../../core/theme.dart';
import '../../../../data/dto/conversation_dtos.dart';
import '../../group_settings/group_settings_page.dart';
import '../conversation_messages_controller.dart';

class GroupConversationManager {
  GroupConversationManager(this.controller);

  final ConversationMessagesController controller;

  void navigateToGroupSettingsPage() {
    if (controller.isAnonymousBot) return;
    UNavigator.push(GroupSettingsPage(controller: controller));
  }

  void removeMember(final ConversationMemberDto member) {
    if (controller.isAnonymousBot) return;
    if (member.isOwner) return;
    controller.repository.removeMember(controller.conversation.value.id, member.user.id);
  }

  void leaveGroup() {
    if (controller.isAnonymousBot) return;
    appShowYesCancelDialog(
      title: controller.isGroupOwner ? s.deleteAndLeave : s.leaveGroup,
      description: controller.isGroupOwner
          ? s.deleteAndLeaveGroupDialogDescription
          : s.leaveGroupDialogDescription,
      onYesButtonTap: () {
        UNavigator.back(); // Close dialog
        if (controller.isGroupOwner) {
          AppNavigator.snackbarOrange(
            title: s.warning,
            subtitle: s.notSupportedInThisVersion,
          );
          return;
        }
        controller.repository.leaveConversation(controller.conversation.value.id);
        // Navigate back to conversations list
        UNavigator.back(); // Close group settings page
        UNavigator.back(); // Close messages page
      },
      yesBackgroundColor: AppColors.red,
    );
  }

  void updateConversation(final ConversationDto updatedConversation) {
    if (controller.conversation.value.id == updatedConversation.id) {
      controller.conversation(updatedConversation);
    }
  }
}

