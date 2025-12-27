import 'package:u/utilities.dart';

import '../utils/enums/enums.dart';
import '../../data/data.dart';
import '../widgets/widgets.dart';
import '../core.dart';

Future<List<UserReadDto>> showMemberPickerMultiSelectDialog({
  required final List<UserReadDto> members,
  required final List<UserReadDto> initialMembers,
  final bool showAccessType = false,
}) async {
  final TextEditingController searchController = TextEditingController();
  List<UserReadDto> membersList = [...members];
  List<UserReadDto> selectedUsers = [...initialMembers];

  final result = await showAppDialog<List<UserReadDto>>(
    barrierDismissible: false,
    useSafeArea: true,
    onDismiss: () {
      searchController.dispose();
      FocusManager.instance.primaryFocus!.unfocus();
    },
    AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
      content: StatefulBuilder(
        builder: (final context, final setState) => Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            WSearchField(
              controller: searchController,
              fillColor: context.theme.scaffoldBackgroundColor,
              onChanged: (final value) {
                setState(() {
                  if (searchController.text.isNotEmpty) {
                    membersList = members.where((final user) => user.fullName?.toLowerCase().contains(searchController.text.toLowerCase()) ?? false).toList();
                  } else {
                    membersList = members;
                  }
                });
              },
            ).paddingSymmetric(horizontal: 16),
            Flexible(
              child: Container(
                constraints: BoxConstraints(maxHeight: context.height / 2.2),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...List<Widget>.generate(
                          membersList.length,
                          (final index) {
                            final membersListIds = membersList.map((final e) => e.id).toList();
                            final selectedUsersIds = selectedUsers.map((final e) => e.id).toList();
                            final bool checkBoxStatus = selectedUsersIds.contains(membersListIds[index]);

                            String? permissionAccessTitle;

                            if (showAccessType) {
                              permissionAccessTitle = membersList[index].type.isOwner()
                                  ? membersList[index].type?.getTitle()
                                  : membersList[index].accessType?.getTitle();
                            }

                            return Container(
                              height: 50,
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  const SizedBox(width: 16),
                                  WCheckBox(
                                    isChecked: checkBoxStatus,
                                    size: 20,
                                    borderColor: Colors.grey,
                                    onChanged: (final value) {
                                      setState(() {
                                        if (value) {
                                          selectedUsers.add(membersList[index]);
                                        } else {
                                          // Remove This User
                                          selectedUsers = selectedUsers.where((final user) => user.id != membersList[index].id).toList();
                                        }
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  WCircleAvatar(
                                    user: membersList[index],
                                    size: 30,
                                    showFullName: true,
                                    subTitle: permissionAccessTitle != null
                                        ? Text(permissionAccessTitle, maxLines: 1).bodySmall(color: context.theme.hintColor, overflow: TextOverflow.ellipsis)
                                        : null,
                                    onTapImage: () {
                                      setState(() {
                                        if (!checkBoxStatus) {
                                          selectedUsers.add(membersList[index]);
                                        } else {
                                          // Remove This User
                                          selectedUsers = selectedUsers.where((final user) => user.id != membersList[index].id).toList();
                                        }
                                      });
                                    },
                                  ).expanded(),
                                ],
                              ),
                            ).onTap(
                              () => setState(() {
                                if (!checkBoxStatus) {
                                  selectedUsers.add(membersList[index]);
                                } else {
                                  // Remove This User
                                  selectedUsers = selectedUsers.where((final user) => user.id != membersList[index].id).toList();
                                }
                              }),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                UElevatedButton(
                  title: s.cancel,
                  backgroundColor: navigatorKey.currentContext!.theme.hintColor,
                  onTap: () {
                    UNavigator.back();
                    FocusManager.instance.primaryFocus!.unfocus();
                  },
                ).expanded(),
                const SizedBox(width: 10),
                UElevatedButton(
                  title: s.confirm,
                  onTap: () {
                    Navigator.of(context).pop(selectedUsers);
                    FocusManager.instance.primaryFocus!.unfocus();
                  },
                ).expanded(),
              ],
            ).paddingSymmetric(horizontal: 16),
          ],
        ),
      ),
    ),
  );
  if (result != null) return result;
  return initialMembers;
}
