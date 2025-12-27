import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../core/services/permission_service.dart';
import '../../../../data/data.dart';
import 'enums/filter_enum.dart';

class MyCasesController extends GetxController {
  MyCasesController({
    required this.legalDepartmentId,
  });

  final int legalDepartmentId;
  final MyContractDatasource _datasource = Get.find();
  final PermissionService _perService = Get.find();
  final RefreshController refreshController = RefreshController();
  final Rx<PageState> pageState = PageState.initial.obs;
  final TextEditingController searchCtrl = TextEditingController();
  final RxList<dynamic> items = <dynamic>[].obs; // Mix of FollowUpReadDto and SubtaskReadDto
  final Rx<MyContractFilterType> selectedFilter = MyContractFilterType.all.obs;
  int pageNumber = 1;

  // Advanced filter properties
  String? filterItemType;
  String? filterFromDate;
  String? filterToDate;
  String? filterFromDueDate;
  String? filterToDueDate;
  int? filterResponsibleId;
  int? filterLabelId;

  bool get hasActiveFilters =>
      filterItemType != null ||
      filterFromDate != null ||
      filterToDate != null ||
      filterFromDueDate != null ||
      filterToDueDate != null ||
      filterResponsibleId != null ||
      filterLabelId != null;

  bool get haveAdminAccess => _perService.haveLegalAdminAccess;


  @override
  void onInit() {
    onRefresh();
    super.onInit();
  }

  @override
  void onClose() {
    refreshController.dispose();
    searchCtrl.dispose();
    items.close();
    pageState.close();
    selectedFilter.close();
    super.onClose();
  }

  void setFilter(final MyContractFilterType value) {
    if (selectedFilter.value == value) return;
    selectedFilter(value);
    pageState.loading();
    onRefresh();
  }

  void onSearch() {
    pageState.loading();
    pageNumber = 1;
    _getMyContracts();
  }

  void onTryAgain() {
    pageState.initial();
    pageNumber = 1;
    _getMyContracts();
  }

  void onRefresh() {
    pageNumber = 1;
    _getMyContracts();
  }

  void onLoadMore() {
    pageNumber++;
    _getMyContracts();
  }

  void applyAdvancedFilters({
    final String? itemType,
    final String? fromDate,
    final String? toDate,
    final String? fromDueDate,
    final String? toDueDate,
    final int? responsibleId,
    final int? labelId,
  }) {
    filterItemType = itemType;
    filterFromDate = fromDate;
    filterToDate = toDate;
    filterFromDueDate = fromDueDate;
    filterToDueDate = toDueDate;
    filterResponsibleId = responsibleId;
    filterLabelId = labelId;
    pageState.loading();
    onRefresh();
  }

  void _getMyContracts() {
    // Determine status filters based on selectedFilter
    bool? isTracked;
    bool? isCompleted;

    switch (selectedFilter.value) {
      case MyContractFilterType.all:
        isTracked = null;
        isCompleted = null;
        break;
      case MyContractFilterType.completed:
        // For mixed items, we need to handle both tracking and checklist
        // API will filter appropriately based on item_type
        isTracked = true;
        isCompleted = true;
        break;
      case MyContractFilterType.notCompleted:
        isTracked = false;
        isCompleted = false;
        break;
    }

    // Convert Jalali dates to YYYY-MM-DD format if needed
    String? convertDate(final String? date) {
      if (date == null || date.isEmpty) return null;
      // If date is already in YYYY-MM-DD format, return as is
      if (date.contains('-') && date.length == 10) return date;
      // Otherwise convert from Jalali format (YYYY/MM/DD) to (YYYY-MM-DD)
      return date.replaceAll('/', '-');
    }

    _datasource.getMyContracts(
      legalDepartmentId: legalDepartmentId,
      pageNumber: pageNumber,
      itemType: filterItemType,
      isTracked: isTracked,
      isCompleted: isCompleted,
      responsibleId: filterResponsibleId,
      trackerId: filterResponsibleId,
      labelId: filterLabelId,
      fromDate: convertDate(filterFromDate),
      toDate: convertDate(filterToDate),
      fromDueDate: convertDate(filterFromDueDate),
      toDueDate: convertDate(filterToDueDate),
      search: searchCtrl.text.trim().isNotEmpty ? searchCtrl.text.trim() : null,
      onResponse: (final response) {
        if (response.resultList == null || items.subject.isClosed) return;
        if (pageNumber == 1) {
          items.assignAll(response.resultList ?? []);
          refreshController.refreshCompleted();
        } else {
          items.addAll(response.resultList ?? []);
        }

        if (response.extra?.next == null) {
          refreshController.loadNoData();
        } else {
          refreshController.loadComplete();
        }

        pageState.loaded();
      },
      onError: (final errorResponse) {
        if (pageState.isInitial()) {
          pageState.error();
        }
        if (pageNumber == 1) {
          refreshController.refreshFailed();
        } else {
          refreshController.loadFailed();
        }
      },
    );
  }

  void updateItem(final dynamic model) {
    for (var i = 0; i < items.length; i++) {
      final currentItem = items[i];
      String? currentSlug;
      String? currentId;

      if (currentItem is FollowUpReadDto) {
        currentSlug = currentItem.slug;
      } else if (currentItem is SubtaskReadDto) {
        currentId = currentItem.id;
      }

      String? modelSlug;
      String? modelId;

      if (model is FollowUpReadDto) {
        modelSlug = model.slug;
      } else if (model is SubtaskReadDto) {
        modelId = model.id;
      }

      if ((currentSlug != null && currentSlug == modelSlug) || (currentId != null && currentId == modelId)) {
        items[i] = model;
        break;
      }
    }
  }

  void removeItem(final dynamic model) {
    if (model is FollowUpReadDto) {
      items.removeWhere((final e) => e is FollowUpReadDto && e.slug == model.slug);
    } else if (model is SubtaskReadDto) {
      items.removeWhere((final e) => e is SubtaskReadDto && e.id == model.id);
    }
  }
}

