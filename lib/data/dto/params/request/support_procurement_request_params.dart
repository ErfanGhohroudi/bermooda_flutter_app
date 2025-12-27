part of '../../../data.dart';

/// Support and Procurement Request Parameters
class SupportProcurementRequestParams extends BaseRequestParams {
  const SupportProcurementRequestParams({
    super.requestingUserId,
    required super.categoryType,
    super.description,
    required this.supportType,
    this.equipmentType,
    this.quantity,
    this.suggestedModel,
    this.urgencyLevel,
    this.supplyType,
    this.currentEquipment,
    this.problemDescription,
    this.problemDate,
    this.repairType,
    this.files,
  });

  final SupportType supportType;
  final EquipmentType? equipmentType;
  final int? quantity;
  final String? suggestedModel;
  final UrgencyLevel? urgencyLevel;
  final String? supplyType;
  final String? currentEquipment;
  final String? problemDescription;
  final String? problemDate;
  final RepairType? repairType;
  final List<MainFileReadDto>? files;

  @override
  RequestCategoryType get categoryType => RequestCategoryType.support_logistics;

  @override
  String toJson() => json.encode(toMap()).englishNumber();

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();

    final fileIds = files?.map((final file) => file.fileId).whereType<int>().toList();

    switch (supportType) {
      case SupportType.equipment_purchase:
        return {
          ...baseMap,
          'subcategory': supportType.name,
          'equipment_type': equipmentType?.name,
          'equipment_quantity': quantity,
          'suggested_model': suggestedModel,
          'urgency_level': urgencyLevel?.name,
        };

      case SupportType.office_supplies:
        return {
          ...baseMap,
          'subcategory': supportType.name,
          'supply_type': supplyType,
          'required_quantity': quantity,
        };

      case SupportType.equipment_repair:
        return {
          ...baseMap,
          'subcategory': supportType.name,
          'current_equipment_name': currentEquipment,
          'problem_description': problemDescription,
          'problem_date': problemDate,
          'repair_need': repairType?.name,
          'problem_photo_id_list': fileIds,
        };
    }
  }
}
