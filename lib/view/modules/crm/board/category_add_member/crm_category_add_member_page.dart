import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../data/data.dart';
import 'crm_category_add_member_controller.dart';

class CrmCategoryAddMemberPage extends StatefulWidget {
  const CrmCategoryAddMemberPage({
    required this.category,
    required this.onResponse,
    super.key,
  });

  final CrmCategoryReadDto category;
  final Function(CrmCategoryReadDto group) onResponse;

  @override
  State<CrmCategoryAddMemberPage> createState() => _CrmCategoryAddMemberPageState();
}

class _CrmCategoryAddMemberPageState extends State<CrmCategoryAddMemberPage> with CrmCategoryAddMemberController {
  @override
  void initState() {
    category = widget.category;
    getMembers();
    super.initState();
  }

  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => pageState.isLoaded()
          ? Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 18,
                  children: [
                    WMembersPickerFormField(
                      labelText: s.accessibleMembers,
                      helperText: s.crmAccessibleMembersHelper,
                      members: members,
                      showSelf: false,
                      required: true,
                      selectedMembers: selectedMembers,
                      onConfirm: (final list) {
                        selectedMembers = list;
                      },
                    ),
                    Obx(
                      () => UElevatedButton(
                        width: double.maxFinite,
                        title: s.submit,
                        isLoading: buttonState.isLoading(),
                        onTap: () => onSubmit(
                          onResponse: (final group) {
                            widget.onResponse(group);
                            UNavigator.back();
                          },
                        ),
                      ),
                    ).marginOnly(top: 100),
                  ],
                ),
              ),
            ).container().onTap(() => FocusManager.instance.primaryFocus?.unfocus(),)
          : const SizedBox(height: 300, child: Center(child: WCircularLoading())),
    );
  }
}
