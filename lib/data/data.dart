import 'package:equatable/equatable.dart';
import 'package:u/utilities.dart';
import 'package:dio/dio.dart' as dio;

import '../view/modules/subscription/enums/max_contract_count.dart';
import '../core/navigator/navigator.dart';
import '../core/theme.dart';
import '../core/utils/extensions/money_extensions.dart';
import '../core/widgets/kanban_board/view_models/item_view_model.dart';
import '../core/widgets/kanban_board/view_models/section_view_model.dart';
import '../core/loading/loading.dart';
import '../core/utils/extensions/date_extensions.dart';
import '../core/services/secure_storage_service.dart';
import '../core/utils/enums/enums.dart';
import '../core/core.dart';
import '../core/utils/enums/request_enums.dart';
import '../view/modules/crm/my_followups/enums/filter_enum.dart';
import '../view/modules/requests/entities/reviewer_entity.dart';
import '../view/modules/requests/list/request_list_page.dart';
import 'api_client.dart';
import 'remote_datasource/label/interfaces/label_interface.dart';
import 'remote_datasource/report/interfaces/report_interface.dart';
import '../view/modules/reports/models/report_params.dart';

part 'generic_response.dart';

/// params ////////////////////////////////////////////////////////////////////////////////////////////
/// contract
part 'dto/params/contract/contract_params.dart';
/// request
part 'dto/params/request/base_request_params.dart';
part 'dto/params/request/employment_request_params.dart';
part 'dto/params/request/general_request_params.dart';
part 'dto/params/request/leave_attendance_request_params.dart';
part 'dto/params/request/mission_work_request_params.dart';
part 'dto/params/request/overtime_request_params.dart';
part 'dto/params/request/support_procurement_request_params.dart';
part 'dto/params/request/welfare_financial_request_params.dart';

/// workspace
part 'dto/params/workspace/base_workspace_required_info_params.dart';
part 'dto/params/workspace/legal_workspace_required_info_params.dart';
part 'dto/params/workspace/person_workspace_required_info_params.dart';
part 'dto/params/workspace/workspace_info_params.dart';

///
part 'dto/params/check_in_out_params.dart';
part 'dto/params/customer_params.dart';
part 'dto/params/customer_status_params.dart';
part 'dto/params/login_params.dart';
part 'dto/params/meeting_params.dart';
part 'dto/params/member_params.dart';
part 'dto/params/task_params.dart';

/// response ///////////////////////////////////////////////////////////////////////////////////////////
// calendar models
part 'dto/response/calendar/calendar.dart';
part 'dto/response/calendar/events.dart';
part 'dto/response/calendar/meeting.dart';
// CRM models
part 'dto/response/crm/crm.dart';
part 'dto/response/crm/crm_section.dart';
part 'dto/response/crm/crm_statistics_summary.dart';
part 'dto/response/crm/crm_user_statistics_summary.dart';
part 'dto/response/crm/currency_unit.dart';
part 'dto/response/crm/customer.dart';
part 'dto/response/crm/customers_bank_document.dart';
part 'dto/response/crm/follow_up.dart';
part 'dto/response/crm/invoice.dart';
part 'dto/response/crm/status_reason.dart';
// Dashboard models
part 'dto/response/dashboard/crm_summery.dart';
part 'dto/response/dashboard/online_users_summery.dart';
part 'dto/response/dashboard/project_summery.dart';
// Human Resource models
part 'dto/response/human_resource/board_member.dart';
part 'dto/response/human_resource/hr_department.dart';
part 'dto/response/human_resource/hr_section.dart';
part 'dto/response/human_resource/hr_statistics_summary.dart';
part 'dto/response/human_resource/hr_user_statistics_summary.dart';
part 'dto/response/human_resource/member.dart';
part 'dto/response/human_resource/member_activity.dart';
part 'dto/response/human_resource/timesheet.dart';
part 'dto/response/human_resource/monthly_attendance_statistics.dart';
part 'dto/response/human_resource/work_shift.dart';
// Import Customer Exel models
part 'dto/response/import_customer_exel/exel_mapping_result.dart';
part 'dto/response/import_customer_exel/exel_result.dart';
part 'dto/response/import_customer_exel/exel_upload_result.dart';
// Legal models
part 'dto/response/legal/contract.dart';
part 'dto/response/legal/legal_case.dart';
part 'dto/response/legal/legal_case_document.dart';
part 'dto/response/legal/legal_department.dart';
part 'dto/response/legal/legal_section.dart';
part 'dto/response/legal/legal_statistics_summary.dart';
part 'dto/response/legal/legal_user_statistics_summary.dart';
// Notification models
part 'dto/response/notification/interfaces/notification.dart';
part 'dto/response/notification/response/customer_notification.dart';
part 'dto/response/notification/response/followup_notification.dart';
part 'dto/response/notification/response/subtask_notification.dart';
part 'dto/response/notification/response/task_notification.dart';
// Project models
part 'dto/response/project/project.dart';
part 'dto/response/project/project_section.dart';
part 'dto/response/project/project_statistics_summary.dart';
part 'dto/response/project/project_user_statistics_summary.dart';
part 'dto/response/project/subtask.dart';
part 'dto/response/project/task.dart';
// Report models
part 'dto/response/report/entities/report_contract_entity.dart';
part 'dto/response/report/entities/report_invoice_entity.dart';
part 'dto/response/report/interfaces/report.dart';
part 'dto/response/report/interfaces/report_archive.dart';
part 'dto/response/report/response/report_contract.dart';
part 'dto/response/report/response/report_followup_archive.dart';
part 'dto/response/report/response/report_invoice.dart';
part 'dto/response/report/response/report_note.dart';
part 'dto/response/report/response/report_subtask_archive.dart';
part 'dto/response/report/response/report_update.dart';
// Request models
part 'dto/response/request/human_resource/acceptor_user.dart';
part 'dto/response/request/human_resource/base_response.dart';
part 'dto/response/request/human_resource/employment_response.dart';
part 'dto/response/request/human_resource/general_response.dart';
part 'dto/response/request/human_resource/leave_attendance_response.dart';
part 'dto/response/request/human_resource/mission_work_response.dart';
part 'dto/response/request/human_resource/overtime_response.dart';
part 'dto/response/request/human_resource/support_procurement_response.dart';
part 'dto/response/request/human_resource/welfare_financial_response.dart';
part 'dto/response/request/human_resource/response_factory.dart';
// subscription models
part 'dto/response/subscription/bank_account_info.dart';
part 'dto/response/subscription/module.dart';
part 'dto/response/subscription/subscription.dart';
part 'dto/response/subscription/subscription_invoice.dart';
// Other models
part 'dto/response/app_update.dart';
part 'dto/response/banner.dart';
part 'dto/response/dropdown_item.dart';
part 'dto/response/label.dart';
part 'dto/response/login.dart';
part 'dto/response/letter.dart';
part 'dto/response/main_file.dart';
part 'dto/response/media.dart';
part 'dto/response/notice.dart';
part 'dto/response/otp.dart';
part 'dto/response/request.dart';
part 'dto/response/shift_status.dart';
part 'dto/response/user.dart';
part 'dto/response/workspace.dart';
part 'dto/response/workspace_info.dart';

/// remote datasource //////////////////////////////////////////////////////////////////////////////
// CRM_Manager
part 'remote_datasource/crm_manager/crm_archive_datasource.dart';
part 'remote_datasource/crm_manager/crm_datasource.dart';
part 'remote_datasource/crm_manager/crm_section_datasource.dart';
part 'remote_datasource/crm_manager/crm_statistics_datasource.dart';
part 'remote_datasource/crm_manager/customer_datasource.dart';
part 'remote_datasource/crm_manager/customer_exel_import_datasource.dart';
part 'remote_datasource/crm_manager/customer_industry_subcategory_datasource.dart';
part 'remote_datasource/crm_manager/customer_label_datasource.dart';
part 'remote_datasource/crm_manager/customer_status_reason_datasource.dart';
part 'remote_datasource/crm_manager/customers_bank_datasource.dart';
part 'remote_datasource/label/customer_invoice_label_datasource.dart';
part 'remote_datasource/label/customer_contract_label_datasource.dart';
// Followup
part 'remote_datasource/followup/follow_up_datasource.dart';
part 'remote_datasource/followup/customer_follow_up_datasource.dart';
part 'remote_datasource/followup/legal_follow_up_datasource.dart';
// Home_Page_Manager
part 'remote_datasource/home_page_manager/banner_datasource.dart';
part 'remote_datasource/home_page_manager/notice_datasource.dart';
// Human_Resources_Manager
part 'remote_datasource/human_resources_manager/attendance_datasource.dart';
part 'remote_datasource/human_resources_manager/hr_section_datasource.dart';
part 'remote_datasource/human_resources_manager/hr_statistics_datasource.dart';
part 'remote_datasource/human_resources_manager/human_resource_datasource.dart';
part 'remote_datasource/human_resources_manager/member_datasource.dart';
part 'remote_datasource/human_resources_manager/work_shift_datasource.dart';
// Kanban_board_Manager
part 'remote_datasource/kanban_board_manager/kanban_datasource.dart';
// Label
part 'remote_datasource/label/label_datasource.dart';
part 'remote_datasource/label/base_label_datasource.dart';
part 'remote_datasource/label/legal_label_datasource.dart';
// Legal_Manager
part 'remote_datasource/legal_manager/contract_datasource.dart';
part 'remote_datasource/legal_manager/legal_case_datasource.dart';
part 'remote_datasource/legal_manager/legal_datasource.dart';
part 'remote_datasource/legal_manager/legal_section_datasource.dart';
part 'remote_datasource/legal_manager/legal_statistics_datasource.dart';
part 'remote_datasource/legal_manager/my_contract_datasource.dart';
// Project_Manager
part 'remote_datasource/project_manager/project_datasource.dart';
part 'remote_datasource/project_manager/project_statistics_datasource.dart';
part 'remote_datasource/project_manager/task_archive_datasource.dart';
part 'remote_datasource/project_manager/task_datasource.dart';
part 'remote_datasource/label/task_invoice_label_datasource.dart';
part 'remote_datasource/label/task_contract_label_datasource.dart';
// Report
part 'remote_datasource/report/history_datasource.dart';
part 'remote_datasource/report/customer_report_datasource.dart';
part 'remote_datasource/report/legal_case_report_datasource.dart';
part 'remote_datasource/report/task_report_datasource.dart';
// Request
part 'remote_datasource/request/employee_request_datasource.dart';
// Subtask
part 'remote_datasource/subtask/subtask_datasource.dart';
// Other
part 'remote_datasource/access_token_datasource.dart';
part 'remote_datasource/add_fcm_datasource.dart';
part 'remote_datasource/calendar_datasource.dart';
part 'remote_datasource/dashboard_datasource.dart';
part 'remote_datasource/dropdown_datasource.dart';
part 'remote_datasource/login_datasource.dart';
part 'remote_datasource/mail_datasource.dart';
part 'remote_datasource/meeting_datasource.dart';
part 'remote_datasource/notification_datasource.dart';
part 'remote_datasource/register_datasource.dart';
part 'remote_datasource/subscription_datasource.dart';
part 'remote_datasource/subscription_invoice_datasource.dart';
part 'remote_datasource/update_datasource.dart';
part 'remote_datasource/upload_customer_exel_datasource.dart';
part 'remote_datasource/upload_file_datasource.dart';
part 'remote_datasource/user_datasource.dart';
part 'remote_datasource/workspace_datasource.dart';

T? removeNullEntries<T>(final T? json) {
  if (json == null) {
    return null;
  }

  if (json is List) {
    // حذف آیتم‌های null از لیست
    json.removeWhere((final item) => item == null);
    // اعمال بازگشتی تابع روی آیتم‌های باقی‌مانده لیست
    for (final item in json) {
      removeNullEntries(item);
    }
  } else if (json is Map) {
    // حذف کلیدهایی که مقدارشان null است (یا خود کلید null است)
    json.removeWhere((final key, final value) => key == null || value == null);
    // اعمال بازگشتی تابع روی مقادیر باقی‌مانده مپ
    for (final value in json.values) {
      removeNullEntries(value);
    }
  }

  return json;
}
