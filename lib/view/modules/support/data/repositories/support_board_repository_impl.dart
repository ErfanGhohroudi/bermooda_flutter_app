import 'package:bermooda_business/core/utils/enums/enums.dart';
import 'package:u/utilities.dart';

import '../../../../../data/data.dart';
import '../../domain/entities/support_customer_entity.dart';
import '../../domain/repositories/support_board_repository.dart';
import '../../domain/entities/support_section.dart';
import '../datasources/support_board_datasource.dart';
import '../models/support_customer_dto.dart';
import '../models/support_section_dto.dart';
import '../../../../../../core/widgets/kanban_board/view_models/item_view_model.dart';
import '../../../../../../core/widgets/kanban_board/view_models/section_view_model.dart';

class SupportBoardRepositoryImpl implements SupportBoardRepository {
  final KanbanDatasource _datasource = Get.find<KanbanDatasource>();
  final SupportBoardDatasource _boardDatasource = Get.find();
  final MemberDatasource _memberDatasource = Get.find();

  @override
  Future<SupportCustomer> createCustomer({
    required final int departmentId,
    required final int sectionId,
    required final String fullName,
    required final String phoneNumber,
  }) {
    final Completer<SupportCustomer> completer = Completer();
    _boardDatasource.createCustomer(
      departmentId: departmentId,
      sectionId: sectionId,
      fullName: fullName,
      phoneNumber: phoneNumber,
      onResponse: (final response) {
        if (response.result == null) return completer.completeError(response);
        completer.complete(SupportCustomer.fromDto(response.result!));
      },
      onError: (final errorResponse) {
        completer.completeError(errorResponse);
      },
    );
    return completer.future;
  }

  @override
  void getBoard({
    required final String departmentSlug,
    required final Function(List<Section<SupportSection, SupportCustomer>> sections) onResponse,
    required final Function(GenericResponse<dynamic> error) onError,
  }) {
    _datasource.getAllBoardSectionsAndItems<SupportSection, SupportCustomer>(
      slug: departmentSlug,
      requestType: KanbanRequestType.support,
      sectionFromMap: (final json) => SupportSection.fromDto(SupportSectionReadDto.fromMap(json)),
      itemListFromMap: (final list) => list
          .map(
            (final json) => Item<SupportCustomer>(
              id: json['id']?.toString() ?? '',
              slug: json['slug']?.toString() ?? '',
              data: SupportCustomer.fromDto(SupportCustomerReadDto.fromMap(json['related_obj']?['data'] ?? json)),
            ),
          )
          .toList(),
      onResponse: onResponse,
      onError: onError,
      withRetry: true,
    );
  }

  @override
  void moveCard({
    required final String cardSlug,
    required final String targetSectionSlug,
    required final String? previousCardSlug,
    required final String? nextCardSlug,
    required final Function(GenericResponse<dynamic> response) onResponse,
    required final Function(GenericResponse<dynamic> error) onError,
  }) {
    _datasource.moveACard(
      cardSlug: cardSlug,
      targetSectionSlug: targetSectionSlug,
      previousCardSlug: previousCardSlug,
      nextCardSlug: nextCardSlug,
      onResponse: onResponse,
      onError: onError,
    );
  }

  @override
  Future<SupportSection> createSection({
    required final int departmentId,
    required final String title,
    required final LabelColors color,
  }) {
    final Completer<SupportSection> completer = Completer();
    _boardDatasource.createSection(
      departmentId: departmentId,
      title: title,
      color: color,
      onResponse: (final response) {
        if (response.result == null) return completer.completeError(response);
        completer.complete(SupportSection.fromDto(response.result!));
      },
      onError: (final errorResponse) {
        completer.completeError(errorResponse);
      },
    );
    return completer.future;
  }

  @override
  Future<SupportSection> updateSection({
    required final int id,
    required final String title,
    required final LabelColors color,
  }) {
    final Completer<SupportSection> completer = Completer();
    _boardDatasource.updateSection(
      id: id,
      title: title,
      color: color,
      onResponse: (final response) {
        if (response.result == null) return completer.completeError(response);
        completer.complete(SupportSection.fromDto(response.result!));
      },
      onError: (final errorResponse) {
        completer.completeError(errorResponse);
      },
    );
    return completer.future;
  }

  @override
  Future<void> deleteSection(final int id) {
    final Completer<void> completer = Completer();
    _boardDatasource.deleteSection(
      id: id,
      onResponse: (final response) {
        if (response.result == null) return completer.completeError(response);
        completer.complete();
      },
      onError: (final errorResponse) {
        completer.completeError(errorResponse);
      },
    );
    return completer.future;
  }

  @override
  Future<List<UserReadDto>> getAllMembers() {
    final Completer<List<UserReadDto>> completer = Completer();
    _memberDatasource.getAllMembers(
      perName: PermissionName.support,
      onResponse: (final response) {
        final list = response.resultList ?? [];
        completer.complete(list);
      },
      onError: (final errorResponse) {
        completer.completeError(errorResponse);
      },
      withRetry: true,
    );
    return completer.future;
  }
}
