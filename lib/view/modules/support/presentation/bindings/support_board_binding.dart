import 'package:get/get.dart';
import '../../data/datasources/support_board_datasource.dart';
import '../../data/repositories/support_department_repository_impl.dart';
import '../../domain/repositories/support_department_repository.dart';
import '../../domain/usecases/create_board_section.dart';
import '../../domain/usecases/get_members.dart';
import '../../domain/usecases/update_board_section.dart';
import '../../domain/usecases/delete_board_section.dart';
import '../../domain/usecases/get_support_board.dart';
import '../../domain/usecases/move_support_card.dart';
import '../../data/repositories/support_board_repository_impl.dart';
import '../../domain/repositories/support_board_repository.dart';
import '../../domain/usecases/update_support_department.dart';
import '../controllers/support_board_controller.dart';
import '../../domain/entities/support_department.dart';

class SupportBoardBinding extends Bindings {
  SupportBoardBinding({required this.department});

  final SupportDepartment department;

  @override
  void dependencies() {
    Get.lazyPut<SupportBoardDatasource>(() => SupportBoardDatasource());
    Get.lazyPut<SupportBoardRepository>(() => SupportBoardRepositoryImpl());
    Get.lazyPut<SupportDepartmentRepository>(() => SupportDepartmentRepositoryImpl());
    Get.lazyPut(() => GetSupportBoardUseCase(Get.find()));
    Get.lazyPut(() => MoveSupportCardUseCase(Get.find()));
    Get.lazyPut(() => CreateBoardSectionUseCase(Get.find()));
    Get.lazyPut(() => UpdateBoardSectionUseCase(Get.find()));
    Get.lazyPut(() => DeleteBoardSectionUseCase(Get.find()));

    // add Member page
    Get.lazyPut(() => GetMembersUseCase(Get.find()));
    Get.lazyPut(() => UpdateSupportDepartmentUseCase(Get.find()));

    Get.put(
      SupportBoardController(
        department: department,
        getSupportBoardUseCase: Get.find(),
        moveSupportCardUseCase: Get.find(),
      ),
    );
  }
}
