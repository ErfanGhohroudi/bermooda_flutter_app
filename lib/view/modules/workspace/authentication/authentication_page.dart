import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/widgets/fields/fields.dart';
import '../../../../core/core.dart';
import '../../../../core/utils/enums/enums.dart';
import 'authentication_controller.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({
    required this.workspaceId,
    super.key,
  });

  final String workspaceId;

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> with AuthenticationController {
  @override
  void initState() {
    initialController(widget.workspaceId);
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
      () => Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 18,
          children: [
            Text("توجه: برای صدور فاکتور نیاز به تکمیل اطلاعات زیر است.").bodyMedium(color: context.theme.hintColor),

            /// AuthenticationType
            WRadioGroup<AuthenticationType>(
              items: AuthenticationType.values,
              initialValue: authenticationType.value,
              labelBuilder: (final item) => item.title,
              onChanged: (final value) {
                if (authenticationType.value != value) {
                  authenticationType(value);
                  nationalIDController.clear();
                }
                FocusManager.instance.primaryFocus!.unfocus();
              },
            ),
            ..._verificationForm(),
            Obx(
              () => UElevatedButton(
                width: double.infinity,
                title: s.submit,
                isLoading: buttonState.isLoading(),
                onTap: onSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _verificationForm() => [
        /// Company Name or Full Name
        WTextField(
          controller: nameController,
          labelText: authenticationType.isPerson() ? s.fullName : s.companyName,
          required: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          minLength: 3,
        ),

        /// National ID
        UTextFormField(
          controller: nationalIDController,
          labelText: authenticationType.isPerson() ? s.nationalID : s.companyNationalID,
          required: true,
          keyboardType: TextInputType.number,
          maxLength: authenticationType.isPerson() ? 10 : 11,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          formatters: [FilteringTextInputFormatter.digitsOnly],
          validator: validateMinLength(
            authenticationType.isPerson() ? 10 : 11,
            requiredMessage: s.requiredField,
            minLengthMessage: s.isShort.replaceAll('#', authenticationType.isPerson() ? '10' : '11'),
          ),
        ),
        if (authenticationType.isLegal()) ...[
          /// Registration Number
          UTextFormField(
            controller: registrationNumberController,
            labelText: s.registrationNumber,
            required: true,
            keyboardType: TextInputType.number,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            formatters: [FilteringTextInputFormatter.digitsOnly],
            validator: validateMinLength(
              6,
              requiredMessage: s.requiredField,
              minLengthMessage: s.isShort.replaceAll('#', '6'),
            ),
          ),

          /// Economic Code
          UTextFormField(
            controller: economicNumberController,
            labelText: s.economicCode,
            required: true,
            keyboardType: TextInputType.number,
            maxLength: 12,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            formatters: [FilteringTextInputFormatter.digitsOnly],
            validator: validateMinLength(
              12,
              requiredMessage: s.requiredField,
              minLengthMessage: s.isShort.replaceAll('#', '12'),
            ),
          ),

          /// Landline
          if (authenticationType.isLegal())
            WPhoneNumberField(
              controller: landlineController,
              labelText: s.landline,
              required: true,
              // hintText: "e.g: 02112345678",
              // keyboardType: TextInputType.number,
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              // formatters: [FilteringTextInputFormatter.digitsOnly],
              // validator: validateMinLength(
              //   11,
              //   requiredMessage: s.requiredField,
              //   minLengthMessage: s.isShort.replaceAll('#', '11'),
              // ),
            ),
        ],

        /// Phone Number
        if (authenticationType.isPerson())
          WPhoneNumberField(
            controller: phoneNumberController,
            required: true,
          ),

        /// Email
        WEmailField(
          controller: emailController,
          required: false,
        ),
      ];
}
