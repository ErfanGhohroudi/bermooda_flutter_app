import 'package:bermooda_business/core/helpers/open_file_helpers.dart';
import 'package:bermooda_business/core/utils/enums/enums.dart';
import 'package:open_filex/open_filex.dart';
import 'package:u/utilities.dart';

import '../../../../core/core.dart';
import '../../../../core/theme.dart';
import '../../../../core/utils/extensions/url_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../data/data.dart';
import 'contract_controller.dart';

class ContractPage extends StatefulWidget {
  const ContractPage({
    required this.legalCaseId,
    required this.canEdit,
    super.key,
  });

  final int legalCaseId;
  final bool canEdit;

  @override
  State<ContractPage> createState() => _ContractPageState();
}

class _ContractPageState extends State<ContractPage> {
  late final ContractController ctrl;

  @override
  void initState() {
    ctrl = Get.put(
      ContractController(
        legalCaseId: widget.legalCaseId,
        canEdit: widget.canEdit,
      ),
    );
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () {
        if (ctrl.pageState.isLoading()) {
          return const Center(child: WCircularLoading());
        }

        if (ctrl.pageState.isError()) {
          return Center(child: WErrorWidget(onTapButton: ctrl.onTryAgain));
        }

        if (ctrl.contract.value == null) {
          return Center(
            child: WEmptyWidget(
              title: s.noContract,
              showUploadButton: ctrl.haveAccess,
              buttonTitle: s.createContract,
              buttonIcon: const Icon(Icons.add_rounded, size: 20, color: Colors.white),
              onTapButton: ctrl.navigateToCreateContractPage,
            ),
          );
        }

        return WSmartRefresher(
          controller: ctrl.refreshController,
          onRefresh: ctrl.onRefresh,
          enablePullUp: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 18,
              children: [
                /// Title
                Text(ctrl.contract.value!.title ?? '- -').titleMedium(),

                /// Status
                _buildItemInfo(
                  title: s.status,
                  child: WLabel(
                    text: ctrl.contract.value!.status.getTitle(),
                    color: ctrl.contract.value!.status.color,
                  ),
                ),

                /// Validity Date
                if (ctrl.contract.value?.expireDate != null)
                  _buildItemInfo(
                    title: s.validityDate,
                    child: Text(ctrl.contract.value!.expireDate?.formatCompactDate() ?? '- -').bodyMedium(),
                  ),

                /// Created by
                _buildItemInfo(
                  title: s.createdBy,
                  child: WCircleAvatar(
                    user: ctrl.contract.value!.creatorDetail,
                    showFullName: true,
                    size: 30,
                  ).expanded(),
                ),
                const Divider(height: 0),

                /// File Section
                if (ctrl.contract.value?.file?.url != null && ctrl.contract.value!.file!.url!.isNotEmpty) _buildFileSection(),

                /// Parties
                _buildParties(),

                /// Signatories
                _buildSignatories(),
                const Divider(height: 0),

                /// Delete Button
                if (ctrl.canDelete) ...[
                  UElevatedButton(
                    width: double.maxFinite,
                    title: s.replace,
                    backgroundColor: AppColors.orange,
                    onTap: ctrl.deleteContract,
                  ),
                  Text(
                    s.deleteContractHelper,
                    textAlign: TextAlign.center,
                  ).bodyMedium(color: context.theme.hintColor).alignAtCenter(),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFileSection() {
    return WCard(
      showBorder: true,
      borderColor: AppColors.blue.withValues(alpha: 0.3),
      color: AppColors.blue.withValues(alpha: 0.1),
      margin: EdgeInsets.zero,
      child: Row(
        spacing: 10,
        children: [
          Text(s.contractFile).bodyMedium().expanded(),
          UElevatedButton(
            title: s.show,
            onTap: () async {
              if (UApp.isMobile) {
                final filePath = await OpenFileHelpers.showDownloadDialog(
                  ctrl.contract.value!.file!.url!,
                  ctrl.contract.value!.file!.fileName ?? '',
                );
                if (filePath != null) {
                  await OpenFilex.open(filePath); // باز کردن فایل بعد از دانلود
                }
              } else {
                ctrl.contract.value!.file!.url!.launchMyUrl();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildParties() {
    return _buildSection(
      title: s.parties,
      child: Wrap(
        spacing: 10,
        runSpacing: 6,
        children: ctrl.contract.value!.signers.mapIndexed((final index, final signer) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: context.theme.hintColor.withValues(alpha: 0.1),
              border: Border.all(color: context.theme.hintColor.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('${index + 1}. ${signer.fullName}').bodyMedium(),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSignatories() {
    return _buildSection(
      title: s.signatories,
      child: ListView.builder(
        itemCount: ctrl.contract.value!.signers.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (final context, final index) {
          final signer = ctrl.contract.value!.signers[index];
          return _buildSignerItem(signer);
        },
      ),
    );
  }

  Widget _buildSignerItem(final SignerDto signer) {
    final isSigned = signer.isSigned;
    final signedValue = ContractStatus.signed;
    final pendingValue = ContractStatus.pending;

    return WCard(
      showBorder: true,
      color: (isSigned ? signedValue.color : pendingValue.color).withValues(alpha: 0.1),
      borderColor: (isSigned ? signedValue.color : pendingValue.color).withValues(alpha: 0.3),
      margin: EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                Text(signer.fullName).bodyMedium(),
                Wrap(
                  spacing: 10,
                  runSpacing: 5,
                  children: [
                    Text("📱 ${signer.mobile}").bodyMedium(),
                    if (signer.email != null && signer.email!.isNotEmpty) Text("📧 ${signer.email}").bodyMedium(),
                    if (signer.nationalId != null && signer.nationalId!.isNotEmpty) Text("🆔 ${signer.nationalId}").bodyMedium(),
                  ],
                ),
              ],
            ),
          ),
          WLabel(
            text: isSigned ? signedValue.getTitle() : pendingValue.getTitle(),
            color: isSigned ? signedValue.color : pendingValue.color,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required final String title,
    required final Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text("$title:").bodyMedium(color: context.theme.hintColor),
        child,
      ],
    );
  }

  Widget _buildItemInfo({
    required final String title,
    required final Widget child,
  }) {
    return Row(
      spacing: 12,
      children: [
        SizedBox(
          width: 100,
          child: Text("$title:").bodyMedium(color: context.theme.hintColor),
        ),
        child,
      ],
    );
  }
}
