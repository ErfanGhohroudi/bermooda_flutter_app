import 'package:flutter/cupertino.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/core.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../data/data.dart';
import '../../../data/dto/conversation_dtos.dart';
import '../create_group_chat/create_update_group_page.dart';
import '../messages/conversation_messages_controller.dart';
import 'add_member/add_member_page.dart';

class GroupSettingsPage extends StatelessWidget {
  GroupSettingsPage({
    required this.controller,
    super.key,
  }) {
    _core = Get.find();
    final myMember = controller.conversation.value.members.firstWhereOrNull((final e) => e.user.id == _core.userReadDto.value.id);
    if (myMember == null) {
      AppNavigator.snackbarRed(title: s.error, subtitle: s.youAreNotMemberOfThisGroup);
      throw Exception("_myMember == null");
    }

    _myMember = myMember;
  }

  final ConversationMessagesController controller;

  late final Core _core;
  late final ConversationMemberDto _myMember;

  bool get isGroupOwner => _myMember.isOwner;

  bool get isGroupAdmin => _myMember.isAdmin;

  bool get haveAdminAccess => isGroupAdmin || isGroupOwner;

  @override
  Widget build(final BuildContext context) {
    // final myMember = _myMember;
    // if (myMember == null) {
    //   Navigator.pop(context);
    //   return const SizedBox.shrink();
    // }
    return UScaffold(
      appBar: AppBar(title: Text(s.details)),
      color: context.theme.cardColor,
      body: Obx(
        () => CustomScrollView(
          slivers: [
            /// Header
            _header(context),
            _buildDivider(context),

            /// Description
            if ((controller.conversation.value.description ?? '').trim().isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Text(s.description).titleMedium(color: context.theme.hintColor),
                    Text(controller.conversation.value.description!).bodyMedium(),
                  ],
                ).pSymmetric(vertical: 16, horizontal: 16),
              ),
              _buildDivider(context),
            ],

            /// Add Member
            _addMember(context),

            /// Members
            _membersList(),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _header(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        color: context.theme.primaryColor,
        child: Column(
          children: [
            WCircleAvatar(
              user: UserReadDto(id: '', avatarUrl: controller.conversation.value.avatarUrl, fullName: controller.conversation.value.title),
              size: 100,
              backgroundColor: Colors.grey,
              imageFontSize: 23,
            ),
            const SizedBox(height: 16),
            Text(controller.conversation.value.displayName, textAlign: TextAlign.center).bodyLarge(color: Colors.white),
            Text(
              "${controller.conversation.value.members.length} "
              "${isPersianLang == false && controller.conversation.value.members.length <= 1 ? s.member.removeLast() : s.member}",
              textAlign: TextAlign.center,
            ).bodyMedium(color: Colors.white54),
            const SizedBox(height: 24),
            _headerActions(),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _addMember(final BuildContext context) {
    return SliverToBoxAdapter(
      child: haveAdminAccess
          ? InkWell(
              onTap: () => UNavigator.push(AddMemberToGroupPage(conversation: controller.conversation.value.copyWith())),
              child: Row(
                spacing: 12,
                children: [
                  Icon(CupertinoIcons.person_add, size: 30, color: context.theme.primaryColor),
                  Expanded(
                    child: Text(
                      s.addMember,
                    ).titleMedium(color: context.theme.primaryColor),
                  ),
                ],
              ).pAll(16),
            )
          : Row(
              spacing: 12,
              children: [
                UImage(AppIcons.groupOutline, size: 30, color: context.theme.primaryColorDark),
                Expanded(
                  child: Text(
                    "${controller.conversation.value.members.length} "
                    "${isPersianLang == false && controller.conversation.value.members.length <= 1 ? s.member.removeLast() : s.member}",
                  ).titleMedium(),
                ),
              ],
            ).pAll(16),
    );
  }

  SliverList _membersList() {
    return SliverList.builder(
      itemCount: controller.conversation.value.members.length,
      itemBuilder: (final context, final index) {
        final member = controller.conversation.value.members[index];
        return ListTile(
          title: WCircleAvatar(
            user: member.user,
            showFullName: true,
            size: 50,
            subTitle: member.isMember == false ? Text(member.role.title).bodyMedium(color: context.theme.primaryColor) : null,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              if (haveAdminAccess && member.isOwner == false)
                TextButton(
                  onPressed: () => controller.removeMember(member),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColors.red.withValues(alpha: 0.1)),
                  ),
                  child: Text(s.remove).bodyMedium(color: AppColors.red),
                ),
              if (member.isOwner || member.isAdmin)
                Icon(
                  member.isOwner ? CupertinoIcons.checkmark_seal_fill : CupertinoIcons.checkmark_seal,
                  color: context.theme.primaryColor,
                  size: 18,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _headerActions() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      children: [
        _headerActionButton(
          labelText: isGroupOwner ? s.deleteAndLeave : s.leaveGroup,
          icon: isGroupOwner ? AppIcons.delete : AppIcons.logout,
          onTap: controller.leaveGroup,
        ),
        if (isGroupOwner)
          _headerActionButton(
            labelText: s.editGroup,
            icon: AppIcons.editOutline,
            onTap: () => UNavigator.push(CreateUpdateGroupPage(model: controller.conversation.value)),
          ),
      ],
    );
  }

  Widget _headerActionButton({
    required final String labelText,
    required final String icon,
    required final VoidCallback onTap,
  }) {
    return Tooltip(
      message: labelText,
      child: WCard(
        onTap: onTap,
        glassEffect: true,
        glassColor: Colors.white24,
        verPadding: 0,
        horPadding: 12,
        margin: EdgeInsets.zero,
        child: SizedBox(
          width: 150,
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UImage(icon, size: 20, color: Colors.white),
              const SizedBox(width: 10),
              Flexible(
                child: Text(labelText, maxLines: 1).bodyMedium(color: Colors.white, overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildDivider(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        height: 10,
        color: context.theme.scaffoldBackgroundColor,
      ),
    );
  }
}
