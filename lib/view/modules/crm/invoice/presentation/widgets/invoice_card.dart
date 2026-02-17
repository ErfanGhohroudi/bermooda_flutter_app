import 'package:bermooda_business/data/data.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../core/utils/extensions/money_extensions.dart';
import '../../../../../../core/widgets/image_files.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/enums/invoice_status.dart';

class WInvoiceCard extends StatelessWidget {
  const WInvoiceCard({
    required this.invoice,
    required this.onTapPay,
    required this.onTapSuspension,
    required this.onTapReCreate,
    super.key,
  });

  final InvoiceEntity invoice;
  final Function(String invoiceMainId, int? installmentId, Decimal amount) onTapPay;
  final Function() onTapSuspension;
  final Function() onTapReCreate;

  InvoiceStatus? get _status => invoice.status;

  bool get _isExpired => _status == InvoiceStatus.expired;

  bool get _isSuspended => _status == InvoiceStatus.suspended;

  bool get _isClosed => _status == InvoiceStatus.closed;

  bool get _noPaymentDisablingStatuses => !_isExpired && !_isSuspended && !_isClosed;

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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: context.theme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(invoice.invoiceCode).bodyMedium(color: context.theme.primaryColor).bold(),
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
            _buildPaidInfo(
              context,
              invoice.paymentRecord,
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
                children: invoice.installments
                    .mapIndexed(
                      (final index, final installment) => _buildInstallmentItem(
                        context,
                        type,
                        installment,
                        index + 1,
                      ),
                    )
                    .toList(),
              ).pOnly(left: 6, right: 6, bottom: 6),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaidInfo(final BuildContext context, final PaymentRecord? paymentRecord) {
    if (paymentRecord == null) return const SizedBox.shrink();
    final documents = paymentRecord.paymentFiles;
    final verified = paymentRecord.verified;

    final paymentDateTime =
        "${paymentRecord.paymentDate?.formatCompactDate()}"
        "${paymentRecord.paymentTime != null ? ' - ${paymentRecord.paymentTime!.split(':').take(2).join(':')}' : ''}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(),
        Text(s.paymentInfo).titleMedium(color: context.theme.hintColor),
        const SizedBox(height: 7),
        if (paymentRecord.paymentDate != null)
          _buildInstallmentRow(context, s.paymentDate, paymentDateTime).pSymmetric(vertical: 2),
        if (paymentRecord.trackingCode != null)
          _buildInstallmentRow(context, s.trackingCode, paymentRecord.trackingCode!).pSymmetric(vertical: 2),
        const SizedBox(height: 10),
        if (documents.isNotEmpty) ...[
          Text(s.attachments).bodyMedium(color: context.theme.hintColor),
          const SizedBox(height: 6),
          WImageFiles(
            files: documents,
            removable: false,
            showUploadWidget: false,
            onFilesUpdated: (final uploadedFiles) {},
            uploadingFileStatus: (final value) {},
          ),
        ],
        if (verified == false)
          Container(
            decoration: BoxDecoration(),
            // child: ,
          ),
      ],
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
    final BuildContext context,
    final InvoiceType type,
    final InstallmentEntity installment,
    final int order,
  ) {
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
              if (_noPaymentDisablingStatuses && !isPaid)
                _buildPayButton(
                  context,
                  isPreInvoice: type.isFinalInvoice,
                  action: () => onTapPay(invoice.mainId, installment.id, installment.price),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstallmentRow(final BuildContext context, final String label, final String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label).bodyMedium(color: context.theme.disabledColor),
        Text(value).bodyMedium(),
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
}
