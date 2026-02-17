import '../../../../../../data/data.dart';
import '../../../invoice/data/models/invoice.dart';
import '../models/order_interface.dart';

class OrderModelMapper {
  static IOrderModel? fromMap(final Map<String, dynamic> json) {
    final dataType = json["data_type"];

    switch (dataType) {
      case "invoice":
        return InvoiceReadDto.fromMap(json);
      case "contract":
        return ContractReadDto.fromMap(json);
      default:
        return null;
    }
  }
}
