import 'package:u/utilities.dart';

import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../core/utils/extensions/money_extensions.dart';
import '../../../../../../core/core.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/theme.dart';
import '../../../components/access_levels/access_levels_selection.dart';
import '../../profile_controller.dart';

class PersonalInfoTab extends StatelessWidget {
  const PersonalInfoTab({
    required this.controller,
    super.key,
  });

  final ProfileController controller;

  @override
  Widget build(final BuildContext context) {
    return Obx(() {
      final isWorkspaceMember = controller.currentMember.value.type.isMember();

      if (controller.pageState.isLoading()) {
        return const Center(child: WCircularLoading());
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 6,
          children: [
            // Header with actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(s.personalInfo).titleMedium(),
                if (controller.canEdit)
                  IconButton(
                    onPressed: controller.editPersonalInfo,
                    icon: const UImage(AppIcons.editOutline, color: AppColors.green),
                    tooltip: s.edit,
                  ),
              ],
            ),

            // Basic Information Card
            WCard(
              showBorder: true,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    Text(s.basicInfo).titleMedium(),
                    _buildInfoGrid([
                      _InfoItem(s.fullName, _getFullName()),
                      _InfoItem(s.firstName, controller.currentMember.value.firstName ?? "- -"),
                      _InfoItem(s.lastName, controller.currentMember.value.lastName ?? "- -"),
                      _InfoItem(s.nationalID, controller.currentMember.value.nationalCode ?? "- -"),
                      _InfoItem(s.birthCertificateNumber, controller.currentMember.value.certificateNumber ?? "- -"),
                      _InfoItem(s.dateOfBirth, controller.currentMember.value.dateOfBirthPersian ?? "- -"),
                      _InfoItem(s.gender, controller.currentMember.value.gender?.getTitle() ?? "- -"),
                      _InfoItem(s.militaryStatus, controller.currentMember.value.militaryStatus?.getTitle() ?? "- -"),
                      _InfoItem(s.maritalStatus, controller.currentMember.value.marriage ? s.married : s.single),
                      _InfoItem(s.numberOfChildren, controller.currentMember.value.numberOfChildren?.toString() ?? "0"),
                    ]),
                  ],
                ),
              ),
            ),

            // Contact Information Card
            WCard(
              showBorder: true,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    Text(s.contactInfo).titleMedium(),
                    _buildInfoGrid([
                      _InfoItem(s.phoneNumber, controller.currentMember.value.userAccount?.phoneNumber ?? "- -"),
                      _InfoItem(s.email, controller.currentMember.value.email ?? "- -"),
                      _InfoItem(s.address, controller.currentMember.value.address ?? "- -"),
                      _InfoItem(s.state, controller.currentMember.value.state?.title ?? "- -"),
                      _InfoItem(s.city, controller.currentMember.value.city?.title ?? "- -"),
                      _InfoItem(s.postalCode, controller.currentMember.value.postalCode ?? "- -"),
                    ]),
                  ],
                ),
              ),
            ),

            // Work Information Card
            WCard(
              showBorder: true,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    Text(s.employmentInfo).titleMedium(),
                    _buildInfoGrid([
                      _InfoItem(s.personnelCode, controller.currentMember.value.personnelCode ?? "- -"),
                      _InfoItem(s.department, controller.department?.title ?? "- -"),
                      _InfoItem(s.role, controller.currentMember.value.jobPosition ?? "- -"),
                      _InfoItem(s.workShift, controller.currentMember.value.workShift?.title ?? "- -"),
                      _InfoItem(s.joinDate, controller.currentMember.value.jtime ?? "- -"),
                      _InfoItem(s.employmentType, controller.currentMember.value.employmentType?.getTitle() ?? "- -"),
                      _InfoItem(s.salaryType, controller.currentMember.value.salaryType?.getTitle() ?? "- -"),
                      _InfoItem(s.insurance, controller.currentMember.value.insuranceType?.getTitle() ?? "- -"),
                      _InfoItem(s.contractStartDate, controller.currentMember.value.dateOfStartToWorkPersian ?? "- -"),
                      _InfoItem(s.contractEndDate, controller.currentMember.value.contractEndDatePersian ?? "- -"),
                      _InfoItem(s.iban, controller.currentMember.value.shabaNumber != null ? controller.currentMember.value.shabaNumber!.ibanFormat() : "- -"),
                    ]),
                  ],
                ),
              ),
            ),

            // Education Information Card
            WCard(
              showBorder: true,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    Text(s.educationInfo).titleMedium(),
                    _buildInfoGrid([
                      _InfoItem(s.educationalDegree, controller.currentMember.value.educationType?.getTitle() ?? "- -"),
                      _InfoItem(s.fieldOfStudy, controller.currentMember.value.studyCategory?.title ?? "- -"),
                    ]),
                  ],
                ),
              ),
            ),

            // Skills and Favorites Card
            if (controller.currentMember.value.skills?.isNotEmpty == true || controller.currentMember.value.favorites?.isNotEmpty == true)
              WCard(
                showBorder: true,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.currentMember.value.skills?.isNotEmpty == true) ...[
                        Text(s.skills).bodyMedium().bold(),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: controller.currentMember.value.skills!
                              .map((final skill) => Chip(
                                    label: Text(skill),
                                    backgroundColor: context.theme.primaryColor.withValues(alpha: 0.1),
                                    labelStyle: TextStyle(color: context.theme.primaryColor),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (controller.currentMember.value.favorites?.isNotEmpty == true) ...[
                        Text(s.favorites).bodyMedium().bold(),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: controller.currentMember.value.favorites!
                              .map((final favorite) => Chip(
                                    label: Text(favorite),
                                    backgroundColor: context.theme.secondaryHeaderColor,
                                  ))
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

            // Emergency Information Card
            if (controller.currentMember.value.isEmergencyInformation)
              WCard(
                showBorder: true,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      Text(s.emergencyInformation).titleMedium(),
                      _buildInfoGrid([
                        _InfoItem(s.firstName, controller.currentMember.value.emergencyFirstName ?? "- -"),
                        _InfoItem(s.lastName, controller.currentMember.value.emergencyLastName ?? "- -"),
                        _InfoItem(s.phoneNumber, controller.currentMember.value.emergencyPhoneNumber ?? "- -"),
                        _InfoItem(s.relationship, controller.currentMember.value.emergencyRelationship ?? "- -"),
                      ]),
                    ],
                  ),
                ),
              ),

            // Access Levels Card
            if (isWorkspaceMember)
              WCard(
                showBorder: true,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      Text(s.accessLevels).titleMedium(),
                      WAccessLevelsSelection(
                        permissions: controller.currentMember.value.permissions ?? [],
                        selectable: false,
                        onConfirmed: (final list) {},
                      ).marginOnly(bottom: 10),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  String _getFullName() {
    final member = controller.currentMember.value;
    if (member.firstName != null && member.lastName != null) {
      return "${member.firstName} ${member.lastName}";
    }
    return member.userAccount?.fullName ?? "- -";
  }

  Widget _buildInfoGrid(final List<_InfoItem> items) {
    return ListView.builder(
      // محاسبه تعداد ردیف‌ها
      // (items.length / 2).ceil() تعداد ردیف‌ها را محاسبه می‌کند
      // برای مثال اگر ۱۱ آیتم داشته باشیم، ۶ ردیف خواهیم داشت
      itemCount: (items.length / 2).ceil(),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (final context, final index) {
        final int firstItemIndex = index * 2;
        final int secondItemIndex = firstItemIndex + 1;

        final haveSecondItem = secondItemIndex < items.length;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                child: _buildInfoItem(items[firstItemIndex]),
              ),
              if (haveSecondItem)
                Expanded(
                  child: _buildInfoItem(items[secondItemIndex]),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoItem(final _InfoItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(item.label).bodySmall(color: Get.theme.hintColor),
        Text(item.value).bodyMedium(),
      ],
    );
  }
}

class _InfoItem {
  final String label;
  final String value;

  _InfoItem(this.label, this.value);
}
