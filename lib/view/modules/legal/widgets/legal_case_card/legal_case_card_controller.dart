import 'package:bermooda_business/core/navigator/navigator.dart';
import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../data/data.dart';
import '../../legal_case/legal_case_page.dart';

mixin LegalCaseCardController {
  final LegalCaseDatasource _datasource = Get.find();
  final Rx<LegalCaseReadDto> legalCase = const LegalCaseReadDto(id: 0).obs;
  final RxList<dynamic> tasks = <dynamic>[].obs;

  void onStepChanged(final LegalCaseReadDto model) {
    legalCase(model);
  }

  void initializeController({required final LegalCaseReadDto legalCase}) {
    this.legalCase(legalCase);
    tasks.assignAll(this.legalCase.value.taskItems);
  }

  void navigateToLegalCasePage() {
    delay(200, () {
      AppNavigator.push(
        LegalCasePage(
          legalCase: legalCase.value,
          canEdit: true,
        ),
      );
    });
  }

  void onTapCheckBox() {
    appShowYesCancelDialog(
      description: s.changeLegalCaseStatusDialogDescription,
      onYesButtonTap: () {
        AppNavigator.back();
        _datasource.changeLegalCaseStatusToCompleted(
          legalCaseId: legalCase.value.id,
          onResponse: () => AppSnackBar.snackbarGreen(title: s.done, subtitle: ''),
          onError: (final errorResponse) {},
        );
      },
    );
  }

  void onDeleteLegalCase() {
    appShowYesCancelDialog(
      title: s.delete,
      description: s.areYouSureYouWantToDeleteItem(s.legalCase.toLowerCase()),
      yesButtonTitle: s.delete,
      yesBackgroundColor: AppColors.red,
      onYesButtonTap: () {
        AppNavigator.back(); // close dialog
        _datasource.delete(
          caseId: legalCase.value.id,
          onResponse: () => AppSnackBar.snackbarGreen(title: s.done, subtitle: ''),
          onError: (final errorResponse) {},
        );
      },
    );
  }
}
