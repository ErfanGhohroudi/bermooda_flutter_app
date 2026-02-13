import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/widgets/fields/fields.dart';
import '../../../../../core/widgets/profile_upload_and_show_image.dart';
import '../../domain/entities/warehouse.dart';
import '../controllers/warehouse_create_update_controller.dart';

class WarehouseCreateUpdatePage extends StatefulWidget {
  const WarehouseCreateUpdatePage({
    required this.onResponse,
    this.warehouse,
    super.key,
  });

  final Function(Warehouse warehouse) onResponse;
  final Warehouse? warehouse;

  @override
  State<WarehouseCreateUpdatePage> createState() => _WarehouseCreateUpdatePageState();
}

class _WarehouseCreateUpdatePageState extends State<WarehouseCreateUpdatePage> with WarehouseCreateUpdateController {
  @override
  void initState() {
    warehouse = widget.warehouse;
    if (warehouse != null) {
      setValues();
    }
    super.initState();
  }

  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              WProfileUploadAndShowImage(
                file: avatar,
                onUploaded: (final file) {
                  avatar = file;
                },
                onRemove: (final file) {
                  avatar = null;
                },
                uploadStatus: (final value) {
                  isUploadingFile = value;
                },
              ),
              Flexible(
                child: Text(s.uploadPhoto).bodyMedium(color: context.theme.hintColor),
              ),
            ],
          ).marginOnly(bottom: 18),
          WTextField(
            controller: titleController,
            labelText: s.title,
            required: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          WTextField(
            controller: codeController,
            labelText: s.warehouseCode,
          ),
          WPlusMinusField(
            labelText: s.capacity,
            defaultValue: capacity,
            onChanged: (final value) => capacity = value,
          ),
          WTextField(
            controller: descriptionController,
            labelText: s.description,
            minLines: 4,
            maxLines: 8,
            maxLength: 2000,
            showCounter: true,
            multiLine: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          Obx(
            () => UElevatedButton(
              width: double.maxFinite,
              title: s.submit,
              isLoading: buttonState.isLoading(),
              onTap: () => onSubmit(
                onResponse: (final warehouse) {
                  widget.onResponse(warehouse);
                  AppNavigator.back();
                },
              ),
            ),
          ).marginOnly(top: 100),
        ],
      ),
    ).container().onTap(
      () => FocusManager.instance.primaryFocus?.unfocus(),
    );
  }
}
