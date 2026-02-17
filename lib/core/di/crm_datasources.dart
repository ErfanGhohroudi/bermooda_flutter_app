import 'package:get/get.dart';

import '../../data/data.dart';
import '../../view/modules/crm/invoice/data/datasources/customer_finance/get_invoice_code_datasource.dart';
import '../../view/modules/crm/invoice/data/datasources/customer_finance/invoice_manager_datasource.dart';
import '../../view/modules/crm/invoice/data/datasources/customer_finance/pay_invoice_datasource.dart';
import '../../view/modules/crm/invoice/data/datasources/customer_finance/update_invoice_info_datasource.dart';
import '../../view/modules/crm/order/data/datasources/customer_order_datasource.dart';

class CrmDatasources {
  static void init() {
    // --- CRM Module Data Sources ---
    Get.lazyPut<CrmDatasource>(() => CrmDatasource(), fenix: true);
    Get.lazyPut<CrmSectionDatasource>(() => CrmSectionDatasource(), fenix: true);
    Get.lazyPut<CrmArchiveDatasource>(() => CrmArchiveDatasource(), fenix: true);
    Get.lazyPut<CRMStatisticsDatasource>(() => CRMStatisticsDatasource(), fenix: true);
    Get.lazyPut<CustomerDatasource>(() => CustomerDatasource(), fenix: true);
    Get.lazyPut<CustomerExelImportDatasource>(() => CustomerExelImportDatasource(), fenix: true);
    Get.lazyPut<CustomerIndustrySubCategoryDatasource>(() => CustomerIndustrySubCategoryDatasource(), fenix: true);
    Get.lazyPut<CustomerLabelDatasource>(() => CustomerLabelDatasource(), fenix: true);
    Get.lazyPut<CustomerStatusReasonDatasource>(() => CustomerStatusReasonDatasource(), fenix: true);
    Get.lazyPut<CustomersBankDatasource>(() => CustomersBankDatasource(), fenix: true);
    Get.lazyPut<CustomerInvoiceLabelDatasource>(() => CustomerInvoiceLabelDatasource(), fenix: true);
    Get.lazyPut<CustomerContractLabelDatasource>(() => CustomerContractLabelDatasource(), fenix: true);
    // Customer Finance Data Sources
    Get.lazyPut<InvoiceManagerDatasource>(() => InvoiceManagerDatasource(), fenix: true);
    Get.lazyPut<PayInvoiceDatasource>(() => PayInvoiceDatasource(), fenix: true);
    Get.lazyPut<GetInvoiceCodeDatasource>(() => GetInvoiceCodeDatasource(), fenix: true);
    Get.lazyPut<UpdateInvoiceInfoDatasource>(() => UpdateInvoiceInfoDatasource(), fenix: true);
    Get.lazyPut<CustomerOrderDatasource>(() => CustomerOrderDatasource(), fenix: true);
  }
}
