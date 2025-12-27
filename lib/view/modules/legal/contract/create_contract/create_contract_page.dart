import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/fields/fields.dart';
import '../../../../../core/widgets/upload_and_show_image.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../data/data.dart';
import 'create_contract_controller.dart';

class CreateContractPage extends StatefulWidget {
  const CreateContractPage({super.key});

  @override
  State<CreateContractPage> createState() => _CreateContractPageState();
}

class _CreateContractPageState extends State<CreateContractPage> with CreateContractController {
  static const double _fileItemSize = 100;

  @override
  void initState() {
    initialController();
    super.initState();
  }

  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(title: Text(s.createContract)),
      bottomNavigationBar: Obx(
        () => UElevatedButton(
          title: s.submit,
          isLoading: isSaving.value,
          onTap: onSubmit,
        ).pOnly(left: 16, right: 16, bottom: 24),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 18,
            children: [
              /// Type
              WDropDownFormField<ContractType>(
                labelText: s.type,
                value: params.type,
                required: true,
                showRequiredIcon: false,
                items: ContractType.values
                    .map(
                      (final type) => DropdownMenuItem<ContractType>(
                        value: type,
                        child: WDropdownItemText(text: type.title),
                      ),
                    )
                    .toList(),
                onChanged: (final type) {
                  if (type == null) return;
                  setState(() {
                    params = params.copyWith(type: type);
                  });
                },
              ),

              /// Type Helper
              _buildTypeHelper(),

              /// Title
              WTextField(
                controller: titleCtrl,
                labelText: s.title,
                required: true,
                minLength: 3,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              if (params.type == ContractType.contract) ...[
                /// Validity Date
                WDatePickerField(
                  labelText: s.validityDate,
                  initialValue: params.expireDate,
                  startDate: Jalali.now(),
                  required: true,
                  onConfirm: (final date, final compactFormatterDate) {
                    params = params.copyWith(expireDate: compactFormatterDate);
                  },
                ),

                /// Send Type
                // WDropDownFormField<ContractSendType>(
                //   labelText: s.type,
                //   value: params.sendType,
                //   required: true,
                //   showRequiredIcon: false,
                //   items: ContractSendType.values
                //       .map(
                //         (final type) => DropdownMenuItem<ContractSendType>(
                //           value: type,
                //           child: WDropdownItemText(text: type.title),
                //         ),
                //       )
                //       .toList(),
                //   onChanged: (final type) {
                //     if (type == null) return;
                //     params = params.copyWith(sendType: type);
                //   },
                // ),
              ],

              /// Upload File
              _buildUploadFile(),

              /// Signers or Parties
              _buildSignersOrParties(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeHelper() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.hintColor.withValues(alpha: 0.1),
        border: Border.all(color: context.theme.hintColor.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "${params.type.title}: ",
              style: context.textTheme.bodyMedium?.copyWith(color: context.theme.primaryColor),
            ),
            TextSpan(
              text: switch (params.type) {
                ContractType.contract => s.contractTypeHelper,
                ContractType.legalCase => s.caseTypeHelper,
              },
              style: context.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadFile() {
    return Obx(
      () => WCard(
        showBorder: true,
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Text(
              switch (params.type) {
                ContractType.contract => s.contractFile,
                ContractType.legalCase => s.file,
              },
            ).titleMedium(),
            if (selectedFile.value == null)
              Material(
                color: context.theme.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: context.theme.hintColor, width: 2),
                ),
                child: InkWell(
                  onTap: pickFile,
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                    width: _fileItemSize,
                    height: _fileItemSize,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 12,
                      children: [
                        Icon(Icons.add_rounded, size: 30, color: context.theme.hintColor),
                        Text("${s.select} ${s.file}").bodyMedium(color: context.theme.hintColor),
                      ],
                    ),
                  ),
                ),
              ).alignAtCenter()
            else
              WUploadAndShowImage(
                file: selectedFile.value!,
                onUploaded: (final file) {
                  selectedFile.value = file;
                  params = params.copyWith(fileId: file.fileId);
                },
                onRemove: (final file) {
                  selectedFile.value = null;
                  params = params.copyWith(fileId: null);
                },
                uploadStatus: (final value) => isUploading = value,
                itemSize: _fileItemSize,
              ).alignAtCenter(),
            Text(s.onlyPDFFilesAllowed).bodyMedium(color: context.theme.hintColor).alignAtCenter().pOnly(top: 8),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSignersOrParties() {
    return WCard(
      showBorder: true,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(
            switch (params.type) {
              ContractType.contract => s.signatories,
              ContractType.legalCase => s.parties,
            },
          ).titleMedium(),
          UElevatedButton(
            width: double.maxFinite,
            title: switch (params.type) {
              ContractType.contract => s.newSignatory,
              ContractType.legalCase => s.newParty,
            },
            titleColor: context.theme.primaryColor,
            borderWidth: 2,
            borderColor: context.theme.primaryColor,
            backgroundColor: context.theme.cardColor,
            icon: Icon(Icons.add_rounded, size: 20, color: context.theme.primaryColor),
            onTap: () => addOrEditSignatoryOrParty(
              action: (final model) {
                final members = List<SignerDto>.from(params.members);
                members.add(model);
                setState(() {
                  params = params.copyWith(members: members);
                });
              },
            ),
          ),
          const Divider(height: 0),
          if (params.members.isEmpty)
            const WEmptyWidget().alignAtCenter()
          else
            ListView.builder(
              itemCount: params.members.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (final context, final index) {
                final member = params.members[index];
                return WCard(
                  showBorder: true,
                  color: context.theme.scaffoldBackgroundColor,
                  margin: EdgeInsets.zero,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          spacing: 10,
                          children: [
                            Text(member.fullName).bodyMedium(),
                            Wrap(
                              spacing: 10,
                              runSpacing: 5,
                              children: [
                                Text("📱 ${member.mobile}").bodyMedium(),
                                if (member.email != null && member.email!.isNotEmpty) Text("📧 ${member.email}").bodyMedium(),
                                if (member.nationalId != null && member.nationalId!.isNotEmpty)
                                  Text("🆔 ${member.nationalId}").bodyMedium(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const UImage(AppIcons.editOutline, color: AppColors.green),
                            style: IconButton.styleFrom(visualDensity: VisualDensity.compact),
                            onPressed: () => addOrEditSignatoryOrParty(
                              model: member,
                              action: (final model) {
                                final members = List<SignerDto>.from(params.members);
                                members[index] = model;
                                setState(() {
                                  params = params.copyWith(members: members);
                                });
                              },
                            ),
                          ),
                          IconButton(
                            icon: const UImage(AppIcons.delete, color: AppColors.red),
                            style: IconButton.styleFrom(visualDensity: VisualDensity.compact),
                            onPressed: () => appShowYesCancelDialog(
                              title: s.delete,
                              description: s.areYouSureYouWantToDeleteItem,
                              onYesButtonTap: () {
                                UNavigator.back();
                                final members = List<SignerDto>.from(params.members);
                                members.removeAt(index);
                                setState(() {
                                  params = params.copyWith(members: members);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
