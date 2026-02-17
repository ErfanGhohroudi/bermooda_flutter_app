import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../core/utils/extensions/money_extensions.dart';
import '../../../../../../core/widgets/fields/fields.dart';
import '../../../../../../core/widgets/upload_and_show_image.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../data/data.dart';
import '../../data/models/models.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/enums/invoice_status.dart';
import '../../domain/enums/verify_status.dart';

class WInvoiceCard extends StatelessWidget {
  const WInvoiceCard({
    required this.invoice,
    required this.onTapPay,
    required this.onTapSuspension,
    required this.onTapReCreate,
    required this.onTapPaymentVerification,
    super.key,
  });

  final InvoiceEntity invoice;
  final Function(String invoiceMainId, int? installmentId, Decimal amount) onTapPay;
  final Function() onTapSuspension;
  final Function() onTapReCreate;
  final Future<GenericResponse<InvoiceEntity>?> Function(
    int recordId,
    bool verify,
    String? reason,
    int? installmentId,
  )
  onTapPaymentVerification;

  bool get _isPaid => invoice.isPaid;

  bool get _isExpired => invoice.isExpired;

  bool get _isSuspended => invoice.isSuspended;

  bool get _isClosed => invoice.isClosed;

  bool get _noPaymentDisablingStatuses => !_isPaid && !_isExpired && !_isSuspended && !_isClosed;

  @override
  Widget build(final BuildContext context) {
    final InvoiceType type = invoice.invoiceType;

    final paidInstallments = invoice.installments.where((final installment) => installment.isPaid).length;
    final totalInstallments = invoice.installments.length;
    final isInstallmentPaymentTerms = invoice.paymentType == PaymentTerms.installment;
    final isCashPaymentTerms = invoice.paymentType == PaymentTerms.cash;

    final moreItems = <WPopupMenuItem>[
      if (type.isFinalInvoice && invoice.status != InvoiceStatus.suspended)
        WPopupMenuItem(
          title: s.suspend,
          icon: '',
          iconData: CupertinoIcons.pause_circle,
          onTap: onTapSuspension,
        ),
      if (type.isPreInvoice)
        WPopupMenuItem(
          title: s.reCreate,
          icon: '',
          iconData: CupertinoIcons.refresh,
          onTap: onTapReCreate,
        ),
    ];

    return WCard(
      showBorder: true,
      onTap: invoice.invoiceUrl?.isURL ?? false
          ? () => launchUrl(
              Uri.parse(invoice.invoiceUrl!),
              mode: LaunchMode.inAppBrowserView,
              webOnlyWindowName: kIsWeb ? "_self" : null,
              browserConfiguration: const BrowserConfiguration(showTitle: true),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          // Header: ID and Status
          Row(
            children: [
              WLabel(
                text: invoice.invoiceCode,
                color: context.theme.primaryColor,
                verticalPadding: 6,
                fontSize: context.textTheme.bodyMedium?.fontSize,
              ),
              const Spacer(),
              if (invoice.status != null)
                WLabel(
                  text: invoice.status!.title,
                  color: invoice.status!.color,
                ),

              /// More
              if (moreItems.isNotEmpty) WMoreButtonIcon(items: moreItems),
            ],
          ),

          const Divider(height: 1),

          // Vital Info: Type, Amount, Date
          Row(
            children: [
              _buildVitalInfoItem(
                context,
                icon: AppIcons.invoiceOutline,
                title: s.type,
                value: invoice.invoiceType.getTitle(),
              ).expanded(),
              _buildVitalInfoItem(
                context,
                icon: AppIcons.dollarOutline,
                title: s.amount,
                value: invoice.factorPrice.finalPrice.toString().toRialMoney(),
              ).expanded(),
            ],
          ),

          Row(
            children: [
              _buildVitalInfoItem(
                context,
                icon: AppIcons.calendarOutline,
                title: s.date,
                value: invoice.invoiceDate,
              ).expanded(),
              _buildVitalInfoItem(
                context,
                icon: AppIcons.walletOutline,
                title: s.paymentTerms,
                value: invoice.paymentType.getTitle(),
              ).expanded(),
            ],
          ),

          if (isInstallmentPaymentTerms)
            _buildVitalInfoItem(
              context,
              icon: AppIcons.info,
              title: s.status,
              value: s.installmentsPaid(paidInstallments, totalInstallments),
            ),

          // Pay Button in cash payment terms
          if (isCashPaymentTerms && invoice.paymentRecord == null)
            _buildPayButton(
              context,
              isPreInvoice: type.isFinalInvoice,
              action: () => onTapPay(invoice.mainId, null, invoice.factorPrice.finalPrice),
            ),

          // Paid Info
          if (isCashPaymentTerms && invoice.paymentRecord != null)
            _buildPaymentRecordInfo(
              context,
              paymentRecord: invoice.paymentRecord,
            ),

          // Installments Section
          if (isInstallmentPaymentTerms && invoice.installments.isNotEmpty) ...[
            const Divider(height: 1),
            WExpansionTile(
              curve: Curves.easeInOut,
              title: s.installments,
              icon: AppIcons.timerOutline,
              onChanged: (final value) {},
              child: Column(
                spacing: 6,
                children: List<Widget>.generate(invoice.installments.length, (final index) {
                  final installment = invoice.installments[index];
                  final isFirstInstallment = index == 0;
                  final isPreviousInstallmentPaid = isFirstInstallment
                      ? true
                      : index > 0
                      ? invoice.installments[index - 1].paymentRecord != null
                      : false;

                  return _buildInstallmentItem(
                    context,
                    type: type,
                    installment: installment,
                    order: index + 1,
                    isPreviousInstallmentPaid: isPreviousInstallmentPaid,
                  );
                }),
              ).pOnly(left: 6, right: 6, bottom: 6),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentRecordInfo(
    final BuildContext context, {
    final PaymentRecord? paymentRecord,
    final int? installmentId,
  }) {
    if (paymentRecord == null) return const SizedBox.shrink();
    final documents = paymentRecord.paymentFiles;
    final status = paymentRecord.verifyStatus;

    final paymentDateTime =
        "${paymentRecord.paymentDate?.formatCompactDate()}"
        "${paymentRecord.paymentTime != null ? ' - ${paymentRecord.paymentTime!.split(':').take(2).join(':')}' : ''}";

    return WCard(
      showBorder: true,
      borderWidth: 1,
      margin: EdgeInsets.zero,
      color: Colors.grey.withValues(alpha: 0.05),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 10,
            children: [
              Text(s.paymentInfo).titleMedium(color: context.theme.hintColor),
              WLabel(
                text: paymentRecord.verifyStatus.title,
                color: paymentRecord.verifyStatus.color,
              ),
            ],
          ),
          const SizedBox(height: 7),
          if (paymentRecord.paymentDate != null)
            _buildInstallmentRow(context, s.paymentDate, paymentDateTime).pSymmetric(vertical: 2),
          if (paymentRecord.trackingCode != null)
            _buildInstallmentRow(context, s.trackingCode, paymentRecord.trackingCode!).pSymmetric(vertical: 2),
          const SizedBox(height: 10),
          if (documents.isNotEmpty) ...[
            Text(s.attachments).bodyMedium(color: context.theme.hintColor),
            const SizedBox(height: 6),
            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: List<Widget>.generate(documents.length, (final index) {
                final document = documents[index];
                return WUploadAndShowImage(
                  file: document,
                  removable: false,
                  itemSize: 65,
                  onUploaded: (final file) {},
                  onRemove: (final file) {},
                  uploadStatus: (final value) {},
                );
              }),
            ),
          ],
          if (status == VerifyStatus.pending)
            _buildPaymentVerificationButtons(
              record: paymentRecord,
              installmentId: installmentId,
            ).alignAtCenter().marginOnly(top: 7),
        ],
      ),
    );
  }

  Widget _buildVitalInfoItem(
    final BuildContext context, {
    required final String icon,
    required final String title,
    required final String value,
  }) {
    return Row(
      spacing: 8,
      children: [
        UImage(icon, size: 18, color: context.theme.hintColor),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title).bodySmall(color: context.theme.hintColor),
            Text(value).bodyMedium(),
          ],
        ),
      ],
    );
  }

  Widget _buildInstallmentItem(
    final BuildContext context, {
    required final InvoiceType type,
    required final bool isPreviousInstallmentPaid,
    required final InstallmentEntity installment,
    required final int order,
  }) {
    final bool isOverdue = _checkIfOverdue(installment);
    final bool isPaid = installment.isPaid;

    return WCard(
      showBorder: true,
      horPadding: 4,
      verPadding: 4,
      margin: EdgeInsets.zero,
      elevation: 0,
      borderWidth: 1,
      child: WExpansionTile(
        curve: Curves.easeInOut,
        title: '${s.installment} $order',
        titleWidget: Row(
          spacing: 8,
          children: [
            Text('${s.installment} $order').bodyMedium(),
            const Spacer(),
            if (isPaid)
              WLabel(
                text: s.paid,
                color: AppColors.green,
              )
            else if (isOverdue)
              WLabel(
                text: s.overdueInstallmentStatus,
                color: AppColors.red,
              )
            else
              WLabel(
                text: s.pending,
                color: AppColors.orange,
              ),
          ],
        ),
        onChanged: (final value) {},
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            spacing: 10,
            children: [
              _buildInstallmentRow(context, s.amount, installment.price.toString().toRialMoney()),
              _buildInstallmentRow(context, s.dueDateInvoice, installment.dateToPayPersian),
              if (isPaid && installment.datePayedPersian != null)
                _buildInstallmentRow(context, s.paymentDate, installment.datePayedPersian!),
              if (isOverdue && !isPaid)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    spacing: 8,
                    children: [
                      const UImage(AppIcons.warningOutline, color: AppColors.red, size: 20),
                      Expanded(
                        child: Text(
                          s.overdueInstallmentMessage,
                        ).bodySmall(color: AppColors.red),
                      ),
                    ],
                  ),
                ),
              if (isPreviousInstallmentPaid && _noPaymentDisablingStatuses && !isPaid && installment.paymentRecord == null)
                _buildPayButton(
                  context,
                  isPreInvoice: type.isFinalInvoice,
                  action: () => onTapPay(invoice.mainId, installment.id, installment.price),
                ),

              if (installment.paymentRecord != null)
                _buildPaymentRecordInfo(
                  context,
                  paymentRecord: installment.paymentRecord,
                  installmentId: installment.id,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstallmentRow(final BuildContext context, final String label, final String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 5,
      children: [
        Text("$label:").bodyMedium(color: context.theme.disabledColor),
        Flexible(child: Text(value).bodyMedium()),
      ],
    );
  }

  bool _checkIfOverdue(final InstallmentEntity installment) {
    if (installment.isPaid) return false;
    if (installment.dateToPayPersian.isEmpty) return false;
    return installment.isDelayed;
  }

  Widget _buildPayButton(
    final BuildContext context, {
    required final bool isPreInvoice,
    required final VoidCallback action,
  }) => Opacity(
    opacity: isPreInvoice ? 1 : 0.3,
    child: UElevatedButton(
      title: s.pay,
      width: double.infinity,
      titleColor: context.theme.primaryColor,
      borderColor: context.theme.primaryColor,
      borderWidth: 2,
      backgroundColor: context.theme.cardColor,
      onTap: () {
        if (isPreInvoice) {
          action();
          return;
        }

        AppSnackBar.snackbarOrange(title: s.warning, subtitle: s.proformaInvoiceCannotBePaid);
      },
    ),
  );

  Widget _buildPaymentVerificationButtons({
    required final PaymentRecord record,
    final int? installmentId,
  }) {
    return Row(
      spacing: 10,
      children: [
        UElevatedButton(
          onTap: () => _showPaymentVerificationBottomSheet(record, installmentId),
          backgroundColor: AppColors.green,
          icon: const Icon(Icons.check_rounded, color: Colors.white),
          title: "${s.confirm} ${s.payment}",
        ).expanded(),
        UElevatedButton(
          onTap: () => _showPaymentRejectReasonBottomSheet(record, installmentId),
          backgroundColor: AppColors.red,
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          title: "${s.reject} ${s.payment}",
        ).expanded(),
      ],
    );
  }

  Future<void> _showPaymentRejectReasonBottomSheet(
    final PaymentRecord record,
    final int? installmentId,
  ) {
    final formKey = GlobalKey<FormState>();
    final reasonCtrl = TextEditingController();

    final Widget content = StatefulBuilder(
      builder: (final context, final setState) {
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              WTextField(
                controller: reasonCtrl,
                hintText: s.typeYourReasonHere,
                required: true,
                showRequired: false,
                multiLine: true,
                minLines: 4,
                maxLines: 10,
                maxLength: 2000,
                showCounter: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 100),
              Row(
                spacing: 10,
                children: [
                  UElevatedButton(
                    title: s.cancel,
                    backgroundColor: context.theme.hintColor,
                    onTap: AppNavigator.back,
                  ).expanded(),
                  UElevatedButton(
                    title: s.submit,
                    onTap: () async {
                      final result = await onTapPaymentVerification(record.id, false, reasonCtrl.text.trim(), installmentId);
                      if (result != null) {
                        AppSnackBar.snackbarGreen(title: s.done, subtitle: result.message);
                        AppNavigator.back();
                      }
                    },
                  ).expanded(),
                ],
              ),
            ],
          ),
        );
      },
    );

    return bottomSheet(
      title: "${s.reject} ${s.payment}",
      childBuilder: (final context) => content,
    ).whenComplete(() {
      reasonCtrl.dispose();
    });
  }

  void _showPaymentVerificationBottomSheet(
    final PaymentRecord record,
    final int? installmentId,
  ) async {
    return await appShowYesCancelDialog(
      title: "${s.confirm} ${s.payment}",
      description: s.confirm,
      onYesButtonTap: () async {
        AppNavigator.back();
        final result = await onTapPaymentVerification(record.id, true, null, installmentId);
        if (result != null) {
          AppSnackBar.snackbarGreen(title: s.done, subtitle: result.message);
        }
      },
    );
  }
}
