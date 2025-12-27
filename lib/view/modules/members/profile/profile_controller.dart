import 'package:bermooda_business/core/services/subscription_service.dart';
import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/navigator/navigator.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../data/data.dart';
import '../invite/invite_member_page.dart';
import '../list/members_list_controller.dart';
import '../transfer_member/transfer_member_page.dart';

class ProfileController extends GetxController {
  ProfileController({
    required this.memberId,
    this.canEdit = true,
    final int initialTabIndex = 0,
  }) : currentTabIndex = initialTabIndex.obs;

  late final int? memberId;
  HRDepartmentReadDto? department;
  final core = Get.find<Core>();
  final subService = Get.find<SubscriptionService>();
  final MemberDatasource _memberDatasource = Get.find<MemberDatasource>();
  final bool haveAdminAccess = Get.find<PermissionService>().haveHRAdminAccess;
  final Rx<PageState> pageState = PageState.initial.obs;
  final Rx<MemberReadDto> currentMember = const MemberReadDto().obs;
  late final bool canEdit;
  late final RxInt currentTabIndex;

  bool get hrModuleIsActive => subService.hrModuleIsActive;

  // Salary & Benefits
  final RxList<dynamic> salaryHistory = <dynamic>[].obs;
  final RxList<dynamic> benefits = <dynamic>[].obs;

  // Performance
  final RxList<dynamic> performanceEvaluations = <dynamic>[].obs;

  // Documents
  final RxList<dynamic> documents = <dynamic>[].obs;

  // Assets
  final RxList<dynamic> assignedAssets = <dynamic>[].obs;

  // Employment
  final Rx<dynamic> employmentInfo = Rxn<dynamic>();

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  @override
  void onClose() {
    debugPrint("ProfileController closed!!!");
    super.onClose();
  }

  void loadInitialData() {
    pageState.loading();
    _getMember();
    // Load data for current tab
    loadTabData(currentTabIndex.value);
  }

  void _getMember() {
    if (memberId == null) return;
    _memberDatasource.getAMember(
      memberId: memberId!,
      onResponse: (final response) {
        final member = response.result;
        if (member == null) return;
        department = member.department;
        currentMember(member);
        pageState.loaded();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void loadTabData(final int tabIndex) {
    switch (tabIndex) {
      case 0: // Personal Info
        break;
      case 1: // Requests
        break;
      case 2: // Attendance
        break;
      case 3: // Salary & Benefits
        _loadSalaryBenefits();
        break;
      case 4: // Performance
        _loadPerformance();
        break;
      case 5: // Documents
        _loadDocuments();
        break;
      case 6: // Assets
        _loadAssets();
        break;
      case 7: // Employment
        _loadEmployment();
        break;
    }
  }

  void switchTab(final int index) {
    if (currentTabIndex.value == index) return;
    currentTabIndex.value = index;
    loadTabData(index);
  }

  void removeMember() {
    appShowYesCancelDialog(
      title: s.removeMember,
      description: s.areYouSureToRemoveMember,
      onYesButtonTap: () {
        UNavigator.back();
        _archiveMember();
      },
    );
  }

  void _archiveMember() {
    if (currentMember.value.id == null) return;
    _memberDatasource.delete(
      id: currentMember.value.id!,
      onResponse: () {
        if (Get.isRegistered<MembersListController>()) {
          Get.find<MembersListController>().deleteMember(currentMember.value);
        }
        UNavigator.back();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void editPersonalInfo() {
    // Navigate to edit personal info page
    UNavigator.push(
      InviteMemberPage(
        member: currentMember.value,
        department: department,
        onResponse: (final member) {
          if (Get.isRegistered<MembersListController>()) {
            Get.find<MembersListController>().updateMember(member);
          }
          currentMember(member);
        },
      ),
    );
  }

  void transferMember() {
    if (department?.slug == null) return;
    // Show transfer member bottom sheet
    bottomSheet(
      title: s.transfer2AnotherDepartment,
      child: TransferMemberPage(
        member: currentMember.value,
        department: department!,
        onResponse: (final member) => currentMember(member),
      ),
    );
  }

  // Salary & Benefits Methods
  void _loadSalaryBenefits() {
    // Load salary and benefits data
    salaryHistory.clear();
    benefits.clear();
    // Add sample data for now
    salaryHistory.addAll([
      {
        'month': '2024-01',
        'baseSalary': 50000000,
        'bonus': 5000000,
        'total': 55000000,
      },
    ]);
    benefits.addAll([
      {
        'type': "s.healthInsurance",
        'amount': 2000000,
        'status': "s.active",
      },
      {
        'type': "s.lifeInsurance",
        'amount': 1000000,
        'status': "s.active",
      },
    ]);
  }

  void addSalaryRecord() {
    // Navigate to add salary record page
  }

  void addBenefit() {
    // Navigate to add benefit page
  }

  // Performance Methods
  void _loadPerformance() {
    // Load performance evaluations
    performanceEvaluations.clear();
    // Add sample data for now
    performanceEvaluations.addAll([
      {
        'period': 'Q4 2023',
        'rating': 4.5,
        'goals': "s.excellent",
        'reviewer': "s.manager",
      },
    ]);
  }

  void addPerformanceEvaluation() {
    // Navigate to add performance evaluation page
  }

  // Documents Methods
  void _loadDocuments() {
    // Load documents
    documents.clear();
    // Add sample data for now
    documents.addAll([
      {
        'name': "s.contract",
        'type': 'PDF',
        'size': '2.5 MB',
        'uploadDate': '2024-01-01',
      },
      {
        'name': "s.idCard",
        'type': 'Image',
        'size': '1.2 MB',
        'uploadDate': '2024-01-01',
      },
    ]);
  }

  void uploadDocument() {
    // Navigate to upload document page
  }

  void downloadDocument(final dynamic document) {
    // Download document
  }

  void deleteDocument(final dynamic document) {
    // Delete document
    documents.remove(document);
  }

  // Assets Methods
  void _loadAssets() {
    // Load assigned assets
    assignedAssets.clear();
    // Add sample data for now
    assignedAssets.addAll([
      {
        'name': "s.laptop",
        'serialNumber': 'LAP001',
        'assignDate': '2024-01-01',
        'status': "s.assigned",
      },
      {
        'name': "s.mobilePhone",
        'serialNumber': 'MOB001',
        'assignDate': '2024-01-01',
        'status': "s.assigned",
      },
    ]);
  }

  void assignAsset() {
    // Navigate to assign asset page
  }

  void returnAsset(final dynamic asset) {
    // Return asset
    assignedAssets.remove(asset);
  }

  // Employment Methods
  void _loadEmployment() {
    // Load employment information
    employmentInfo.value = {
      'position': "s.softwareDeveloper",
      'employmentType': "s.fullTime",
      'contractStart': '2024-01-01',
      'contractEnd': '2024-12-31',
      'probationPeriod': "s.threeMonths",
      'noticePeriod': "s.oneMonth",
    };
  }

  void showSuccess(final String message) {
    AppNavigator.snackbarGreen(title: s.done, subtitle: message);
  }
}
