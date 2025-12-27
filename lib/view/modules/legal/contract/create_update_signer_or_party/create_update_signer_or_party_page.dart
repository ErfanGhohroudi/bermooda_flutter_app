import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/utils/validators/iranian_national_code_validator.dart';
import '../../../../../core/widgets/fields/fields.dart';
import '../../../../../data/data.dart';

class CreateUpdateSignerOrPartyPage extends StatefulWidget {
  const CreateUpdateSignerOrPartyPage({
    super.key,
    this.model,
  });

  final SignerDto? model;

  @override
  State<CreateUpdateSignerOrPartyPage> createState() => _CreateUpdateSignerOrPartyPageState();
}

class _CreateUpdateSignerOrPartyPageState extends State<CreateUpdateSignerOrPartyPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _familyCtrl;
  late final TextEditingController _mobileCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _nationalIdCtrl;

  String get name => _nameCtrl.text.trim();
  String get family => _familyCtrl.text.trim();
  String get mobile => _mobileCtrl.text.trim();
  String? get email => _emailCtrl.text.trim().isNotEmpty ? _emailCtrl.text.trim() : null;
  String? get nationalId => _nationalIdCtrl.text.trim().isNotEmpty ? _nationalIdCtrl.text.trim() : null;

  @override
  void initState() {
    _nameCtrl = TextEditingController(text: widget.model?.name);
    _familyCtrl = TextEditingController(text: widget.model?.family);
    _mobileCtrl = TextEditingController(text: widget.model?.mobile);
    _emailCtrl = TextEditingController(text: widget.model?.email);
    _nationalIdCtrl = TextEditingController(text: widget.model?.nationalId);
    super.initState();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _familyCtrl.dispose();
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    _nationalIdCtrl.dispose();
    super.dispose();
  }

  void _onSubmit(final BuildContext context) {
    validateForm(
      key: formKey,
      action: () {
        if (widget.model == null) {
          final dto = SignerDto(
            id: 0,
            name: name,
            family: family,
            fullName: "$name $family".trim(),
            mobile: mobile,
            email: email,
            nationalId: nationalId,
          );
          Navigator.pop(context, dto);
        } else {
          final dto = widget.model!.copyWith(
            name: name,
            family: family,
            fullName: "$name $family".trim(),
            mobile: mobile,
            email: email,
            nationalId: nationalId,
          );
          Navigator.pop(context, dto);
        }
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 18,
        children: [
          WTextField(
            controller: _nameCtrl,
            labelText: s.firstName,
            required: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          WTextField(
            controller: _familyCtrl,
            labelText: s.lastName,
            required: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          WPhoneNumberField(
            controller: _mobileCtrl,
            hintText: "0912xxxxxxx",
            startWith: "09",
            minLength: 11,
            maxLength: 11,
            required: true,
          ),
          WEmailField(
            controller: _emailCtrl,
          ),
          UTextFormField(
            controller: _nationalIdCtrl,
            labelText: s.nationalID,
            keyboardType: TextInputType.number,
            maxLength: 10,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            formatters: [FilteringTextInputFormatter.digitsOnly],
            validator: iranianNationalCodeValidator(),
          ),
          const SizedBox(height: 50),
          Row(
            spacing: 10,
            children: [
              UElevatedButton(
                title: s.cancel,
                backgroundColor: context.theme.hintColor,
                onTap: () => Navigator.pop(context, null),
              ).expanded(),
              UElevatedButton(
                title: widget.model == null ? s.addText : s.save,
                onTap: () => _onSubmit(context),
              ).expanded(),
            ],
          ),
        ],
      ),
    );
  }
}
