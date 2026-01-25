import 'package:u/utilities.dart';

import '../../../../../core/widgets/image_files.dart';
import '../../../../../data/data.dart';
import '../../data/repositories/warehouse_repository_impl.dart';
import '../../domain/entities/warehouse.dart';
import '../../domain/usecases/create_warehouse.dart';
import '../../domain/usecases/update_warehouse.dart';
import '../../domain/usecases/get_warehouse_by_id.dart';

mixin WarehouseCreateUpdateController {
  Warehouse? warehouse;
  final GlobalKey<FormState> formKey = GlobalKey();
  final WarehouseRepositoryImpl _repository = WarehouseRepositoryImpl();
  late final CreateWarehouseUseCase _createWarehouseUseCase = CreateWarehouseUseCase(_repository);
  late final UpdateWarehouseUseCase _updateWarehouseUseCase = UpdateWarehouseUseCase(_repository);
  late final GetWarehouseByIdUseCase _getWarehouseByIdUseCase = GetWarehouseByIdUseCase(_repository);

  final Rx<PageState> buttonState = PageState.loaded.obs;

  MainFileReadDto? avatar;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  int capacity = 0;
  final TextEditingController descriptionController = TextEditingController();
  bool isUploadingFile = false;
  int? stateId;
  int? cityId;
  double? latitude;
  double? longitude;
  int? mainCategoryId;

  void disposeItems() {
    buttonState.close();
    titleController.dispose();
    codeController.dispose();
    descriptionController.dispose();
  }

  Future<void> loadWarehouse(final int id) async {
    try {
      warehouse = await _getWarehouseByIdUseCase(id);
      setValues();
    } catch (e) {
      // Error handling
    }
  }

  void setValues() {
    if (warehouse == null) return;
    avatar = warehouse?.avatarId != null ? MainFileReadDto(fileId: warehouse!.avatarId, url: warehouse!.avatarUrl) : null;
    titleController.text = warehouse?.title ?? '';
    codeController.text = warehouse?.code ?? '';
    capacity = warehouse?.capacity?.toInt() ?? 0;
    descriptionController.text = warehouse?.description ?? '';
    stateId = warehouse?.stateId;
    cityId = warehouse?.cityId;
    latitude = warehouse?.latitude;
    longitude = warehouse?.longitude;
    mainCategoryId = warehouse?.mainCategoryId;
  }

  void onSubmit({required final Function(Warehouse warehouse) onResponse}) {
    validateForm(
      key: formKey,
      action: () {
        WImageFiles.checkFileUploading(
          isUploadingFile: isUploadingFile,
          action: () {
            buttonState.loading();
            if (warehouse == null) {
              create(onResponse);
            } else {
              update(onResponse);
            }
          },
        );
      },
    );
  }

  Future<void> create(final Function(Warehouse warehouse) onResponse) async {
    try {
      final params = <String, dynamic>{
        'title': titleController.text.trim(),
        if (codeController.text.trim().isNotEmpty) 'code': codeController.text.trim(),
        'capacity': capacity.toDouble(),
        if (descriptionController.text.trim().isNotEmpty) 'description': descriptionController.text.trim(),
        if (stateId != null) 'state': stateId,
        if (cityId != null) 'city': cityId,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (mainCategoryId != null) 'main_category': mainCategoryId,
        if (avatar?.fileId != null) 'avatar': avatar?.fileId,
      };

      final result = await _createWarehouseUseCase(params);
      onResponse(result);
      buttonState.loaded();
    } catch (e) {
      buttonState.loaded();
    }
  }

  Future<void> update(final Function(Warehouse warehouse) onResponse) async {
    try {
      final params = <String, dynamic>{
        'title': titleController.text.trim(),
        if (codeController.text.trim().isNotEmpty) 'code': codeController.text.trim(),
        'capacity': capacity.toDouble(),
        if (descriptionController.text.trim().isNotEmpty) 'description': descriptionController.text.trim(),
        if (stateId != null) 'state': stateId,
        if (cityId != null) 'city': cityId,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (mainCategoryId != null) 'main_category': mainCategoryId,
        if (avatar?.fileId != null) 'avatar': avatar?.fileId,
      };

      final result = await _updateWarehouseUseCase(warehouse!.id, params);
      onResponse(result);
      buttonState.loaded();
    } catch (e) {
      buttonState.loaded();
    }
  }
}
