import 'package:u/utilities.dart';

import '../../../../../data/data.dart';
import '../../../../core.dart';
import '../../fields.dart';
import 'customer_industry_subcategory_create_update_controller.dart';

class CustomerIndustrySubCategoryCreateUpdatePage extends StatefulWidget {
  const CustomerIndustrySubCategoryCreateUpdatePage({
    required this.crmCategoryId,
    required this.industryId,
    required this.onResponse,
    this.model,
    super.key,
  });

  final String crmCategoryId;
  final int industryId;
  final DropdownItemReadDto? model;
  final Function(DropdownItemReadDto model) onResponse;

  @override
  State<CustomerIndustrySubCategoryCreateUpdatePage> createState() => _CustomerIndustrySubCategoryCreateUpdatePageState();
}

class _CustomerIndustrySubCategoryCreateUpdatePageState extends State<CustomerIndustrySubCategoryCreateUpdatePage> with CustomerIndustrySubCategoryCreateUpdateController {
  @override
  void initState() {
    crmCategoryId = widget.crmCategoryId;
    industryId = widget.industryId;
    model = widget.model;
    titleController.text = model?.title ?? '';
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    buttonState.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(model == null ? s.newCategory : s.editCategory).titleMedium(),
        const Divider().marginOnly(bottom: 10),
        Form(
          key: formKey,
          child: WTextField(
            controller: titleController,
            labelText: s.title,
            required: true,
            showRequired: false,
          ),
        ).marginOnly(bottom: 18),
        Row(
          spacing: 10,
          children: [
            UElevatedButton(
              title: s.cancel,
              backgroundColor: context.theme.hintColor,
              onTap: UNavigator.back,
            ).expanded(),
            Obx(
              () => UElevatedButton(
                title: model == null ? s.submit : s.save,
                isLoading: buttonState.isLoading(),
                onTap: () => onSubmit(
                  (final model) {
                    widget.onResponse(model);
                    if (mounted) {
                      UNavigator.back();
                    }
                  },
                ),
              ),
            ).expanded(),
          ],
        ),
      ],
    );
  }
}
