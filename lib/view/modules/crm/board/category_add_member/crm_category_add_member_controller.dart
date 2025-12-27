import 'package:u/utilities.dart';

import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/data.dart';

mixin CrmCategoryAddMemberController {
  late CrmCategoryReadDto category;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final CrmDatasource _crmDatasource = Get.find<CrmDatasource>();
  final MemberDatasource _memberDatasource = Get.find<MemberDatasource>();
  final Rx<PageState> pageState = PageState.initial.obs;
  final Rx<PageState> buttonState = PageState.loaded.obs;
  List<UserReadDto> members = [];

  List<UserReadDto> selectedMembers = [];

  void disposeItems() {
    pageState.close();
    buttonState.close();
  }

  void onSubmit({required final Function(CrmCategoryReadDto group) onResponse}) {
    validateForm(
      key: formKey,
      action: () {
        buttonState.loading();
        update(onResponse);
      },
    );
  }

  void update(final Function(CrmCategoryReadDto group) onResponse) {
    final List<UserReadDto> list = [...category.members ?? [], ...selectedMembers];

    _crmDatasource.update(
      id: category.id,
      avatarId: category.avatar?.fileId,
      title: category.title ?? '',
      users: list,
      onResponse: (final response) {
        if (response.result != null) {
          onResponse(response.result!);
        }
        buttonState.loaded();
      },
      onError: (final errorResponse) {
        buttonState.loaded();
      },
      withRetry: true,
    );
  }

  void getMembers() {
    _memberDatasource.getAllMembers(
      perName: PermissionName.crm,
      onResponse: (final response) {
        if (response.resultList != null) {
          if (category.members.isNullOrEmpty()) {
            members = response.resultList!;
          } else {
            members = response.resultList!.where((final e) => !category.members!.any((final m) => m.id == e.id)).toList();
          }
        }

        pageState.loaded();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }
}
