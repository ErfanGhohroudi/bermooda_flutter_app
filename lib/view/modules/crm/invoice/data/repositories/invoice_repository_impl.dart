import 'package:u/utilities.dart';

import '../../../../../../data/data.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/repositories/invoice_repository.dart';

/// Repository Implementation
/// Converts DTOs to Domain Entities (Data Layer to Domain Layer)
class InvoiceRepositoryImpl implements InvoiceRepository {
  InvoiceRepositoryImpl();

  InvoiceManagerDatasource get _invoiceManagerDatasource => Get.find<InvoiceManagerDatasource>();
  InvoiceStatusManagerDatasource get _invoiceStatusManagerDatasource => Get.find<InvoiceStatusManagerDatasource>();
  InstallmentDatasource get _installmentDatasource => Get.find<InstallmentDatasource>();
  PayInvoiceDatasource get _payInvoiceDatasource => Get.find<PayInvoiceDatasource>();
  SendInvoiceSmsDatasource get _sendInvoiceSmsDatasource => Get.find<SendInvoiceSmsDatasource>();
  GetInvoiceCodeDatasource get _getInvoiceCodeDatasource => Get.find<GetInvoiceCodeDatasource>();
  ChangeInvoiceStatusDatasource get _changeInvoiceStatusDatasource => Get.find<ChangeInvoiceStatusDatasource>();
  InvoicePreviewDatasource get _invoicePreviewDatasource => Get.find<InvoicePreviewDatasource>();

  @override
  Future<String> getInvoiceCode() async {
    final completer = Completer<String>();
    _getInvoiceCodeDatasource.getInvoiceCode(
      onResponse: (final response) {
        if (response == null) {
          completer.completeError('response is null');
        } else {
          completer.complete(response);
        }
      },
      onError: (final error) {
        completer.completeError(error);
      },
    );
    return completer.future;
  }

  @override
  Future<List<InvoiceEntity>> getInvoicesByCustomer(final int customerId) async {
    final completer = Completer<List<InvoiceEntity>>();
    _invoiceManagerDatasource.getInvoicesByCustomer(
      customerId: customerId,
      onResponse: (final response) {
        final invoices = (response.resultList ?? [])
            .map((final dto) => _mapInvoiceDtoToEntity(dto))
            .toList();
        completer.complete(invoices);
      },
      onError: (final error) {
        completer.completeError(error);
      },
    );
    return completer.future;
  }

  @override
  Future<InvoiceEntity> getInvoiceById(final int invoiceId) async {
    final completer = Completer<InvoiceEntity>();
    _invoiceManagerDatasource.getInvoiceById(
      invoiceId: invoiceId,
      onResponse: (final response) {
        completer.complete(_mapInvoiceDtoToEntity(response.result!));
      },
      onError: (final error) {
        completer.completeError(error);
      },
    );
    return completer.future;
  }

  @override
  Future<InvoiceEntity> getInvoicePreview(final String mainId) async {
    final completer = Completer<InvoiceEntity>();
    _invoicePreviewDatasource.getInvoicePreview(
      mainId: mainId,
      onResponse: (final response) {
        completer.complete(_mapInvoiceDtoToEntity(response.result!));
      },
      onError: (final error) {
        completer.completeError(error);
      },
    );
    return completer.future;
  }

  @override
  Future<InvoiceEntity> createInvoice(final Map<String, dynamic> params) async {
    final completer = Completer<InvoiceEntity>();
    _invoiceManagerDatasource.createInvoice(
      data: params,
      onResponse: (final response) {
        completer.complete(_mapInvoiceDtoToEntity(response.result!));
      },
      onError: (final error) {
        completer.completeError(error);
      },
    );
    return completer.future;
  }

  @override
  Future<InvoiceEntity> changeInvoiceStatus(final int invoiceId, final int statusId) async {
    final completer = Completer<InvoiceEntity>();
    _changeInvoiceStatusDatasource.changeInvoiceStatus(
      invoiceId: invoiceId,
      statusId: statusId,
      onResponse: (final response) {
        completer.complete(_mapInvoiceDtoToEntity(response.result!));
      },
      onError: (final error) {
        completer.completeError(error);
      },
    );
    return completer.future;
  }

  @override
  Future<List<InvoiceStatusReadDto>> getInvoiceStatuses(final int groupCrmId) async {
    final completer = Completer<List<InvoiceStatusReadDto>>();
    _invoiceStatusManagerDatasource.getStatusesByGroupCrm(
      groupCrmId: groupCrmId,
      onResponse: (final response) {
        completer.complete(response.resultList ?? []);
      },
      onError: (final error) {
        completer.completeError(error);
      },
    );
    return completer.future;
  }

  @override
  Future<InvoiceStatusReadDto> createInvoiceStatus(final Map<String, dynamic> params) async {
    final completer = Completer<InvoiceStatusReadDto>();
    _invoiceStatusManagerDatasource.createStatus(
      data: params,
      onResponse: (final response) {
        completer.complete(response.result!);
      },
      onError: (final error) {
        completer.completeError(error);
      },
    );
    return completer.future;
  }

  @override
  Future<InvoiceStatusReadDto> updateInvoiceStatus(final int statusId, final Map<String, dynamic> params) async {
    final completer = Completer<InvoiceStatusReadDto>();
    _invoiceStatusManagerDatasource.updateStatus(
      statusId: statusId,
      data: params,
      onResponse: (final response) {
        completer.complete(response.result!);
      },
      onError: (final error) {
        completer.completeError(error);
      },
    );
    return completer.future;
  }

  @override
  Future<void> deleteInvoiceStatus(final int statusId) async {
    final completer = Completer<void>();
    _invoiceStatusManagerDatasource.deleteStatus(
      statusId: statusId,
      onResponse: () {
        completer.complete();
      },
      onError: (final error) {
        completer.completeError(error);
      },
    );
    return completer.future;
  }

  @override
  Future<List<Installment>> getInstallments(final int invoiceId) async {
    final completer = Completer<List<Installment>>();
    _installmentDatasource.getInstallmentsByInvoice(
      invoiceId: invoiceId,
      onResponse: (final response) {
        completer.complete(response.resultList ?? []);
      },
      onError: (final error) {
        completer.completeError(error);
      },
    );
    return completer.future;
  }

  @override
  Future<void> payInstallments(final Map<String, dynamic> params) async {
    final completer = Completer<void>();
    _installmentDatasource.payInstallments(
      data: params,
      onResponse: (_) {
        completer.complete();
      },
      onError: (final error) {
        completer.completeError(error);
      },
    );
    return completer.future;
  }

  @override
  Future<InvoiceEntity> getPaymentInfo(final int invoiceId) async {
    final completer = Completer<InvoiceEntity>();
    _payInvoiceDatasource.getPaymentInfo(
      invoiceId: invoiceId,
      onResponse: (final response) {
        completer.complete(_mapInvoiceDtoToEntity(response.result!));
      },
      onError: (final error) {
        completer.completeError(error);
      },
    );
    return completer.future;
  }

  @override
  Future<InvoiceEntity> payInvoice(final int invoiceId, final Map<String, dynamic> params) async {
    final completer = Completer<InvoiceEntity>();
    _payInvoiceDatasource.payInvoice(
      invoiceId: invoiceId,
      data: params,
      onResponse: (final response) {
        completer.complete(_mapInvoiceDtoToEntity(response.result!));
      },
      onError: (final error) {
        completer.completeError(error);
      },
    );
    return completer.future;
  }

  @override
  Future<void> sendInvoiceSms(final int invoiceId) async {
    final completer = Completer<void>();
    _sendInvoiceSmsDatasource.sendInvoiceSms(
      invoiceId: invoiceId,
      onResponse: (_) {
        completer.complete();
      },
      onError: (final error) {
        completer.completeError(error);
      },
    );
    return completer.future;
  }

  /// Maps InvoiceReadDto to InvoiceEntity
  InvoiceEntity _mapInvoiceDtoToEntity(final InvoiceReadDto dto) {
    return InvoiceEntity.fromDto(dto);
  }
}
