// import 'package:dio/dio.dart';
// import 'package:get_it/get_it.dart';
//
// import 'features/crm/reports/data/datasources/report_remote_data_source.dart';
// import 'features/crm/reports/data/repositories/report_repository_impl.dart';
// import 'features/crm/reports/domain/repositories/report_repository.dart';
// import 'features/crm/reports/domain/usecases/add_report.dart';
// import 'features/crm/reports/domain/usecases/delete_report.dart';
// import 'features/crm/reports/domain/usecases/get_reports.dart';
//
// // این یک نمونه سراسری از Service Locator است
// final sl = GetIt.instance;
//
// Future<void> init() async {
//   // این تابع تمام وابستگی‌ها را ثبت می‌کند
//
//   // ------------------ Features - Reports ------------------
//
//   // BLoC
//   // از registerFactory برای BLoC استفاده می‌کنیم، چون می‌خواهیم با هر بار
//   // نیاز، یک نمونه جدید از آن ساخته شود (مثلاً اگر کاربر از صفحه خارج و دوباره وارد شود).
//   sl.registerFactory(
//     () => ReportBloc(
//       getReports: sl(),
//       addReport: sl(),
//       deleteReport: sl(),
//     ),
//   );
//
//   // Use Cases
//   // یوزکیس‌ها به صورت Lazy Singleton ثبت می‌شوند، چون به یک نمونه از آنها در کل
//   // برنامه نیاز داریم و تا زمانی که فراخوانی نشوند، ساخته نمی‌شوند.
//   sl.registerLazySingleton(() => GetReportsUseCase(sl()));
//   sl.registerLazySingleton(() => AddReportUseCase(sl()));
//   sl.registerLazySingleton(() => DeleteReportUseCase(sl()));
//
//   // Repository
//   // ریپازیتوری نیز به صورت Lazy Singleton ثبت می‌شود.
//   // ما نوع abstract (ReportRepository) را ثبت کرده و پیاده‌سازی آن (ReportRepositoryImpl) را به آن می‌دهیم.
//   // این کار باعث می‌شود لایه‌های بالاتر هیچ اطلاعی از پیاده‌سازی نداشته باشند.
//   sl.registerLazySingleton<ReportRepository>(() => ReportRepositoryImpl(remoteDataSource: sl()));
//
//   // Data Sources
//   // منبع داده نیز به همین شکل ثبت می‌شود.
//   sl.registerLazySingleton<ReportRemoteDataSource>(() => ReportRemoteDataSourceImpl(client: sl()));
//
//   // ------------------ Core ------------------
//   // در اینجا می‌توانید وابستگی‌های مربوط به کل برنامه را ثبت کنید
//   // مثلاً NetworkInfo
//
//   // ------------------ External ------------------
//   // وابستگی‌های خارجی مانند کلاینت HTTP
//   sl.registerLazySingleton(() => Dio());
// }
