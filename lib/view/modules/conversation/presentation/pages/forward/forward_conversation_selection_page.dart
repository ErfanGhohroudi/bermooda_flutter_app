import 'package:u/utilities.dart';

import 'package:bermooda_business/core/widgets/widgets.dart';
import 'package:bermooda_business/data/data.dart';
import 'package:bermooda_business/view/modules/conversation/data/dto/conversation_dtos.dart';
import 'package:bermooda_business/view/modules/conversation/presentation/pages/forward/forward_conversation_selection_controller.dart';

import '../../../../../../core/core.dart';
import '../messages/conversation_messages_controller.dart';

class ForwardConversationSelectionPage extends StatefulWidget {
  const ForwardConversationSelectionPage({
    required this.messageIds,
    super.key,
  });

  final List<String> messageIds;

  @override
  State<ForwardConversationSelectionPage> createState() => _ForwardConversationSelectionPageState();
}

class _ForwardConversationSelectionPageState extends State<ForwardConversationSelectionPage> {
  late final ForwardConversationSelectionController controller;

  @override
  void initState() {
    super.initState();
    // Get current conversation ID from the messages controller if available
    String currentConversationId = '';
    if (Get.isRegistered<ConversationMessagesController>()) {
      try {
        final messagesController = Get.find<ConversationMessagesController>();
        currentConversationId = messagesController.conversation.value.id;
      } catch (e) {
        // Controller not found, use empty string
      }
    }

    controller = Get.put(
      ForwardConversationSelectionController(
        messageIds: widget.messageIds,
        currentConversationId: currentConversationId,
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: _buildAppBar(),
      bottomNavigationBar: Obx(
        () => AnimatedSize(
          duration: 200.milliseconds,
          curve: Curves.easeInOut,
          child: SizedBox(
            width: double.infinity,
            child: controller.selectedConversationIds.isNotEmpty
                ? UElevatedButton(
                    title: s.forward,
                    onTap: controller.forwardMessages,
                  ).pOnly(left: 16, right: 16, bottom: 24)
                : null,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          WSearchField(
            controller: controller.searchCtrl,
            height: 50,
            borderRadius: 0,
            onChanged: (final value) => controller.filterConversations(),
          ),

          // Conversations list
          Expanded(
            child: Obx(
              () {
                if (controller.filteredConversations.isEmpty) {
                  return Center(
                    child: WEmptyWidget(title: controller.searchCtrl.text.trim().isNotEmpty ? s.noResult : null),
                  );
                }

                return ListView.separated(
                  itemCount: controller.filteredConversations.length,
                  padding: const EdgeInsets.only(top: 10, bottom: 100),
                  separatorBuilder: (final context, final index) => Divider(
                    height: 10,
                    indent: 24,
                    endIndent: 16,
                    color: context.theme.dividerColor.withAlpha(100),
                  ),
                  itemBuilder: (final context, final index) => _conversationItemWidget(
                    controller.filteredConversations[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _conversationItemWidget(final ConversationDto conversation) {
    final isGroup = conversation.type == ConversationType.group;
    final displayName = conversation.displayName;
    final avatarUrl = conversation.avatarUrl ?? (isGroup ? null : conversation.members.firstOrNull?.user.avatarUrl);

    return Obx(
      () {
        final isSelected = controller.selectedConversationIds.contains(conversation.id);

        return ListTile(
          minTileHeight: 70,
          leading: WCircleAvatar(
            user: UserReadDto(
              id: conversation.id,
              avatarUrl: avatarUrl,
              fullName: displayName,
            ),
          ),
          title: Text(displayName, maxLines: 1).bodyMedium(overflow: TextOverflow.ellipsis),
          subtitle: isGroup
              ? Text(
                  "${conversation.members.length} ${isPersianLang == false && conversation.members.length <= 1 ? s.member.removeLast() : s.member}",
                ).bodySmall(color: Colors.grey)
              : null,
          trailing: SizedBox(
            width: 30,
            child: WCheckBox(
              isChecked: isSelected,
              activeColor: context.theme.primaryColor,
              borderColor: context.theme.primaryColor,
              onChanged: (final value) {
                controller.toggleConversationSelection(conversation.id);
              },
            ),
          ),
          onTap: () {
            controller.toggleConversationSelection(conversation.id);
          },
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Obx(
        () {
          return AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => UNavigator.back(),
            ),
            title: controller.selectedConversationIds.isEmpty
                ? Text(s.selectConversation)
                : Row(
                    children: [
                      Flexible(
                        child: Text(
                          '${controller.selectedConversationIds.length.toString().separateNumbers3By3()} ${s.conversationsSelected}',
                        ).bodyMedium(color: Colors.white),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: controller.selectedConversationIds.clear,
                        child: Text(s.clear).bodySmall(color: Colors.white),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
