import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetOrdersByCustomerUseCase {
  const GetOrdersByCustomerUseCase(this.repository);

  final OrderRepository repository;

  Future<List<CustomerOrder>> call(final int customerId) => repository.getOrdersByCustomer(customerId);
}