import 'package:get/get.dart';

import '../../data/api_client.dart';
import '../core.dart';
import '../services/permission_service.dart';
import '../services/subscription_service.dart';
import 'auth_datasources.dart';
import 'crm_datasources.dart';
import 'followup_datasources.dart';
import 'project_datasources.dart';
import 'hr_datasources.dart';
import 'legal_datasources.dart';
import 'history_datasources.dart';
import 'label_datasources.dart';
import 'common_datasources.dart';
import 'conversation_datasources.dart';
import 'subtask_datasources.dart';

abstract class DependencyInjector {
  static Future<void> init() async {
    // --- وابستگی‌های خارجی (External Dependencies) ---
    Get.put(Core(), permanent: true);

    // --- API Client ---
    Get.put<ApiClient>(ApiClient(), permanent: true);

    // --- دیتا سورس‌ها (Data Sources) ---
    await Future.microtask(() {
      AuthDatasources.init();
      LabelDatasources.init();
      ConversationDatasources.init();
      CrmDatasources.init();
      FollowUpDatasources.init();
      HistoryDatasources.init();
      ProjectDatasources.init();
      SubtaskDatasources.init();
      HrDatasources.init();
      LegalDatasources.init();
      CommonDatasources.init();
    });

    // --- سرویس‌ها (Core Services) ---
    Get.lazyPut(() => SubscriptionService(currentWorkspace: Get.find<Core>().currentWorkspace));
    Get.lazyPut(() => PermissionService(currentWorkspace: Get.find<Core>().currentWorkspace));

    // --- ریپازیتوری‌ها (Repositories) ---
    // ریپازیتوری‌ها، پیاده‌سازی قراردادهای لایه Domain هستند.
    // ما نوع abstract را ثبت کرده و نمونه‌ی پیاده‌سازی شده را به آن می‌دهیم.

    // Get.lazyPut<ReportRepository>(
    //   () => ReportRepositoryImpl(remoteDataSource: Get.find()),
    // );

    // --- دیتا سورس‌ها (Data Sources) ---
    // Get.lazyPut<ReportRemoteDataSource>(
    //   () => ReportRemoteDataSourceImpl(client: Get.find()),
    // );

    // --- کنترلرها (Controllers) ---
    // کنترلرهایی که باید در کل برنامه در دسترس باشند را می‌توان اینجا lazyPut کرد.
    // (برای کنترلرهای وابسته به یک صفحه خاص، استفاده از Bindings بهتر است)
    // Get.lazyPut<HomeController>(() => HomeController());
  }
}
