import 'package:u/utilities.dart';

import '../../../../core/utils/enums/request_enums.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../data/data.dart';
import '../create/create_request_page.dart';
import '../widgets/request_card.dart';
import '../details/request_detail_page.dart';

/// Example usage of WNewRequestCard widget
class WNewRequestCardExample extends StatelessWidget {
  const WNewRequestCardExample({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مثال کارت درخواست جدید'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          UNavigator.push(CreateRequestPage(
            onResponse: (request) {},
          ));
        },
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'کارت‌های درخواست با مدل‌های response جدید',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Employment Request Example
            _buildSectionTitle(context, 'درخواست استخدام'),
            const SizedBox(height: 12),
            WRequestCard(
              request: _createEmploymentRequest(),
              onTap: () =>
                  _navigateToDetail(context, _createEmploymentRequest()),
              onSelectedNewStatus: (StatusType value) {},
            ),

            const SizedBox(height: 24),

            // Leave Request Example
            _buildSectionTitle(context, 'درخواست مرخصی'),
            const SizedBox(height: 12),
            WRequestCard(
              request: _createLeaveRequest(),
              onTap: () => _navigateToDetail(context, _createLeaveRequest()),
              onSelectedNewStatus: (final value) {},
            ),

            const SizedBox(height: 24),

            // Mission Request Example
            _buildSectionTitle(context, 'درخواست مأموریت'),
            const SizedBox(height: 12),
            WRequestCard(
              request: _createMissionRequest(),
              onTap: () => _navigateToDetail(context, _createMissionRequest()),
              onSelectedNewStatus: (final value) {},
            ),

            const SizedBox(height: 24),

            // Welfare Request Example
            _buildSectionTitle(context, 'درخواست رفاهی'),
            const SizedBox(height: 12),
            WRequestCard(
              request: _createWelfareRequest(),
              onTap: () => _navigateToDetail(context, _createWelfareRequest()),
              onSelectedNewStatus: (final value) {},
            ),

            const SizedBox(height: 24),

            // Support Request Example
            _buildSectionTitle(context, 'درخواست پشتیبانی'),
            const SizedBox(height: 12),
            WRequestCard(
              request: _createSupportRequest(),
              onTap: () => _navigateToDetail(context, _createSupportRequest()),
              onSelectedNewStatus: (final value) {},
            ),

            const SizedBox(height: 24),

            // General Request Example
            _buildSectionTitle(context, 'درخواست عمومی'),
            const SizedBox(height: 12),
            WRequestCard(
              request: _createGeneralRequest(),
              onTap: () => _navigateToDetail(context, _createGeneralRequest()),
              onSelectedNewStatus: (final value) {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(final BuildContext context, final String title) {
    return Text(
      title,
      style: context.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: context.theme.primaryColor,
      ),
    );
  }

  void _navigateToDetail(
      final BuildContext context, final IRequestReadDto request) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (final context) => RequestDetailPage(
          request: request,
          onTapRequestCheckBox: (final value) {},
        ),
      ),
    );
  }

  // Example request creators
  EmploymentRequestEntity _createEmploymentRequest() {
    return EmploymentRequestEntity(
      slug: "1",
      requestingUser: UserReadDto(id: '', fullName: "محسنیییییییییی"),
      categoryType: RequestCategoryType.employment,
      description: 'درخواست استخدام برای پست برنامه‌نویس Flutter',
      status: StatusType.pending,
      cooperationType: EmploymentCooperationType.outsourcing,
      jobTitle: 'برنامه‌نویس Flutter',
      organizationalUnit: 'تیم توسعه',
      workLocation: EmploymentWorkLocation.office,
      requiredPersonnelCount: 2,
      jobSummary: 'توسعه اپلیکیشن موبایل با Flutter',
      mainResponsibilities: [
        'توسعه UI/UX',
        'پیاده‌سازی API',
        'تست نرم‌افزار',
        'نگهداری کد'
      ],
      reportsTo: 'مدیر فنی',
      requiredEducation: EducationType.bachelor,
      preferredFieldOfStudy: 'مهندسی کامپیوتر',
      minimumExperience: 2,
      technicalSkills: ['Flutter', 'Dart', 'Firebase', 'Git'],
      softSkills: ['کار تیمی', 'حل مسئله', 'برقراری ارتباط'],
      requiredLanguages: ['انگلیسی', 'فارسی'],
    );
  }

  LeaveAttendanceRequestEntity _createLeaveRequest() {
    return LeaveAttendanceRequestEntity(
      slug: "2",
      requestingUser: UserReadDto(id: ''),
      categoryType: RequestCategoryType.leave_attendance,
      description: 'درخواست مرخصی استحقاقی',
      status: StatusType.approved,
      leaveType: LeaveType.entitlement_leave,
      startDate: '2024-01-20',
      endDate: '2024-01-25',
      replacementEmployee: 'علی احمدی',
    );
  }

  MissionWorkRequestEntity _createMissionRequest() {
    return MissionWorkRequestEntity(
      slug: "3",
      requestingUser: UserReadDto(id: ''),
      categoryType: RequestCategoryType.missions_work,
      description: 'مأموریت برون‌شهری برای شرکت در کنفرانس',
      status: StatusType.pending,
      missionType: MissionType.out_of_city_mission,
      destination: 'تهران',
      exactLocation: 'برج میلاد',
      startDate: '2024-01-18',
      startTime: '09:00',
      endDate: '2024-01-18',
      endTime: '17:00',
      companionNames: 'محمد رضایی',
    );
  }

  WelfareFinancialRequestEntity _createWelfareRequest() {
    return WelfareFinancialRequestEntity(
      slug: "4",
      requestingUser: UserReadDto(id: ''),
      categoryType: RequestCategoryType.welfare_financial,
      description: 'درخواست وام مسکن',
      status: StatusType.pending,
      welfareType: WelfareType.loan_advance,
      requestTypeFinancial: LoanType.loan,
      amount: '50000000',
      date: '2024-02-01',
      bankAccountNumber: '1234567890123456',
      repaymentMethod: RepaymentType.installment,
    );
  }

  SupportProcurementRequestEntity _createSupportRequest() {
    return SupportProcurementRequestEntity(
      slug: "5",
      requestingUser: UserReadDto(id: ''),
      categoryType: RequestCategoryType.support_logistics,
      description: 'درخواست خرید لپ‌تاپ جدید',
      status: StatusType.pending,
      supportType: SupportType.equipment_purchase,
      equipmentType: EquipmentType.laptop,
      quantity: 1,
      suggestedModel: 'MacBook Pro M3',
      urgencyLevel: UrgencyLevel.normal,
    );
  }

  GeneralRequestEntity _createGeneralRequest() {
    return GeneralRequestEntity(
      slug: "6",
      requestingUser: UserReadDto(id: ''),
      categoryType: RequestCategoryType.general_requests,
      description: 'درخواست گواهی اشتغال',
      status: StatusType.approved,
      generalType: GeneralType.employment_certificate,
      certificatePurpose: 'ارائه به بانک',
      certificateLanguage: CertificateLanguage.persian,
      date: '2024-01-20',
      includeSalary: true,
      includePosition: true,
    );
  }
}
