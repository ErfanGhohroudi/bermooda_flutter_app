part of '../../../../data.dart';

/// Support and Procurement Response Parameters
class SupportProcurementRequestEntity extends BaseResponseParams {
  SupportProcurementRequestEntity({
    super.slug,
    super.currentReviewer,
    super.requestingUser,
    super.reviewerUsers,
    required super.categoryType,
    super.description,
    super.status,
    required this.supportType,
    this.equipmentType,
    this.quantity,
    this.suggestedModel,
    this.urgencyLevel,
    this.supplyType,
    this.currentEquipment,
    this.problemDescription,
    this.date,
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
  final String? date;
  final RepairType? repairType;
  final List<MainFileReadDto>? files;

  @override
  RequestCategoryType get categoryType => RequestCategoryType.support_logistics;

  factory SupportProcurementRequestEntity.fromJson(final String str) => SupportProcurementRequestEntity.fromMap(json.decode(str));

  factory SupportProcurementRequestEntity.fromMap(final Map<String, dynamic> json) => SupportProcurementRequestEntity(
        slug: json["slug"],
        requestingUser: json["requesting_user"] == null ? null : UserReadDto.fromMap(json["requesting_user"]),
        currentReviewer: json["user_decided"] == null ? null : AcceptorUserReadDto.fromMap(json["user_decided"]),
        reviewerUsers:
            json["request_accepter_users"] == null ? [] : List<AcceptorUserReadDto>.from(json["request_accepter_users"].map((final x) => AcceptorUserReadDto.fromMap(x))),
        categoryType: RequestCategoryType.values.firstWhereOrNull((final e) => e.name == json["main_category"]) ?? RequestCategoryType.support_logistics,
        description: json["description"],
        status: json["status"] == null ? null : StatusType.values.firstWhereOrNull((final e) => e.name == json["status"]),
        supportType: SupportType.values.firstWhereOrNull((final e) => e.name == json["subcategory"]) ?? SupportType.equipment_purchase,
        equipmentType: json["equipment_type"] == null ? null : EquipmentType.values.firstWhereOrNull((final e) => e.name == json["equipment_type"]),
        quantity: json["equipment_quantity"] ?? json["required_quantity"],
        suggestedModel: json["suggested_model"],
        urgencyLevel: json["urgency_level"] == null ? null : UrgencyLevel.values.firstWhereOrNull((final e) => e.name == json["urgency_level"]),
        supplyType: json["supply_type"],
        currentEquipment: json["current_equipment_name"],
        problemDescription: json["problem_description"],
        date: json["problem_date"],
        repairType: json["repair_need"] == null ? null : RepairType.values.firstWhereOrNull((final e) => e.name == json["repair_need"]),
        files: _extractFiles(json),
      );

  static List<MainFileReadDto>? _extractFiles(final Map<String, dynamic> json) {
    if (json["problem_photo"] != null && json["problem_photo"] != []) {
      return List<MainFileReadDto>.from(json["problem_photo"].map((final x) => MainFileReadDto.fromMap(x)));
    }
    return null;
  }

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
          'problem_date': date,
          'repair_need': repairType?.name,
          'problem_photo_id_list': fileIds,
        };
    }
  }
}
