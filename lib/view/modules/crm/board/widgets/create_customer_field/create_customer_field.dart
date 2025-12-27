import 'package:flutter/cupertino.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../data/data.dart';

class CreateCustomerField extends StatefulWidget {
  const CreateCustomerField({
    required this.categoryId,
    required this.section,
    required this.onResponse,
    required this.onUnFocus,
    super.key,
  });

  final String categoryId;
  final CrmSectionReadDto? section;
  final Function(CustomerReadDto model) onResponse;
  final VoidCallback onUnFocus;

  @override
  State<CreateCustomerField> createState() => _CreateCustomerFieldState();
}

class _CreateCustomerFieldState extends State<CreateCustomerField> {
  final CustomerDatasource _datasource = Get.find<CustomerDatasource>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (controller.text.isNotEmpty) {
      _createCustomer();
      return;
    }
    widget.onUnFocus();
  }

  void _createCustomer() {
    validateForm(
      key: formKey,
      action: () {
        _datasource.create(
          dto: CustomerParams(
            fullNameOrCompanyName: controller.text.trim(),
            crmCategoryId: widget.categoryId,
            sectionId: widget.section?.id,
          ),
          onResponse: (final response) {
            widget.onResponse(response.result!);
          },
          onError: (final errorResponse) {},
          withRetry: true,
          withLoading: true,
        );
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Form(
      key: formKey,
      child: UTextFormField(
        controller: controller,
        autofocus: true,
        onEditingComplete: _onSubmit,
        hintText: s.title,
        focusNode: focusNode,
        formatters: [NoLeadingSpaceInputFormatter()],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validateMinLength(3, required: false, minLengthMessage: s.isShort.replaceAll('#', '3')),
        onTapOutside: (final event) => _onSubmit(),
        suffixIcon: Icon(CupertinoIcons.add_circled, size: 30, color: context.theme.primaryColor).onTap(_onSubmit),
      ),
    );
  }
}
