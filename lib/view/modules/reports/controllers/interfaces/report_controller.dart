import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../data/data.dart';
import '../../../../../data/remote_datasource/report/interfaces/report_interface.dart';
import '../../../../../data/remote_datasource/label/interfaces/label_interface.dart';
import '../../create/create_report.dart';
import '../../models/report_params.dart';

class ReportController extends GetxController {
  final IReportDatasource _datasource;
  final ILabelDatasource? _invoiceLabelDatasource;
  final ILabelDatasource? _contractLabelDatasource;
  final int? sourceId;
  final bool showFilters;
  final bool showTimelineIndicators;
  final bool showFloatingActionButton;
  final bool canEdit;

  ReportController({
    required final IReportDatasource datasource,
    required final ILabelDatasource? invoiceLabelDatasource,
    required final ILabelDatasource? contractLabelDatasource,
    required this.sourceId,
    this.showFilters = false,
    this.showTimelineIndicators = true,
    this.showFloatingActionButton = false,
    this.canEdit = true,
    final ReportType initialFilter = ReportType.all,
  }) : _datasource = datasource,
       _invoiceLabelDatasource = invoiceLabelDatasource,
       _contractLabelDatasource = contractLabelDatasource,
       selectedFilter = initialFilter.obs;

  final RxList<IReportReadDto> _items = <IReportReadDto>[].obs;
  final RefreshController _refreshController = RefreshController();
  final ScrollController _scrollController = ScrollController();
  final List<ReportType> filterList = ReportType.values;
  int _pageNumber = 1;

  late final Rx<ReportType> selectedFilter;

  final Rx<PageState> pageState = PageState.initial.obs;

  RxList<IReportReadDto> get histories => _items;

  RefreshController get refreshController => _refreshController;

  ScrollController get scrollController => _scrollController;

  @override
  void onInit() {
    pageState.loading();
    onRefresh();
    super.onInit();
  }

  @override
  void onClose() {
    _refreshController.dispose();
    _scrollController.dispose();
    super.onClose();
  }

  void setFilter(final ReportType filter) {
    if (selectedFilter.value == filter) return;
    selectedFilter(filter);
    pageState.loading();
    onRefresh();
  }

  void onRefresh() {
    _pageNumber = 1;
    _getHistory();
  }

  void onLoadMore() {
    _pageNumber++;
    _getHistory();
  }

  void _getHistory() {
    _datasource.getAllReports(
      sourceId: sourceId,
      pageNumber: _pageNumber,
      filter: selectedFilter.value,
      onResponse: (final response) {
        if (_pageNumber == 1) {
          _items.assignAll(response.resultList!);
          _refreshController.refreshCompleted();
        } else {
          _items.addAll(response.resultList!);
        }

        if (response.extra?.next == null) {
          _refreshController.loadNoData();
        } else {
          _refreshController.loadComplete();
        }

        pageState.loaded();
      },
      onError: (final errorResponse) {
        if (_pageNumber == 1) {
          _refreshController.refreshFailed();
        } else {
          _refreshController.loadFailed();
        }
        _items.refresh();
      },
    );
  }

  void createNewHistory(
    final IReportParams params, {
    required final VoidCallback onResponse,
    required final VoidCallback onError,
  }) {
    _datasource.create(
      sourceId: sourceId,
      params: params,
      onResponse: (final response) {
        if (response.result != null) {
          final selectedFilterIsAll = selectedFilter.value == ReportType.all;
          final itemIsForThisSelectedFilter = selectedFilter.value == response.result!.type;

          if (selectedFilterIsAll || itemIsForThisSelectedFilter) {
            _items.insert(0, response.result!);
            _scrollController.animateTo(0, duration: 1.seconds, curve: Curves.ease);
          }
        }
        onResponse();
      },
      onError: (final errorResponse) => onError(),
      withRetry: true,
    );
  }

  void showCreateForm() {
    if (canEdit == false || showFloatingActionButton == false) return;

    String? sheetTitle;

    switch (selectedFilter.value) {
      case ReportType.update || ReportType.archive:
        break;
      case ReportType.all:
        sheetTitle = s.newReport;
        break;
      case ReportType.note:
        sheetTitle = s.note;
        break;
    }

    if (sheetTitle == null) return;

    bottomSheetWithNoScroll(
      title: sheetTitle,
      child: CreateReportForm(
        reportController: this,
        invoiceLabelDatasource: _invoiceLabelDatasource,
        contractLabelDatasource: _contractLabelDatasource,
        // invoiceLabelDatasource: Get.find<CustomerInvoiceLabelDatasource>(),
        // contractLabelDatasource: Get.find<CustomerContractLabelDatasource>(),
      ),
    );
  }
}
