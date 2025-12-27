import 'package:get/get.dart';

import '../../data/data.dart';

class CommonDatasources {
  static void init() {
    // --- Common/Shared Data Sources ---
    Get.lazyPut<DashboardDatasource>(() => DashboardDatasource(), fenix: true);
    Get.lazyPut<DropdownDatasource>(() => DropdownDatasource(), fenix: true);
    Get.lazyPut<CalendarDatasource>(() => CalendarDatasource(), fenix: true);
    Get.lazyPut<MeetingDatasource>(() => MeetingDatasource(), fenix: true);
    Get.lazyPut<MailDatasource>(() => MailDatasource(), fenix: true);
    Get.lazyPut<NotificationDataSource>(() => NotificationDataSource(), fenix: true);
    Get.lazyPut<UploadFileDatasource>(() => UploadFileDatasource(), fenix: true);
    Get.lazyPut<UploadCustomerExelDatasource>(() => UploadCustomerExelDatasource(), fenix: true);
    Get.lazyPut<AddFcmDatasource>(() => AddFcmDatasource(), fenix: true);
    Get.lazyPut<SubscriptionDatasource>(() => SubscriptionDatasource(), fenix: true);
    Get.lazyPut<SubscriptionInvoiceDatasource>(() => SubscriptionInvoiceDatasource(), fenix: true);
    Get.lazyPut<UpdateDatasource>(() => UpdateDatasource(), fenix: true);
    Get.lazyPut<BannerDatasource>(() => BannerDatasource(), fenix: true);
    Get.lazyPut<NoticeDatasource>(() => NoticeDatasource(), fenix: true);
  }
}
