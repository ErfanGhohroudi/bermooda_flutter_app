import 'package:u/utilities.dart';

import '../../../../../../../core/widgets/widgets.dart';
import '../../../../../../../core/core.dart';
import '../../../../data/dto/conversation_dtos.dart';
import 'add_member_controller.dart';

class AddMemberToGroupPage extends StatefulWidget {
  const AddMemberToGroupPage({
    required this.conversation,
    super.key,
  });

  final ConversationDto conversation;

  @override
  State<AddMemberToGroupPage> createState() => _AddMemberToGroupPageState();
}

class _AddMemberToGroupPageState extends State<AddMemberToGroupPage> {
  late final AddMemberToGroupController controller;

  @override
  void initState() {
    controller = Get.put(AddMemberToGroupController(conversation: widget.conversation));
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(title: Text(s.addMember)),
      body: Column(
        children: [
          WSearchField(
            controller: controller.searchCtrl,
            borderRadius: 0,
            height: 50,
            onChanged: (final value) => controller.onSearch(),
          ),
          Expanded(
            child: Obx(
              () {
                if (controller.pageState.isInitial() || controller.pageState.isLoading()) {
                  return const Center(child: WCircularLoading());
                }

                if (controller.pageState.isError()) {
                  return Center(child: WErrorWidget(onTapButton: controller.onTryAgain));
                }

                if (controller.pageState.isLoaded() && controller.userList.isEmpty) {
                  return const Center(child: WEmptyWidget());
                }

                return ListView.separated(
                  itemCount: controller.userList.length,
                  padding: const EdgeInsets.only(top: 10, bottom: 100),
                  separatorBuilder: (final context, final index) => const Divider(height: 5),
                  itemBuilder: (final context, final index) {
                    final user = controller.userList[index];
                    return ListTile(
                      title: WCircleAvatar(user: user, size: 50, showFullName: true, maxLines: 2),
                      onTap: () => controller.onTapUser(user.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
