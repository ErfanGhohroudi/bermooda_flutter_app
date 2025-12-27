import '../../../../../core/widgets/kanban_board/view_models/item_view_model.dart';
import '../../../../../data/data.dart';

class HRBoardWsMessages {
  // get all Sections and Customers
  Map<String, dynamic> readSections({
    required final String? groupCrmId,
  }) {
    return {
      "command":"customer_list",
      "data":{
        "group_crm_id": groupCrmId,
      }
    };
  }

  Map<String, dynamic> move({
    required final String? groupCrmId,
    required final String? targetSectionId,
    required final String? customerId,
    required final List<Item<CustomerReadDto>>? targetSectionCustomers,
  }) {
    final ordersCustomer = targetSectionCustomers == null
        ? null
        : List<Map<String, dynamic>>.generate(targetSectionCustomers.length, (final index) {
            final customer = targetSectionCustomers[index];
            return {
              "customer_id": customer.id,
              "order": index + 1,
            };
          });

    return {
      "command":"move_a_customer",
      "data":{
        "group_crm_id": groupCrmId,
        "label_id": targetSectionId,
        "customer_id": customerId,
        "customer_orders": ordersCustomer,
      }
    };
  }

  Map<String, dynamic> changeCustomerIsFollowed({
    required final String? groupCrmId,
    required final int? customerId,
    required final bool status,
  }) {
    return {
      "command": "change_is_followed",
      "data":{
        "group_crm_id": groupCrmId,
        "customer_id": customerId,
        "is_followed": status,
      }
    };
  }

  Map<String, dynamic> readAllMessages({
    required final String? groupCrmId,
    required final int pageNumber,
    final int? perPageCount = 20,
  }) {
    return {
      "command": "crm_read_all_messages",
      "data":{
        "group_crm_id": groupCrmId,
        "page_number": pageNumber, // optional
        "per_page_count": perPageCount, // optional
      }
    };
  }

  Map<String, dynamic> createMessage({
    required final String? groupCrmId,
    required final String text,
    final List<int>? filesIds,
    final int? repliedMessageId,
  }) {
    return {
      "command":"crm_create_a_message",
      "data":{
        "group_crm_id": groupCrmId,
        "file_id_list": filesIds, // optional
        "replay_id": repliedMessageId,  // optional
        "body": text,
      }
    };
  }

  Map<String, dynamic> editMessage({
    required final String? groupCrmId,
    required final int messageId,
    required final String text,
  }) {
    return {
      "command":"crm_edit_message",
      "data": {
        "group_crm_id": groupCrmId,
        "message_id": messageId,
        "body": text,
      }
    };
  }
}
