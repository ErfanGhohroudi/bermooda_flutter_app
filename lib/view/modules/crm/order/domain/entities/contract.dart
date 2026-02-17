import '../../../../../../data/data.dart';
import 'order.dart';

class ContractOrderEntity extends CustomerOrder {
  final ContractReadDto contract;

  const ContractOrderEntity({
    required this.contract,
  });

  @override
  List<Object?> get props => [contract];

  @override
  int get id => contract.id;
}