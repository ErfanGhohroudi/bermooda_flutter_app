import '../entities/order.dart';

abstract class OrderRepository {
  /// Get list of orders for a customer
  Future<List<CustomerOrder>> getOrdersByCustomer(final int customerId);
}
