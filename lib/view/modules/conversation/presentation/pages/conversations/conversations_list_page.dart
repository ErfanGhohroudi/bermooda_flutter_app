import 'package:u/utilities.dart';

import 'package:bermooda_business/core/widgets/widgets.dart';
import 'package:bermooda_business/core/theme.dart';
import 'package:bermooda_business/data/data.dart';
import 'package:bermooda_business/view/modules/conversation/presentation/pages/conversations/conversations_list_controller.dart';
import 'package:bermooda_business/view/modules/conversation/presentation/pages/messages/conversation_messages_page.dart';
import 'package:bermooda_business/view/modules/conversation/data/dto/conversation_dtos.dart';
import 'package:bermooda_business/view/modules/conversation/presentation/pages/create_group_chat/create_update_group_page.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../create_direct_chat/create_direct_page.dart';

class ConversationsListPage extends StatefulWidget {
  const ConversationsListPage({super.key});

  @override
  State<ConversationsListPage> createState() => _ConversationsListPageState();
}

class _ConversationsListPageState extends State<ConversationsListPage> {
  final ConversationsListController controller = Get.find();

  @override
  void initState() {
    if (Get.isRegistered<ConversationsListController>()) {
      controller.pageState.initial();
      delay(300, () {
        controller.getConversations();
      });
    }
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      floatingActionButtonLocation: isPersianLang
          ? FloatingActionButtonLocation.startFloat
          : FloatingActionButtonLocation.endFloat,
      floatingActionButton: WSpeedDial(
        heroTag: "newConversationFAB",
        tooltip: s.directMessage,
        activeIcon: Icons.close,
        icon: Icons.add,
        overlayColor: Colors.red,
        overlayOpacity: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        children: [
          SpeedDialChild(
            label: s.newGroup,
            backgroundColor: context.theme.primaryColor,
            onTap: () => UNavigator.push(const CreateUpdateGroupPage()),
            child: const UImage(
              AppIcons.groupOutline,
              color: Colors.white,
              size: 25,
            ),
          ),
          SpeedDialChild(
            label: s.directMessage,
            backgroundColor: context.theme.primaryColor,
            onTap: () => UNavigator.push(const CreateDirectPage()),
            child: const UImage(
              AppIcons.userOutline,
              color: Colors.white,
              size: 25,
            ),
          ),
        ],
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Obx(
            () {
              if (controller.pageState.isInitial() || controller.pageState.isLoading()) {
                return _buildShimmerLoading();
              }

              if (controller.pageState.isLoaded() && controller.conversations.isEmpty) {
                return const Center(child: WEmptyWidget());
              }

              return ListView.separated(
                itemCount: controller.conversations.length,
                padding: const EdgeInsets.only(top: 10, bottom: 100),
                separatorBuilder: (final context, final index) => Divider(
                  height: 10,
                  indent: 24,
                  endIndent: 16,
                  color: context.theme.dividerColor.withAlpha(100),
                ),
                itemBuilder: (final context, final index) => _conversationItemWidget(controller.conversations[index]),
              );
            },
          ),

          /// show websocket connection state
          Obx(
            () {
              if (controller.connectionState.value == ChatConnectionType.done) {
                return const SizedBox.shrink();
              }

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                decoration: BoxDecoration(
                  color: context.theme.hintColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(controller.connectionState.value.getTitle()).bodySmall(color: Colors.white),
              ).marginOnly(top: 10);
            },
          ),
        ],
      ),
    ).safeArea();
  }

  Widget _conversationItemShimmerWidget() => ListTile(
    minTileHeight: 70,
    isThreeLine: true,
    leading: const CircleAvatar(
      radius: 30,
      backgroundColor: Colors.grey,
    ),
    title: Container(
      width: 100,
      height: 10,
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
    ),
    subtitle: Container(
      width: 200,
      height: 10,
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
    ),
  );

  Widget _conversationItemWidget(final ConversationDto conversation) {
    final isGroup = conversation.type == ConversationType.group;
    final isBot = conversation.type == ConversationType.bot;
    final displayName = conversation.displayName;
    final avatarUrl = isBot ? AppImages.bot : conversation.avatarUrl ?? (isGroup ? null : conversation.members.firstOrNull?.user.avatarUrl);

    return ListTile(
      minTileHeight: 70,
      leading: UBadge(
        badgeColor: AppColors.green,
        showBadge: !isGroup && !isBot && (conversation.members.firstOrNull?.user.isOnline ?? false),
        smallSize: 12,
        animationType: BadgeAnimationType.fade,
        position: const BadgePosition(bottom: 0, start: 0),
        child: WCircleAvatar(
          user: UserReadDto(
            id: conversation.id,
            avatarUrl: avatarUrl,
            fullName: displayName,
          ),
        ),
      ),
      title: Text(displayName, maxLines: 1).bodyMedium(overflow: TextOverflow.ellipsis),
      subtitle: conversation.lastMessage != null && conversation.type != ConversationType.bot
          ? Text(
              conversation.lastMessage!.messageText ?? '',
              maxLines: 1,
            ).bodyMedium(
              overflow: TextOverflow.ellipsis,
              color: Colors.grey,
            )
          : null,
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (conversation.unreadCount > 0)
            UBadge(
              badgeColor: context.theme.primaryColor,
              alignment: Alignment.center,
              animationType: BadgeAnimationType.fade,
              showBadge: conversation.unreadCount > 0,
              position: const BadgePosition(bottom: 0),
              badgeContent: Text(conversation.unreadCount.toString()).bodySmall(color: Colors.white),
            ),
          Text(conversation.lastMessageAt.toTimeAgo(persian: isPersianLang)).bodySmall(color: Colors.grey).marginOnly(top: 4),
        ],
      ),
      onTap: () => UNavigator.push(
        ConversationMessagesPage(conversation: conversation),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.separated(
      itemCount: 10,
      padding: const EdgeInsets.symmetric(vertical: 16),
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (final context, final index) => Divider(
        height: 10,
        indent: 24,
        endIndent: 16,
        color: context.theme.dividerColor.withAlpha(100),
      ),
      itemBuilder: (final context, final index) => _conversationItemShimmerWidget(),
    ).shimmer();
  }
}
