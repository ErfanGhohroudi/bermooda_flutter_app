import 'package:u/utilities.dart';

import '../../../../../core/widgets/fields/fields.dart';
import '../../../../../core/core.dart';
import '../../../../../data/data.dart';
import '../details/legal_case_details_controller.dart';

class CreateUpdateStepPage extends StatefulWidget {
  const CreateUpdateStepPage({
    super.key,
    required this.controller,
    this.step,
  });

  final LegalCaseDetailsController controller;
  final LegalCaseStep? step;

  @override
  State<CreateUpdateStepPage> createState() => _CreateUpdateStepPageState();
}

class _CreateUpdateStepPageState extends State<CreateUpdateStepPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  final RxBool _isSaving = false.obs;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.step?.title ?? '');
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
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
            minLength: 2,
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    if (widget.step == null) {
                      widget.controller.createStep(
                        title: _titleController.text,
                        onSuccess: () {
                          _isSaving(false);
                          UNavigator.back();
                        },
                        onFailure: () => _isSaving(false),
                      );
                    } else {
                      widget.controller.updateStep(
                        step: widget.step!,
                        title: _titleController.text,
                        onSuccess: () {
                          _isSaving(false);
                          UNavigator.back();
                        },
                        onFailure: () => _isSaving(false),
                      );
                    }
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

