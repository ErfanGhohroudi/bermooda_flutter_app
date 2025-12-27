import 'package:get/get.dart';

import '../../data/data.dart';

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
  }
}
