import 'package:u/utilities.dart';

import '../../../../../../data/data.dart';
import '../../../invoice/data/models/invoice.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/customer_order_datasource.dart';
import '../mappers/customer_order_mapper.dart';
import '../models/order_interface.dart';

/// Repository Implementation
/// Converts DTOs to Domain Entities (Data Layer to Domain Layer)
class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl();

  CustomerOrderDatasource get _orderDatasource => Get.find<CustomerOrderDatasource>();

  @override
  Future<List<CustomerOrder>> getOrdersByCustomer(final int customerId) {
    final completer = Completer<List<CustomerOrder>>();
    _orderDatasource.getOrdersByCustomer(
      customerId: customerId,
      onResponse: (final response) {
        final orders = (response.resultList ?? [])
            .map((final dto) => _mapInvoiceDtoToEntity(dto))
            .whereType<CustomerOrder>()
            .toList();
        completer.complete(orders);
      },
      onError: (final error) {
        completer.completeError(error);
      },
    );
    return completer.future;
  }

  CustomerOrder? _mapInvoiceDtoToEntity(final IOrderModel dto) {
    if (dto is InvoiceReadDto) return CustomerOrderMapper.fromInvoiceDto(dto);
    if (dto is ContractReadDto) return CustomerOrderMapper.fromContractDto(dto);
    return null;
  }
}
