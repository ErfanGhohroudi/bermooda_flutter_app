import 'package:bermooda_business/view/modules/crm/invoice/domain/entities/invoice.dart';

import '../../../../../../data/data.dart';
import '../../../invoice/data/models/invoice.dart';
import '../../domain/entities/contract.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/order.dart';

class CustomerOrderMapper {
  static CustomerOrder fromInvoiceDto(final InvoiceReadDto dto) {
    return InvoiceOrderEntity(invoice: InvoiceEntity.fromDto(dto));
  }

  static CustomerOrder fromContractDto(final ContractReadDto dto) {
    return ContractOrderEntity(contract: dto);
  }
}
