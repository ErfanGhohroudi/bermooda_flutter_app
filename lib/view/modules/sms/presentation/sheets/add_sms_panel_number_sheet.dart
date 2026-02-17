import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/widgets/fields/fields.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../domain/enums/enums.dart';
import '../controllers/numbers_list_controller.dart';

class AddSmsPanelNumberSheet extends StatefulWidget {
  const AddSmsPanelNumberSheet({
    required this.ctrl,
    super.key,
  });

  final SmsNumbersListController ctrl;

  @override
  State<AddSmsPanelNumberSheet> createState() => _AddSmsPanelNumberSheetState();
}

class _AddSmsPanelNumberSheetState extends State<AddSmsPanelNumberSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _numberCtrl = TextEditingController();
  final TextEditingController _apiKeyCtrl = TextEditingController();
  ProviderType _providerType = ProviderType.values.first;

  final RxBool _isLoading = false.obs;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _numberCtrl.dispose();
    _apiKeyCtrl.dispose();
    _isLoading.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 18,
        children: [
          WTextField(
            controller: _titleCtrl,
            labelText: s.title,
            required: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          WPhoneNumberField(
            controller: _numberCtrl,
            labelText: s.number,
            hintText: '3000123456',
            required: true,
          ),
          WDropDownFormField<ProviderType>(
            labelText: s.provider,
            value: _providerType,
            items: ProviderType.values
                .map(
                  (final provider) => DropdownMenuItem<ProviderType>(
                    value: provider,
                    child: WDropdownItemText(text: provider.name),
                  ),
                )
                .toList(),
            onChanged: (final value) {
              _providerType = value!;
            },
          ),
          WPasswordField(
            controller: _apiKeyCtrl,
            labelText: s.apiKey,
            required: true,
            minLength: 10,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          Row(
            spacing: 10,
            children: [
              UElevatedButton(
                title: s.cancel,
                backgroundColor: context.theme.hintColor,
                onTap: AppNavigator.back,
              ).expanded(),
              Obx(
                () => UElevatedButton(
                  title: s.addText,
                  isLoading: _isLoading.value,
                  onTap: () async {
                    if (!formKey.currentState!.validate()) return;
                    _isLoading(true);
                    final result = await widget.ctrl.createNumber(
                      providerName: _titleCtrl.text.trim(),
                      number: _numberCtrl.text.trim(),
                      providerType: _providerType,
                      apiKey: _apiKeyCtrl.text.trim(),
                    );
                    _isLoading(false);
                    if (result != null) AppNavigator.back();
                  },
                ),
              ).expanded(),
            ],
          ).marginOnly(top: 100),
        ],
      ),
    );
  }
}
