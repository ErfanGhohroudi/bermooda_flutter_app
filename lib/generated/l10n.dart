// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Bermooda`
  String get appName {
    return Intl.message('Bermooda', name: 'appName', desc: '', args: []);
  }

  /// `version`
  String get version {
    return Intl.message('version', name: 'version', desc: '', args: []);
  }

  /// `This item is not compatible with your current version.`
  String get notSupportedItem {
    return Intl.message(
      'This item is not compatible with your current version.',
      name: 'notSupportedItem',
      desc: '',
      args: [],
    );
  }

  /// `You don't have any active modules.`
  String get notActiveModules {
    return Intl.message(
      'You don\'t have any active modules.',
      name: 'notActiveModules',
      desc: '',
      args: [],
    );
  }

  /// `Please Wait...`
  String get wait {
    return Intl.message('Please Wait...', name: 'wait', desc: '', args: []);
  }

  /// `Welcome to Bermooda`
  String get welcome {
    return Intl.message(
      'Welcome to Bermooda',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `For a better user experience and faster speed, turn off your vpn.`
  String get vpnText {
    return Intl.message(
      'For a better user experience and faster speed, turn off your vpn.',
      name: 'vpnText',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get tryAgain {
    return Intl.message('Try Again', name: 'tryAgain', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Previous`
  String get previous {
    return Intl.message('Previous', name: 'previous', desc: '', args: []);
  }

  /// `No Result`
  String get noResult {
    return Intl.message('No Result', name: 'noResult', desc: '', args: []);
  }

  /// `Owner`
  String get owner {
    return Intl.message('Owner', name: 'owner', desc: '', args: []);
  }

  /// `Admin`
  String get admin {
    return Intl.message('Admin', name: 'admin', desc: '', args: []);
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password Recovery`
  String get passwordRecovery {
    return Intl.message(
      'Password Recovery',
      name: 'passwordRecovery',
      desc: '',
      args: [],
    );
  }

  /// `Recovery`
  String get recovery {
    return Intl.message('Recovery', name: 'recovery', desc: '', args: []);
  }

  /// `Your password has been successfully changed.`
  String get passwordChanged {
    return Intl.message(
      'Your password has been successfully changed.',
      name: 'passwordChanged',
      desc: '',
      args: [],
    );
  }

  /// `Seconds`
  String get seconds {
    return Intl.message('Seconds', name: 'seconds', desc: '', args: []);
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `to`
  String get to {
    return Intl.message('to', name: 'to', desc: '', args: []);
  }

  /// `Later`
  String get later {
    return Intl.message('Later', name: 'later', desc: '', args: []);
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `Update`
  String get update {
    return Intl.message('Update', name: 'update', desc: '', args: []);
  }

  /// `Dashboard`
  String get dashboard {
    return Intl.message('Dashboard', name: 'dashboard', desc: '', args: []);
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `Add`
  String get addText {
    return Intl.message('Add', name: 'addText', desc: '', args: []);
  }

  /// `Soon...`
  String get soon {
    return Intl.message('Soon...', name: 'soon', desc: '', args: []);
  }

  /// `More`
  String get more {
    return Intl.message('More', name: 'more', desc: '', args: []);
  }

  /// `Less`
  String get less {
    return Intl.message('Less', name: 'less', desc: '', args: []);
  }

  /// `From`
  String get from {
    return Intl.message('From', name: 'from', desc: '', args: []);
  }

  /// `Until`
  String get until {
    return Intl.message('Until', name: 'until', desc: '', args: []);
  }

  /// `Toman`
  String get toman {
    return Intl.message('Toman', name: 'toman', desc: '', args: []);
  }

  /// `New`
  String get neww {
    return Intl.message('New', name: 'neww', desc: '', args: []);
  }

  /// `Don’t have an account?`
  String get doNotHaveAnAccount {
    return Intl.message(
      'Don’t have an account?',
      name: 'doNotHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Support`
  String get support {
    return Intl.message('Support', name: 'support', desc: '', args: []);
  }

  /// `Join Date`
  String get joinDate {
    return Intl.message('Join Date', name: 'joinDate', desc: '', args: []);
  }

  /// `Archive`
  String get archive {
    return Intl.message('Archive', name: 'archive', desc: '', args: []);
  }

  /// `Archive/Removed`
  String get archiveRemoved {
    return Intl.message(
      'Archive/Removed',
      name: 'archiveRemoved',
      desc: '',
      args: [],
    );
  }

  /// `Closed-Won`
  String get closedWon {
    return Intl.message('Closed-Won', name: 'closedWon', desc: '', args: []);
  }

  /// `Storage`
  String get storage {
    return Intl.message('Storage', name: 'storage', desc: '', args: []);
  }

  /// `of`
  String get ofText {
    return Intl.message('of', name: 'ofText', desc: '', args: []);
  }

  /// `Filters`
  String get filters {
    return Intl.message('Filters', name: 'filters', desc: '', args: []);
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `Warning`
  String get warning {
    return Intl.message('Warning', name: 'warning', desc: '', args: []);
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `Project Board`
  String get projectBoard {
    return Intl.message(
      'Project Board',
      name: 'projectBoard',
      desc: '',
      args: [],
    );
  }

  /// `My Tasks`
  String get myTasks {
    return Intl.message('My Tasks', name: 'myTasks', desc: '', args: []);
  }

  /// `Customers Board`
  String get customersBoard {
    return Intl.message(
      'Customers Board',
      name: 'customersBoard',
      desc: '',
      args: [],
    );
  }

  /// `My Follow-ups`
  String get myFollowups {
    return Intl.message(
      'My Follow-ups',
      name: 'myFollowups',
      desc: '',
      args: [],
    );
  }

  /// `Requests Board`
  String get requestsBoard {
    return Intl.message(
      'Requests Board',
      name: 'requestsBoard',
      desc: '',
      args: [],
    );
  }

  /// `Cases Board`
  String get casesBoard {
    return Intl.message('Cases Board', name: 'casesBoard', desc: '', args: []);
  }

  /// `Done`
  String get doned {
    return Intl.message('Done', name: 'doned', desc: '', args: []);
  }

  /// `In Progress`
  String get inProgress {
    return Intl.message('In Progress', name: 'inProgress', desc: '', args: []);
  }

  /// `To-Do`
  String get todo {
    return Intl.message('To-Do', name: 'todo', desc: '', args: []);
  }

  /// `Behind Schedule`
  String get behindSchedule {
    return Intl.message(
      'Behind Schedule',
      name: 'behindSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Details`
  String get details {
    return Intl.message('Details', name: 'details', desc: '', args: []);
  }

  /// `Title`
  String get title {
    return Intl.message('Title', name: 'title', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `A technical issue has occurred`
  String get error400 {
    return Intl.message(
      'A technical issue has occurred',
      name: 'error400',
      desc: '',
      args: [],
    );
  }

  /// `Information not found`
  String get error404 {
    return Intl.message(
      'Information not found',
      name: 'error404',
      desc: '',
      args: [],
    );
  }

  /// `Problem in sending data`
  String get error422 {
    return Intl.message(
      'Problem in sending data',
      name: 'error422',
      desc: '',
      args: [],
    );
  }

  /// `A server error occurred\nPlease try again later`
  String get error500 {
    return Intl.message(
      'A server error occurred\nPlease try again later',
      name: 'error500',
      desc: '',
      args: [],
    );
  }

  /// `Please check your internet connection`
  String get errorNetConnection {
    return Intl.message(
      'Please check your internet connection',
      name: 'errorNetConnection',
      desc: '',
      args: [],
    );
  }

  /// `Invalid File`
  String get invalidFile {
    return Intl.message(
      'Invalid File',
      name: 'invalidFile',
      desc: '',
      args: [],
    );
  }

  /// `Some files were larger than 100 MB or unsupported and were ignored:`
  String get invalidFileInfo {
    return Intl.message(
      'Some files were larger than 100 MB or unsupported and were ignored:',
      name: 'invalidFileInfo',
      desc: '',
      args: [],
    );
  }

  /// `# is required`
  String get isRequired {
    return Intl.message(
      '# is required',
      name: 'isRequired',
      desc: '',
      args: [],
    );
  }

  /// `The time must be set in the future`
  String get timeMustBeSetInFuture {
    return Intl.message(
      'The time must be set in the future',
      name: 'timeMustBeSetInFuture',
      desc: '',
      args: [],
    );
  }

  /// `The start time must be set in the future`
  String get startTimeMustBeSetInFuture {
    return Intl.message(
      'The start time must be set in the future',
      name: 'startTimeMustBeSetInFuture',
      desc: '',
      args: [],
    );
  }

  /// `The due time must be set in the future`
  String get dueTimeMustBeSetInFuture {
    return Intl.message(
      'The due time must be set in the future',
      name: 'dueTimeMustBeSetInFuture',
      desc: '',
      args: [],
    );
  }

  /// `End time must be after start time`
  String get endTimeMustBeAfterStartTime {
    return Intl.message(
      'End time must be after start time',
      name: 'endTimeMustBeAfterStartTime',
      desc: '',
      args: [],
    );
  }

  /// `You are not allowed to change the status`
  String get notAllowChangeStatus {
    return Intl.message(
      'You are not allowed to change the status',
      name: 'notAllowChangeStatus',
      desc: '',
      args: [],
    );
  }

  /// `You have no assigned follow-ups.`
  String get haveNoAssigneeFollowup {
    return Intl.message(
      'You have no assigned follow-ups.',
      name: 'haveNoAssigneeFollowup',
      desc: '',
      args: [],
    );
  }

  /// `This feature is only available on the Advanced plan.`
  String get availableOnAdvancedPlan {
    return Intl.message(
      'This feature is only available on the Advanced plan.',
      name: 'availableOnAdvancedPlan',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get currentPassword {
    return Intl.message(
      'Current Password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm New Password`
  String get confirmNewPassword {
    return Intl.message(
      'Confirm New Password',
      name: 'confirmNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please make sure both passwords are the same`
  String get passwordsNotSame {
    return Intl.message(
      'Please make sure both passwords are the same',
      name: 'passwordsNotSame',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Account Photo`
  String get accountPhoto {
    return Intl.message(
      'Account Photo',
      name: 'accountPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Customer Profile`
  String get customerProfile {
    return Intl.message(
      'Customer Profile',
      name: 'customerProfile',
      desc: '',
      args: [],
    );
  }

  /// `Customer Info`
  String get customerInfo {
    return Intl.message(
      'Customer Info',
      name: 'customerInfo',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message('First Name', name: 'firstName', desc: '', args: []);
  }

  /// `Last Name`
  String get lastName {
    return Intl.message('Last Name', name: 'lastName', desc: '', args: []);
  }

  /// `Full Name`
  String get fullName {
    return Intl.message('Full Name', name: 'fullName', desc: '', args: []);
  }

  /// `Send Code`
  String get sendCode {
    return Intl.message('Send Code', name: 'sendCode', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Sign Up`
  String get signup {
    return Intl.message('Sign Up', name: 'signup', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Apply`
  String get apply {
    return Intl.message('Apply', name: 'apply', desc: '', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Accept`
  String get accept {
    return Intl.message('Accept', name: 'accept', desc: '', args: []);
  }

  /// `Decline`
  String get decline {
    return Intl.message('Decline', name: 'decline', desc: '', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Deleted`
  String get deleted {
    return Intl.message('Deleted', name: 'deleted', desc: '', args: []);
  }

  /// `Remove`
  String get remove {
    return Intl.message('Remove', name: 'remove', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Both`
  String get both {
    return Intl.message('Both', name: 'both', desc: '', args: []);
  }

  /// `Color`
  String get color {
    return Intl.message('Color', name: 'color', desc: '', args: []);
  }

  /// `This # is already exist`
  String get thisIsExist {
    return Intl.message(
      'This # is already exist',
      name: 'thisIsExist',
      desc: '',
      args: [],
    );
  }

  /// `At least # characters required`
  String get countOfCharactersRequired {
    return Intl.message(
      'At least # characters required',
      name: 'countOfCharactersRequired',
      desc: '',
      args: [],
    );
  }

  /// `* Tap the Enter key on your keyboard to add.`
  String get tapEnterToAdd {
    return Intl.message(
      '* Tap the Enter key on your keyboard to add.',
      name: 'tapEnterToAdd',
      desc: '',
      args: [],
    );
  }

  /// `New Customer`
  String get newCustomer {
    return Intl.message(
      'New Customer',
      name: 'newCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Edit Customer`
  String get editCustomer {
    return Intl.message(
      'Edit Customer',
      name: 'editCustomer',
      desc: '',
      args: [],
    );
  }

  /// `New Task`
  String get newTask {
    return Intl.message('New Task', name: 'newTask', desc: '', args: []);
  }

  /// `Edit Task`
  String get editTask {
    return Intl.message('Edit Task', name: 'editTask', desc: '', args: []);
  }

  /// `Label`
  String get label {
    return Intl.message('Label', name: 'label', desc: '', args: []);
  }

  /// `Unlabeled`
  String get unlabeled {
    return Intl.message('Unlabeled', name: 'unlabeled', desc: '', args: []);
  }

  /// `New Label`
  String get newLabel {
    return Intl.message('New Label', name: 'newLabel', desc: '', args: []);
  }

  /// `Edit Label`
  String get editLabel {
    return Intl.message('Edit Label', name: 'editLabel', desc: '', args: []);
  }

  /// `New Meeting`
  String get newMeeting {
    return Intl.message('New Meeting', name: 'newMeeting', desc: '', args: []);
  }

  /// `Edit Meeting`
  String get editMeeting {
    return Intl.message(
      'Edit Meeting',
      name: 'editMeeting',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get requiredField {
    return Intl.message(
      'This field is required',
      name: 'requiredField',
      desc: '',
      args: [],
    );
  }

  /// `Invalid number format`
  String get invalidPhoneNumber {
    return Intl.message(
      'Invalid number format',
      name: 'invalidPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `+ is only allowed at the beginning`
  String get validBeginningSignInPhoneNumber {
    return Intl.message(
      '+ is only allowed at the beginning',
      name: 'validBeginningSignInPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `The email address is not valid`
  String get invalidEmailAddress {
    return Intl.message(
      'The email address is not valid',
      name: 'invalidEmailAddress',
      desc: '',
      args: [],
    );
  }

  /// `The entered value is too short (minimum # characters)`
  String get isShort {
    return Intl.message(
      'The entered value is too short (minimum # characters)',
      name: 'isShort',
      desc: '',
      args: [],
    );
  }

  /// `Pull to refresh`
  String get pullToRefresh {
    return Intl.message(
      'Pull to refresh',
      name: 'pullToRefresh',
      desc: '',
      args: [],
    );
  }

  /// `Release to refresh`
  String get releaseToRefresh {
    return Intl.message(
      'Release to refresh',
      name: 'releaseToRefresh',
      desc: '',
      args: [],
    );
  }

  /// `Failed`
  String get failed {
    return Intl.message('Failed', name: 'failed', desc: '', args: []);
  }

  /// `Completed`
  String get completed {
    return Intl.message('Completed', name: 'completed', desc: '', args: []);
  }

  /// `Fetch more data`
  String get fetchMoreData {
    return Intl.message(
      'Fetch more data',
      name: 'fetchMoreData',
      desc: '',
      args: [],
    );
  }

  /// `Connection lost`
  String get connectionLost {
    return Intl.message(
      'Connection lost',
      name: 'connectionLost',
      desc: '',
      args: [],
    );
  }

  /// `Connecting...`
  String get connecting {
    return Intl.message(
      'Connecting...',
      name: 'connecting',
      desc: '',
      args: [],
    );
  }

  /// `Refreshing...`
  String get refreshing {
    return Intl.message(
      'Refreshing...',
      name: 'refreshing',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `File is uploading...`
  String get uploading {
    return Intl.message(
      'File is uploading...',
      name: 'uploading',
      desc: '',
      args: [],
    );
  }

  /// `Downloading...`
  String get downloading {
    return Intl.message(
      'Downloading...',
      name: 'downloading',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to log out?`
  String get areYouSureYouWantToLogOut {
    return Intl.message(
      'Do you want to log out?',
      name: 'areYouSureYouWantToLogOut',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this?`
  String get areYouSureYouWantToDeleteItem {
    return Intl.message(
      'Are you sure you want to delete this?',
      name: 'areYouSureYouWantToDeleteItem',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this message?`
  String get areYouSureToDeleteMessage {
    return Intl.message(
      'Are you sure you want to delete this message?',
      name: 'areYouSureToDeleteMessage',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this customer?`
  String get areYouSureToDeleteCustomer {
    return Intl.message(
      'Are you sure you want to delete this customer?',
      name: 'areYouSureToDeleteCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this project?`
  String get areYouSureToDeleteProject {
    return Intl.message(
      'Are you sure you want to delete this project?',
      name: 'areYouSureToDeleteProject',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this category?`
  String get areYouSureToDeleteCategory {
    return Intl.message(
      'Are you sure you want to delete this category?',
      name: 'areYouSureToDeleteCategory',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete this business?`
  String get areYouSureToDeleteBusiness {
    return Intl.message(
      'Do you want to delete this business?',
      name: 'areYouSureToDeleteBusiness',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to change the phone number?`
  String get areYouSureToChangePhoneNumber {
    return Intl.message(
      'Do you want to change the phone number?',
      name: 'areYouSureToChangePhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter the 6-digit code sent to (#).`
  String get otpInfoText {
    return Intl.message(
      'Enter the 6-digit code sent to (#).',
      name: 'otpInfoText',
      desc: '',
      args: [],
    );
  }

  /// `Didn't receive the code?`
  String get otpCodeNotReceived {
    return Intl.message(
      'Didn\'t receive the code?',
      name: 'otpCodeNotReceived',
      desc: '',
      args: [],
    );
  }

  /// `RESEND`
  String get resend {
    return Intl.message('RESEND', name: 'resend', desc: '', args: []);
  }

  /// `New Workspace`
  String get newWorkspace {
    return Intl.message(
      'New Workspace',
      name: 'newWorkspace',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message('Camera', name: 'camera', desc: '', args: []);
  }

  /// `Photo`
  String get photo {
    return Intl.message('Photo', name: 'photo', desc: '', args: []);
  }

  /// `File`
  String get file {
    return Intl.message('File', name: 'file', desc: '', args: []);
  }

  /// `Reply`
  String get reply {
    return Intl.message('Reply', name: 'reply', desc: '', args: []);
  }

  /// `Message`
  String get message {
    return Intl.message('Message', name: 'message', desc: '', args: []);
  }

  /// `List is Empty!`
  String get listIsEmpty {
    return Intl.message(
      'List is Empty!',
      name: 'listIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `No Data`
  String get noData {
    return Intl.message('No Data', name: 'noData', desc: '', args: []);
  }

  /// `Write your message`
  String get writeYourMessage {
    return Intl.message(
      'Write your message',
      name: 'writeYourMessage',
      desc: '',
      args: [],
    );
  }

  /// `Medias`
  String get medias {
    return Intl.message('Medias', name: 'medias', desc: '', args: []);
  }

  /// `Next Month`
  String get nextMonth {
    return Intl.message('Next Month', name: 'nextMonth', desc: '', args: []);
  }

  /// `Previous Month`
  String get previousMonth {
    return Intl.message(
      'Previous Month',
      name: 'previousMonth',
      desc: '',
      args: [],
    );
  }

  /// `Next Year`
  String get nextYear {
    return Intl.message('Next Year', name: 'nextYear', desc: '', args: []);
  }

  /// `Previous Year`
  String get previousYear {
    return Intl.message(
      'Previous Year',
      name: 'previousYear',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message('Start', name: 'start', desc: '', args: []);
  }

  /// `End`
  String get end {
    return Intl.message('End', name: 'end', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Mails`
  String get mails {
    return Intl.message('Mails', name: 'mails', desc: '', args: []);
  }

  /// `Attendance`
  String get attendance {
    return Intl.message('Attendance', name: 'attendance', desc: '', args: []);
  }

  /// `Conversation`
  String get conversation {
    return Intl.message(
      'Conversation',
      name: 'conversation',
      desc: '',
      args: [],
    );
  }

  /// `Conversations`
  String get conversations {
    return Intl.message(
      'Conversations',
      name: 'conversations',
      desc: '',
      args: [],
    );
  }

  /// `Calendar`
  String get calendar {
    return Intl.message('Calendar', name: 'calendar', desc: '', args: []);
  }

  /// `Human Resources`
  String get humanResources {
    return Intl.message(
      'Human Resources',
      name: 'humanResources',
      desc: '',
      args: [],
    );
  }

  /// `Notice`
  String get notice {
    return Intl.message('Notice', name: 'notice', desc: '', args: []);
  }

  /// `Step`
  String get step {
    return Intl.message('Step', name: 'step', desc: '', args: []);
  }

  /// `Steps`
  String get steps {
    return Intl.message('Steps', name: 'steps', desc: '', args: []);
  }

  /// `Enter the step title`
  String get enterStepTitle {
    return Intl.message(
      'Enter the step title',
      name: 'enterStepTitle',
      desc: '',
      args: [],
    );
  }

  /// `The number of steps cannot be less than 2.`
  String get stepLengthError {
    return Intl.message(
      'The number of steps cannot be less than 2.',
      name: 'stepLengthError',
      desc: '',
      args: [],
    );
  }

  /// `Requests`
  String get requests {
    return Intl.message('Requests', name: 'requests', desc: '', args: []);
  }

  /// `Exit`
  String get exit {
    return Intl.message('Exit', name: 'exit', desc: '', args: []);
  }

  /// `Leave this page?\n*Unsaved changes will be lost.`
  String get exitPage {
    return Intl.message(
      'Leave this page?\n*Unsaved changes will be lost.',
      name: 'exitPage',
      desc: '',
      args: [],
    );
  }

  /// `Exit the app?`
  String get exitApp {
    return Intl.message('Exit the app?', name: 'exitApp', desc: '', args: []);
  }

  /// `Change status?`
  String get changeStatus {
    return Intl.message(
      'Change status?',
      name: 'changeStatus',
      desc: '',
      args: [],
    );
  }

  /// `You are not allowed to change the status.`
  String get notAuthorizedToChangeStatus {
    return Intl.message(
      'You are not allowed to change the status.',
      name: 'notAuthorizedToChangeStatus',
      desc: '',
      args: [],
    );
  }

  /// `Change task status to 'Done'?`
  String get changeTaskStatusToDone {
    return Intl.message(
      'Change task status to \'Done\'?',
      name: 'changeTaskStatusToDone',
      desc: '',
      args: [],
    );
  }

  /// `Change subtask status to 'Done'?`
  String get changeSubtaskStatusToDone {
    return Intl.message(
      'Change subtask status to \'Done\'?',
      name: 'changeSubtaskStatusToDone',
      desc: '',
      args: [],
    );
  }

  /// `Change subtask progress to '#'?`
  String get changeSubtaskProgressTo {
    return Intl.message(
      'Change subtask progress to \'#\'?',
      name: 'changeSubtaskProgressTo',
      desc: '',
      args: [],
    );
  }

  /// `Returning to the previous status is not allowed`
  String get cannotChangeStatus {
    return Intl.message(
      'Returning to the previous status is not allowed',
      name: 'cannotChangeStatus',
      desc: '',
      args: [],
    );
  }

  /// `Change step to (#)?`
  String get changeStep {
    return Intl.message(
      'Change step to (#)?',
      name: 'changeStep',
      desc: '',
      args: [],
    );
  }

  /// `Change step status?`
  String get changeStepStatus {
    return Intl.message(
      'Change step status?',
      name: 'changeStepStatus',
      desc: '',
      args: [],
    );
  }

  /// `Returning to the previous step is not allowed`
  String get cannotChangeStep {
    return Intl.message(
      'Returning to the previous step is not allowed',
      name: 'cannotChangeStep',
      desc: '',
      args: [],
    );
  }

  /// `Cannot move completed steps.`
  String get cannotMoveCompletedSteps {
    return Intl.message(
      'Cannot move completed steps.',
      name: 'cannotMoveCompletedSteps',
      desc: '',
      args: [],
    );
  }

  /// `Incomplete steps cannot be inserted between completed ones.`
  String get cannotInsertInCompletedBetweenCompletedSteps {
    return Intl.message(
      'Incomplete steps cannot be inserted between completed ones.',
      name: 'cannotInsertInCompletedBetweenCompletedSteps',
      desc: '',
      args: [],
    );
  }

  /// `Cannot Delete Completed Steps.`
  String get cannotDeleteCompletedSteps {
    return Intl.message(
      'Cannot Delete Completed Steps.',
      name: 'cannotDeleteCompletedSteps',
      desc: '',
      args: [],
    );
  }

  /// `Location Permission`
  String get locationPermission {
    return Intl.message(
      'Location Permission',
      name: 'locationPermission',
      desc: '',
      args: [],
    );
  }

  /// `Location services (GPS) are disabled. Please turn them on`
  String get gpsIsOff {
    return Intl.message(
      'Location services (GPS) are disabled. Please turn them on',
      name: 'gpsIsOff',
      desc: '',
      args: [],
    );
  }

  /// `This app uses your location only at the moment of clocking in/out to ensure you are within the company premises and to validate your attendance record.`
  String get getLocationDescribe {
    return Intl.message(
      'This app uses your location only at the moment of clocking in/out to ensure you are within the company premises and to validate your attendance record.',
      name: 'getLocationDescribe',
      desc: '',
      args: [],
    );
  }

  /// `Location access is required to register attendance.`
  String get locationIsRequiredToAttendance {
    return Intl.message(
      'Location access is required to register attendance.',
      name: 'locationIsRequiredToAttendance',
      desc: '',
      args: [],
    );
  }

  /// `You have permanently denied location access.\nTo use this feature, please enable it from the device settings.`
  String get enableLocationAccess {
    return Intl.message(
      'You have permanently denied location access.\nTo use this feature, please enable it from the device settings.',
      name: 'enableLocationAccess',
      desc: '',
      args: [],
    );
  }

  /// `Could not retrieve location within the time limit. Please check your internet and GPS connection and try again.`
  String get locationTimeLimit {
    return Intl.message(
      'Could not retrieve location within the time limit. Please check your internet and GPS connection and try again.',
      name: 'locationTimeLimit',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while fetching the location.`
  String get locationFailedError {
    return Intl.message(
      'An error occurred while fetching the location.',
      name: 'locationFailedError',
      desc: '',
      args: [],
    );
  }

  /// `Scan The QR Code`
  String get scanQRCode {
    return Intl.message(
      'Scan The QR Code',
      name: 'scanQRCode',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message('Today', name: 'today', desc: '', args: []);
  }

  /// `Not Now!`
  String get notNow {
    return Intl.message('Not Now!', name: 'notNow', desc: '', args: []);
  }

  /// `A new update is available!`
  String get updateTitle {
    return Intl.message(
      'A new update is available!',
      name: 'updateTitle',
      desc: '',
      args: [],
    );
  }

  /// `Update to the latest version and enjoy bug fixes and improved features!`
  String get updateSubTitle {
    return Intl.message(
      'Update to the latest version and enjoy bug fixes and improved features!',
      name: 'updateSubTitle',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message('Category', name: 'category', desc: '', args: []);
  }

  /// `Sub-category`
  String get subcategory {
    return Intl.message(
      'Sub-category',
      name: 'subcategory',
      desc: '',
      args: [],
    );
  }

  /// `Move Task`
  String get moveTask {
    return Intl.message('Move Task', name: 'moveTask', desc: '', args: []);
  }

  /// `Move Customer`
  String get moveCustomer {
    return Intl.message(
      'Move Customer',
      name: 'moveCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `No Notifications`
  String get noNotifications {
    return Intl.message(
      'No Notifications',
      name: 'noNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Task`
  String get task {
    return Intl.message('Task', name: 'task', desc: '', args: []);
  }

  /// `Tasks`
  String get tasks {
    return Intl.message('Tasks', name: 'tasks', desc: '', args: []);
  }

  /// `Select Invoice`
  String get selectInvoice {
    return Intl.message(
      'Select Invoice',
      name: 'selectInvoice',
      desc: '',
      args: [],
    );
  }

  /// `New Invoice`
  String get newInvoice {
    return Intl.message('New Invoice', name: 'newInvoice', desc: '', args: []);
  }

  /// `By selecting this option, your customer will be transferred to my customer list.`
  String get noFollowUpInfo {
    return Intl.message(
      'By selecting this option, your customer will be transferred to my customer list.',
      name: 'noFollowUpInfo',
      desc: '',
      args: [],
    );
  }

  /// `What was the reason for closing this customer?`
  String get customerStatusInfo {
    return Intl.message(
      'What was the reason for closing this customer?',
      name: 'customerStatusInfo',
      desc: '',
      args: [],
    );
  }

  /// `The customer has been added to the archive.`
  String get customerAddedToArchiveList {
    return Intl.message(
      'The customer has been added to the archive.',
      name: 'customerAddedToArchiveList',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message('Status', name: 'status', desc: '', args: []);
  }

  /// `Type your comments...`
  String get typeYourComments {
    return Intl.message(
      'Type your comments...',
      name: 'typeYourComments',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Time`
  String get time {
    return Intl.message('Time', name: 'time', desc: '', args: []);
  }

  /// `Time Tracking`
  String get timeTracking {
    return Intl.message(
      'Time Tracking',
      name: 'timeTracking',
      desc: '',
      args: [],
    );
  }

  /// `Progress Status`
  String get progressStatus {
    return Intl.message(
      'Progress Status',
      name: 'progressStatus',
      desc: '',
      args: [],
    );
  }

  /// `No date`
  String get noDate {
    return Intl.message('No date', name: 'noDate', desc: '', args: []);
  }

  /// `Start Time`
  String get startTime {
    return Intl.message('Start Time', name: 'startTime', desc: '', args: []);
  }

  /// `End Time`
  String get endTime {
    return Intl.message('End Time', name: 'endTime', desc: '', args: []);
  }

  /// `Start Date`
  String get startDate {
    return Intl.message('Start Date', name: 'startDate', desc: '', args: []);
  }

  /// `End Date`
  String get endDate {
    return Intl.message('End Date', name: 'endDate', desc: '', args: []);
  }

  /// `Reminder Time`
  String get reminderTime {
    return Intl.message(
      'Reminder Time',
      name: 'reminderTime',
      desc: '',
      args: [],
    );
  }

  /// `Additional Info`
  String get additionalInfo {
    return Intl.message(
      'Additional Info',
      name: 'additionalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Representative`
  String get representative {
    return Intl.message(
      'Representative',
      name: 'representative',
      desc: '',
      args: [],
    );
  }

  /// `Representative Info`
  String get representativeInfo {
    return Intl.message(
      'Representative Info',
      name: 'representativeInfo',
      desc: '',
      args: [],
    );
  }

  /// `Representative Name`
  String get representativeName {
    return Intl.message(
      'Representative Name',
      name: 'representativeName',
      desc: '',
      args: [],
    );
  }

  /// `Website`
  String get website {
    return Intl.message('Website', name: 'website', desc: '', args: []);
  }

  /// `Link`
  String get link {
    return Intl.message('Link', name: 'link', desc: '', args: []);
  }

  /// `Direct Link`
  String get directLink {
    return Intl.message('Direct Link', name: 'directLink', desc: '', args: []);
  }

  /// `Social Media Link`
  String get socialMediaLink {
    return Intl.message(
      'Social Media Link',
      name: 'socialMediaLink',
      desc: '',
      args: [],
    );
  }

  /// `Link is empty.`
  String get linkIsEmpty {
    return Intl.message(
      'Link is empty.',
      name: 'linkIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Unable to open the link.`
  String get unableOpenLink {
    return Intl.message(
      'Unable to open the link.',
      name: 'unableOpenLink',
      desc: '',
      args: [],
    );
  }

  /// `The entered link format is invalid.`
  String get linkFormatIsInvalid {
    return Intl.message(
      'The entered link format is invalid.',
      name: 'linkFormatIsInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Customer Name`
  String get customerName {
    return Intl.message(
      'Customer Name',
      name: 'customerName',
      desc: '',
      args: [],
    );
  }

  /// `Upload Photo`
  String get uploadPhoto {
    return Intl.message(
      'Upload Photo',
      name: 'uploadPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Section`
  String get section {
    return Intl.message('Section', name: 'section', desc: '', args: []);
  }

  /// `Contact Preference`
  String get contactPreference {
    return Intl.message(
      'Contact Preference',
      name: 'contactPreference',
      desc: '',
      args: [],
    );
  }

  /// `Assignee`
  String get assignee {
    return Intl.message('Assignee', name: 'assignee', desc: '', args: []);
  }

  /// `Date of Entry`
  String get dateOfEntry {
    return Intl.message(
      'Date of Entry',
      name: 'dateOfEntry',
      desc: '',
      args: [],
    );
  }

  /// `Invoice`
  String get invoice {
    return Intl.message('Invoice', name: 'invoice', desc: '', args: []);
  }

  /// `Invoices`
  String get invoices {
    return Intl.message('Invoices', name: 'invoices', desc: '', args: []);
  }

  /// `Payment Receipt`
  String get paymentReceipt {
    return Intl.message(
      'Payment Receipt',
      name: 'paymentReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Invoice ID`
  String get invoiceId {
    return Intl.message('Invoice ID', name: 'invoiceId', desc: '', args: []);
  }

  /// `Invoice Type`
  String get invoiceType {
    return Intl.message(
      'Invoice Type',
      name: 'invoiceType',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Meeting Type`
  String get meetingType {
    return Intl.message(
      'Meeting Type',
      name: 'meetingType',
      desc: '',
      args: [],
    );
  }

  /// `Repeat`
  String get repeat {
    return Intl.message('Repeat', name: 'repeat', desc: '', args: []);
  }

  /// `Restore`
  String get restore {
    return Intl.message('Restore', name: 'restore', desc: '', args: []);
  }

  /// `Do you want to restore?`
  String get restoreDescription {
    return Intl.message(
      'Do you want to restore?',
      name: 'restoreDescription',
      desc: '',
      args: [],
    );
  }

  /// `Staff Management`
  String get staffManagement {
    return Intl.message(
      'Staff Management',
      name: 'staffManagement',
      desc: '',
      args: [],
    );
  }

  /// `Members`
  String get members {
    return Intl.message('Members', name: 'members', desc: '', args: []);
  }

  /// `Members`
  String get member {
    return Intl.message('Members', name: 'member', desc: '', args: []);
  }

  /// `Members List`
  String get membersList {
    return Intl.message(
      'Members List',
      name: 'membersList',
      desc: '',
      args: [],
    );
  }

  /// `Removed Members`
  String get removedMembers {
    return Intl.message(
      'Removed Members',
      name: 'removedMembers',
      desc: '',
      args: [],
    );
  }

  /// `Invite Members`
  String get inviteMembers {
    return Intl.message(
      'Invite Members',
      name: 'inviteMembers',
      desc: '',
      args: [],
    );
  }

  /// `Accessible Members`
  String get accessibleMembers {
    return Intl.message(
      'Accessible Members',
      name: 'accessibleMembers',
      desc: '',
      args: [],
    );
  }

  /// `* Only members selected as Managers and Specialists will have access to this project.`
  String get projectAccessibleMembersHelper {
    return Intl.message(
      '* Only members selected as Managers and Specialists will have access to this project.',
      name: 'projectAccessibleMembersHelper',
      desc: '',
      args: [],
    );
  }

  /// `* Only members selected as Managers and Specialists will have access to this customer category.`
  String get crmAccessibleMembersHelper {
    return Intl.message(
      '* Only members selected as Managers and Specialists will have access to this customer category.',
      name: 'crmAccessibleMembersHelper',
      desc: '',
      args: [],
    );
  }

  /// `* Only members selected as Managers and Specialists will have access to this department.`
  String get humanResourcesAccessibleMembersHelper {
    return Intl.message(
      '* Only members selected as Managers and Specialists will have access to this department.',
      name: 'humanResourcesAccessibleMembersHelper',
      desc: '',
      args: [],
    );
  }

  /// `Invite Guests`
  String get inviteGuests {
    return Intl.message(
      'Invite Guests',
      name: 'inviteGuests',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message('Help', name: 'help', desc: '', args: []);
  }

  /// `Company/Business Logo`
  String get logo {
    return Intl.message(
      'Company/Business Logo',
      name: 'logo',
      desc: '',
      args: [],
    );
  }

  /// `Business Name`
  String get businessName {
    return Intl.message(
      'Business Name',
      name: 'businessName',
      desc: '',
      args: [],
    );
  }

  /// `Industry`
  String get industry {
    return Intl.message('Industry', name: 'industry', desc: '', args: []);
  }

  /// `Business Size`
  String get businessSize {
    return Intl.message(
      'Business Size',
      name: 'businessSize',
      desc: '',
      args: [],
    );
  }

  /// `My Business List`
  String get myBusinessList {
    return Intl.message(
      'My Business List',
      name: 'myBusinessList',
      desc: '',
      args: [],
    );
  }

  /// `My Businesses`
  String get myBusinesses {
    return Intl.message(
      'My Businesses',
      name: 'myBusinesses',
      desc: '',
      args: [],
    );
  }

  /// `Switched to (#) business`
  String get SwitchedBusiness {
    return Intl.message(
      'Switched to (#) business',
      name: 'SwitchedBusiness',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message('Country', name: 'country', desc: '', args: []);
  }

  /// `Province`
  String get state {
    return Intl.message('Province', name: 'state', desc: '', args: []);
  }

  /// `City`
  String get city {
    return Intl.message('City', name: 'city', desc: '', args: []);
  }

  /// `Verification`
  String get verification {
    return Intl.message(
      'Verification',
      name: 'verification',
      desc: '',
      args: [],
    );
  }

  /// `This section must be completed to create invoices, settle payments, and perform related actions.`
  String get verificationTextInfo {
    return Intl.message(
      'This section must be completed to create invoices, settle payments, and perform related actions.',
      name: 'verificationTextInfo',
      desc: '',
      args: [],
    );
  }

  /// `National ID`
  String get nationalID {
    return Intl.message('National ID', name: 'nationalID', desc: '', args: []);
  }

  /// `Birth Certificate Number`
  String get birthCertificateNumber {
    return Intl.message(
      'Birth Certificate Number',
      name: 'birthCertificateNumber',
      desc: '',
      args: [],
    );
  }

  /// `IBAN`
  String get iban {
    return Intl.message('IBAN', name: 'iban', desc: '', args: []);
  }

  /// `Iran's IBAN number must be 26 characters long.`
  String get iranIBANisShort {
    return Intl.message(
      'Iran\'s IBAN number must be 26 characters long.',
      name: 'iranIBANisShort',
      desc: '',
      args: [],
    );
  }

  /// `The IBAN is invalid.`
  String get invalidIBAN {
    return Intl.message(
      'The IBAN is invalid.',
      name: 'invalidIBAN',
      desc: '',
      args: [],
    );
  }

  /// `The IBAN format is invalid.`
  String get invalidIBANFormat {
    return Intl.message(
      'The IBAN format is invalid.',
      name: 'invalidIBANFormat',
      desc: '',
      args: [],
    );
  }

  /// `Postal Code`
  String get postalCode {
    return Intl.message('Postal Code', name: 'postalCode', desc: '', args: []);
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `Organization name`
  String get companyName {
    return Intl.message(
      'Organization name',
      name: 'companyName',
      desc: '',
      args: [],
    );
  }

  /// `National ID`
  String get companyNationalID {
    return Intl.message(
      'National ID',
      name: 'companyNationalID',
      desc: '',
      args: [],
    );
  }

  /// `Registration Number`
  String get registrationNumber {
    return Intl.message(
      'Registration Number',
      name: 'registrationNumber',
      desc: '',
      args: [],
    );
  }

  /// `Economic Code`
  String get economicCode {
    return Intl.message(
      'Economic Code',
      name: 'economicCode',
      desc: '',
      args: [],
    );
  }

  /// `Landline`
  String get landline {
    return Intl.message('Landline', name: 'landline', desc: '', args: []);
  }

  /// `Ext`
  String get extension {
    return Intl.message('Ext', name: 'extension', desc: '', args: []);
  }

  /// `Fax`
  String get fax {
    return Intl.message('Fax', name: 'fax', desc: '', args: []);
  }

  /// `Upload National ID Card`
  String get uploadNationalIDCard {
    return Intl.message(
      'Upload National ID Card',
      name: 'uploadNationalIDCard',
      desc: '',
      args: [],
    );
  }

  /// `Uploading the national ID card photo is required.`
  String get uploadNationalIDCardIsRequired {
    return Intl.message(
      'Uploading the national ID card photo is required.',
      name: 'uploadNationalIDCardIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Upload Business Registration / License`
  String get uploadBusinessRegistrationLicense {
    return Intl.message(
      'Upload Business Registration / License',
      name: 'uploadBusinessRegistrationLicense',
      desc: '',
      args: [],
    );
  }

  /// `Uploading the business registration or license is required.`
  String get uploadBusinessRegistrationLicenseIsRequired {
    return Intl.message(
      'Uploading the business registration or license is required.',
      name: 'uploadBusinessRegistrationLicenseIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Verified`
  String get verified {
    return Intl.message('Verified', name: 'verified', desc: '', args: []);
  }

  /// `Not Verified`
  String get notVerified {
    return Intl.message(
      'Not Verified',
      name: 'notVerified',
      desc: '',
      args: [],
    );
  }

  /// `By entering a phone number or email address, an invitation will be sent to the guests.\nIf you enter a phone number, the invitation will be sent via SMS. If you enter an email address, it will be sent via email.`
  String get inviteGuestsHelper {
    return Intl.message(
      'By entering a phone number or email address, an invitation will be sent to the guests.\nIf you enter a phone number, the invitation will be sent via SMS. If you enter an email address, it will be sent via email.',
      name: 'inviteGuestsHelper',
      desc: '',
      args: [],
    );
  }

  /// `Business Title`
  String get workspaceTitle {
    return Intl.message(
      'Business Title',
      name: 'workspaceTitle',
      desc: '',
      args: [],
    );
  }

  /// `Dear #, to access your personalized business dashboard, you need to complete your business information and activate the dashboard.`
  String get authenticationNeedsDialogText {
    return Intl.message(
      'Dear #, to access your personalized business dashboard, you need to complete your business information and activate the dashboard.',
      name: 'authenticationNeedsDialogText',
      desc: '',
      args: [],
    );
  }

  /// `Invitation Pending Approval`
  String get pendingInvitation {
    return Intl.message(
      'Invitation Pending Approval',
      name: 'pendingInvitation',
      desc: '',
      args: [],
    );
  }

  /// `New Member`
  String get newMember {
    return Intl.message('New Member', name: 'newMember', desc: '', args: []);
  }

  /// `Add Member`
  String get addMember {
    return Intl.message('Add Member', name: 'addMember', desc: '', args: []);
  }

  /// `Add to members list?`
  String get addMemberDialog {
    return Intl.message(
      'Add to members list?',
      name: 'addMemberDialog',
      desc: '',
      args: [],
    );
  }

  /// `Edit Member`
  String get editMember {
    return Intl.message('Edit Member', name: 'editMember', desc: '', args: []);
  }

  /// `Remove Member`
  String get removeMember {
    return Intl.message(
      'Remove Member',
      name: 'removeMember',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to remove this user? They will immediately lose access to the dashboard, and their assigned tasks will need to be reassigned.`
  String get areYouSureToRemoveMember {
    return Intl.message(
      'Are you sure you want to remove this user? They will immediately lose access to the dashboard, and their assigned tasks will need to be reassigned.',
      name: 'areYouSureToRemoveMember',
      desc: '',
      args: [],
    );
  }

  /// `Send Invitation`
  String get sendInvitation {
    return Intl.message(
      'Send Invitation',
      name: 'sendInvitation',
      desc: '',
      args: [],
    );
  }

  /// `Access Levels`
  String get accessLevels {
    return Intl.message(
      'Access Levels',
      name: 'accessLevels',
      desc: '',
      args: [],
    );
  }

  /// `Date of Birth`
  String get dateOfBirth {
    return Intl.message(
      'Date of Birth',
      name: 'dateOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get day {
    return Intl.message('Day', name: 'day', desc: '', args: []);
  }

  /// `Days`
  String get days {
    return Intl.message('Days', name: 'days', desc: '', args: []);
  }

  /// `Daily`
  String get daily {
    return Intl.message('Daily', name: 'daily', desc: '', args: []);
  }

  /// `Month`
  String get month {
    return Intl.message('Month', name: 'month', desc: '', args: []);
  }

  /// `Year`
  String get year {
    return Intl.message('Year', name: 'year', desc: '', args: []);
  }

  /// `Months`
  String get months {
    return Intl.message('Months', name: 'months', desc: '', args: []);
  }

  /// `Gender`
  String get gender {
    return Intl.message('Gender', name: 'gender', desc: '', args: []);
  }

  /// `Military Status`
  String get militaryStatus {
    return Intl.message(
      'Military Status',
      name: 'militaryStatus',
      desc: '',
      args: [],
    );
  }

  /// `Marital Status`
  String get maritalStatus {
    return Intl.message(
      'Marital Status',
      name: 'maritalStatus',
      desc: '',
      args: [],
    );
  }

  /// `Single`
  String get single {
    return Intl.message('Single', name: 'single', desc: '', args: []);
  }

  /// `Married`
  String get married {
    return Intl.message('Married', name: 'married', desc: '', args: []);
  }

  /// `Number of Children`
  String get numberOfChildren {
    return Intl.message(
      'Number of Children',
      name: 'numberOfChildren',
      desc: '',
      args: [],
    );
  }

  /// `Education Info`
  String get educationInfo {
    return Intl.message(
      'Education Info',
      name: 'educationInfo',
      desc: '',
      args: [],
    );
  }

  /// `Educational Degree`
  String get educationalDegree {
    return Intl.message(
      'Educational Degree',
      name: 'educationalDegree',
      desc: '',
      args: [],
    );
  }

  /// `Field of Study`
  String get fieldOfStudy {
    return Intl.message(
      'Field of Study',
      name: 'fieldOfStudy',
      desc: '',
      args: [],
    );
  }

  /// `Employment Info`
  String get employmentInfo {
    return Intl.message(
      'Employment Info',
      name: 'employmentInfo',
      desc: '',
      args: [],
    );
  }

  /// `Employment Role`
  String get employmentRole {
    return Intl.message(
      'Employment Role',
      name: 'employmentRole',
      desc: '',
      args: [],
    );
  }

  /// `Role`
  String get role {
    return Intl.message('Role', name: 'role', desc: '', args: []);
  }

  /// `Personnel Code`
  String get personnelCode {
    return Intl.message(
      'Personnel Code',
      name: 'personnelCode',
      desc: '',
      args: [],
    );
  }

  /// `Employment Type`
  String get employmentType {
    return Intl.message(
      'Employment Type',
      name: 'employmentType',
      desc: '',
      args: [],
    );
  }

  /// `Salary Type`
  String get salaryType {
    return Intl.message('Salary Type', name: 'salaryType', desc: '', args: []);
  }

  /// `Favorite`
  String get favorite {
    return Intl.message('Favorite', name: 'favorite', desc: '', args: []);
  }

  /// `Favorites`
  String get favorites {
    return Intl.message('Favorites', name: 'favorites', desc: '', args: []);
  }

  /// `Skill`
  String get skill {
    return Intl.message('Skill', name: 'skill', desc: '', args: []);
  }

  /// `Skills`
  String get skills {
    return Intl.message('Skills', name: 'skills', desc: '', args: []);
  }

  /// `Insurance`
  String get insurance {
    return Intl.message('Insurance', name: 'insurance', desc: '', args: []);
  }

  /// `Contract Start Date`
  String get contractStartDate {
    return Intl.message(
      'Contract Start Date',
      name: 'contractStartDate',
      desc: '',
      args: [],
    );
  }

  /// `Contract End Date`
  String get contractEndDate {
    return Intl.message(
      'Contract End Date',
      name: 'contractEndDate',
      desc: '',
      args: [],
    );
  }

  /// `Upload Criminal Record Clearance Certificate`
  String get uploadCriminalRecordClearanceCertificate {
    return Intl.message(
      'Upload Criminal Record Clearance Certificate',
      name: 'uploadCriminalRecordClearanceCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Emergency Info`
  String get emergencyInformation {
    return Intl.message(
      'Emergency Info',
      name: 'emergencyInformation',
      desc: '',
      args: [],
    );
  }

  /// `In case of emergency and if the user is unreachable, this person will be contacted.`
  String get emergencyInfoText {
    return Intl.message(
      'In case of emergency and if the user is unreachable, this person will be contacted.',
      name: 'emergencyInfoText',
      desc: '',
      args: [],
    );
  }

  /// `Relationship`
  String get relationship {
    return Intl.message(
      'Relationship',
      name: 'relationship',
      desc: '',
      args: [],
    );
  }

  /// `Attachment`
  String get attachment {
    return Intl.message('Attachment', name: 'attachment', desc: '', args: []);
  }

  /// `Attachments`
  String get attachments {
    return Intl.message('Attachments', name: 'attachments', desc: '', args: []);
  }

  /// `Has`
  String get hasAttachment {
    return Intl.message('Has', name: 'hasAttachment', desc: '', args: []);
  }

  /// `No`
  String get noAttachment {
    return Intl.message('No', name: 'noAttachment', desc: '', args: []);
  }

  /// `Sender`
  String get sender {
    return Intl.message('Sender', name: 'sender', desc: '', args: []);
  }

  /// `Letter`
  String get letter {
    return Intl.message('Letter', name: 'letter', desc: '', args: []);
  }

  /// `Letter Number`
  String get letterNumber {
    return Intl.message(
      'Letter Number',
      name: 'letterNumber',
      desc: '',
      args: [],
    );
  }

  /// `Received / Sent`
  String get receivedSent {
    return Intl.message(
      'Received / Sent',
      name: 'receivedSent',
      desc: '',
      args: [],
    );
  }

  /// `Signed`
  String get signed {
    return Intl.message('Signed', name: 'signed', desc: '', args: []);
  }

  /// `Unsigned`
  String get unsigned {
    return Intl.message('Unsigned', name: 'unsigned', desc: '', args: []);
  }

  /// `Clear`
  String get clear {
    return Intl.message('Clear', name: 'clear', desc: '', args: []);
  }

  /// `Or`
  String get or {
    return Intl.message('Or', name: 'or', desc: '', args: []);
  }

  /// `Signatures`
  String get signatures {
    return Intl.message('Signatures', name: 'signatures', desc: '', args: []);
  }

  /// `Upload Signature`
  String get uploadSignature {
    return Intl.message(
      'Upload Signature',
      name: 'uploadSignature',
      desc: '',
      args: [],
    );
  }

  /// `Draw Signature`
  String get drawSignature {
    return Intl.message(
      'Draw Signature',
      name: 'drawSignature',
      desc: '',
      args: [],
    );
  }

  /// `Please upload the signature first.`
  String get uploadSignatureFirst {
    return Intl.message(
      'Please upload the signature first.',
      name: 'uploadSignatureFirst',
      desc: '',
      args: [],
    );
  }

  /// `Submit the signature?\n * Once submitted, it cannot be edited.`
  String get wantToSubmitSignature {
    return Intl.message(
      'Submit the signature?\n * Once submitted, it cannot be edited.',
      name: 'wantToSubmitSignature',
      desc: '',
      args: [],
    );
  }

  /// `Maximum # files can be selected.`
  String get maximumFilesCanSelected {
    return Intl.message(
      'Maximum # files can be selected.',
      name: 'maximumFilesCanSelected',
      desc: '',
      args: [],
    );
  }

  /// `Uploading a medical certificate photo is required.`
  String get requiredMedicalCertificate {
    return Intl.message(
      'Uploading a medical certificate photo is required.',
      name: 'requiredMedicalCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Submit Request`
  String get submitRequest {
    return Intl.message(
      'Submit Request',
      name: 'submitRequest',
      desc: '',
      args: [],
    );
  }

  /// `Request Type`
  String get requestType {
    return Intl.message(
      'Request Type',
      name: 'requestType',
      desc: '',
      args: [],
    );
  }

  /// `Welfare Request Type`
  String get welfareType {
    return Intl.message(
      'Welfare Request Type',
      name: 'welfareType',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message('Type', name: 'type', desc: '', args: []);
  }

  /// `Upload Medical Certificate`
  String get uploadMedicalCertificate {
    return Intl.message(
      'Upload Medical Certificate',
      name: 'uploadMedicalCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Customer`
  String get customer {
    return Intl.message('Customer', name: 'customer', desc: '', args: []);
  }

  /// `Customer Database`
  String get customerDatabase {
    return Intl.message(
      'Customer Database',
      name: 'customerDatabase',
      desc: '',
      args: [],
    );
  }

  /// `Customers`
  String get customers {
    return Intl.message('Customers', name: 'customers', desc: '', args: []);
  }

  /// `Reports`
  String get reports {
    return Intl.message('Reports', name: 'reports', desc: '', args: []);
  }

  /// `Note`
  String get note {
    return Intl.message('Note', name: 'note', desc: '', args: []);
  }

  /// `Project`
  String get project {
    return Intl.message('Project', name: 'project', desc: '', args: []);
  }

  /// `* First, select your desired project.`
  String get projectHelperText {
    return Intl.message(
      '* First, select your desired project.',
      name: 'projectHelperText',
      desc: '',
      args: [],
    );
  }

  /// `* First, select your desired category.`
  String get crmGroupHelperText {
    return Intl.message(
      '* First, select your desired category.',
      name: 'crmGroupHelperText',
      desc: '',
      args: [],
    );
  }

  /// `It's not possible for past days.`
  String get notPossibleForPastDays {
    return Intl.message(
      'It\'s not possible for past days.',
      name: 'notPossibleForPastDays',
      desc: '',
      args: [],
    );
  }

  /// `Subtasks`
  String get subtasks {
    return Intl.message('Subtasks', name: 'subtasks', desc: '', args: []);
  }

  /// `New Subtask`
  String get newSubtask {
    return Intl.message('New Subtask', name: 'newSubtask', desc: '', args: []);
  }

  /// `Edit Subtask`
  String get editSubtask {
    return Intl.message(
      'Edit Subtask',
      name: 'editSubtask',
      desc: '',
      args: [],
    );
  }

  /// `Due Date`
  String get dueDate {
    return Intl.message('Due Date', name: 'dueDate', desc: '', args: []);
  }

  /// `Due Time`
  String get dueTime {
    return Intl.message('Due Time', name: 'dueTime', desc: '', args: []);
  }

  /// `Clock-in`
  String get checkIn {
    return Intl.message('Clock-in', name: 'checkIn', desc: '', args: []);
  }

  /// `Clock-out`
  String get checkOut {
    return Intl.message('Clock-out', name: 'checkOut', desc: '', args: []);
  }

  /// `Timesheet`
  String get timesheet {
    return Intl.message('Timesheet', name: 'timesheet', desc: '', args: []);
  }

  /// `Presence`
  String get presence {
    return Intl.message('Presence', name: 'presence', desc: '', args: []);
  }

  /// `Absence`
  String get absence {
    return Intl.message('Absence', name: 'absence', desc: '', args: []);
  }

  /// `Leave`
  String get leave {
    return Intl.message('Leave', name: 'leave', desc: '', args: []);
  }

  /// `Tardiness`
  String get tardiness {
    return Intl.message('Tardiness', name: 'tardiness', desc: '', args: []);
  }

  /// `Overtime`
  String get overtime {
    return Intl.message('Overtime', name: 'overtime', desc: '', args: []);
  }

  /// `Mission`
  String get mission {
    return Intl.message('Mission', name: 'mission', desc: '', args: []);
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `Remaining`
  String get remaining {
    return Intl.message('Remaining', name: 'remaining', desc: '', args: []);
  }

  /// `New Section`
  String get newSection {
    return Intl.message('New Section', name: 'newSection', desc: '', args: []);
  }

  /// `Edit Section`
  String get editSection {
    return Intl.message(
      'Edit Section',
      name: 'editSection',
      desc: '',
      args: [],
    );
  }

  /// `Files`
  String get files {
    return Intl.message('Files', name: 'files', desc: '', args: []);
  }

  /// `Links`
  String get links {
    return Intl.message('Links', name: 'links', desc: '', args: []);
  }

  /// `Select Labels`
  String get selectLabels {
    return Intl.message(
      'Select Labels',
      name: 'selectLabels',
      desc: '',
      args: [],
    );
  }

  /// `New Project`
  String get newProject {
    return Intl.message('New Project', name: 'newProject', desc: '', args: []);
  }

  /// `Edit Project`
  String get editProject {
    return Intl.message(
      'Edit Project',
      name: 'editProject',
      desc: '',
      args: [],
    );
  }

  /// `New Category`
  String get newCategory {
    return Intl.message(
      'New Category',
      name: 'newCategory',
      desc: '',
      args: [],
    );
  }

  /// `Edit Category`
  String get editCategory {
    return Intl.message(
      'Edit Category',
      name: 'editCategory',
      desc: '',
      args: [],
    );
  }

  /// `Department`
  String get department {
    return Intl.message('Department', name: 'department', desc: '', args: []);
  }

  /// `New Department`
  String get newDepartment {
    return Intl.message(
      'New Department',
      name: 'newDepartment',
      desc: '',
      args: [],
    );
  }

  /// `Edit Department`
  String get editDepartment {
    return Intl.message(
      'Edit Department',
      name: 'editDepartment',
      desc: '',
      args: [],
    );
  }

  /// `Work Shift`
  String get workShift {
    return Intl.message('Work Shift', name: 'workShift', desc: '', args: []);
  }

  /// `Won Reason`
  String get wonReason {
    return Intl.message('Won Reason', name: 'wonReason', desc: '', args: []);
  }

  /// `Loss Reason`
  String get lossReason {
    return Intl.message('Loss Reason', name: 'lossReason', desc: '', args: []);
  }

  /// `New Reason`
  String get newReason {
    return Intl.message('New Reason', name: 'newReason', desc: '', args: []);
  }

  /// `Edit Reason`
  String get editReason {
    return Intl.message('Edit Reason', name: 'editReason', desc: '', args: []);
  }

  /// `Amount`
  String get amount {
    return Intl.message('Amount', name: 'amount', desc: '', args: []);
  }

  /// `Budget`
  String get budget {
    return Intl.message('Budget', name: 'budget', desc: '', args: []);
  }

  /// `Sales Forecast`
  String get salesForecast {
    return Intl.message(
      'Sales Forecast',
      name: 'salesForecast',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get currency {
    return Intl.message('Currency', name: 'currency', desc: '', args: []);
  }

  /// `Sales Probability`
  String get salesProbability {
    return Intl.message(
      'Sales Probability',
      name: 'salesProbability',
      desc: '',
      args: [],
    );
  }

  /// `Follow-up`
  String get followUp {
    return Intl.message('Follow-up', name: 'followUp', desc: '', args: []);
  }

  /// `Follow-ups`
  String get followUps {
    return Intl.message('Follow-ups', name: 'followUps', desc: '', args: []);
  }

  /// `New Follow-up`
  String get newFollowUp {
    return Intl.message(
      'New Follow-up',
      name: 'newFollowUp',
      desc: '',
      args: [],
    );
  }

  /// `Edit Follow-up`
  String get editFollowUp {
    return Intl.message(
      'Edit Follow-up',
      name: 'editFollowUp',
      desc: '',
      args: [],
    );
  }

  /// `New Report`
  String get newReport {
    return Intl.message('New Report', name: 'newReport', desc: '', args: []);
  }

  /// `Was the follow-up successful?`
  String get followUpStatusPopupDescription {
    return Intl.message(
      'Was the follow-up successful?',
      name: 'followUpStatusPopupDescription',
      desc: '',
      args: [],
    );
  }

  /// `Reorder`
  String get reorder {
    return Intl.message('Reorder', name: 'reorder', desc: '', args: []);
  }

  /// `Please save your changes first.`
  String get saveYourChangesFirst {
    return Intl.message(
      'Please save your changes first.',
      name: 'saveYourChangesFirst',
      desc: '',
      args: [],
    );
  }

  /// `Changes saved.`
  String get changesSaved {
    return Intl.message(
      'Changes saved.',
      name: 'changesSaved',
      desc: '',
      args: [],
    );
  }

  /// `New Request`
  String get newRequest {
    return Intl.message('New Request', name: 'newRequest', desc: '', args: []);
  }

  /// `Select`
  String get select {
    return Intl.message('Select', name: 'select', desc: '', args: []);
  }

  /// `Select Again`
  String get selectAgain {
    return Intl.message(
      'Select Again',
      name: 'selectAgain',
      desc: '',
      args: [],
    );
  }

  /// `Request Description`
  String get requestDescription {
    return Intl.message(
      'Request Description',
      name: 'requestDescription',
      desc: '',
      args: [],
    );
  }

  /// `Start and End Date`
  String get startAndEndDate {
    return Intl.message(
      'Start and End Date',
      name: 'startAndEndDate',
      desc: '',
      args: [],
    );
  }

  /// `Replacement Employee (Optional)`
  String get replacementEmployeeOptional {
    return Intl.message(
      'Replacement Employee (Optional)',
      name: 'replacementEmployeeOptional',
      desc: '',
      args: [],
    );
  }

  /// `Disease Type`
  String get diseaseType {
    return Intl.message(
      'Disease Type',
      name: 'diseaseType',
      desc: '',
      args: [],
    );
  }

  /// `Hospital or Doctor Issuing Certificate`
  String get hospitalOrDoctor {
    return Intl.message(
      'Hospital or Doctor Issuing Certificate',
      name: 'hospitalOrDoctor',
      desc: '',
      args: [],
    );
  }

  /// `Medical Certificate (PDF/JPG)*`
  String get medicalCertificateRequired {
    return Intl.message(
      'Medical Certificate (PDF/JPG)*',
      name: 'medicalCertificateRequired',
      desc: '',
      args: [],
    );
  }

  /// `Replacement Employee`
  String get replacementEmployee {
    return Intl.message(
      'Replacement Employee',
      name: 'replacementEmployee',
      desc: '',
      args: [],
    );
  }

  /// `Leave Date`
  String get leaveDate {
    return Intl.message('Leave Date', name: 'leaveDate', desc: '', args: []);
  }

  /// `Request Reason`
  String get requestReason {
    return Intl.message(
      'Request Reason',
      name: 'requestReason',
      desc: '',
      args: [],
    );
  }

  /// `Occasion Type`
  String get occasionType {
    return Intl.message(
      'Occasion Type',
      name: 'occasionType',
      desc: '',
      args: [],
    );
  }

  /// `Invitation`
  String get invitation {
    return Intl.message('Invitation', name: 'invitation', desc: '', args: []);
  }

  /// `Proof Document (Marriage Certificate, Death Certificate, Birth Certificate, etc.)`
  String get proofDocument {
    return Intl.message(
      'Proof Document (Marriage Certificate, Death Certificate, Birth Certificate, etc.)',
      name: 'proofDocument',
      desc: '',
      args: [],
    );
  }

  /// `Mission Destination (City, Province)`
  String get missionDestination {
    return Intl.message(
      'Mission Destination (City, Province)',
      name: 'missionDestination',
      desc: '',
      args: [],
    );
  }

  /// `Destination`
  String get destination {
    return Intl.message('Destination', name: 'destination', desc: '', args: []);
  }

  /// `Exact Location`
  String get exactLocation {
    return Intl.message(
      'Exact Location',
      name: 'exactLocation',
      desc: '',
      args: [],
    );
  }

  /// `Departure Date`
  String get departureDate {
    return Intl.message(
      'Departure Date',
      name: 'departureDate',
      desc: '',
      args: [],
    );
  }

  /// `Departure Time`
  String get departureTime {
    return Intl.message(
      'Departure Time',
      name: 'departureTime',
      desc: '',
      args: [],
    );
  }

  /// `Return Date`
  String get returnDate {
    return Intl.message('Return Date', name: 'returnDate', desc: '', args: []);
  }

  /// `Return Time`
  String get returnTime {
    return Intl.message('Return Time', name: 'returnTime', desc: '', args: []);
  }

  /// `Mission Purpose`
  String get missionPurpose {
    return Intl.message(
      'Mission Purpose',
      name: 'missionPurpose',
      desc: '',
      args: [],
    );
  }

  /// `Transportation Type`
  String get transportationType {
    return Intl.message(
      'Transportation Type',
      name: 'transportationType',
      desc: '',
      args: [],
    );
  }

  /// `Needs Accommodation`
  String get needsAccommodation {
    return Intl.message(
      'Needs Accommodation',
      name: 'needsAccommodation',
      desc: '',
      args: [],
    );
  }

  /// `Accommodation Type`
  String get accommodationType {
    return Intl.message(
      'Accommodation Type',
      name: 'accommodationType',
      desc: '',
      args: [],
    );
  }

  /// `Companions (if team)`
  String get companionsLabel {
    return Intl.message(
      'Companions (if team)',
      name: 'companionsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Companions`
  String get companions {
    return Intl.message('Companions', name: 'companions', desc: '', args: []);
  }

  /// `Exact Address`
  String get exactAddress {
    return Intl.message(
      'Exact Address',
      name: 'exactAddress',
      desc: '',
      args: [],
    );
  }

  /// `Related Mission Number`
  String get relatedMissionNumber {
    return Intl.message(
      'Related Mission Number',
      name: 'relatedMissionNumber',
      desc: '',
      args: [],
    );
  }

  /// `Expense Type`
  String get expenseType {
    return Intl.message(
      'Expense Type',
      name: 'expenseType',
      desc: '',
      args: [],
    );
  }

  /// `Expense Date`
  String get expenseDate {
    return Intl.message(
      'Expense Date',
      name: 'expenseDate',
      desc: '',
      args: [],
    );
  }

  /// `Expense Amount`
  String get expenseAmount {
    return Intl.message(
      'Expense Amount',
      name: 'expenseAmount',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get paymentMethodLabel {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethodLabel',
      desc: '',
      args: [],
    );
  }

  /// `Upload Invoice / Receipt`
  String get uploadInvoiceReceipt {
    return Intl.message(
      'Upload Invoice / Receipt',
      name: 'uploadInvoiceReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Requested Amount`
  String get requestedAmount {
    return Intl.message(
      'Requested Amount',
      name: 'requestedAmount',
      desc: '',
      args: [],
    );
  }

  /// `Required Payment Date`
  String get requiredPaymentDate {
    return Intl.message(
      'Required Payment Date',
      name: 'requiredPaymentDate',
      desc: '',
      args: [],
    );
  }

  /// `Proposed Repayment Conditions`
  String get repaymentConditions {
    return Intl.message(
      'Proposed Repayment Conditions',
      name: 'repaymentConditions',
      desc: '',
      args: [],
    );
  }

  /// `Guarantee Documents (Check / Promissory Note)`
  String get guaranteeDocuments {
    return Intl.message(
      'Guarantee Documents (Check / Promissory Note)',
      name: 'guaranteeDocuments',
      desc: '',
      args: [],
    );
  }

  /// `Covered Persons Info (Name, Relation, National ID)`
  String get coveredPersonsInfo {
    return Intl.message(
      'Covered Persons Info (Name, Relation, National ID)',
      name: 'coveredPersonsInfo',
      desc: '',
      args: [],
    );
  }

  /// `Covered Persons`
  String get coveredPersons {
    return Intl.message(
      'Covered Persons',
      name: 'coveredPersons',
      desc: '',
      args: [],
    );
  }

  /// `Coverage Start Date`
  String get coverageStartDate {
    return Intl.message(
      'Coverage Start Date',
      name: 'coverageStartDate',
      desc: '',
      args: [],
    );
  }

  /// `Treatment Cost (if reimbursement)`
  String get treatmentAmount {
    return Intl.message(
      'Treatment Cost (if reimbursement)',
      name: 'treatmentAmount',
      desc: '',
      args: [],
    );
  }

  /// `Medical Documents (Bill, Doctor's Prescription, Hospital Report)`
  String get medicalDocuments {
    return Intl.message(
      'Medical Documents (Bill, Doctor\'s Prescription, Hospital Report)',
      name: 'medicalDocuments',
      desc: '',
      args: [],
    );
  }

  /// `Allowance Type`
  String get allowanceType {
    return Intl.message(
      'Allowance Type',
      name: 'allowanceType',
      desc: '',
      args: [],
    );
  }

  /// `Period`
  String get period {
    return Intl.message('Period', name: 'period', desc: '', args: []);
  }

  /// `Requested Amount`
  String get requestedAmountLabel {
    return Intl.message(
      'Requested Amount',
      name: 'requestedAmountLabel',
      desc: '',
      args: [],
    );
  }

  /// `Supporting Documents (Rent Bill, Transportation Ticket, etc.)`
  String get supportingDocuments {
    return Intl.message(
      'Supporting Documents (Rent Bill, Transportation Ticket, etc.)',
      name: 'supportingDocuments',
      desc: '',
      args: [],
    );
  }

  /// `Optional Attachments`
  String get optionalAttachments {
    return Intl.message(
      'Optional Attachments',
      name: 'optionalAttachments',
      desc: '',
      args: [],
    );
  }

  /// `Equipment Type`
  String get equipmentType {
    return Intl.message(
      'Equipment Type',
      name: 'equipmentType',
      desc: '',
      args: [],
    );
  }

  /// `Quantity`
  String get quantity {
    return Intl.message('Quantity', name: 'quantity', desc: '', args: []);
  }

  /// `Suggested Model (if specific need)`
  String get suggestedModelLabel {
    return Intl.message(
      'Suggested Model (if specific need)',
      name: 'suggestedModelLabel',
      desc: '',
      args: [],
    );
  }

  /// `Suggested Model`
  String get suggestedModel {
    return Intl.message(
      'Suggested Model',
      name: 'suggestedModel',
      desc: '',
      args: [],
    );
  }

  /// `Urgency`
  String get urgency {
    return Intl.message('Urgency', name: 'urgency', desc: '', args: []);
  }

  /// `Item Type`
  String get itemType {
    return Intl.message('Item Type', name: 'itemType', desc: '', args: []);
  }

  /// `Required Quantity`
  String get requiredQuantity {
    return Intl.message(
      'Required Quantity',
      name: 'requiredQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Current Equipment (Name + Model)`
  String get currentEquipmentLabel {
    return Intl.message(
      'Current Equipment (Name + Model)',
      name: 'currentEquipmentLabel',
      desc: '',
      args: [],
    );
  }

  /// `Current Equipment`
  String get currentEquipment {
    return Intl.message(
      'Current Equipment',
      name: 'currentEquipment',
      desc: '',
      args: [],
    );
  }

  /// `Exact Problem`
  String get exactProblem {
    return Intl.message(
      'Exact Problem',
      name: 'exactProblem',
      desc: '',
      args: [],
    );
  }

  /// `Problem Date`
  String get problemDate {
    return Intl.message(
      'Problem Date',
      name: 'problemDate',
      desc: '',
      args: [],
    );
  }

  /// `Need`
  String get need {
    return Intl.message('Need', name: 'need', desc: '', args: []);
  }

  /// `Optional Problem Photo Attachment`
  String get optionalProblemPhoto {
    return Intl.message(
      'Optional Problem Photo Attachment',
      name: 'optionalProblemPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Job Specifications`
  String get jobSpecifications {
    return Intl.message(
      'Job Specifications',
      name: 'jobSpecifications',
      desc: '',
      args: [],
    );
  }

  /// `Workload`
  String get workload {
    return Intl.message('Workload', name: 'workload', desc: '', args: []);
  }

  /// `Job Title`
  String get jobTitle {
    return Intl.message('Job Title', name: 'jobTitle', desc: '', args: []);
  }

  /// `Organizational Unit`
  String get organizationalUnit {
    return Intl.message(
      'Organizational Unit',
      name: 'organizationalUnit',
      desc: '',
      args: [],
    );
  }

  /// `e.g.: Sales, Product Development, Support`
  String get unitExample {
    return Intl.message(
      'e.g.: Sales, Product Development, Support',
      name: 'unitExample',
      desc: '',
      args: [],
    );
  }

  /// `Work Location`
  String get workLocation {
    return Intl.message(
      'Work Location',
      name: 'workLocation',
      desc: '',
      args: [],
    );
  }

  /// `Required Personnel Count`
  String get requiredPersonnelCount {
    return Intl.message(
      'Required Personnel Count',
      name: 'requiredPersonnelCount',
      desc: '',
      args: [],
    );
  }

  /// `Job Description and Responsibilities`
  String get jobDescriptionAndResponsibilities {
    return Intl.message(
      'Job Description and Responsibilities',
      name: 'jobDescriptionAndResponsibilities',
      desc: '',
      args: [],
    );
  }

  /// `Job Summary`
  String get jobSummary {
    return Intl.message('Job Summary', name: 'jobSummary', desc: '', args: []);
  }

  /// `Main Responsibilities`
  String get mainResponsibilities {
    return Intl.message(
      'Main Responsibilities',
      name: 'mainResponsibilities',
      desc: '',
      args: [],
    );
  }

  /// `Responsibility`
  String get responsibility {
    return Intl.message(
      'Responsibility',
      name: 'responsibility',
      desc: '',
      args: [],
    );
  }

  /// `Reports To`
  String get reportsTo {
    return Intl.message('Reports To', name: 'reportsTo', desc: '', args: []);
  }

  /// `e.g.: Sales Manager`
  String get reportsToExample {
    return Intl.message(
      'e.g.: Sales Manager',
      name: 'reportsToExample',
      desc: '',
      args: [],
    );
  }

  /// `Requirements and Conditions`
  String get requirementsAndConditions {
    return Intl.message(
      'Requirements and Conditions',
      name: 'requirementsAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `Required Education`
  String get requiredEducation {
    return Intl.message(
      'Required Education',
      name: 'requiredEducation',
      desc: '',
      args: [],
    );
  }

  /// `Preferred Field of Study`
  String get preferredFieldOfStudy {
    return Intl.message(
      'Preferred Field of Study',
      name: 'preferredFieldOfStudy',
      desc: '',
      args: [],
    );
  }

  /// `Minimum Work Experience (Years)`
  String get minimumWorkExperience {
    return Intl.message(
      'Minimum Work Experience (Years)',
      name: 'minimumWorkExperience',
      desc: '',
      args: [],
    );
  }

  /// `Technical Skills`
  String get technicalSkills {
    return Intl.message(
      'Technical Skills',
      name: 'technicalSkills',
      desc: '',
      args: [],
    );
  }

  /// `Soft Skills`
  String get softSkills {
    return Intl.message('Soft Skills', name: 'softSkills', desc: '', args: []);
  }

  /// `Required Foreign Languages`
  String get requiredForeignLanguages {
    return Intl.message(
      'Required Foreign Languages',
      name: 'requiredForeignLanguages',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Information Type`
  String get informationType {
    return Intl.message(
      'Information Type',
      name: 'informationType',
      desc: '',
      args: [],
    );
  }

  /// `Current Value`
  String get currentValue {
    return Intl.message(
      'Current Value',
      name: 'currentValue',
      desc: '',
      args: [],
    );
  }

  /// `New Value`
  String get newValue {
    return Intl.message('New Value', name: 'newValue', desc: '', args: []);
  }

  /// `Supporting Documents (Bill, National ID, Birth Certificate)`
  String get supportingDocumentsPersonal {
    return Intl.message(
      'Supporting Documents (Bill, National ID, Birth Certificate)',
      name: 'supportingDocumentsPersonal',
      desc: '',
      args: [],
    );
  }

  /// `Certificate Purpose`
  String get certificatePurpose {
    return Intl.message(
      'Certificate Purpose',
      name: 'certificatePurpose',
      desc: '',
      args: [],
    );
  }

  /// `Required Language`
  String get requiredLanguage {
    return Intl.message(
      'Required Language',
      name: 'requiredLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Required Issue Date`
  String get requiredIssueDate {
    return Intl.message(
      'Required Issue Date',
      name: 'requiredIssueDate',
      desc: '',
      args: [],
    );
  }

  /// `Include Salary`
  String get includeSalary {
    return Intl.message(
      'Include Salary',
      name: 'includeSalary',
      desc: '',
      args: [],
    );
  }

  /// `Include Position`
  String get includePosition {
    return Intl.message(
      'Include Position',
      name: 'includePosition',
      desc: '',
      args: [],
    );
  }

  /// `Destination Organization`
  String get destinationOrganization {
    return Intl.message(
      'Destination Organization',
      name: 'destinationOrganization',
      desc: '',
      args: [],
    );
  }

  /// `Organization Address`
  String get organizationAddress {
    return Intl.message(
      'Organization Address',
      name: 'organizationAddress',
      desc: '',
      args: [],
    );
  }

  /// `Introduction Subject`
  String get introductionSubject {
    return Intl.message(
      'Introduction Subject',
      name: 'introductionSubject',
      desc: '',
      args: [],
    );
  }

  /// `Special Specifications (Mention Employee's Position or Special Expertise)`
  String get specialSpecificationsLabel {
    return Intl.message(
      'Special Specifications (Mention Employee\'s Position or Special Expertise)',
      name: 'specialSpecificationsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Special Specifications`
  String get specialSpecifications {
    return Intl.message(
      'Special Specifications',
      name: 'specialSpecifications',
      desc: '',
      args: [],
    );
  }

  /// `Review Request`
  String get changeRequestStatusDialogTitle {
    return Intl.message(
      'Review Request',
      name: 'changeRequestStatusDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to approve or reject this request?`
  String get changeRequestStatusDialogContent {
    return Intl.message(
      'Do you want to approve or reject this request?',
      name: 'changeRequestStatusDialogContent',
      desc: '',
      args: [],
    );
  }

  /// `Approve`
  String get approve {
    return Intl.message('Approve', name: 'approve', desc: '', args: []);
  }

  /// `Reject`
  String get reject {
    return Intl.message('Reject', name: 'reject', desc: '', args: []);
  }

  /// `Scheduling`
  String get scheduling {
    return Intl.message('Scheduling', name: 'scheduling', desc: '', args: []);
  }

  /// `My Requests`
  String get myRequests {
    return Intl.message('My Requests', name: 'myRequests', desc: '', args: []);
  }

  /// `My Reviews`
  String get myReviews {
    return Intl.message('My Reviews', name: 'myReviews', desc: '', args: []);
  }

  /// `Reviewers`
  String get reviewers {
    return Intl.message('Reviewers', name: 'reviewers', desc: '', args: []);
  }

  /// `Please assign one or more reviewers to this request.`
  String get assignReviewersToRequestInfoText {
    return Intl.message(
      'Please assign one or more reviewers to this request.',
      name: 'assignReviewersToRequestInfoText',
      desc: '',
      args: [],
    );
  }

  /// `Assign Reviewers`
  String get addReviewers {
    return Intl.message(
      'Assign Reviewers',
      name: 'addReviewers',
      desc: '',
      args: [],
    );
  }

  /// `Please select reviewers in the desired order of approval.`
  String get selectReviewersInfoText {
    return Intl.message(
      'Please select reviewers in the desired order of approval.',
      name: 'selectReviewersInfoText',
      desc: '',
      args: [],
    );
  }

  /// `The selection order determines the approval priority.`
  String get selectReviewersHelperText {
    return Intl.message(
      'The selection order determines the approval priority.',
      name: 'selectReviewersHelperText',
      desc: '',
      args: [],
    );
  }

  /// `Priority`
  String get priority {
    return Intl.message('Priority', name: 'priority', desc: '', args: []);
  }

  /// `Selected Users`
  String get selectedUsers {
    return Intl.message(
      'Selected Users',
      name: 'selectedUsers',
      desc: '',
      args: [],
    );
  }

  /// `User Selection`
  String get userSelection {
    return Intl.message(
      'User Selection',
      name: 'userSelection',
      desc: '',
      args: [],
    );
  }

  /// `Stats`
  String get statistics {
    return Intl.message('Stats', name: 'statistics', desc: '', args: []);
  }

  /// `Please select a review deadline for each person.`
  String get selectReviewDeadline {
    return Intl.message(
      'Please select a review deadline for each person.',
      name: 'selectReviewDeadline',
      desc: '',
      args: [],
    );
  }

  /// `Deadline`
  String get deadline {
    return Intl.message('Deadline', name: 'deadline', desc: '', args: []);
  }

  /// `Success Rate`
  String get successRate {
    return Intl.message(
      'Success Rate',
      name: 'successRate',
      desc: '',
      args: [],
    );
  }

  /// `Personal Info`
  String get personalInfo {
    return Intl.message(
      'Personal Info',
      name: 'personalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Applicant`
  String get applicant {
    return Intl.message('Applicant', name: 'applicant', desc: '', args: []);
  }

  /// `Salary & Benefits`
  String get salaryAndBenefits {
    return Intl.message(
      'Salary & Benefits',
      name: 'salaryAndBenefits',
      desc: '',
      args: [],
    );
  }

  /// `Employment`
  String get employment {
    return Intl.message('Employment', name: 'employment', desc: '', args: []);
  }

  /// `Performance`
  String get performance {
    return Intl.message('Performance', name: 'performance', desc: '', args: []);
  }

  /// `Transfer`
  String get transfer {
    return Intl.message('Transfer', name: 'transfer', desc: '', args: []);
  }

  /// `Transfer to another department`
  String get transfer2AnotherDepartment {
    return Intl.message(
      'Transfer to another department',
      name: 'transfer2AnotherDepartment',
      desc: '',
      args: [],
    );
  }

  /// `Contact Info`
  String get contactInfo {
    return Intl.message(
      'Contact Info',
      name: 'contactInfo',
      desc: '',
      args: [],
    );
  }

  /// `Basic Info`
  String get basicInfo {
    return Intl.message('Basic Info', name: 'basicInfo', desc: '', args: []);
  }

  /// `Subscription`
  String get subscription {
    return Intl.message(
      'Subscription',
      name: 'subscription',
      desc: '',
      args: [],
    );
  }

  /// `Current Subscription`
  String get currentSubscription {
    return Intl.message(
      'Current Subscription',
      name: 'currentSubscription',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Management`
  String get subscriptionManagement {
    return Intl.message(
      'Subscription Management',
      name: 'subscriptionManagement',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Settings`
  String get subscriptionSettings {
    return Intl.message(
      'Subscription Settings',
      name: 'subscriptionSettings',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Details`
  String get subscriptionDetails {
    return Intl.message(
      'Subscription Details',
      name: 'subscriptionDetails',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe`
  String get buySubscription {
    return Intl.message(
      'Subscribe',
      name: 'buySubscription',
      desc: '',
      args: [],
    );
  }

  /// `Renew`
  String get renewSubscription {
    return Intl.message('Renew', name: 'renewSubscription', desc: '', args: []);
  }

  /// `Upgrade`
  String get upgradeSubscription {
    return Intl.message(
      'Upgrade',
      name: 'upgradeSubscription',
      desc: '',
      args: [],
    );
  }

  /// `You don't have an active subscription. Please get a plan for your business to continue.`
  String get noSubscriptionDialogDescription {
    return Intl.message(
      'You don\'t have an active subscription. Please get a plan for your business to continue.',
      name: 'noSubscriptionDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `Your subscription has expired. Please renew your subscription to continue.`
  String get expiredSubscriptionDialogDescription {
    return Intl.message(
      'Your subscription has expired. Please renew your subscription to continue.',
      name: 'expiredSubscriptionDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Modules`
  String get subscriptionModules {
    return Intl.message(
      'Subscription Modules',
      name: 'subscriptionModules',
      desc: '',
      args: [],
    );
  }

  /// `User Count`
  String get userCount {
    return Intl.message('User Count', name: 'userCount', desc: '', args: []);
  }

  /// `Subscription Period`
  String get subscriptionPeriod {
    return Intl.message(
      'Subscription Period',
      name: 'subscriptionPeriod',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Price`
  String get subscriptionPrice {
    return Intl.message(
      'Subscription Price',
      name: 'subscriptionPrice',
      desc: '',
      args: [],
    );
  }

  /// `Current Subscription Price`
  String get currentSubscriptionPrice {
    return Intl.message(
      'Current Subscription Price',
      name: 'currentSubscriptionPrice',
      desc: '',
      args: [],
    );
  }

  /// `New Subscription Price`
  String get newSubscriptionPrice {
    return Intl.message(
      'New Subscription Price',
      name: 'newSubscriptionPrice',
      desc: '',
      args: [],
    );
  }

  /// `Total monthly`
  String get totalMonthly {
    return Intl.message(
      'Total monthly',
      name: 'totalMonthly',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message('Price', name: 'price', desc: '', args: []);
  }

  /// `Price Summary`
  String get priceSummary {
    return Intl.message(
      'Price Summary',
      name: 'priceSummary',
      desc: '',
      args: [],
    );
  }

  /// `Total Price`
  String get totalPrice {
    return Intl.message('Total Price', name: 'totalPrice', desc: '', args: []);
  }

  /// `Final Price`
  String get finalPrice {
    return Intl.message('Final Price', name: 'finalPrice', desc: '', args: []);
  }

  /// `Price Details`
  String get priceDetails {
    return Intl.message(
      'Price Details',
      name: 'priceDetails',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get discount {
    return Intl.message('Discount', name: 'discount', desc: '', args: []);
  }

  /// `Pay Now`
  String get payNow {
    return Intl.message('Pay Now', name: 'payNow', desc: '', args: []);
  }

  /// `Free`
  String get free {
    return Intl.message('Free', name: 'free', desc: '', args: []);
  }

  /// `Users`
  String get user {
    return Intl.message('Users', name: 'user', desc: '', args: []);
  }

  /// `Users`
  String get users {
    return Intl.message('Users', name: 'users', desc: '', args: []);
  }

  /// `User Activity`
  String get userActivity {
    return Intl.message(
      'User Activity',
      name: 'userActivity',
      desc: '',
      args: [],
    );
  }

  /// `overdue`
  String get overdue {
    return Intl.message('overdue', name: 'overdue', desc: '', args: []);
  }

  /// `Bank Account Information`
  String get bankAccountInformation {
    return Intl.message(
      'Bank Account Information',
      name: 'bankAccountInformation',
      desc: '',
      args: [],
    );
  }

  /// `Bank`
  String get bank {
    return Intl.message('Bank', name: 'bank', desc: '', args: []);
  }

  /// `Active Modules`
  String get activeModules {
    return Intl.message(
      'Active Modules',
      name: 'activeModules',
      desc: '',
      args: [],
    );
  }

  /// `Activated Modules`
  String get activatedModules {
    return Intl.message(
      'Activated Modules',
      name: 'activatedModules',
      desc: '',
      args: [],
    );
  }

  /// `Module Management`
  String get moduleManagement {
    return Intl.message(
      'Module Management',
      name: 'moduleManagement',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get active {
    return Intl.message('Active', name: 'active', desc: '', args: []);
  }

  /// `Expired`
  String get expired {
    return Intl.message('Expired', name: 'expired', desc: '', args: []);
  }

  /// `Expiring Soon`
  String get expiringSoon {
    return Intl.message(
      'Expiring Soon',
      name: 'expiringSoon',
      desc: '',
      args: [],
    );
  }

  /// `Note: After registering a subscription, it is not possible to reduce the number of users and storage space, nor to deactivate modules. Please choose carefully.`
  String get subscriptionNote {
    return Intl.message(
      'Note: After registering a subscription, it is not possible to reduce the number of users and storage space, nor to deactivate modules. Please choose carefully.',
      name: 'subscriptionNote',
      desc: '',
      args: [],
    );
  }

  /// `Module`
  String get module {
    return Intl.message('Module', name: 'module', desc: '', args: []);
  }

  /// `Modules`
  String get modules {
    return Intl.message('Modules', name: 'modules', desc: '', args: []);
  }

  /// `Selected Modules`
  String get selectedModules {
    return Intl.message(
      'Selected Modules',
      name: 'selectedModules',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message('Share', name: 'share', desc: '', args: []);
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Go to home page`
  String get goToHomePage {
    return Intl.message(
      'Go to home page',
      name: 'goToHomePage',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get payment {
    return Intl.message('Payment', name: 'payment', desc: '', args: []);
  }

  /// `Successful`
  String get successfulPayment {
    return Intl.message(
      'Successful',
      name: 'successfulPayment',
      desc: '',
      args: [],
    );
  }

  /// `Payment was successful`
  String get paymentWasSuccessful {
    return Intl.message(
      'Payment was successful',
      name: 'paymentWasSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Unsuccessful`
  String get unsuccessfulPayment {
    return Intl.message(
      'Unsuccessful',
      name: 'unsuccessfulPayment',
      desc: '',
      args: [],
    );
  }

  /// `Payment failed`
  String get paymentFailed {
    return Intl.message(
      'Payment failed',
      name: 'paymentFailed',
      desc: '',
      args: [],
    );
  }

  /// `Payment Date`
  String get paymentDate {
    return Intl.message(
      'Payment Date',
      name: 'paymentDate',
      desc: '',
      args: [],
    );
  }

  /// `Invoice Number`
  String get invoiceNumber {
    return Intl.message(
      'Invoice Number',
      name: 'invoiceNumber',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Number`
  String get transactionNumber {
    return Intl.message(
      'Transaction Number',
      name: 'transactionNumber',
      desc: '',
      args: [],
    );
  }

  /// `Reference ID`
  String get referenceID {
    return Intl.message(
      'Reference ID',
      name: 'referenceID',
      desc: '',
      args: [],
    );
  }

  /// `Card Number`
  String get cardNumber {
    return Intl.message('Card Number', name: 'cardNumber', desc: '', args: []);
  }

  /// `Account Owner Name`
  String get accountOwnerName {
    return Intl.message(
      'Account Owner Name',
      name: 'accountOwnerName',
      desc: '',
      args: [],
    );
  }

  /// `Send Payment Receipt`
  String get sendPaymentReceipt {
    return Intl.message(
      'Send Payment Receipt',
      name: 'sendPaymentReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message('Send', name: 'send', desc: '', args: []);
  }

  /// `Please turn off your VPN to enter the payment gateway.`
  String get turnOffVPNToEnterPaymentGateway {
    return Intl.message(
      'Please turn off your VPN to enter the payment gateway.',
      name: 'turnOffVPNToEnterPaymentGateway',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least one module.`
  String get selectAtLeastOneModule {
    return Intl.message(
      'Please select at least one module.',
      name: 'selectAtLeastOneModule',
      desc: '',
      args: [],
    );
  }

  /// `Popular`
  String get popular {
    return Intl.message('Popular', name: 'popular', desc: '', args: []);
  }

  /// `GB`
  String get gb {
    return Intl.message('GB', name: 'gb', desc: '', args: []);
  }

  /// `Online`
  String get online {
    return Intl.message('Online', name: 'online', desc: '', args: []);
  }

  /// `Offline`
  String get offline {
    return Intl.message('Offline', name: 'offline', desc: '', args: []);
  }

  /// `Contract`
  String get contract {
    return Intl.message('Contract', name: 'contract', desc: '', args: []);
  }

  /// `Contracts`
  String get contracts {
    return Intl.message('Contracts', name: 'contracts', desc: '', args: []);
  }

  /// `Contract Type`
  String get contractType {
    return Intl.message(
      'Contract Type',
      name: 'contractType',
      desc: '',
      args: [],
    );
  }

  /// `Contract Title`
  String get contractTitle {
    return Intl.message(
      'Contract Title',
      name: 'contractTitle',
      desc: '',
      args: [],
    );
  }

  /// `❌ Ignore`
  String get ignore {
    return Intl.message('❌ Ignore', name: 'ignore', desc: '', args: []);
  }

  /// `The file information has not been fully received.`
  String get fileInfoNotFullyReceived {
    return Intl.message(
      'The file information has not been fully received.',
      name: 'fileInfoNotFullyReceived',
      desc: '',
      args: [],
    );
  }

  /// `Row Count`
  String get rowCount {
    return Intl.message('Row Count', name: 'rowCount', desc: '', args: []);
  }

  /// `Detected Columns`
  String get detectedColumns {
    return Intl.message(
      'Detected Columns',
      name: 'detectedColumns',
      desc: '',
      args: [],
    );
  }

  /// `Potential Duplicates`
  String get potentialDuplicates {
    return Intl.message(
      'Potential Duplicates',
      name: 'potentialDuplicates',
      desc: '',
      args: [],
    );
  }

  /// `Column Mapping`
  String get columnMapping {
    return Intl.message(
      'Column Mapping',
      name: 'columnMapping',
      desc: '',
      args: [],
    );
  }

  /// `Excel Column`
  String get excelColumn {
    return Intl.message(
      'Excel Column',
      name: 'excelColumn',
      desc: '',
      args: [],
    );
  }

  /// `Sample Data`
  String get sampleData {
    return Intl.message('Sample Data', name: 'sampleData', desc: '', args: []);
  }

  /// `Column Data Type`
  String get columnDataType {
    return Intl.message(
      'Column Data Type',
      name: 'columnDataType',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to go back to the previous step?`
  String get backToPreviousStepDialogDescription {
    return Intl.message(
      'Do you want to go back to the previous step?',
      name: 'backToPreviousStepDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `There are no records to display.`
  String get noRecordsToDisplay {
    return Intl.message(
      'There are no records to display.',
      name: 'noRecordsToDisplay',
      desc: '',
      args: [],
    );
  }

  /// `Data preview (first 10 rows)`
  String get dataPreview {
    return Intl.message(
      'Data preview (first 10 rows)',
      name: 'dataPreview',
      desc: '',
      args: [],
    );
  }

  /// `Download Error File`
  String get downloadErrorFile {
    return Intl.message(
      'Download Error File',
      name: 'downloadErrorFile',
      desc: '',
      args: [],
    );
  }

  /// `Detected Errors`
  String get detectedErrors {
    return Intl.message(
      'Detected Errors',
      name: 'detectedErrors',
      desc: '',
      args: [],
    );
  }

  /// `Result`
  String get result {
    return Intl.message('Result', name: 'result', desc: '', args: []);
  }

  /// `Preview`
  String get preview {
    return Intl.message('Preview', name: 'preview', desc: '', args: []);
  }

  /// `Upload`
  String get upload {
    return Intl.message('Upload', name: 'upload', desc: '', args: []);
  }

  /// `Upload Exel File`
  String get uploadExelFile {
    return Intl.message(
      'Upload Exel File',
      name: 'uploadExelFile',
      desc: '',
      args: [],
    );
  }

  /// `Show`
  String get show {
    return Intl.message('Show', name: 'show', desc: '', args: []);
  }

  /// `Successful`
  String get successful {
    return Intl.message('Successful', name: 'successful', desc: '', args: []);
  }

  /// `Duplicate`
  String get duplicate {
    return Intl.message('Duplicate', name: 'duplicate', desc: '', args: []);
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `Successfully Completed`
  String get successfullyCompleted {
    return Intl.message(
      'Successfully Completed',
      name: 'successfullyCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Send To Board`
  String get sendToBoard {
    return Intl.message(
      'Send To Board',
      name: 'sendToBoard',
      desc: '',
      args: [],
    );
  }

  /// `Send this customer to the Kanban board?`
  String get sendThisCustomerToBoardDialogDescription {
    return Intl.message(
      'Send this customer to the Kanban board?',
      name: 'sendThisCustomerToBoardDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `Send all the selected customers to the Kanban board?`
  String get sendSelectedCustomersToBoardDialogDescription {
    return Intl.message(
      'Send all the selected customers to the Kanban board?',
      name: 'sendSelectedCustomersToBoardDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `Delete this customer from folder?`
  String get deleteThisCustomerDialogDescription {
    return Intl.message(
      'Delete this customer from folder?',
      name: 'deleteThisCustomerDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `Delete selected customers from folder?`
  String get deleteSelectedCustomersDialogDescription {
    return Intl.message(
      'Delete selected customers from folder?',
      name: 'deleteSelectedCustomersDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `On-Time`
  String get onTime {
    return Intl.message('On-Time', name: 'onTime', desc: '', args: []);
  }

  /// `Early`
  String get early {
    return Intl.message('Early', name: 'early', desc: '', args: []);
  }

  /// `Late`
  String get late {
    return Intl.message('Late', name: 'late', desc: '', args: []);
  }

  /// `Manual`
  String get manual {
    return Intl.message('Manual', name: 'manual', desc: '', args: []);
  }

  /// `Finger Print`
  String get fingerPrint {
    return Intl.message(
      'Finger Print',
      name: 'fingerPrint',
      desc: '',
      args: [],
    );
  }

  /// `Face Id`
  String get faceId {
    return Intl.message('Face Id', name: 'faceId', desc: '', args: []);
  }

  /// `Swipe to clock-in`
  String get swipeToCheckIn {
    return Intl.message(
      'Swipe to clock-in',
      name: 'swipeToCheckIn',
      desc: '',
      args: [],
    );
  }

  /// `Swipe to clock-out`
  String get swipeToCheckOut {
    return Intl.message(
      'Swipe to clock-out',
      name: 'swipeToCheckOut',
      desc: '',
      args: [],
    );
  }

  /// `Start of Rest`
  String get restStart {
    return Intl.message('Start of Rest', name: 'restStart', desc: '', args: []);
  }

  /// `End of Rest`
  String get restEnd {
    return Intl.message('End of Rest', name: 'restEnd', desc: '', args: []);
  }

  /// `Start of Leave`
  String get leaveStart {
    return Intl.message(
      'Start of Leave',
      name: 'leaveStart',
      desc: '',
      args: [],
    );
  }

  /// `End of Leave`
  String get leaveEnd {
    return Intl.message('End of Leave', name: 'leaveEnd', desc: '', args: []);
  }

  /// `Start of Mission`
  String get missionStart {
    return Intl.message(
      'Start of Mission',
      name: 'missionStart',
      desc: '',
      args: [],
    );
  }

  /// `End of Mission`
  String get missionEnd {
    return Intl.message(
      'End of Mission',
      name: 'missionEnd',
      desc: '',
      args: [],
    );
  }

  /// `Start of Overtime`
  String get overtimeStart {
    return Intl.message(
      'Start of Overtime',
      name: 'overtimeStart',
      desc: '',
      args: [],
    );
  }

  /// `End of Overtime`
  String get overtimeEnd {
    return Intl.message(
      'End of Overtime',
      name: 'overtimeEnd',
      desc: '',
      args: [],
    );
  }

  /// `The Human Resource(HR) module is required.`
  String get hRModuleIsRequired {
    return Intl.message(
      'The Human Resource(HR) module is required.',
      name: 'hRModuleIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Documents`
  String get documents {
    return Intl.message('Documents', name: 'documents', desc: '', args: []);
  }

  /// `Assets`
  String get assets {
    return Intl.message('Assets', name: 'assets', desc: '', args: []);
  }

  /// `Attendance Rate`
  String get attendanceRate {
    return Intl.message(
      'Attendance Rate',
      name: 'attendanceRate',
      desc: '',
      args: [],
    );
  }

  /// `Hours Worked`
  String get hoursWorked {
    return Intl.message(
      'Hours Worked',
      name: 'hoursWorked',
      desc: '',
      args: [],
    );
  }

  /// `Total Work Hours`
  String get totalWorkHours {
    return Intl.message(
      'Total Work Hours',
      name: 'totalWorkHours',
      desc: '',
      args: [],
    );
  }

  /// `Overall Stats`
  String get overallStatistics {
    return Intl.message(
      'Overall Stats',
      name: 'overallStatistics',
      desc: '',
      args: [],
    );
  }

  /// `Members Performance`
  String get membersPerformance {
    return Intl.message(
      'Members Performance',
      name: 'membersPerformance',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message('Success', name: 'success', desc: '', args: []);
  }

  /// `No Activity`
  String get noActivity {
    return Intl.message('No Activity', name: 'noActivity', desc: '', args: []);
  }

  /// `Excellent`
  String get excellent {
    return Intl.message('Excellent', name: 'excellent', desc: '', args: []);
  }

  /// `Good`
  String get good {
    return Intl.message('Good', name: 'good', desc: '', args: []);
  }

  /// `Fair`
  String get fair {
    return Intl.message('Fair', name: 'fair', desc: '', args: []);
  }

  /// `Needs Improvement`
  String get needsImprovement {
    return Intl.message(
      'Needs Improvement',
      name: 'needsImprovement',
      desc: '',
      args: [],
    );
  }

  /// `Working Hours`
  String get workingHours {
    return Intl.message(
      'Working Hours',
      name: 'workingHours',
      desc: '',
      args: [],
    );
  }

  /// `Time Worked Today`
  String get timeWorkedToday {
    return Intl.message(
      'Time Worked Today',
      name: 'timeWorkedToday',
      desc: '',
      args: [],
    );
  }

  /// `Great! You are on time.`
  String get youAreOnTime {
    return Intl.message(
      'Great! You are on time.',
      name: 'youAreOnTime',
      desc: '',
      args: [],
    );
  }

  /// `You are # early.`
  String get youAreEarly {
    return Intl.message(
      'You are # early.',
      name: 'youAreEarly',
      desc: '',
      args: [],
    );
  }

  /// `You are # late.`
  String get youAreLate {
    return Intl.message(
      'You are # late.',
      name: 'youAreLate',
      desc: '',
      args: [],
    );
  }

  /// `Minutes`
  String get minutes {
    return Intl.message('Minutes', name: 'minutes', desc: '', args: []);
  }

  /// `Hours`
  String get hours {
    return Intl.message('Hours', name: 'hours', desc: '', args: []);
  }

  /// `Correspondence`
  String get correspondence {
    return Intl.message(
      'Correspondence',
      name: 'correspondence',
      desc: '',
      args: [],
    );
  }

  /// `New Letter`
  String get newLetter {
    return Intl.message('New Letter', name: 'newLetter', desc: '', args: []);
  }

  /// `Direct Message`
  String get directMessage {
    return Intl.message(
      'Direct Message',
      name: 'directMessage',
      desc: '',
      args: [],
    );
  }

  /// `New Group`
  String get newGroup {
    return Intl.message('New Group', name: 'newGroup', desc: '', args: []);
  }

  /// `Edit Group`
  String get editGroup {
    return Intl.message('Edit Group', name: 'editGroup', desc: '', args: []);
  }

  /// `Group Title`
  String get groupTitle {
    return Intl.message('Group Title', name: 'groupTitle', desc: '', args: []);
  }

  /// `Start Conversation?`
  String get startConversationDialog {
    return Intl.message(
      'Start Conversation?',
      name: 'startConversationDialog',
      desc: '',
      args: [],
    );
  }

  /// `Pin`
  String get pin {
    return Intl.message('Pin', name: 'pin', desc: '', args: []);
  }

  /// `Unpin`
  String get unpin {
    return Intl.message('Unpin', name: 'unpin', desc: '', args: []);
  }

  /// `Image`
  String get image {
    return Intl.message('Image', name: 'image', desc: '', args: []);
  }

  /// `Audio`
  String get audio {
    return Intl.message('Audio', name: 'audio', desc: '', args: []);
  }

  /// `Video`
  String get video {
    return Intl.message('Video', name: 'video', desc: '', args: []);
  }

  /// `Voice message`
  String get voiceMessage {
    return Intl.message(
      'Voice message',
      name: 'voiceMessage',
      desc: '',
      args: [],
    );
  }

  /// `Copy Text`
  String get copyText {
    return Intl.message('Copy Text', name: 'copyText', desc: '', args: []);
  }

  /// `Edited`
  String get edited {
    return Intl.message('Edited', name: 'edited', desc: '', args: []);
  }

  /// `Download`
  String get download {
    return Intl.message('Download', name: 'download', desc: '', args: []);
  }

  /// `Save to Gallery`
  String get saveToGallery {
    return Intl.message(
      'Save to Gallery',
      name: 'saveToGallery',
      desc: '',
      args: [],
    );
  }

  /// `Leave Group`
  String get leaveGroup {
    return Intl.message('Leave Group', name: 'leaveGroup', desc: '', args: []);
  }

  /// `Delete & Leave`
  String get deleteAndLeave {
    return Intl.message(
      'Delete & Leave',
      name: 'deleteAndLeave',
      desc: '',
      args: [],
    );
  }

  /// `Legal`
  String get legal {
    return Intl.message('Legal', name: 'legal', desc: '', args: []);
  }

  /// `Personal`
  String get personal {
    return Intl.message('Personal', name: 'personal', desc: '', args: []);
  }

  /// `SMS`
  String get sms {
    return Intl.message('SMS', name: 'sms', desc: '', args: []);
  }

  /// `Cloud Call`
  String get cloudCall {
    return Intl.message('Cloud Call', name: 'cloudCall', desc: '', args: []);
  }

  /// `Marketing`
  String get marketing {
    return Intl.message('Marketing', name: 'marketing', desc: '', args: []);
  }

  /// `Planning`
  String get planning {
    return Intl.message('Planning', name: 'planning', desc: '', args: []);
  }

  /// `Total Count`
  String get totalCount {
    return Intl.message('Total Count', name: 'totalCount', desc: '', args: []);
  }

  /// `Pending`
  String get pending {
    return Intl.message('Pending', name: 'pending', desc: '', args: []);
  }

  /// `Forward`
  String get forward {
    return Intl.message('Forward', name: 'forward', desc: '', args: []);
  }

  /// `Forwarded From`
  String get forwardedFrom {
    return Intl.message(
      'Forwarded From',
      name: 'forwardedFrom',
      desc: '',
      args: [],
    );
  }

  /// `Forwarded successfully`
  String get forwardedSuccessfully {
    return Intl.message(
      'Forwarded successfully',
      name: 'forwardedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `No messages to forward`
  String get noMessagesToForward {
    return Intl.message(
      'No messages to forward',
      name: 'noMessagesToForward',
      desc: '',
      args: [],
    );
  }

  /// `No messages selected`
  String get noMessagesSelected {
    return Intl.message(
      'No messages selected',
      name: 'noMessagesSelected',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least one conversation`
  String get pleaseSelectAtLeastOneConversation {
    return Intl.message(
      'Please select at least one conversation',
      name: 'pleaseSelectAtLeastOneConversation',
      desc: '',
      args: [],
    );
  }

  /// `Select Conversation`
  String get selectConversation {
    return Intl.message(
      'Select Conversation',
      name: 'selectConversation',
      desc: '',
      args: [],
    );
  }

  /// `conversations selected`
  String get conversationsSelected {
    return Intl.message(
      'conversations selected',
      name: 'conversationsSelected',
      desc: '',
      args: [],
    );
  }

  /// `This date has already been added.`
  String get thisDateHasAlreadyBeenAdded {
    return Intl.message(
      'This date has already been added.',
      name: 'thisDateHasAlreadyBeenAdded',
      desc: '',
      args: [],
    );
  }

  /// `You are not a member of this group.`
  String get youAreNotMemberOfThisGroup {
    return Intl.message(
      'You are not a member of this group.',
      name: 'youAreNotMemberOfThisGroup',
      desc: '',
      args: [],
    );
  }

  /// `Message not found`
  String get messageNotFound {
    return Intl.message(
      'Message not found',
      name: 'messageNotFound',
      desc: '',
      args: [],
    );
  }

  /// `File not found`
  String get fileNotFound {
    return Intl.message(
      'File not found',
      name: 'fileNotFound',
      desc: '',
      args: [],
    );
  }

  /// `File size exceeds the allowed limit`
  String get fileSizeExceedsTheAllowedLimit {
    return Intl.message(
      'File size exceeds the allowed limit',
      name: 'fileSizeExceedsTheAllowedLimit',
      desc: '',
      args: [],
    );
  }

  /// `maximum`
  String get maximum {
    return Intl.message('maximum', name: 'maximum', desc: '', args: []);
  }

  /// `File upload error`
  String get fileUploadError {
    return Intl.message(
      'File upload error',
      name: 'fileUploadError',
      desc: '',
      args: [],
    );
  }

  /// `No text messages selected`
  String get noTextMessagesSelected {
    return Intl.message(
      'No text messages selected',
      name: 'noTextMessagesSelected',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to leave this group?`
  String get leaveGroupDialogDescription {
    return Intl.message(
      'Are you sure you want to leave this group?',
      name: 'leaveGroupDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete and leave this group?`
  String get deleteAndLeaveGroupDialogDescription {
    return Intl.message(
      'Are you sure you want to delete and leave this group?',
      name: 'deleteAndLeaveGroupDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `You are not allowed to delete other users' messages.`
  String get notAllowedDeleteOtherUsersMessages {
    return Intl.message(
      'You are not allowed to delete other users\' messages.',
      name: 'notAllowedDeleteOtherUsersMessages',
      desc: '',
      args: [],
    );
  }

  /// `Saved`
  String get saved {
    return Intl.message('Saved', name: 'saved', desc: '', args: []);
  }

  /// `Gallery permission denied. Please enable it from settings.`
  String get galleryPermissionDenied {
    return Intl.message(
      'Gallery permission denied. Please enable it from settings.',
      name: 'galleryPermissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `The directory could not be found.`
  String get directoryCouldNotBeFound {
    return Intl.message(
      'The directory could not be found.',
      name: 'directoryCouldNotBeFound',
      desc: '',
      args: [],
    );
  }

  /// `The file format is not allowed.`
  String get formatIsNotAllowed {
    return Intl.message(
      'The file format is not allowed.',
      name: 'formatIsNotAllowed',
      desc: '',
      args: [],
    );
  }

  /// `File selected successfully.`
  String get fileSelectedSuccessfully {
    return Intl.message(
      'File selected successfully.',
      name: 'fileSelectedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Allowed formats: XLSX, XLS, CSV (maximum 10 MB)`
  String get allowedExelFormatsAndSize {
    return Intl.message(
      'Allowed formats: XLSX, XLS, CSV (maximum 10 MB)',
      name: 'allowedExelFormatsAndSize',
      desc: '',
      args: [],
    );
  }

  /// `Case`
  String get legalCase {
    return Intl.message('Case', name: 'legalCase', desc: '', args: []);
  }

  /// `New Case`
  String get newCase {
    return Intl.message('New Case', name: 'newCase', desc: '', args: []);
  }

  /// `Edit Case`
  String get editCase {
    return Intl.message('Edit Case', name: 'editCase', desc: '', args: []);
  }

  /// `My Case`
  String get myCase {
    return Intl.message('My Case', name: 'myCase', desc: '', args: []);
  }

  /// `Create Contract`
  String get createContract {
    return Intl.message(
      'Create Contract',
      name: 'createContract',
      desc: '',
      args: [],
    );
  }

  /// `Contract File`
  String get contractFile {
    return Intl.message(
      'Contract File',
      name: 'contractFile',
      desc: '',
      args: [],
    );
  }

  /// `View & Download`
  String get viewAndDownload {
    return Intl.message(
      'View & Download',
      name: 'viewAndDownload',
      desc: '',
      args: [],
    );
  }

  /// `Error downloading file`
  String get errorDownloadingFile {
    return Intl.message(
      'Error downloading file',
      name: 'errorDownloadingFile',
      desc: '',
      args: [],
    );
  }

  /// `The Parties`
  String get parties {
    return Intl.message('The Parties', name: 'parties', desc: '', args: []);
  }

  /// `New Party`
  String get newParty {
    return Intl.message('New Party', name: 'newParty', desc: '', args: []);
  }

  /// `Edit Party`
  String get editParty {
    return Intl.message('Edit Party', name: 'editParty', desc: '', args: []);
  }

  /// `Signatories`
  String get signatories {
    return Intl.message('Signatories', name: 'signatories', desc: '', args: []);
  }

  /// `New Signatory`
  String get newSignatory {
    return Intl.message(
      'New Signatory',
      name: 'newSignatory',
      desc: '',
      args: [],
    );
  }

  /// `Edit Signatory`
  String get editSignatory {
    return Intl.message(
      'Edit Signatory',
      name: 'editSignatory',
      desc: '',
      args: [],
    );
  }

  /// `Message sent successfully`
  String get messageSentSuccessfully {
    return Intl.message(
      'Message sent successfully',
      name: 'messageSentSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Member added successfully`
  String get memberAddedSuccessfully {
    return Intl.message(
      'Member added successfully',
      name: 'memberAddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Member removed successfully`
  String get memberRemovedSuccessfully {
    return Intl.message(
      'Member removed successfully',
      name: 'memberRemovedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `You have files being uploaded. Leaving now will cancel all uploads. Do you want to exit?`
  String get exitConversationMessagesPageWarningDescription {
    return Intl.message(
      'You have files being uploaded. Leaving now will cancel all uploads. Do you want to exit?',
      name: 'exitConversationMessagesPageWarningDescription',
      desc: '',
      args: [],
    );
  }

  /// `Not supported in this version.`
  String get notSupportedInThisVersion {
    return Intl.message(
      'Not supported in this version.',
      name: 'notSupportedInThisVersion',
      desc: '',
      args: [],
    );
  }

  /// `Send Anonymous Message`
  String get sendAnonymousMessage {
    return Intl.message(
      'Send Anonymous Message',
      name: 'sendAnonymousMessage',
      desc: '',
      args: [],
    );
  }

  /// `Recipients`
  String get recipients {
    return Intl.message('Recipients', name: 'recipients', desc: '', args: []);
  }

  /// `Message Text`
  String get messageText {
    return Intl.message(
      'Message Text',
      name: 'messageText',
      desc: '',
      args: [],
    );
  }

  /// `Custom Message Text`
  String get customMessageText {
    return Intl.message(
      'Custom Message Text',
      name: 'customMessageText',
      desc: '',
      args: [],
    );
  }

  /// `No contract has been registered`
  String get noContract {
    return Intl.message(
      'No contract has been registered',
      name: 'noContract',
      desc: '',
      args: [],
    );
  }

  /// `The file will be sent to registered users for online signing.`
  String get contractTypeHelper {
    return Intl.message(
      'The file will be sent to registered users for online signing.',
      name: 'contractTypeHelper',
      desc: '',
      args: [],
    );
  }

  /// `The file is used for case documentation and workflow management.`
  String get caseTypeHelper {
    return Intl.message(
      'The file is used for case documentation and workflow management.',
      name: 'caseTypeHelper',
      desc: '',
      args: [],
    );
  }

  /// `Validity Date`
  String get validityDate {
    return Intl.message(
      'Validity Date',
      name: 'validityDate',
      desc: '',
      args: [],
    );
  }

  /// `Only PDF files are allowed.`
  String get onlyPDFFilesAllowed {
    return Intl.message(
      'Only PDF files are allowed.',
      name: 'onlyPDFFilesAllowed',
      desc: '',
      args: [],
    );
  }

  /// `Created by`
  String get createdBy {
    return Intl.message('Created by', name: 'createdBy', desc: '', args: []);
  }

  /// `Clicking this button will delete the current contract, and you can then create a new one.`
  String get deleteContractHelper {
    return Intl.message(
      'Clicking this button will delete the current contract, and you can then create a new one.',
      name: 'deleteContractHelper',
      desc: '',
      args: [],
    );
  }

  /// `The national code must be 10 digits`
  String get nationalIdIsShort {
    return Intl.message(
      'The national code must be 10 digits',
      name: 'nationalIdIsShort',
      desc: '',
      args: [],
    );
  }

  /// `The national code is invalid`
  String get invalidNationalId {
    return Intl.message(
      'The national code is invalid',
      name: 'invalidNationalId',
      desc: '',
      args: [],
    );
  }

  /// `Replace`
  String get replace {
    return Intl.message('Replace', name: 'replace', desc: '', args: []);
  }

  /// `Are you sure the file is complete?`
  String get changeLegalCaseStatusDialogDescription {
    return Intl.message(
      'Are you sure the file is complete?',
      name: 'changeLegalCaseStatusDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `Total Contracts`
  String get totalContracts {
    return Intl.message(
      'Total Contracts',
      name: 'totalContracts',
      desc: '',
      args: [],
    );
  }

  /// `Total Tasks`
  String get totalTasks {
    return Intl.message('Total Tasks', name: 'totalTasks', desc: '', args: []);
  }

  /// `Total Follow-ups`
  String get totalFollowups {
    return Intl.message(
      'Total Follow-ups',
      name: 'totalFollowups',
      desc: '',
      args: [],
    );
  }

  /// `Overdue Tasks`
  String get overdueTasks {
    return Intl.message(
      'Overdue Tasks',
      name: 'overdueTasks',
      desc: '',
      args: [],
    );
  }

  /// `Overdue Follow-ups`
  String get overdueFollowups {
    return Intl.message(
      'Overdue Follow-ups',
      name: 'overdueFollowups',
      desc: '',
      args: [],
    );
  }

  /// `Unscheduled`
  String get unscheduled {
    return Intl.message('Unscheduled', name: 'unscheduled', desc: '', args: []);
  }

  /// `Unscheduled Tasks`
  String get unscheduledTasks {
    return Intl.message(
      'Unscheduled Tasks',
      name: 'unscheduledTasks',
      desc: '',
      args: [],
    );
  }

  /// `Time Spent`
  String get timeSpent {
    return Intl.message('Time Spent', name: 'timeSpent', desc: '', args: []);
  }

  /// `Closed-Won Follow-ups`
  String get closedWonFollowups {
    return Intl.message(
      'Closed-Won Follow-ups',
      name: 'closedWonFollowups',
      desc: '',
      args: [],
    );
  }

  /// `Have a promo code?`
  String get promoCode {
    return Intl.message(
      'Have a promo code?',
      name: 'promoCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter code here...`
  String get enterCodeHere {
    return Intl.message(
      'Enter code here...',
      name: 'enterCodeHere',
      desc: '',
      args: [],
    );
  }

  /// `Promo code applied successfully!`
  String get promoCodeApplied {
    return Intl.message(
      'Promo code applied successfully!',
      name: 'promoCodeApplied',
      desc: '',
      args: [],
    );
  }

  /// `Invalid code.`
  String get invalidPromoCode {
    return Intl.message(
      'Invalid code.',
      name: 'invalidPromoCode',
      desc: '',
      args: [],
    );
  }

  /// `Contract Count`
  String get contractCount {
    return Intl.message(
      'Contract Count',
      name: 'contractCount',
      desc: '',
      args: [],
    );
  }

  /// `This value represents the total number of contracts you are authorized to create within the Legal module based on your account permissions.`
  String get contractCountInfo {
    return Intl.message(
      'This value represents the total number of contracts you are authorized to create within the Legal module based on your account permissions.',
      name: 'contractCountInfo',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fa'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
