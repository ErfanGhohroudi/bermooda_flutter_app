import 'package:u/utilities.dart';

import '../../../../core/utils/enums/enums.dart';
import '../../../../data/data.dart';
import '../../subscription/subscription_controller.dart';

mixin AuthenticationController {
  late final String _workspaceId;
  final GlobalKey<FormState> formKey = GlobalKey();
  final WorkspaceDatasource _datasource = Get.find<WorkspaceDatasource>();
  final Rx<AuthenticationType> authenticationType = AuthenticationType.person.obs;
  final Rx<PageState> buttonState = PageState.loaded.obs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nationalIDController = TextEditingController();
  final TextEditingController registrationNumberController = TextEditingController();
  final TextEditingController economicNumberController = TextEditingController();
  final TextEditingController landlineController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void disposeItems() {
    authenticationType.close();
    buttonState.close();
    nameController.dispose();
    nationalIDController.dispose();
    registrationNumberController.dispose();
    economicNumberController.dispose();
    landlineController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
  }

  void initialController(final String workspaceId) {
    _workspaceId = workspaceId;
  }

  void onSubmit() {
    validateForm(
      key: formKey,
      action: _update,
    );
  }

  void _update() {
    IWorkspaceRequiredInfoParams getDto() {
      switch (authenticationType.value) {
        case AuthenticationType.person:
          return PersonWorkspaceRequiredInfoParams(
            authenticationType: authenticationType.value,
            fullName: nameController.text.trim(),
            nationalId: nationalIDController.text.trim(),
            phoneNumber: phoneNumberController.text.trim(),
            email: emailController.text.trim().isNotEmpty ? emailController.text.trim() : null,
          );
        case AuthenticationType.legal:
          return LegalWorkspaceRequiredInfoParams(
            authenticationType: authenticationType.value,
            organizationName: nameController.text.trim(),
            nationalId: nationalIDController.text.trim(),
            registrationNumber: registrationNumberController.text.trim(),
            economicCode: economicNumberController.text.trim(),
            landline: landlineController.text.trim(),
            email: emailController.text.trim().isNotEmpty ? emailController.text.trim() : null,
          );
      }
    }

    buttonState.loading();
    _datasource.updateRequiredInfo(
      id: _workspaceId,
      dto: getDto(),
      onResponse: () {
        if (buttonState.subject.isClosed) return;
        UNavigator.back();
        if (Get.isRegistered<SubscriptionController>()) {
          Get.find<SubscriptionController>().createPaymentRequest();
        }
      },
      onError: (final errorResponse) {
        buttonState.loaded();
      },
    );
  }
}
