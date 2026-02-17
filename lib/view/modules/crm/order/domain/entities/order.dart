import 'package:equatable/equatable.dart';

abstract class CustomerOrder extends Equatable {
  const CustomerOrder();

  int get id;
}