// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(item) =>
      "* Only members selected as Managers and Specialists will have access to this ${item}.";

  static String m1(count) => "and ${count} more";

  static String m2(item) => "Are you sure you want to delete this ${item}?";

  static String m3(name) =>
      "Dear ${name}, to access your personalized business dashboard, you need to complete your business information and activate the dashboard.";

  static String m4(step) => "Change step to (${step})?";

  static String m5(percentage) =>
      "Change subtask progress to \'${percentage}\'?";

  static String m6(count) => "${count} days without conflict will be applied";

  static String m7(count, total) =>
      "${count} of ${total} installments have been paid";

  static String m8(item) => "\"${item}\" is required";

  static String m9(count) => "Maximum ${count} files can be selected.";

  static String m10(phoneNumber) =>
      "Enter the 6-digit code sent to (${phoneNumber}).";

  static String m11(path) => "PDF successfully saved at:\n${path}";

  static String m12(item) => "Please add at least one ${item}.";

  static String m13(name) => "Shift ${name} conflicts with all selected days";

  static String m14(name, count) =>
      "shift ${name} conflicts with ${count} days";

  static String m15(name) => "Switched to (${name}) business";

  static String m16(item) => "This ${item} is already exist";

  static String m17(length) =>
      "The entered value is too short (minimum ${length} characters)";

  static String m18(time) => "You are ${time} early.";

  static String m19(time) => "You are ${time} late.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "absence": MessageLookupByLibrary.simpleMessage("Absence"),
    "accept": MessageLookupByLibrary.simpleMessage("Accept"),
    "accessLevels": MessageLookupByLibrary.simpleMessage("Access Levels"),
    "accessibleMembers": MessageLookupByLibrary.simpleMessage(
      "Accessible Members",
    ),
    "accessibleMembersHelper": m0,
    "accommodationType": MessageLookupByLibrary.simpleMessage(
      "Accommodation Type",
    ),
    "account": MessageLookupByLibrary.simpleMessage("Account"),
    "accountOwnerName": MessageLookupByLibrary.simpleMessage(
      "Account Owner Name",
    ),
    "accountPhoto": MessageLookupByLibrary.simpleMessage("Account Photo"),
    "activatedModules": MessageLookupByLibrary.simpleMessage(
      "Activated Modules",
    ),
    "active": MessageLookupByLibrary.simpleMessage("Active"),
    "activeModules": MessageLookupByLibrary.simpleMessage("Active Modules"),
    "addMember": MessageLookupByLibrary.simpleMessage("Add Member"),
    "addMemberDialog": MessageLookupByLibrary.simpleMessage(
      "Add to members list?",
    ),
    "addReviewers": MessageLookupByLibrary.simpleMessage("Assign Reviewers"),
    "addRow": MessageLookupByLibrary.simpleMessage("Add Row"),
    "addShift": MessageLookupByLibrary.simpleMessage("Add Shift"),
    "addText": MessageLookupByLibrary.simpleMessage("Add"),
    "additionalInfo": MessageLookupByLibrary.simpleMessage("Additional Info"),
    "address": MessageLookupByLibrary.simpleMessage("Address"),
    "admin": MessageLookupByLibrary.simpleMessage("Admin"),
    "all": MessageLookupByLibrary.simpleMessage("All"),
    "allowanceType": MessageLookupByLibrary.simpleMessage("Allowance Type"),
    "allowedAttendanceMethods": MessageLookupByLibrary.simpleMessage(
      "Allowed Attendance Methods",
    ),
    "allowedExelFormatsAndSize": MessageLookupByLibrary.simpleMessage(
      "Allowed formats: XLSX, XLS, CSV (maximum 10 MB)",
    ),
    "amount": MessageLookupByLibrary.simpleMessage("Amount"),
    "andMore": m1,
    "apiKey": MessageLookupByLibrary.simpleMessage("API Key"),
    "appName": MessageLookupByLibrary.simpleMessage("Bermooda"),
    "applicant": MessageLookupByLibrary.simpleMessage("Applicant"),
    "apply": MessageLookupByLibrary.simpleMessage("Apply"),
    "applyFilter": MessageLookupByLibrary.simpleMessage("Apply"),
    "approve": MessageLookupByLibrary.simpleMessage("Approve"),
    "archive": MessageLookupByLibrary.simpleMessage("Archive"),
    "archiveRemoved": MessageLookupByLibrary.simpleMessage("Archive/Removed"),
    "areYouSureToArchiveCategory": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to archive this category?",
    ),
    "areYouSureToArchiveCustomer": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to archive this customer?",
    ),
    "areYouSureToArchiveDepartment": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to archive this department?",
    ),
    "areYouSureToArchiveProject": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to archive this project?",
    ),
    "areYouSureToChangePhoneNumber": MessageLookupByLibrary.simpleMessage(
      "Do you want to change the phone number?",
    ),
    "areYouSureToDeleteBusiness": MessageLookupByLibrary.simpleMessage(
      "Do you want to delete this business?",
    ),
    "areYouSureToDeleteWarehouse": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this warehouse?",
    ),
    "areYouSureToRemoveMember": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to remove this user? They will immediately lose access to the dashboard, and their assigned tasks will need to be reassigned.",
    ),
    "areYouSureYouWantToDeleteItem": m2,
    "areYouSureYouWantToLogOut": MessageLookupByLibrary.simpleMessage(
      "Do you want to log out?",
    ),
    "assets": MessageLookupByLibrary.simpleMessage("Assets"),
    "assignReviewersToRequestInfoText": MessageLookupByLibrary.simpleMessage(
      "Please assign one or more reviewers to this request.",
    ),
    "assignee": MessageLookupByLibrary.simpleMessage("Assignee"),
    "attachment": MessageLookupByLibrary.simpleMessage("Attachment"),
    "attachments": MessageLookupByLibrary.simpleMessage("Attachments"),
    "attendance": MessageLookupByLibrary.simpleMessage("Attendance"),
    "attendanceRate": MessageLookupByLibrary.simpleMessage("Attendance Rate"),
    "audio": MessageLookupByLibrary.simpleMessage("Audio"),
    "authenticationNeedsDialogText": m3,
    "autoApproveAfterRegistration": MessageLookupByLibrary.simpleMessage(
      "Auto-approve immediately after registration",
    ),
    "availableOnAdvancedPlan": MessageLookupByLibrary.simpleMessage(
      "This feature is only available on the Advanced plan.",
    ),
    "back": MessageLookupByLibrary.simpleMessage("Back"),
    "backToPreviousStepDialogDescription": MessageLookupByLibrary.simpleMessage(
      "Do you want to go back to the previous step?",
    ),
    "balance": MessageLookupByLibrary.simpleMessage("Balance"),
    "balancingRemainingInstallments": MessageLookupByLibrary.simpleMessage(
      "Balancing the remaining installments",
    ),
    "bank": MessageLookupByLibrary.simpleMessage("Bank"),
    "bankAccountInformation": MessageLookupByLibrary.simpleMessage(
      "Bank Account Information",
    ),
    "basicInfo": MessageLookupByLibrary.simpleMessage("Basic Info"),
    "behindSchedule": MessageLookupByLibrary.simpleMessage("Behind Schedule"),
    "birthCertificateNumber": MessageLookupByLibrary.simpleMessage(
      "Birth Certificate Number",
    ),
    "both": MessageLookupByLibrary.simpleMessage("Both"),
    "breakEnd": MessageLookupByLibrary.simpleMessage("End of Break"),
    "breakStart": MessageLookupByLibrary.simpleMessage("Start of Break"),
    "breakStartEndMustBothBeSet": MessageLookupByLibrary.simpleMessage(
      "Break start/end must both be set",
    ),
    "breakText": MessageLookupByLibrary.simpleMessage("Break"),
    "budget": MessageLookupByLibrary.simpleMessage("Budget"),
    "businessName": MessageLookupByLibrary.simpleMessage("Business Name"),
    "businessSize": MessageLookupByLibrary.simpleMessage("Business Size"),
    "businesses": MessageLookupByLibrary.simpleMessage("Businesses"),
    "buySubscription": MessageLookupByLibrary.simpleMessage("Subscribe"),
    "buyer": MessageLookupByLibrary.simpleMessage("Buyer"),
    "buyerInfo": MessageLookupByLibrary.simpleMessage("Buyer Information"),
    "buyerName": MessageLookupByLibrary.simpleMessage("Buyer Name"),
    "buyerPhoneFormat": MessageLookupByLibrary.simpleMessage(
      "Buyer phone number must be in format 09xxxxxxxxx",
    ),
    "calendar": MessageLookupByLibrary.simpleMessage("Calendar"),
    "camera": MessageLookupByLibrary.simpleMessage("Camera"),
    "campaignSummary": MessageLookupByLibrary.simpleMessage("Campaign Summary"),
    "campaignTitle": MessageLookupByLibrary.simpleMessage("Campaign Title"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancelSend": MessageLookupByLibrary.simpleMessage("Cancel Send"),
    "cannotChangeStatus": MessageLookupByLibrary.simpleMessage(
      "Returning to the previous status is not allowed",
    ),
    "cannotChangeStep": MessageLookupByLibrary.simpleMessage(
      "Returning to the previous step is not allowed",
    ),
    "cannotDeleteCompletedSteps": MessageLookupByLibrary.simpleMessage(
      "Cannot Delete Completed Steps.",
    ),
    "cannotInsertInCompletedBetweenCompletedSteps":
        MessageLookupByLibrary.simpleMessage(
          "Incomplete steps cannot be inserted between completed ones.",
        ),
    "cannotMoveCompletedSteps": MessageLookupByLibrary.simpleMessage(
      "Cannot move completed steps.",
    ),
    "capacity": MessageLookupByLibrary.simpleMessage("Capacity"),
    "cardNumber": MessageLookupByLibrary.simpleMessage("Card Number"),
    "caseTypeHelper": MessageLookupByLibrary.simpleMessage(
      "The file is used for case documentation and workflow management.",
    ),
    "casesBoard": MessageLookupByLibrary.simpleMessage("Cases Board"),
    "category": MessageLookupByLibrary.simpleMessage("Category"),
    "certificatePurpose": MessageLookupByLibrary.simpleMessage(
      "Certificate Purpose",
    ),
    "changeLegalCaseStatusDialogDescription":
        MessageLookupByLibrary.simpleMessage(
          "Are you sure the file is complete?",
        ),
    "changeRequestStatusDialogContent": MessageLookupByLibrary.simpleMessage(
      "Do you want to approve or reject this request?",
    ),
    "changeRequestStatusDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Review Request",
    ),
    "changeStatus": MessageLookupByLibrary.simpleMessage("Change status?"),
    "changeStep": m4,
    "changeStepStatus": MessageLookupByLibrary.simpleMessage(
      "Change step status?",
    ),
    "changeSubtaskProgressTo": m5,
    "changeSubtaskStatusToDone": MessageLookupByLibrary.simpleMessage(
      "Change subtask status to \'Done\'?",
    ),
    "changeTaskStatusToDone": MessageLookupByLibrary.simpleMessage(
      "Change task status to \'Done\'?",
    ),
    "changes": MessageLookupByLibrary.simpleMessage("Changes"),
    "changesSaved": MessageLookupByLibrary.simpleMessage("Changes saved."),
    "checkIn": MessageLookupByLibrary.simpleMessage("Clock-in"),
    "checkOut": MessageLookupByLibrary.simpleMessage("Clock-out"),
    "city": MessageLookupByLibrary.simpleMessage("City"),
    "clear": MessageLookupByLibrary.simpleMessage("Clear"),
    "close": MessageLookupByLibrary.simpleMessage("Close"),
    "closed": MessageLookupByLibrary.simpleMessage("Closed"),
    "closedWon": MessageLookupByLibrary.simpleMessage("Closed-Won"),
    "closedWonFollowups": MessageLookupByLibrary.simpleMessage(
      "Closed-Won Follow-ups",
    ),
    "cloudCall": MessageLookupByLibrary.simpleMessage("Cloud Call"),
    "color": MessageLookupByLibrary.simpleMessage("Color"),
    "columnDataType": MessageLookupByLibrary.simpleMessage("Column Data Type"),
    "columnMapping": MessageLookupByLibrary.simpleMessage("Column Mapping"),
    "companions": MessageLookupByLibrary.simpleMessage("Companions"),
    "companionsLabel": MessageLookupByLibrary.simpleMessage(
      "Companions (if team)",
    ),
    "companyName": MessageLookupByLibrary.simpleMessage("Organization name"),
    "companyNationalID": MessageLookupByLibrary.simpleMessage("National ID"),
    "completeRequiredFields": MessageLookupByLibrary.simpleMessage(
      "Complete the required fields.",
    ),
    "completed": MessageLookupByLibrary.simpleMessage("Completed"),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "confirmNewPassword": MessageLookupByLibrary.simpleMessage(
      "Confirm New Password",
    ),
    "confirmPassword": MessageLookupByLibrary.simpleMessage("Confirm Password"),
    "confirmed": MessageLookupByLibrary.simpleMessage("Confirmed"),
    "conflictingDays": MessageLookupByLibrary.simpleMessage("Conflicting days"),
    "connecting": MessageLookupByLibrary.simpleMessage("Connecting..."),
    "connectionLost": MessageLookupByLibrary.simpleMessage("Connection lost"),
    "contactInfo": MessageLookupByLibrary.simpleMessage("Contact Info"),
    "contactPreference": MessageLookupByLibrary.simpleMessage(
      "Contact Preference",
    ),
    "contentAndSettings": MessageLookupByLibrary.simpleMessage(
      "Content & Settings",
    ),
    "contract": MessageLookupByLibrary.simpleMessage("Contract"),
    "contractCount": MessageLookupByLibrary.simpleMessage("Contract Count"),
    "contractCountInfo": MessageLookupByLibrary.simpleMessage(
      "This value represents the total number of contracts you are authorized to create within the Legal module based on your account permissions.",
    ),
    "contractEndDate": MessageLookupByLibrary.simpleMessage(
      "Contract End Date",
    ),
    "contractFile": MessageLookupByLibrary.simpleMessage("Contract File"),
    "contractStartDate": MessageLookupByLibrary.simpleMessage(
      "Contract Start Date",
    ),
    "contractTitle": MessageLookupByLibrary.simpleMessage("Contract Title"),
    "contractType": MessageLookupByLibrary.simpleMessage("Contract Type"),
    "contractTypeHelper": MessageLookupByLibrary.simpleMessage(
      "The file will be sent to registered users for online signing.",
    ),
    "contracts": MessageLookupByLibrary.simpleMessage("Contracts"),
    "conversation": MessageLookupByLibrary.simpleMessage("Conversation"),
    "conversations": MessageLookupByLibrary.simpleMessage("Conversations"),
    "conversationsSelected": MessageLookupByLibrary.simpleMessage(
      "conversations selected",
    ),
    "copyText": MessageLookupByLibrary.simpleMessage("Copy Text"),
    "correspondence": MessageLookupByLibrary.simpleMessage("Correspondence"),
    "cost": MessageLookupByLibrary.simpleMessage("Cost"),
    "count": MessageLookupByLibrary.simpleMessage("Count"),
    "country": MessageLookupByLibrary.simpleMessage("Country"),
    "coverageStartDate": MessageLookupByLibrary.simpleMessage(
      "Coverage Start Date",
    ),
    "coveredPersons": MessageLookupByLibrary.simpleMessage("Covered Persons"),
    "coveredPersonsInfo": MessageLookupByLibrary.simpleMessage(
      "Covered Persons Info (Name, Relation, National ID)",
    ),
    "createAccount": MessageLookupByLibrary.simpleMessage("Create Account"),
    "createContract": MessageLookupByLibrary.simpleMessage("Create Contract"),
    "createInstallments": MessageLookupByLibrary.simpleMessage(
      "Create Installments",
    ),
    "createdAt": MessageLookupByLibrary.simpleMessage("Created at"),
    "createdBy": MessageLookupByLibrary.simpleMessage("Created by"),
    "crmGroupHelperText": MessageLookupByLibrary.simpleMessage(
      "* First, select your desired category.",
    ),
    "currency": MessageLookupByLibrary.simpleMessage("Currency"),
    "currentEquipment": MessageLookupByLibrary.simpleMessage(
      "Current Equipment",
    ),
    "currentEquipmentLabel": MessageLookupByLibrary.simpleMessage(
      "Current Equipment (Name + Model)",
    ),
    "currentPassword": MessageLookupByLibrary.simpleMessage("Current Password"),
    "currentSubscription": MessageLookupByLibrary.simpleMessage(
      "Current Subscription",
    ),
    "currentSubscriptionPrice": MessageLookupByLibrary.simpleMessage(
      "Current Subscription Price",
    ),
    "currentValue": MessageLookupByLibrary.simpleMessage("Current Value"),
    "customMessageText": MessageLookupByLibrary.simpleMessage(
      "Custom Message Text",
    ),
    "customer": MessageLookupByLibrary.simpleMessage("Customer"),
    "customerAddedToArchiveList": MessageLookupByLibrary.simpleMessage(
      "The customer has been added to the archive.",
    ),
    "customerDatabase": MessageLookupByLibrary.simpleMessage(
      "Customer Database",
    ),
    "customerInfo": MessageLookupByLibrary.simpleMessage("Customer Info"),
    "customerName": MessageLookupByLibrary.simpleMessage("Customer Name"),
    "customerPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "Customer phone number",
    ),
    "customerProfile": MessageLookupByLibrary.simpleMessage("Customer Profile"),
    "customerStatusInfo": MessageLookupByLibrary.simpleMessage(
      "What was the reason for closing this customer?",
    ),
    "customers": MessageLookupByLibrary.simpleMessage("Customers"),
    "customersBoard": MessageLookupByLibrary.simpleMessage("Customers Board"),
    "daily": MessageLookupByLibrary.simpleMessage("Daily"),
    "dailyLimit": MessageLookupByLibrary.simpleMessage("Daily Limit"),
    "dashboard": MessageLookupByLibrary.simpleMessage("Dashboard"),
    "dataPreview": MessageLookupByLibrary.simpleMessage(
      "Data preview (first 10 rows)",
    ),
    "date": MessageLookupByLibrary.simpleMessage("Date"),
    "dateOfBirth": MessageLookupByLibrary.simpleMessage("Date of Birth"),
    "dateOfEntry": MessageLookupByLibrary.simpleMessage("Date of Entry"),
    "day": MessageLookupByLibrary.simpleMessage("Day"),
    "days": MessageLookupByLibrary.simpleMessage("Days"),
    "daysOfMonth": MessageLookupByLibrary.simpleMessage("Days of Month"),
    "daysWithoutConflictWillBeApplied": m6,
    "deadline": MessageLookupByLibrary.simpleMessage("Deadline"),
    "decline": MessageLookupByLibrary.simpleMessage("Decline"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteAndLeave": MessageLookupByLibrary.simpleMessage("Delete & Leave"),
    "deleteAndLeaveGroupDialogDescription":
        MessageLookupByLibrary.simpleMessage(
          "Are you sure you want to delete and leave this group?",
        ),
    "deleteContractHelper": MessageLookupByLibrary.simpleMessage(
      "Clicking this button will delete the current contract, and you can then create a new one.",
    ),
    "deleteFromAllDay": MessageLookupByLibrary.simpleMessage(
      "Delete From All Day",
    ),
    "deleteFromDay": MessageLookupByLibrary.simpleMessage("Delete From Day"),
    "deleteSelectedCustomersDialogDescription":
        MessageLookupByLibrary.simpleMessage(
          "Delete selected customers from folder?",
        ),
    "deleteShiftFromAllDaysQuestion": MessageLookupByLibrary.simpleMessage(
      "Remove shift from all days?",
    ),
    "deleteShiftQuestion": MessageLookupByLibrary.simpleMessage(
      "Remove shift from day?",
    ),
    "deleteThisCustomerDialogDescription": MessageLookupByLibrary.simpleMessage(
      "Delete this customer from folder?",
    ),
    "deleted": MessageLookupByLibrary.simpleMessage("Deleted"),
    "delivered": MessageLookupByLibrary.simpleMessage("Delivered"),
    "department": MessageLookupByLibrary.simpleMessage("Department"),
    "departureDate": MessageLookupByLibrary.simpleMessage("Departure Date"),
    "departureTime": MessageLookupByLibrary.simpleMessage("Departure Time"),
    "description": MessageLookupByLibrary.simpleMessage("Description"),
    "descriptionHint": MessageLookupByLibrary.simpleMessage(
      "Additional descriptions if needed...",
    ),
    "destination": MessageLookupByLibrary.simpleMessage("Destination"),
    "destinationOrganization": MessageLookupByLibrary.simpleMessage(
      "Destination Organization",
    ),
    "details": MessageLookupByLibrary.simpleMessage("Details"),
    "detectedColumns": MessageLookupByLibrary.simpleMessage("Detected Columns"),
    "detectedErrors": MessageLookupByLibrary.simpleMessage("Detected Errors"),
    "directLink": MessageLookupByLibrary.simpleMessage("Direct Link"),
    "directMessage": MessageLookupByLibrary.simpleMessage("Direct Message"),
    "directoryCouldNotBeFound": MessageLookupByLibrary.simpleMessage(
      "The directory could not be found.",
    ),
    "discount": MessageLookupByLibrary.simpleMessage("Discount"),
    "diseaseType": MessageLookupByLibrary.simpleMessage("Disease Type"),
    "doNotHaveAccessToAnyNumbers": MessageLookupByLibrary.simpleMessage(
      "You don\'t have access to any numbers.",
    ),
    "doNotHaveAnAccount": MessageLookupByLibrary.simpleMessage(
      "Don’t have an account?",
    ),
    "document": MessageLookupByLibrary.simpleMessage("Document"),
    "documents": MessageLookupByLibrary.simpleMessage("Documents"),
    "done": MessageLookupByLibrary.simpleMessage("Done"),
    "doned": MessageLookupByLibrary.simpleMessage("Done"),
    "download": MessageLookupByLibrary.simpleMessage("Download"),
    "downloadErrorFile": MessageLookupByLibrary.simpleMessage(
      "Download Error File",
    ),
    "downloadSampleFile": MessageLookupByLibrary.simpleMessage(
      "Download Sample File",
    ),
    "downloading": MessageLookupByLibrary.simpleMessage("Downloading..."),
    "drawSignature": MessageLookupByLibrary.simpleMessage("Draw Signature"),
    "dueDate": MessageLookupByLibrary.simpleMessage("Due Date"),
    "dueDateInvoice": MessageLookupByLibrary.simpleMessage("Due Date"),
    "dueTime": MessageLookupByLibrary.simpleMessage("Due Time"),
    "dueTimeMustBeSetInFuture": MessageLookupByLibrary.simpleMessage(
      "The due time must be set in the future",
    ),
    "duplicate": MessageLookupByLibrary.simpleMessage("Duplicate"),
    "early": MessageLookupByLibrary.simpleMessage("Early"),
    "earlyOutAllowance": MessageLookupByLibrary.simpleMessage(
      "Early Out Allowance",
    ),
    "economicCode": MessageLookupByLibrary.simpleMessage("Economic Code"),
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "editCase": MessageLookupByLibrary.simpleMessage("Edit Case"),
    "editCategory": MessageLookupByLibrary.simpleMessage("Edit Category"),
    "editCustomer": MessageLookupByLibrary.simpleMessage("Edit Customer"),
    "editDepartment": MessageLookupByLibrary.simpleMessage("Edit Department"),
    "editFollowUp": MessageLookupByLibrary.simpleMessage("Edit Follow-up"),
    "editGroup": MessageLookupByLibrary.simpleMessage("Edit Group"),
    "editLabel": MessageLookupByLibrary.simpleMessage("Edit Label"),
    "editMeeting": MessageLookupByLibrary.simpleMessage("Edit Meeting"),
    "editMember": MessageLookupByLibrary.simpleMessage("Edit Member"),
    "editParty": MessageLookupByLibrary.simpleMessage("Edit Party"),
    "editProject": MessageLookupByLibrary.simpleMessage("Edit Project"),
    "editReason": MessageLookupByLibrary.simpleMessage("Edit Reason"),
    "editSection": MessageLookupByLibrary.simpleMessage("Edit Section"),
    "editSignatory": MessageLookupByLibrary.simpleMessage("Edit Signatory"),
    "editSubtask": MessageLookupByLibrary.simpleMessage("Edit Subtask"),
    "editTask": MessageLookupByLibrary.simpleMessage("Edit Task"),
    "editWarehouse": MessageLookupByLibrary.simpleMessage("Edit Warehouse"),
    "edited": MessageLookupByLibrary.simpleMessage("Edited"),
    "educationInfo": MessageLookupByLibrary.simpleMessage("Education Info"),
    "educationalDegree": MessageLookupByLibrary.simpleMessage(
      "Educational Degree",
    ),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "emergencyInfoText": MessageLookupByLibrary.simpleMessage(
      "In case of emergency and if the user is unreachable, this person will be contacted.",
    ),
    "emergencyInformation": MessageLookupByLibrary.simpleMessage(
      "Emergency Info",
    ),
    "employment": MessageLookupByLibrary.simpleMessage("Employment"),
    "employmentInfo": MessageLookupByLibrary.simpleMessage("Employment Info"),
    "employmentRole": MessageLookupByLibrary.simpleMessage("Employment Role"),
    "employmentType": MessageLookupByLibrary.simpleMessage("Employment Type"),
    "enableLocationAccess": MessageLookupByLibrary.simpleMessage(
      "You have permanently denied location access.\nTo use this feature, please enable it from the device settings.",
    ),
    "end": MessageLookupByLibrary.simpleMessage("End"),
    "endDate": MessageLookupByLibrary.simpleMessage("End Date"),
    "endTime": MessageLookupByLibrary.simpleMessage("End Time"),
    "endTimeMustBeAfterStartTime": MessageLookupByLibrary.simpleMessage(
      "End time must be after start time",
    ),
    "enterCodeHere": MessageLookupByLibrary.simpleMessage("Enter code here..."),
    "enterStepTitle": MessageLookupByLibrary.simpleMessage(
      "Enter the step title",
    ),
    "enterYourMessage": MessageLookupByLibrary.simpleMessage(
      "Enter your message...",
    ),
    "entry": MessageLookupByLibrary.simpleMessage("Entry"),
    "entryTime": MessageLookupByLibrary.simpleMessage("Entry Time"),
    "equipmentType": MessageLookupByLibrary.simpleMessage("Equipment Type"),
    "error": MessageLookupByLibrary.simpleMessage("Error"),
    "error400": MessageLookupByLibrary.simpleMessage(
      "A technical issue has occurred",
    ),
    "error404": MessageLookupByLibrary.simpleMessage("Information not found"),
    "error422": MessageLookupByLibrary.simpleMessage("Problem in sending data"),
    "error500": MessageLookupByLibrary.simpleMessage(
      "A server error occurred\nPlease try again later",
    ),
    "errorDownloadingFile": MessageLookupByLibrary.simpleMessage(
      "Error downloading file",
    ),
    "errorNetConnection": MessageLookupByLibrary.simpleMessage(
      "Please check your internet connection",
    ),
    "errorSavingInvoice": MessageLookupByLibrary.simpleMessage(
      "Error saving invoice",
    ),
    "estimatedCost": MessageLookupByLibrary.simpleMessage("Estimated Cost"),
    "exactAddress": MessageLookupByLibrary.simpleMessage("Exact Address"),
    "exactLocation": MessageLookupByLibrary.simpleMessage("Exact Location"),
    "exactProblem": MessageLookupByLibrary.simpleMessage("Exact Problem"),
    "example": MessageLookupByLibrary.simpleMessage("e.g."),
    "excelColumn": MessageLookupByLibrary.simpleMessage("Excel Column"),
    "excelCsvFileGuideDescription": MessageLookupByLibrary.simpleMessage(
      "The Excel or CSV file must include mobile numbers in the first column.",
    ),
    "excellent": MessageLookupByLibrary.simpleMessage("Excellent"),
    "exit": MessageLookupByLibrary.simpleMessage("Exit"),
    "exitApp": MessageLookupByLibrary.simpleMessage("Exit the app?"),
    "exitConversationMessagesPageWarningDescription":
        MessageLookupByLibrary.simpleMessage(
          "You have files being uploaded. Leaving now will cancel all uploads. Do you want to exit?",
        ),
    "exitPage": MessageLookupByLibrary.simpleMessage(
      "Leave this page?\n*Unsaved changes will be lost.",
    ),
    "exitTime": MessageLookupByLibrary.simpleMessage("Exit Time"),
    "expenseAmount": MessageLookupByLibrary.simpleMessage("Expense Amount"),
    "expenseDate": MessageLookupByLibrary.simpleMessage("Expense Date"),
    "expenseType": MessageLookupByLibrary.simpleMessage("Expense Type"),
    "expired": MessageLookupByLibrary.simpleMessage("Expired"),
    "expiredSubscriptionDialogDescription": MessageLookupByLibrary.simpleMessage(
      "Your subscription has expired. Please renew your subscription to continue.",
    ),
    "expiringSoon": MessageLookupByLibrary.simpleMessage("Expiring Soon"),
    "export": MessageLookupByLibrary.simpleMessage("Export"),
    "exportAllRecordsToExcel": MessageLookupByLibrary.simpleMessage(
      "Export all records to \"Excel\".",
    ),
    "exportFilteredListToExcel": MessageLookupByLibrary.simpleMessage(
      "Export filtered list to \"Excel\".",
    ),
    "extension": MessageLookupByLibrary.simpleMessage("Ext"),
    "extraAmountToBalance": MessageLookupByLibrary.simpleMessage(
      "Extra amount to balance",
    ),
    "faceId": MessageLookupByLibrary.simpleMessage("Face Id"),
    "failed": MessageLookupByLibrary.simpleMessage("Failed"),
    "failedToApplyShift": MessageLookupByLibrary.simpleMessage(
      "Failed to apply shift",
    ),
    "fair": MessageLookupByLibrary.simpleMessage("Fair"),
    "favorite": MessageLookupByLibrary.simpleMessage("Favorite"),
    "favorites": MessageLookupByLibrary.simpleMessage("Favorites"),
    "fax": MessageLookupByLibrary.simpleMessage("Fax"),
    "fetchMoreData": MessageLookupByLibrary.simpleMessage("Fetch more data"),
    "fieldOfStudy": MessageLookupByLibrary.simpleMessage("Field of Study"),
    "file": MessageLookupByLibrary.simpleMessage("File"),
    "fileInfoNotFullyReceived": MessageLookupByLibrary.simpleMessage(
      "The file information has not been fully received.",
    ),
    "fileNotFound": MessageLookupByLibrary.simpleMessage("File not found"),
    "fileSelectedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "File selected successfully.",
    ),
    "fileSizeExceedsTheAllowedLimit": MessageLookupByLibrary.simpleMessage(
      "File size exceeds the allowed limit",
    ),
    "fileUploadError": MessageLookupByLibrary.simpleMessage(
      "File upload error",
    ),
    "files": MessageLookupByLibrary.simpleMessage("Files"),
    "filters": MessageLookupByLibrary.simpleMessage("Filters"),
    "finalApproval": MessageLookupByLibrary.simpleMessage("Final Approval"),
    "finalPrice": MessageLookupByLibrary.simpleMessage("Final Price"),
    "fingerPrint": MessageLookupByLibrary.simpleMessage("Finger Print"),
    "firstName": MessageLookupByLibrary.simpleMessage("First Name"),
    "floatingTime": MessageLookupByLibrary.simpleMessage("Floating Time"),
    "followUp": MessageLookupByLibrary.simpleMessage("Follow-up"),
    "followUpStatusPopupDescription": MessageLookupByLibrary.simpleMessage(
      "Was the follow-up successful?",
    ),
    "followUps": MessageLookupByLibrary.simpleMessage("Follow-ups"),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Forgot Password?"),
    "formatIsNotAllowed": MessageLookupByLibrary.simpleMessage(
      "The file format is not allowed.",
    ),
    "forward": MessageLookupByLibrary.simpleMessage("Forward"),
    "forwardedFrom": MessageLookupByLibrary.simpleMessage("Forwarded From"),
    "forwardedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Forwarded successfully",
    ),
    "free": MessageLookupByLibrary.simpleMessage("Free"),
    "from": MessageLookupByLibrary.simpleMessage("From"),
    "fullName": MessageLookupByLibrary.simpleMessage("Full Name"),
    "galleryPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "Gallery permission denied. Please enable it from settings.",
    ),
    "gb": MessageLookupByLibrary.simpleMessage("GB"),
    "gender": MessageLookupByLibrary.simpleMessage("Gender"),
    "generalInfo": MessageLookupByLibrary.simpleMessage("General Info"),
    "getLocationDescribe": MessageLookupByLibrary.simpleMessage(
      "This app uses your location only at the moment of clocking in/out to ensure you are within the company premises and to validate your attendance record.",
    ),
    "goToHomePage": MessageLookupByLibrary.simpleMessage("Go to home page"),
    "good": MessageLookupByLibrary.simpleMessage("Good"),
    "gpsIsOff": MessageLookupByLibrary.simpleMessage(
      "Location services (GPS) are disabled. Please turn them on",
    ),
    "groupMessages": MessageLookupByLibrary.simpleMessage("Group Messages"),
    "groupSmsWarningMessage": MessageLookupByLibrary.simpleMessage(
      "After confirmation, your SMS will be queued. Please verify the details before proceeding.",
    ),
    "groupTitle": MessageLookupByLibrary.simpleMessage("Group Title"),
    "guaranteeDocuments": MessageLookupByLibrary.simpleMessage(
      "Guarantee Documents (Check / Promissory Note)",
    ),
    "guide": MessageLookupByLibrary.simpleMessage("Guide"),
    "hRModuleIsRequired": MessageLookupByLibrary.simpleMessage(
      "The Human Resource(HR) module is required.",
    ),
    "hasAttachment": MessageLookupByLibrary.simpleMessage("Has"),
    "haveNoAssigneeFollowup": MessageLookupByLibrary.simpleMessage(
      "You have no assigned follow-ups.",
    ),
    "help": MessageLookupByLibrary.simpleMessage("Help"),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "hospitalOrDoctor": MessageLookupByLibrary.simpleMessage(
      "Hospital or Doctor Issuing Certificate",
    ),
    "hours": MessageLookupByLibrary.simpleMessage("Hours"),
    "hoursWorked": MessageLookupByLibrary.simpleMessage("Hours Worked"),
    "humanResources": MessageLookupByLibrary.simpleMessage("Human Resources"),
    "iban": MessageLookupByLibrary.simpleMessage("IBAN"),
    "ignore": MessageLookupByLibrary.simpleMessage("❌ Ignore"),
    "image": MessageLookupByLibrary.simpleMessage("Image"),
    "immediate": MessageLookupByLibrary.simpleMessage("Immediate"),
    "inProgress": MessageLookupByLibrary.simpleMessage("In Progress"),
    "inbox": MessageLookupByLibrary.simpleMessage("Inbox"),
    "includePosition": MessageLookupByLibrary.simpleMessage("Include Position"),
    "includeSalary": MessageLookupByLibrary.simpleMessage("Include Salary"),
    "industry": MessageLookupByLibrary.simpleMessage("Industry"),
    "informationType": MessageLookupByLibrary.simpleMessage("Information Type"),
    "initialSetupAppliedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Initial setup applied successfully",
    ),
    "initialShiftSetup": MessageLookupByLibrary.simpleMessage(
      "Initial shift setup",
    ),
    "installment": MessageLookupByLibrary.simpleMessage("Installment"),
    "installmentCount": MessageLookupByLibrary.simpleMessage(
      "Installment Count",
    ),
    "installmentInterestNotice": MessageLookupByLibrary.simpleMessage(
      "\"The installment interest for this invoice has been calculated definitively and distributed equally among the installments.\"",
    ),
    "installmentStartDateRequired": MessageLookupByLibrary.simpleMessage(
      "Installment start date is required",
    ),
    "installments": MessageLookupByLibrary.simpleMessage("Installments"),
    "installmentsPaid": m7,
    "insurance": MessageLookupByLibrary.simpleMessage("Insurance"),
    "interestRate": MessageLookupByLibrary.simpleMessage(
      "Annual Interest Rate",
    ),
    "introductionSubject": MessageLookupByLibrary.simpleMessage(
      "Introduction Subject",
    ),
    "invalid": MessageLookupByLibrary.simpleMessage("Invalid"),
    "invalidEmailAddress": MessageLookupByLibrary.simpleMessage(
      "The email address is not valid",
    ),
    "invalidFile": MessageLookupByLibrary.simpleMessage("Invalid File"),
    "invalidFileInfo": MessageLookupByLibrary.simpleMessage(
      "Some files were larger than 100 MB or unsupported and were ignored:",
    ),
    "invalidIBAN": MessageLookupByLibrary.simpleMessage("The IBAN is invalid."),
    "invalidIBANFormat": MessageLookupByLibrary.simpleMessage(
      "The IBAN format is invalid.",
    ),
    "invalidNationalId": MessageLookupByLibrary.simpleMessage(
      "The national code is invalid",
    ),
    "invalidPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "Invalid number format",
    ),
    "invalidPromoCode": MessageLookupByLibrary.simpleMessage("Invalid code."),
    "invitation": MessageLookupByLibrary.simpleMessage("Invitation"),
    "inviteGuests": MessageLookupByLibrary.simpleMessage("Invite Guests"),
    "inviteGuestsHelper": MessageLookupByLibrary.simpleMessage(
      "By entering a phone number or email address, an invitation will be sent to the guests.\nIf you enter a phone number, the invitation will be sent via SMS. If you enter an email address, it will be sent via email.",
    ),
    "inviteMembers": MessageLookupByLibrary.simpleMessage("Invite Members"),
    "invoice": MessageLookupByLibrary.simpleMessage("Invoice"),
    "invoiceAutoApproveInfo": MessageLookupByLibrary.simpleMessage(
      "By enabling this option, the invoice/installment will change to \"Approved\" status immediately after submitting the documentation.",
    ),
    "invoiceDetails": MessageLookupByLibrary.simpleMessage("Invoice Details"),
    "invoiceDetailsStep": MessageLookupByLibrary.simpleMessage("Details"),
    "invoiceId": MessageLookupByLibrary.simpleMessage("Invoice ID"),
    "invoiceInstallmentsStep": MessageLookupByLibrary.simpleMessage(
      "Installments",
    ),
    "invoiceNumber": MessageLookupByLibrary.simpleMessage("Invoice Number"),
    "invoiceSaved": MessageLookupByLibrary.simpleMessage("Invoice saved"),
    "invoiceType": MessageLookupByLibrary.simpleMessage("Invoice Type"),
    "invoiceUnitExample": MessageLookupByLibrary.simpleMessage("Qty / kg"),
    "invoices": MessageLookupByLibrary.simpleMessage("Invoices"),
    "iranIBANisShort": MessageLookupByLibrary.simpleMessage(
      "Iran\'s IBAN number must be 26 characters long.",
    ),
    "isRequired": m8,
    "issueInvoice": MessageLookupByLibrary.simpleMessage("Issue"),
    "issueInvoiceConfirmation": MessageLookupByLibrary.simpleMessage(
      "Confirm invoice issuance? This operation is irreversible.",
    ),
    "issued": MessageLookupByLibrary.simpleMessage("Issued"),
    "itemType": MessageLookupByLibrary.simpleMessage("Item Type"),
    "jobDescriptionAndResponsibilities": MessageLookupByLibrary.simpleMessage(
      "Job Description and Responsibilities",
    ),
    "jobSpecifications": MessageLookupByLibrary.simpleMessage(
      "Job Specifications",
    ),
    "jobSummary": MessageLookupByLibrary.simpleMessage("Job Summary"),
    "jobTitle": MessageLookupByLibrary.simpleMessage("Job Title"),
    "joinDate": MessageLookupByLibrary.simpleMessage("Join Date"),
    "label": MessageLookupByLibrary.simpleMessage("Label"),
    "landline": MessageLookupByLibrary.simpleMessage("Landline"),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "lastName": MessageLookupByLibrary.simpleMessage("Last Name"),
    "late": MessageLookupByLibrary.simpleMessage("Late"),
    "later": MessageLookupByLibrary.simpleMessage("Later"),
    "leave": MessageLookupByLibrary.simpleMessage("Leave"),
    "leaveDate": MessageLookupByLibrary.simpleMessage("Leave Date"),
    "leaveEnd": MessageLookupByLibrary.simpleMessage("End of Leave"),
    "leaveEntitlement": MessageLookupByLibrary.simpleMessage(
      "Leave Entitlement",
    ),
    "leaveGroup": MessageLookupByLibrary.simpleMessage("Leave Group"),
    "leaveGroupDialogDescription": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to leave this group?",
    ),
    "leaveStart": MessageLookupByLibrary.simpleMessage("Start of Leave"),
    "legal": MessageLookupByLibrary.simpleMessage("Legal"),
    "legalCase": MessageLookupByLibrary.simpleMessage("Case"),
    "less": MessageLookupByLibrary.simpleMessage("Less"),
    "letter": MessageLookupByLibrary.simpleMessage("Letter"),
    "letterNumber": MessageLookupByLibrary.simpleMessage("Letter Number"),
    "link": MessageLookupByLibrary.simpleMessage("Link"),
    "linkFormatIsInvalid": MessageLookupByLibrary.simpleMessage(
      "The entered link format is invalid.",
    ),
    "linkIsEmpty": MessageLookupByLibrary.simpleMessage("Link is empty."),
    "links": MessageLookupByLibrary.simpleMessage("Links"),
    "listIsEmpty": MessageLookupByLibrary.simpleMessage("List is Empty!"),
    "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
    "location": MessageLookupByLibrary.simpleMessage("Location"),
    "locationFailedError": MessageLookupByLibrary.simpleMessage(
      "An error occurred while fetching the location.",
    ),
    "locationIsRequiredToAttendance": MessageLookupByLibrary.simpleMessage(
      "Location access is required to register attendance.",
    ),
    "locationPermission": MessageLookupByLibrary.simpleMessage(
      "Location Permission",
    ),
    "locationTimeLimit": MessageLookupByLibrary.simpleMessage(
      "Could not retrieve location within the time limit. Please check your internet and GPS connection and try again.",
    ),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "logo": MessageLookupByLibrary.simpleMessage("Company/Business Logo"),
    "logout": MessageLookupByLibrary.simpleMessage("Logout"),
    "lossReason": MessageLookupByLibrary.simpleMessage("Loss Reason"),
    "mails": MessageLookupByLibrary.simpleMessage("Mails"),
    "mainResponsibilities": MessageLookupByLibrary.simpleMessage(
      "Main Responsibilities",
    ),
    "manual": MessageLookupByLibrary.simpleMessage("Manual"),
    "manualEntry": MessageLookupByLibrary.simpleMessage("Manual Entry"),
    "maritalStatus": MessageLookupByLibrary.simpleMessage("Marital Status"),
    "marketing": MessageLookupByLibrary.simpleMessage("Marketing"),
    "married": MessageLookupByLibrary.simpleMessage("Married"),
    "maxLength": MessageLookupByLibrary.simpleMessage("Maximum length"),
    "maximum": MessageLookupByLibrary.simpleMessage("maximum"),
    "maximumFilesCanSelected": m9,
    "medias": MessageLookupByLibrary.simpleMessage("Medias"),
    "medicalCertificateRequired": MessageLookupByLibrary.simpleMessage(
      "Medical Certificate (PDF/JPG)*",
    ),
    "medicalDocuments": MessageLookupByLibrary.simpleMessage(
      "Medical Documents (Bill, Doctor\'s Prescription, Hospital Report)",
    ),
    "meeting": MessageLookupByLibrary.simpleMessage("Meeting"),
    "meetingType": MessageLookupByLibrary.simpleMessage("Meeting Type"),
    "member": MessageLookupByLibrary.simpleMessage("Members"),
    "memberAddedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Member added successfully",
    ),
    "memberRemovedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Member removed successfully",
    ),
    "members": MessageLookupByLibrary.simpleMessage("Members"),
    "membersList": MessageLookupByLibrary.simpleMessage("Members List"),
    "membersPerformance": MessageLookupByLibrary.simpleMessage(
      "Members Performance",
    ),
    "message": MessageLookupByLibrary.simpleMessage("Message"),
    "messageContent": MessageLookupByLibrary.simpleMessage("Message Content"),
    "messageNotFound": MessageLookupByLibrary.simpleMessage(
      "Message not found",
    ),
    "messageSentSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Message sent successfully",
    ),
    "messageText": MessageLookupByLibrary.simpleMessage("Message Text"),
    "militaryStatus": MessageLookupByLibrary.simpleMessage("Military Status"),
    "minimumWorkExperience": MessageLookupByLibrary.simpleMessage(
      "Minimum Work Experience (Years)",
    ),
    "minutes": MessageLookupByLibrary.simpleMessage("Minutes"),
    "mission": MessageLookupByLibrary.simpleMessage("Mission"),
    "missionDestination": MessageLookupByLibrary.simpleMessage(
      "Mission Destination (City, Province)",
    ),
    "missionEnd": MessageLookupByLibrary.simpleMessage("End of Mission"),
    "missionLimit": MessageLookupByLibrary.simpleMessage("Mission Limit"),
    "missionPurpose": MessageLookupByLibrary.simpleMessage("Mission Purpose"),
    "missionStart": MessageLookupByLibrary.simpleMessage("Start of Mission"),
    "module": MessageLookupByLibrary.simpleMessage("Module"),
    "modules": MessageLookupByLibrary.simpleMessage("Modules"),
    "month": MessageLookupByLibrary.simpleMessage("Month"),
    "monthly": MessageLookupByLibrary.simpleMessage("Monthly"),
    "monthlyLimit": MessageLookupByLibrary.simpleMessage("Monthly Limit"),
    "monthlyRepeatTypeHelper": MessageLookupByLibrary.simpleMessage(
      "Shifts will be created on selected month days for remaining months of selected year",
    ),
    "monthlySettings": MessageLookupByLibrary.simpleMessage("Monthly Settings"),
    "months": MessageLookupByLibrary.simpleMessage("Months"),
    "more": MessageLookupByLibrary.simpleMessage("More"),
    "moveCustomer": MessageLookupByLibrary.simpleMessage("Move Customer"),
    "moveTask": MessageLookupByLibrary.simpleMessage("Move Task"),
    "myBusinessList": MessageLookupByLibrary.simpleMessage("My Business List"),
    "myBusinesses": MessageLookupByLibrary.simpleMessage("My Businesses"),
    "myCase": MessageLookupByLibrary.simpleMessage("My Case"),
    "myFollowups": MessageLookupByLibrary.simpleMessage("My Follow-ups"),
    "myRequests": MessageLookupByLibrary.simpleMessage("My Requests"),
    "myReviews": MessageLookupByLibrary.simpleMessage("My Reviews"),
    "myTasks": MessageLookupByLibrary.simpleMessage("My Tasks"),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "nationalCodeOrIdBuyer": MessageLookupByLibrary.simpleMessage(
      "National ID / Code",
    ),
    "nationalID": MessageLookupByLibrary.simpleMessage("National ID"),
    "nationalIdIsShort": MessageLookupByLibrary.simpleMessage(
      "The national code must be 10 digits",
    ),
    "need": MessageLookupByLibrary.simpleMessage("Need"),
    "needsAccommodation": MessageLookupByLibrary.simpleMessage(
      "Needs Accommodation",
    ),
    "needsImprovement": MessageLookupByLibrary.simpleMessage(
      "Needs Improvement",
    ),
    "newCase": MessageLookupByLibrary.simpleMessage("New Case"),
    "newCategory": MessageLookupByLibrary.simpleMessage("New Category"),
    "newContract": MessageLookupByLibrary.simpleMessage("New Contract"),
    "newCustomer": MessageLookupByLibrary.simpleMessage("New Customer"),
    "newDepartment": MessageLookupByLibrary.simpleMessage("New Department"),
    "newFollowUp": MessageLookupByLibrary.simpleMessage("New Follow-up"),
    "newGroup": MessageLookupByLibrary.simpleMessage("New Group"),
    "newInvoice": MessageLookupByLibrary.simpleMessage("New Invoice"),
    "newLabel": MessageLookupByLibrary.simpleMessage("New Label"),
    "newLetter": MessageLookupByLibrary.simpleMessage("New Letter"),
    "newMeeting": MessageLookupByLibrary.simpleMessage("New Meeting"),
    "newMember": MessageLookupByLibrary.simpleMessage("New Member"),
    "newParty": MessageLookupByLibrary.simpleMessage("New Party"),
    "newPassword": MessageLookupByLibrary.simpleMessage("New Password"),
    "newProject": MessageLookupByLibrary.simpleMessage("New Project"),
    "newReason": MessageLookupByLibrary.simpleMessage("New Reason"),
    "newReport": MessageLookupByLibrary.simpleMessage("New Report"),
    "newRequest": MessageLookupByLibrary.simpleMessage("New Request"),
    "newSection": MessageLookupByLibrary.simpleMessage("New Section"),
    "newSignatory": MessageLookupByLibrary.simpleMessage("New Signatory"),
    "newSubscriptionPrice": MessageLookupByLibrary.simpleMessage(
      "New Subscription Price",
    ),
    "newSubtask": MessageLookupByLibrary.simpleMessage("New Subtask"),
    "newTask": MessageLookupByLibrary.simpleMessage("New Task"),
    "newValue": MessageLookupByLibrary.simpleMessage("New Value"),
    "newWarehouse": MessageLookupByLibrary.simpleMessage("New Warehouse"),
    "newWorkShift": MessageLookupByLibrary.simpleMessage("New WorkShift"),
    "newWorkspace": MessageLookupByLibrary.simpleMessage("New Workspace"),
    "neww": MessageLookupByLibrary.simpleMessage("New"),
    "next": MessageLookupByLibrary.simpleMessage("Next"),
    "nextMonth": MessageLookupByLibrary.simpleMessage("Next Month"),
    "nextYear": MessageLookupByLibrary.simpleMessage("Next Year"),
    "nightShift": MessageLookupByLibrary.simpleMessage("Night Shift"),
    "nightShiftHelper": MessageLookupByLibrary.simpleMessage(
      "Shifts that start one night and end the next morning (e.g., 22:00 - 06:00)",
    ),
    "no": MessageLookupByLibrary.simpleMessage("No"),
    "noActivity": MessageLookupByLibrary.simpleMessage("No Activity"),
    "noAttachment": MessageLookupByLibrary.simpleMessage("No"),
    "noContract": MessageLookupByLibrary.simpleMessage(
      "No contract has been registered",
    ),
    "noData": MessageLookupByLibrary.simpleMessage("No Data"),
    "noDate": MessageLookupByLibrary.simpleMessage("No date"),
    "noFollowUpInfo": MessageLookupByLibrary.simpleMessage(
      "By selecting this option, your customer will be transferred to my customer list.",
    ),
    "noMessagesSelected": MessageLookupByLibrary.simpleMessage(
      "No messages selected",
    ),
    "noMessagesToForward": MessageLookupByLibrary.simpleMessage(
      "No messages to forward",
    ),
    "noNotifications": MessageLookupByLibrary.simpleMessage("No Notifications"),
    "noRecordsToDisplay": MessageLookupByLibrary.simpleMessage(
      "There are no records to display.",
    ),
    "noResult": MessageLookupByLibrary.simpleMessage("No Result"),
    "noSubscriptionDialogDescription": MessageLookupByLibrary.simpleMessage(
      "You don\'t have an active subscription. Please get a plan for your business to continue.",
    ),
    "noTextMessagesSelected": MessageLookupByLibrary.simpleMessage(
      "No text messages selected",
    ),
    "notActiveModules": MessageLookupByLibrary.simpleMessage(
      "You don\'t have any active modules.",
    ),
    "notAllowChangeStatus": MessageLookupByLibrary.simpleMessage(
      "You are not allowed to change the status",
    ),
    "notAllowedDeleteOtherUsersMessages": MessageLookupByLibrary.simpleMessage(
      "You are not allowed to delete other users\' messages.",
    ),
    "notAuthorizedToChangeStatus": MessageLookupByLibrary.simpleMessage(
      "You are not allowed to change the status.",
    ),
    "notNow": MessageLookupByLibrary.simpleMessage("Not Now!"),
    "notPossibleForPastDays": MessageLookupByLibrary.simpleMessage(
      "It\'s not possible for past days.",
    ),
    "notSupportedInThisVersion": MessageLookupByLibrary.simpleMessage(
      "Not supported in this version.",
    ),
    "notSupportedItem": MessageLookupByLibrary.simpleMessage(
      "This item is not compatible with your current version.",
    ),
    "note": MessageLookupByLibrary.simpleMessage("Note"),
    "notice": MessageLookupByLibrary.simpleMessage("Notice"),
    "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
    "nowruzFestival": MessageLookupByLibrary.simpleMessage("Nowruz Festival"),
    "number": MessageLookupByLibrary.simpleMessage("Number"),
    "numberManagement": MessageLookupByLibrary.simpleMessage(
      "Number Management",
    ),
    "numberOfChildren": MessageLookupByLibrary.simpleMessage(
      "Number of Children",
    ),
    "numbersEntryMethod": MessageLookupByLibrary.simpleMessage(
      "Numbers Entry Method",
    ),
    "numbersShouldStartWith09": MessageLookupByLibrary.simpleMessage(
      "Numbers should start with 09.",
    ),
    "occasionType": MessageLookupByLibrary.simpleMessage("Occasion Type"),
    "ofText": MessageLookupByLibrary.simpleMessage("of"),
    "offline": MessageLookupByLibrary.simpleMessage("Offline"),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "onTime": MessageLookupByLibrary.simpleMessage("On-Time"),
    "online": MessageLookupByLibrary.simpleMessage("Online"),
    "onlyPDFFilesAllowed": MessageLookupByLibrary.simpleMessage(
      "Only PDF files are allowed.",
    ),
    "onlyThisDay": MessageLookupByLibrary.simpleMessage("Only this day"),
    "optional": MessageLookupByLibrary.simpleMessage("(Optional)"),
    "optionalAttachments": MessageLookupByLibrary.simpleMessage(
      "Optional Attachments",
    ),
    "optionalProblemPhoto": MessageLookupByLibrary.simpleMessage(
      "Optional Problem Photo Attachment",
    ),
    "or": MessageLookupByLibrary.simpleMessage("Or"),
    "orders": MessageLookupByLibrary.simpleMessage("Orders"),
    "organizationAddress": MessageLookupByLibrary.simpleMessage(
      "Organization Address",
    ),
    "organizationalUnit": MessageLookupByLibrary.simpleMessage(
      "Organizational Unit",
    ),
    "otpCodeNotReceived": MessageLookupByLibrary.simpleMessage(
      "Didn\'t receive the code?",
    ),
    "otpInfoText": m10,
    "overallStatistics": MessageLookupByLibrary.simpleMessage("Overall Stats"),
    "overdue": MessageLookupByLibrary.simpleMessage("overdue"),
    "overdueFollowups": MessageLookupByLibrary.simpleMessage(
      "Overdue Follow-ups",
    ),
    "overdueInstallmentMessage": MessageLookupByLibrary.simpleMessage(
      "This installment is overdue. Please pay it.",
    ),
    "overdueInstallmentStatus": MessageLookupByLibrary.simpleMessage("Overdue"),
    "overdueTasks": MessageLookupByLibrary.simpleMessage("Overdue Tasks"),
    "overtime": MessageLookupByLibrary.simpleMessage("Overtime"),
    "overtimeEnd": MessageLookupByLibrary.simpleMessage("End of Overtime"),
    "overtimeLimit": MessageLookupByLibrary.simpleMessage("Overtime Limit"),
    "overtimeStart": MessageLookupByLibrary.simpleMessage("Start of Overtime"),
    "owner": MessageLookupByLibrary.simpleMessage("Owner"),
    "paid": MessageLookupByLibrary.simpleMessage("Paid"),
    "partiallyPaid": MessageLookupByLibrary.simpleMessage("Partially Paid"),
    "parties": MessageLookupByLibrary.simpleMessage("The Parties"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordChanged": MessageLookupByLibrary.simpleMessage(
      "Your password has been successfully changed.",
    ),
    "passwordRecovery": MessageLookupByLibrary.simpleMessage(
      "Password Recovery",
    ),
    "passwordsNotSame": MessageLookupByLibrary.simpleMessage(
      "Please make sure both passwords are the same",
    ),
    "pay": MessageLookupByLibrary.simpleMessage("Pay"),
    "payNow": MessageLookupByLibrary.simpleMessage("Pay Now"),
    "payable": MessageLookupByLibrary.simpleMessage("Payable"),
    "payment": MessageLookupByLibrary.simpleMessage("Payment"),
    "paymentDate": MessageLookupByLibrary.simpleMessage("Payment Date"),
    "paymentFailed": MessageLookupByLibrary.simpleMessage("Payment failed"),
    "paymentInfo": MessageLookupByLibrary.simpleMessage("Payment Info"),
    "paymentMethod": MessageLookupByLibrary.simpleMessage("Payment Method"),
    "paymentMethodLabel": MessageLookupByLibrary.simpleMessage(
      "Payment Method",
    ),
    "paymentReceipt": MessageLookupByLibrary.simpleMessage("Payment Receipt"),
    "paymentReceiptImages": MessageLookupByLibrary.simpleMessage(
      "Payment Receipt Images",
    ),
    "paymentRegistrationInfo": MessageLookupByLibrary.simpleMessage(
      "After completing the payment, please fill in the following information. Your payment will be confirmed after review by the finance team.",
    ),
    "paymentTerms": MessageLookupByLibrary.simpleMessage("Payment Terms"),
    "paymentTime": MessageLookupByLibrary.simpleMessage("Payment Time"),
    "paymentWasSuccessful": MessageLookupByLibrary.simpleMessage(
      "Payment was successful",
    ),
    "pdfSavedAt": m11,
    "penaltyRateCannotBeZero": MessageLookupByLibrary.simpleMessage(
      "Penalty rate cannot be zero.",
    ),
    "pending": MessageLookupByLibrary.simpleMessage("Pending"),
    "pendingInvitation": MessageLookupByLibrary.simpleMessage(
      "Invitation Pending Approval",
    ),
    "performance": MessageLookupByLibrary.simpleMessage("Performance"),
    "period": MessageLookupByLibrary.simpleMessage("Period"),
    "personal": MessageLookupByLibrary.simpleMessage("Personal"),
    "personalInfo": MessageLookupByLibrary.simpleMessage("Personal Info"),
    "personnelCode": MessageLookupByLibrary.simpleMessage("Personnel Code"),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("Phone Number"),
    "photo": MessageLookupByLibrary.simpleMessage("Photo"),
    "pickAtLeastOneAttendanceMethod": MessageLookupByLibrary.simpleMessage(
      "Pick at least one attendance method",
    ),
    "pickAtLeastOneDayOfMonth": MessageLookupByLibrary.simpleMessage(
      "Pick at least one day of month",
    ),
    "pickAtLeastOneWeekday": MessageLookupByLibrary.simpleMessage(
      "Pick at least one weekday",
    ),
    "pin": MessageLookupByLibrary.simpleMessage("Pin"),
    "planning": MessageLookupByLibrary.simpleMessage("Planning"),
    "pleaseAddAtLeastOne": m12,
    "pleaseEnterReason": MessageLookupByLibrary.simpleMessage(
      "Please enter the reason for invoice suspension",
    ),
    "pleaseSelectAtLeastOneConversation": MessageLookupByLibrary.simpleMessage(
      "Please select at least one conversation",
    ),
    "popular": MessageLookupByLibrary.simpleMessage("Popular"),
    "postalCode": MessageLookupByLibrary.simpleMessage("Postal Code"),
    "potentialDuplicates": MessageLookupByLibrary.simpleMessage(
      "Potential Duplicates",
    ),
    "preferredFieldOfStudy": MessageLookupByLibrary.simpleMessage(
      "Preferred Field of Study",
    ),
    "presence": MessageLookupByLibrary.simpleMessage("Presence"),
    "preview": MessageLookupByLibrary.simpleMessage("Preview"),
    "previewStep": MessageLookupByLibrary.simpleMessage("Preview"),
    "previous": MessageLookupByLibrary.simpleMessage("Previous"),
    "previousDay": MessageLookupByLibrary.simpleMessage("previous day"),
    "previousMonth": MessageLookupByLibrary.simpleMessage("Previous Month"),
    "previousYear": MessageLookupByLibrary.simpleMessage("Previous Year"),
    "price": MessageLookupByLibrary.simpleMessage("Price"),
    "priceDetails": MessageLookupByLibrary.simpleMessage("Price Details"),
    "priceSummary": MessageLookupByLibrary.simpleMessage("Price Summary"),
    "priority": MessageLookupByLibrary.simpleMessage("Priority"),
    "problemDate": MessageLookupByLibrary.simpleMessage("Problem Date"),
    "product": MessageLookupByLibrary.simpleMessage("Product"),
    "productCode": MessageLookupByLibrary.simpleMessage("Product Code"),
    "productService": MessageLookupByLibrary.simpleMessage("Product / Service"),
    "productsOrServices": MessageLookupByLibrary.simpleMessage("Products"),
    "profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "proformaInvoiceCannotBePaid": MessageLookupByLibrary.simpleMessage(
      "The proforma invoice cannot be paid.",
    ),
    "progressStatus": MessageLookupByLibrary.simpleMessage("Progress Status"),
    "project": MessageLookupByLibrary.simpleMessage("Project"),
    "projectBoard": MessageLookupByLibrary.simpleMessage("Project Board"),
    "projectHelperText": MessageLookupByLibrary.simpleMessage(
      "* First, select your desired project.",
    ),
    "promoCode": MessageLookupByLibrary.simpleMessage("Have a promo code?"),
    "promoCodeApplied": MessageLookupByLibrary.simpleMessage(
      "Promo code applied successfully!",
    ),
    "proofDocument": MessageLookupByLibrary.simpleMessage(
      "Proof Document (Marriage Certificate, Death Certificate, Birth Certificate, etc.)",
    ),
    "provider": MessageLookupByLibrary.simpleMessage("Provider"),
    "pullToRefresh": MessageLookupByLibrary.simpleMessage("Pull to refresh"),
    "quantity": MessageLookupByLibrary.simpleMessage("Quantity"),
    "reCreate": MessageLookupByLibrary.simpleMessage("Re-create"),
    "reasonLengthError": MessageLookupByLibrary.simpleMessage(
      "Reason must be at least 10 characters.",
    ),
    "receivedBy": MessageLookupByLibrary.simpleMessage("Received by"),
    "receivedSent": MessageLookupByLibrary.simpleMessage("Received / Sent"),
    "recipient": MessageLookupByLibrary.simpleMessage("Recipient"),
    "recipients": MessageLookupByLibrary.simpleMessage("Recipients"),
    "recipientsNumbers": MessageLookupByLibrary.simpleMessage(
      "Recipients Numbers",
    ),
    "recovery": MessageLookupByLibrary.simpleMessage("Recovery"),
    "referenceID": MessageLookupByLibrary.simpleMessage("Reference ID"),
    "refreshing": MessageLookupByLibrary.simpleMessage("Refreshing..."),
    "registerPaymentDocuments": MessageLookupByLibrary.simpleMessage(
      "Register Payment Documents",
    ),
    "registrationNumber": MessageLookupByLibrary.simpleMessage(
      "Registration Number",
    ),
    "reject": MessageLookupByLibrary.simpleMessage("Reject"),
    "rejected": MessageLookupByLibrary.simpleMessage("Rejected"),
    "relatedMissionNumber": MessageLookupByLibrary.simpleMessage(
      "Related Mission Number",
    ),
    "relationship": MessageLookupByLibrary.simpleMessage("Relationship"),
    "releaseToRefresh": MessageLookupByLibrary.simpleMessage(
      "Release to refresh",
    ),
    "remaining": MessageLookupByLibrary.simpleMessage("Remaining"),
    "remainingAmountToBalance": MessageLookupByLibrary.simpleMessage(
      "Remaining amount to balance",
    ),
    "reminderTime": MessageLookupByLibrary.simpleMessage("Reminder Time"),
    "remove": MessageLookupByLibrary.simpleMessage("Remove"),
    "removeMember": MessageLookupByLibrary.simpleMessage("Remove Member"),
    "removedMembers": MessageLookupByLibrary.simpleMessage("Removed Members"),
    "renewSubscription": MessageLookupByLibrary.simpleMessage("Renew"),
    "reorder": MessageLookupByLibrary.simpleMessage("Reorder"),
    "repaymentConditions": MessageLookupByLibrary.simpleMessage(
      "Proposed Repayment Conditions",
    ),
    "repeat": MessageLookupByLibrary.simpleMessage("Repeat"),
    "repeatOptions": MessageLookupByLibrary.simpleMessage("Repeat Options"),
    "repeatType": MessageLookupByLibrary.simpleMessage("Repeat Type"),
    "replace": MessageLookupByLibrary.simpleMessage("Replace"),
    "replacementEmployee": MessageLookupByLibrary.simpleMessage(
      "Replacement Employee",
    ),
    "replacementEmployeeOptional": MessageLookupByLibrary.simpleMessage(
      "Replacement Employee (Optional)",
    ),
    "reply": MessageLookupByLibrary.simpleMessage("Reply"),
    "reports": MessageLookupByLibrary.simpleMessage("Reports"),
    "reportsTo": MessageLookupByLibrary.simpleMessage("Reports To"),
    "reportsToExample": MessageLookupByLibrary.simpleMessage(
      "e.g.: Sales Manager",
    ),
    "representative": MessageLookupByLibrary.simpleMessage("Representative"),
    "representativeInfo": MessageLookupByLibrary.simpleMessage(
      "Representative Info",
    ),
    "representativeName": MessageLookupByLibrary.simpleMessage(
      "Representative Name",
    ),
    "requestDescription": MessageLookupByLibrary.simpleMessage(
      "Request Description",
    ),
    "requestReason": MessageLookupByLibrary.simpleMessage("Request Reason"),
    "requestType": MessageLookupByLibrary.simpleMessage("Request Type"),
    "requestedAmount": MessageLookupByLibrary.simpleMessage("Requested Amount"),
    "requestedAmountLabel": MessageLookupByLibrary.simpleMessage(
      "Requested Amount",
    ),
    "requests": MessageLookupByLibrary.simpleMessage("Requests"),
    "requestsBoard": MessageLookupByLibrary.simpleMessage("Requests Board"),
    "requiredEducation": MessageLookupByLibrary.simpleMessage(
      "Required Education",
    ),
    "requiredField": MessageLookupByLibrary.simpleMessage(
      "This field is required",
    ),
    "requiredForeignLanguages": MessageLookupByLibrary.simpleMessage(
      "Required Foreign Languages",
    ),
    "requiredIssueDate": MessageLookupByLibrary.simpleMessage(
      "Required Issue Date",
    ),
    "requiredLanguage": MessageLookupByLibrary.simpleMessage(
      "Required Language",
    ),
    "requiredMedicalCertificate": MessageLookupByLibrary.simpleMessage(
      "Uploading a medical certificate photo is required.",
    ),
    "requiredPaymentDate": MessageLookupByLibrary.simpleMessage(
      "Required Payment Date",
    ),
    "requiredPersonnelCount": MessageLookupByLibrary.simpleMessage(
      "Required Personnel Count",
    ),
    "requiredQuantity": MessageLookupByLibrary.simpleMessage(
      "Required Quantity",
    ),
    "requirementsAndConditions": MessageLookupByLibrary.simpleMessage(
      "Requirements and Conditions",
    ),
    "resend": MessageLookupByLibrary.simpleMessage("RESEND"),
    "responsibility": MessageLookupByLibrary.simpleMessage("Responsibility"),
    "restore": MessageLookupByLibrary.simpleMessage("Restore"),
    "restoreDescription": MessageLookupByLibrary.simpleMessage(
      "Do you want to restore?",
    ),
    "result": MessageLookupByLibrary.simpleMessage("Result"),
    "returnDate": MessageLookupByLibrary.simpleMessage("Return Date"),
    "returnTime": MessageLookupByLibrary.simpleMessage("Return Time"),
    "reviewers": MessageLookupByLibrary.simpleMessage("Reviewers"),
    "revised": MessageLookupByLibrary.simpleMessage("Revised"),
    "rial": MessageLookupByLibrary.simpleMessage("Rial"),
    "role": MessageLookupByLibrary.simpleMessage("Role"),
    "rowCount": MessageLookupByLibrary.simpleMessage("Row Count"),
    "salaryAndBenefits": MessageLookupByLibrary.simpleMessage(
      "Salary & Benefits",
    ),
    "salaryType": MessageLookupByLibrary.simpleMessage("Salary Type"),
    "salesForecast": MessageLookupByLibrary.simpleMessage("Sales Forecast"),
    "salesInvoiceTitle": MessageLookupByLibrary.simpleMessage(
      "Sales Invoice for Goods and Services",
    ),
    "salesProbability": MessageLookupByLibrary.simpleMessage(
      "Sales Probability",
    ),
    "sampleData": MessageLookupByLibrary.simpleMessage("Sample Data"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "saveToGallery": MessageLookupByLibrary.simpleMessage("Save to Gallery"),
    "saveYourChangesFirst": MessageLookupByLibrary.simpleMessage(
      "Please save your changes first.",
    ),
    "saved": MessageLookupByLibrary.simpleMessage("Saved"),
    "scanQRCode": MessageLookupByLibrary.simpleMessage("Scan The QR Code"),
    "scheduledDate": MessageLookupByLibrary.simpleMessage("Scheduled Date"),
    "scheduling": MessageLookupByLibrary.simpleMessage("Scheduling"),
    "search": MessageLookupByLibrary.simpleMessage("Search"),
    "seconds": MessageLookupByLibrary.simpleMessage("Seconds"),
    "section": MessageLookupByLibrary.simpleMessage("Section"),
    "select": MessageLookupByLibrary.simpleMessage("Select"),
    "selectAgain": MessageLookupByLibrary.simpleMessage("Select Again"),
    "selectAtLeastOneModule": MessageLookupByLibrary.simpleMessage(
      "Please select at least one module.",
    ),
    "selectConversation": MessageLookupByLibrary.simpleMessage(
      "Select Conversation",
    ),
    "selectInvoice": MessageLookupByLibrary.simpleMessage("Select Invoice"),
    "selectLabels": MessageLookupByLibrary.simpleMessage("Select Labels"),
    "selectReviewDeadline": MessageLookupByLibrary.simpleMessage(
      "Please select a review deadline for each person.",
    ),
    "selectReviewersHelperText": MessageLookupByLibrary.simpleMessage(
      "The selection order determines the approval priority.",
    ),
    "selectReviewersInfoText": MessageLookupByLibrary.simpleMessage(
      "Please select reviewers in the desired order of approval.",
    ),
    "selectTime": MessageLookupByLibrary.simpleMessage("Select Time"),
    "selectedModules": MessageLookupByLibrary.simpleMessage("Selected Modules"),
    "selectedUsers": MessageLookupByLibrary.simpleMessage("Selected Users"),
    "seller": MessageLookupByLibrary.simpleMessage("Seller"),
    "sellerInfo": MessageLookupByLibrary.simpleMessage("Seller Information"),
    "send": MessageLookupByLibrary.simpleMessage("Send"),
    "sendAnonymousMessage": MessageLookupByLibrary.simpleMessage(
      "Send Anonymous Message",
    ),
    "sendCode": MessageLookupByLibrary.simpleMessage("Send Code"),
    "sendGroupSMS": MessageLookupByLibrary.simpleMessage("Send Group SMS"),
    "sendInvitation": MessageLookupByLibrary.simpleMessage("Send Invitation"),
    "sendPaymentReceipt": MessageLookupByLibrary.simpleMessage(
      "Send Payment Receipt",
    ),
    "sendSMS": MessageLookupByLibrary.simpleMessage("Send SMS"),
    "sendSelectedCustomersToBoardDialogDescription":
        MessageLookupByLibrary.simpleMessage(
          "Send all the selected customers to the Kanban board?",
        ),
    "sendTest": MessageLookupByLibrary.simpleMessage("Send Test"),
    "sendThisCustomerToBoardDialogDescription":
        MessageLookupByLibrary.simpleMessage(
          "Send this customer to the Kanban board?",
        ),
    "sendTime": MessageLookupByLibrary.simpleMessage("Send Time"),
    "sendToBoard": MessageLookupByLibrary.simpleMessage("Send To Board"),
    "sender": MessageLookupByLibrary.simpleMessage("Sender"),
    "senderBalance": MessageLookupByLibrary.simpleMessage("Sender Balance"),
    "senderNumber": MessageLookupByLibrary.simpleMessage("Sender Number"),
    "sent": MessageLookupByLibrary.simpleMessage("Sent"),
    "sentAt": MessageLookupByLibrary.simpleMessage("Sent at"),
    "sentBy": MessageLookupByLibrary.simpleMessage("Sent by"),
    "sentMessages": MessageLookupByLibrary.simpleMessage("Sent Messages"),
    "serviceId": MessageLookupByLibrary.simpleMessage("Service ID"),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "share": MessageLookupByLibrary.simpleMessage("Share"),
    "shiftColor": MessageLookupByLibrary.simpleMessage("Shift Color"),
    "shiftConflictsWithAllSelectedDays": m13,
    "shiftConflictsWithDays": m14,
    "shiftOverlapReport": MessageLookupByLibrary.simpleMessage(
      "Shift Overlap Report",
    ),
    "shiftTitle": MessageLookupByLibrary.simpleMessage("Shift Title"),
    "shippingCost": MessageLookupByLibrary.simpleMessage("Shipping Cost"),
    "show": MessageLookupByLibrary.simpleMessage("Show"),
    "signatories": MessageLookupByLibrary.simpleMessage("Signatories"),
    "signatory": MessageLookupByLibrary.simpleMessage("Signatory"),
    "signatureImage": MessageLookupByLibrary.simpleMessage("Signature image"),
    "signatures": MessageLookupByLibrary.simpleMessage("Signatures"),
    "signed": MessageLookupByLibrary.simpleMessage("Signed"),
    "signup": MessageLookupByLibrary.simpleMessage("Sign Up"),
    "single": MessageLookupByLibrary.simpleMessage("Single"),
    "skill": MessageLookupByLibrary.simpleMessage("Skill"),
    "skills": MessageLookupByLibrary.simpleMessage("Skills"),
    "sms": MessageLookupByLibrary.simpleMessage("SMS"),
    "smsSentSuccessfully": MessageLookupByLibrary.simpleMessage(
      "The SMS was sent successfully.",
    ),
    "socialMediaLink": MessageLookupByLibrary.simpleMessage(
      "Social Media Link",
    ),
    "softSkills": MessageLookupByLibrary.simpleMessage("Soft Skills"),
    "soon": MessageLookupByLibrary.simpleMessage("Soon..."),
    "specialSpecifications": MessageLookupByLibrary.simpleMessage(
      "Special Specifications",
    ),
    "specialSpecificationsLabel": MessageLookupByLibrary.simpleMessage(
      "Special Specifications (Mention Employee\'s Position or Special Expertise)",
    ),
    "staffManagement": MessageLookupByLibrary.simpleMessage("Staff Management"),
    "start": MessageLookupByLibrary.simpleMessage("Start"),
    "startAndEndDate": MessageLookupByLibrary.simpleMessage(
      "Start and End Date",
    ),
    "startConversationDialog": MessageLookupByLibrary.simpleMessage(
      "Start Conversation?",
    ),
    "startDate": MessageLookupByLibrary.simpleMessage("Start Date"),
    "startTime": MessageLookupByLibrary.simpleMessage("Start Time"),
    "startTimeMustBeSetInFuture": MessageLookupByLibrary.simpleMessage(
      "The start time must be set in the future",
    ),
    "state": MessageLookupByLibrary.simpleMessage("State"),
    "statistics": MessageLookupByLibrary.simpleMessage("Stats"),
    "status": MessageLookupByLibrary.simpleMessage("Status"),
    "step": MessageLookupByLibrary.simpleMessage("Step"),
    "stepLengthError": MessageLookupByLibrary.simpleMessage(
      "The number of steps cannot be less than 2.",
    ),
    "steps": MessageLookupByLibrary.simpleMessage("Steps"),
    "storage": MessageLookupByLibrary.simpleMessage("Storage"),
    "subcategory": MessageLookupByLibrary.simpleMessage("Sub-category"),
    "submit": MessageLookupByLibrary.simpleMessage("Submit"),
    "submitPayment": MessageLookupByLibrary.simpleMessage("Submit Payment"),
    "submitRequest": MessageLookupByLibrary.simpleMessage("Submit Request"),
    "subscription": MessageLookupByLibrary.simpleMessage("Subscription"),
    "subscriptionDetails": MessageLookupByLibrary.simpleMessage(
      "Subscription Details",
    ),
    "subscriptionManagement": MessageLookupByLibrary.simpleMessage(
      "Subscription Management",
    ),
    "subscriptionModules": MessageLookupByLibrary.simpleMessage(
      "Subscription Modules",
    ),
    "subscriptionNote": MessageLookupByLibrary.simpleMessage(
      "Note: After registering a subscription, it is not possible to reduce the number of users and storage space, nor to deactivate modules. Please choose carefully.",
    ),
    "subscriptionPeriod": MessageLookupByLibrary.simpleMessage(
      "Subscription Period",
    ),
    "subscriptionPrice": MessageLookupByLibrary.simpleMessage(
      "Subscription Price",
    ),
    "subscriptionSettings": MessageLookupByLibrary.simpleMessage(
      "Subscription Settings",
    ),
    "subtask": MessageLookupByLibrary.simpleMessage("Subtask"),
    "subtasks": MessageLookupByLibrary.simpleMessage("Subtasks"),
    "success": MessageLookupByLibrary.simpleMessage("Success"),
    "successRate": MessageLookupByLibrary.simpleMessage("Success Rate"),
    "successful": MessageLookupByLibrary.simpleMessage("Successful"),
    "successfulPayment": MessageLookupByLibrary.simpleMessage("Successful"),
    "successfullyCompleted": MessageLookupByLibrary.simpleMessage(
      "Successfully Completed",
    ),
    "suggestedModel": MessageLookupByLibrary.simpleMessage("Suggested Model"),
    "suggestedModelLabel": MessageLookupByLibrary.simpleMessage(
      "Suggested Model (if specific need)",
    ),
    "sumOfInstallmentsIsNotEqualToInvoicePrice":
        MessageLookupByLibrary.simpleMessage(
          "The sum of the installments is not equal to the invoice price.",
        ),
    "support": MessageLookupByLibrary.simpleMessage("Support"),
    "supportingDocuments": MessageLookupByLibrary.simpleMessage(
      "Supporting Documents (Rent Bill, Transportation Ticket, etc.)",
    ),
    "supportingDocumentsPersonal": MessageLookupByLibrary.simpleMessage(
      "Supporting Documents (Bill, National ID, Birth Certificate)",
    ),
    "suspend": MessageLookupByLibrary.simpleMessage("Suspend"),
    "suspendInvoice": MessageLookupByLibrary.simpleMessage("Suspend Invoice"),
    "suspended": MessageLookupByLibrary.simpleMessage("Suspended"),
    "suspensionDocumentOptional": MessageLookupByLibrary.simpleMessage(
      "Suspension Document (Optional)",
    ),
    "suspensionReason": MessageLookupByLibrary.simpleMessage(
      "Suspension Reason",
    ),
    "suspensionWarning": MessageLookupByLibrary.simpleMessage(
      "Notice: By suspending the invoice, all financial timers including installment due dates, late fees, and expiration will stop. The customer cannot make payments during this period.",
    ),
    "swipeToCheckIn": MessageLookupByLibrary.simpleMessage("Swipe to clock-in"),
    "swipeToCheckOut": MessageLookupByLibrary.simpleMessage(
      "Swipe to clock-out",
    ),
    "switchedBusiness": m15,
    "tapEnterToAdd": MessageLookupByLibrary.simpleMessage(
      "* Tap the Enter key on your keyboard to add.",
    ),
    "tardiness": MessageLookupByLibrary.simpleMessage("Tardiness"),
    "tardinessAllowance": MessageLookupByLibrary.simpleMessage(
      "Tardiness Allowance",
    ),
    "task": MessageLookupByLibrary.simpleMessage("Task"),
    "tasks": MessageLookupByLibrary.simpleMessage("Tasks"),
    "tax": MessageLookupByLibrary.simpleMessage("Tax"),
    "technicalSkills": MessageLookupByLibrary.simpleMessage("Technical Skills"),
    "testSendDoesNotAffectCampaignStats": MessageLookupByLibrary.simpleMessage(
      "Test send doesn\'t affect campaign statistics.",
    ),
    "theme": MessageLookupByLibrary.simpleMessage("Theme"),
    "thisDateHasAlreadyBeenAdded": MessageLookupByLibrary.simpleMessage(
      "This date has already been added.",
    ),
    "thisIsExist": m16,
    "time": MessageLookupByLibrary.simpleMessage("Time"),
    "timeMustBeSetInFuture": MessageLookupByLibrary.simpleMessage(
      "The time must be set in the future",
    ),
    "timeSpent": MessageLookupByLibrary.simpleMessage("Time Spent"),
    "timeTracking": MessageLookupByLibrary.simpleMessage("Time Tracking"),
    "timeWorkedToday": MessageLookupByLibrary.simpleMessage(
      "Time Worked Today",
    ),
    "timesheet": MessageLookupByLibrary.simpleMessage("Timesheet"),
    "title": MessageLookupByLibrary.simpleMessage("Title"),
    "to": MessageLookupByLibrary.simpleMessage("to"),
    "today": MessageLookupByLibrary.simpleMessage("Today"),
    "todo": MessageLookupByLibrary.simpleMessage("To-Do"),
    "toman": MessageLookupByLibrary.simpleMessage("Toman"),
    "total": MessageLookupByLibrary.simpleMessage("Total"),
    "totalAmountOfProductsServices": MessageLookupByLibrary.simpleMessage(
      "Total amount",
    ),
    "totalContracts": MessageLookupByLibrary.simpleMessage("Total Contracts"),
    "totalCount": MessageLookupByLibrary.simpleMessage("Total Count"),
    "totalFollowups": MessageLookupByLibrary.simpleMessage("Total Follow-ups"),
    "totalInstallmentAmount": MessageLookupByLibrary.simpleMessage(
      "Total Installment Amount",
    ),
    "totalMonthly": MessageLookupByLibrary.simpleMessage("Total monthly"),
    "totalPrice": MessageLookupByLibrary.simpleMessage("Total Price"),
    "totalPriceAfterDiscount": MessageLookupByLibrary.simpleMessage(
      "Total after Discount",
    ),
    "totalTasks": MessageLookupByLibrary.simpleMessage("Total Tasks"),
    "totalWithTax": MessageLookupByLibrary.simpleMessage("Total with Tax"),
    "totalWorkHours": MessageLookupByLibrary.simpleMessage("Total Work Hours"),
    "trackingCode": MessageLookupByLibrary.simpleMessage("Tracking Code"),
    "trackingCodeHint": MessageLookupByLibrary.simpleMessage(
      "Transaction tracking code",
    ),
    "transactionNumber": MessageLookupByLibrary.simpleMessage(
      "Transaction Number",
    ),
    "transfer": MessageLookupByLibrary.simpleMessage("Transfer"),
    "transfer2AnotherDepartment": MessageLookupByLibrary.simpleMessage(
      "Transfer to another department",
    ),
    "transportationType": MessageLookupByLibrary.simpleMessage(
      "Transportation Type",
    ),
    "treatmentAmount": MessageLookupByLibrary.simpleMessage(
      "Treatment Cost (if reimbursement)",
    ),
    "tryAgain": MessageLookupByLibrary.simpleMessage("Try Again"),
    "turnOffVPNToEnterPaymentGateway": MessageLookupByLibrary.simpleMessage(
      "Please turn off your VPN to enter the payment gateway.",
    ),
    "type": MessageLookupByLibrary.simpleMessage("Type"),
    "typeYourComments": MessageLookupByLibrary.simpleMessage(
      "Type your comments...",
    ),
    "typeYourReasonHere": MessageLookupByLibrary.simpleMessage(
      "Type your reason here...",
    ),
    "unableOpenLink": MessageLookupByLibrary.simpleMessage(
      "Unable to open the link.",
    ),
    "unit": MessageLookupByLibrary.simpleMessage("Unit"),
    "unitExample": MessageLookupByLibrary.simpleMessage(
      "e.g.: Sales, Product Development, Support",
    ),
    "unitPrice": MessageLookupByLibrary.simpleMessage("Unit Price"),
    "unlabeled": MessageLookupByLibrary.simpleMessage("Unlabeled"),
    "unpin": MessageLookupByLibrary.simpleMessage("Unpin"),
    "unscheduled": MessageLookupByLibrary.simpleMessage("Unscheduled"),
    "unscheduledTasks": MessageLookupByLibrary.simpleMessage(
      "Unscheduled Tasks",
    ),
    "unsigned": MessageLookupByLibrary.simpleMessage("Unsigned"),
    "unsuccessfulPayment": MessageLookupByLibrary.simpleMessage("Unsuccessful"),
    "until": MessageLookupByLibrary.simpleMessage("Until"),
    "update": MessageLookupByLibrary.simpleMessage("Update"),
    "updateInvoiceInfoError": MessageLookupByLibrary.simpleMessage(
      "Error updating information",
    ),
    "updateSubTitle": MessageLookupByLibrary.simpleMessage(
      "Update to the latest version and enjoy bug fixes and improved features!",
    ),
    "updateTitle": MessageLookupByLibrary.simpleMessage(
      "A new update is available!",
    ),
    "upgradeSubscription": MessageLookupByLibrary.simpleMessage("Upgrade"),
    "upload": MessageLookupByLibrary.simpleMessage("Upload"),
    "uploadCriminalRecordClearanceCertificate":
        MessageLookupByLibrary.simpleMessage(
          "Upload Criminal Record Clearance Certificate",
        ),
    "uploadExelFile": MessageLookupByLibrary.simpleMessage("Upload Exel File"),
    "uploadFileExcelCsv": MessageLookupByLibrary.simpleMessage(
      "Upload File (Excel/CSV)",
    ),
    "uploadInvoiceReceipt": MessageLookupByLibrary.simpleMessage(
      "Upload Invoice / Receipt",
    ),
    "uploadMedicalCertificate": MessageLookupByLibrary.simpleMessage(
      "Upload Medical Certificate",
    ),
    "uploadPhoto": MessageLookupByLibrary.simpleMessage("Upload Photo"),
    "uploadSignature": MessageLookupByLibrary.simpleMessage("Upload Signature"),
    "uploadSignatureFirst": MessageLookupByLibrary.simpleMessage(
      "Please upload the signature first.",
    ),
    "uploading": MessageLookupByLibrary.simpleMessage("File is uploading..."),
    "urgency": MessageLookupByLibrary.simpleMessage("Urgency"),
    "usedThisMonth": MessageLookupByLibrary.simpleMessage("Used This Month"),
    "user": MessageLookupByLibrary.simpleMessage("Users"),
    "userActivity": MessageLookupByLibrary.simpleMessage("User Activity"),
    "userCount": MessageLookupByLibrary.simpleMessage("User Count"),
    "userSelection": MessageLookupByLibrary.simpleMessage("User Selection"),
    "users": MessageLookupByLibrary.simpleMessage("Users"),
    "valid": MessageLookupByLibrary.simpleMessage("Valid"),
    "validBeginningSignInPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "+ is only allowed at the beginning",
    ),
    "validationIssues": MessageLookupByLibrary.simpleMessage(
      "Validation Issues",
    ),
    "validityDate": MessageLookupByLibrary.simpleMessage("Validity Date"),
    "valueIsShort": m17,
    "verification": MessageLookupByLibrary.simpleMessage("Verification"),
    "verificationTextInfo": MessageLookupByLibrary.simpleMessage(
      "This section must be completed to create invoices, settle payments, and perform related actions.",
    ),
    "verified": MessageLookupByLibrary.simpleMessage("Verified"),
    "version": MessageLookupByLibrary.simpleMessage("version"),
    "video": MessageLookupByLibrary.simpleMessage("Video"),
    "viewAndDownload": MessageLookupByLibrary.simpleMessage("View & Download"),
    "voiceMessage": MessageLookupByLibrary.simpleMessage("Voice message"),
    "vpnText": MessageLookupByLibrary.simpleMessage(
      "For a better user experience and faster speed, turn off your vpn.",
    ),
    "wait": MessageLookupByLibrary.simpleMessage("Please Wait..."),
    "wantToSubmitSignature": MessageLookupByLibrary.simpleMessage(
      "Submit the signature?\n * Once submitted, it cannot be edited.",
    ),
    "warehouse": MessageLookupByLibrary.simpleMessage("Warehouse"),
    "warehouseCode": MessageLookupByLibrary.simpleMessage("Warehouse Code"),
    "warehouseModuleName": MessageLookupByLibrary.simpleMessage("Warehouse"),
    "warehouses": MessageLookupByLibrary.simpleMessage("Warehouses"),
    "warning": MessageLookupByLibrary.simpleMessage("Warning"),
    "webserviceToken": MessageLookupByLibrary.simpleMessage("Webservice Token"),
    "website": MessageLookupByLibrary.simpleMessage("Website"),
    "weekDays": MessageLookupByLibrary.simpleMessage("WeekDays"),
    "weekly": MessageLookupByLibrary.simpleMessage("Weekly"),
    "weeklyRepeatTypeHelper": MessageLookupByLibrary.simpleMessage(
      "Shifts will be created on selected weekdays until end of selected year",
    ),
    "welcome": MessageLookupByLibrary.simpleMessage("Welcome to Bermooda"),
    "welfareType": MessageLookupByLibrary.simpleMessage("Welfare Request Type"),
    "wonReason": MessageLookupByLibrary.simpleMessage("Won Reason"),
    "workLocation": MessageLookupByLibrary.simpleMessage("Work Location"),
    "workShift": MessageLookupByLibrary.simpleMessage("Work Shift"),
    "workingHours": MessageLookupByLibrary.simpleMessage("Working Hours"),
    "workload": MessageLookupByLibrary.simpleMessage("Workload"),
    "workshiftCalendarInfo": MessageLookupByLibrary.simpleMessage(
      "To make changes, click on the calendar cells.",
    ),
    "workspaceTitle": MessageLookupByLibrary.simpleMessage("Business Title"),
    "writeYourMessage": MessageLookupByLibrary.simpleMessage(
      "Type your message",
    ),
    "year": MessageLookupByLibrary.simpleMessage("Year"),
    "yes": MessageLookupByLibrary.simpleMessage("Yes"),
    "youAreEarly": m18,
    "youAreLate": m19,
    "youAreNotMemberOfThisGroup": MessageLookupByLibrary.simpleMessage(
      "You are not a member of this group.",
    ),
    "youAreOnTime": MessageLookupByLibrary.simpleMessage(
      "Great! You are on time.",
    ),
  };
}
