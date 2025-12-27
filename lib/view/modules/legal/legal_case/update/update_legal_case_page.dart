import 'package:u/utilities.dart';

import '../../../../../core/widgets/fields/fields.dart';
import '../../../../../core/core.dart';
import '../details/legal_case_details_controller.dart';

class UpdateLegalCasePage extends StatefulWidget {
  const UpdateLegalCasePage({super.key, required this.controller});

  final LegalCaseDetailsController controller;

  @override
  State<UpdateLegalCasePage> createState() => _UpdateLegalCasePageState();
}

class _UpdateLegalCasePageState extends State<UpdateLegalCasePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  final RxBool _isSaving = false.obs;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.controller.legalCase.value.title);
    _descriptionController = TextEditingController(text: widget.controller.legalCase.value.description);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _isSaving.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 18,
        children: [
          WTextField(
            controller: _titleController,
            labelText: s.title,
            required: true,
            showRequired: false,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          WTextField(
            controller: _descriptionController,
            labelText: s.description,
            minLines: 4,
            maxLines: 8,
            maxLength: 2000,
            showCounter: true,
            multiLine: true,
          ),
          const SizedBox(height: 50),
          Obx(
            () => UElevatedButton(
              width: double.infinity,
              title: s.save,
              isLoading: _isSaving.value,
              onTap: () {
                validateForm(
                  key: _formKey,
                  action: () {
                    _isSaving(true);
                    widget.controller.editLegalCase(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      onSuccess: () {
                        _isSaving(false);
                        UNavigator.back();
                      },
                      onFailure: () => _isSaving(false),
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
