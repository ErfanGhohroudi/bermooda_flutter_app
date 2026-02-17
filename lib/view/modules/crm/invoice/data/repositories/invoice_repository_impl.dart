import 'package:u/utilities.dart';

import '../../../../../../data/data.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../datasources/customer_finance/get_invoice_code_datasource.dart';
import '../datasources/customer_finance/invoice_manager_datasource.dart';
import '../datasources/customer_finance/pay_invoice_datasource.dart';
import '../models/models.dart';

/// Repository Implementation
/// Converts DTOs to Domain Entities (Data Layer to Domain Layer)
class InvoiceRepositoryImpl implements InvoiceRepository {
  InvoiceRepositoryImpl();

  InvoiceManagerDatasource get _invoiceManagerDatasource => Get.find<InvoiceManagerDatasource>();

  PayInvoiceDatasource get _payInvoiceDatasource => Get.find<PayInvoiceDatasource>();

  GetInvoiceCodeDatasource get _getInvoiceCodeDatasource => Get.find<GetInvoiceCodeDatasource>();

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
        final invoices = (response.resultList ?? []).map((final dto) => _mapInvoiceDtoToEntity(dto)).toList();
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
  Future<InvoiceBuyerSellerInfo> getInvoiceBuyerAndSellerInfo(final int customerId) {
    final completer = Completer<InvoiceBuyerSellerInfo>();
    _invoiceManagerDatasource.getInvoiceInfo(
      customerId: customerId,
      onResponse: (final response) {
        final buyerSellerInfo = response.result;
        if (buyerSellerInfo == null) {
          completer.completeError('InvoiceBuyerSellerInfo is null');
          return;
        }
        completer.complete(response.result!);
      },
      onError: (final error) {
        completer.completeError(error);
      },
    );
    return completer.future;
  }

  @override
  Future<InvoiceEntity> createInvoice(final InvoiceParams params) async {
    final completer = Completer<InvoiceEntity>();
    _invoiceManagerDatasource.createInvoice(
      params: params,
      onResponse: (final response) {
        completer.complete(_mapInvoiceDtoToEntity(response.result!));
      },
      onError: (final error) {
        completer.completeError(error);
      },
      withLoading: true,
    );
    return completer.future;
  }

  @override
  Future<GenericResponse<InvoiceEntity>> payInvoice(final String invoiceMainId, final PayInvoiceParams params) async {
    final completer = Completer<GenericResponse<InvoiceEntity>>();
    _payInvoiceDatasource.payInvoice(
      invoiceMainId: invoiceMainId,
      data: params,
      onResponse: (final response) {
        final res = GenericResponse(
          status: response.status,
          message: response.message,
          result: response.result != null ? _mapInvoiceDtoToEntity(response.result!) : null,
          extra: response.extra,
        );
        completer.complete(res);
      },
      onError: (final error) {
        completer.completeError(error);
      },
    );
    return completer.future;
  }

  @override
  Future<InvoiceEntity> suspendInvoice(final int invoiceId, final String reason, final int? documentId) {
    final completer = Completer<InvoiceEntity>();
    _payInvoiceDatasource.suspendInvoice(
      invoiceId: invoiceId,
      reason: reason,
      documentId: documentId,
      onResponse: (final response) {
        if (response.result == null) return completer.completeError('response.result is null');
        final res = response.result!;
        completer.complete(_mapInvoiceDtoToEntity(res));
      },
      onError: (final error) {
        completer.completeError(error);
      },
    );
    return completer.future;
  }

  @override
  Future<GenericResponse<InvoiceEntity>> paymentVerification(
    final int recordId,
    final bool verify,
    final String? reason,
    final int? installmentId,
  ) {
    final completer = Completer<GenericResponse<InvoiceEntity>>();
    _payInvoiceDatasource.paymentVerification(
      recordId: recordId,
      verify: verify,
      reason: reason,
      installmentId: installmentId,
      onResponse: (final response) {
        if (response.result == null) return completer.completeError('response.result is null');
        final res = GenericResponse<InvoiceEntity>(
          status: response.status,
          message: response.message,
          result: response.result != null ? _mapInvoiceDtoToEntity(response.result!) : null,
          extra: response.extra,
        );
        completer.complete(res);
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
