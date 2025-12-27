import 'package:bermooda_business/core/navigator/navigator.dart';
import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
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
      UNavigator.push(
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
        UNavigator.back();
        _datasource.changeLegalCaseStatusToCompleted(
          legalCaseId: legalCase.value.id,
          onResponse: () => AppNavigator.snackbarGreen(title: s.done, subtitle: ''),
          onError: (final errorResponse) {},
        );
      },
    );
  }

  void onDeleteLegalCase() {
    appShowYesCancelDialog(
      title: s.delete,
      description: s.areYouSureYouWantToDeleteItem,
      onYesButtonTap: () {
        UNavigator.back(); // close dialog
        _datasource.delete(
          caseId: legalCase.value.id,
          onResponse: () => AppNavigator.snackbarGreen(title: s.done, subtitle: ''),
          onError: (final errorResponse) {},
        );
      },
    );
  }
}
