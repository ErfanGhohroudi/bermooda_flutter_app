part of 'enums.dart';

extension AuthStatusExtentions<T> on AuthStatus? {
  bool isAuth() => this == AuthStatus.accepted;
}

extension ActionApiTypeExtentions<T> on ActionApiType {
  ActionApiType toCreate() => ActionApiType.create;

  ActionApiType toUpdate() => ActionApiType.update;

  ActionApiType toDelete() => ActionApiType.delete;

  bool isCreate() => this == ActionApiType.create;

  bool isUpdate() => this == ActionApiType.update;

  bool isDelete() => this == ActionApiType.delete;
}

extension RxActionApiTypeExtentions<T> on Rx<ActionApiType> {
  ActionApiType toCreate() => this(ActionApiType.create);

  ActionApiType toUpdate() => this(ActionApiType.update);

  ActionApiType toDelete() => this(ActionApiType.delete);

  bool isCreate() => value == ActionApiType.create;

  bool isUpdate() => value == ActionApiType.update;

  bool isDelete() => value == ActionApiType.delete;
}

extension CalendarFilterTypeExtentions<T> on CalendarFilterType {
  CalendarFilterType all() => CalendarFilterType.all;

  CalendarFilterType meetings() => CalendarFilterType.meetings;

  CalendarFilterType checklists() => CalendarFilterType.checklists;

  CalendarFilterType customers() => CalendarFilterType.customers;

  bool isAll() => this == CalendarFilterType.all;

  bool isMeetings() => this == CalendarFilterType.meetings;

  bool isChecklists() => this == CalendarFilterType.checklists;

  bool isCustomers() => this == CalendarFilterType.customers;
}

extension OwnerMemberTypeExtentions<T> on OwnerMemberType? {
  bool isOwner() => this == OwnerMemberType.owner;

  bool isNotOwner() => this != OwnerMemberType.owner;

  bool isMember() => this == OwnerMemberType.member;
}

extension RxAuthenticationTypeExtentions<T> on Rx<AuthenticationType> {
  bool isPerson() => value == AuthenticationType.person;

  bool isLegal() => value == AuthenticationType.legal;
}

extension ListModulesExtentions<T> on List<ModuleReadDto>? {
  ModuleReadDto? getByType(final ModuleType type) {
    final item = this?.firstWhereOrNull((final e) => e.type == type);
    return item;
  }

  bool get projectBoardIsActive => (getByType(ModuleType.project)?.isActive ?? false);

  bool get crmIsActive => (getByType(ModuleType.crm)?.isActive ?? false);

  bool get humanResourcesIsActive => (getByType(ModuleType.humanResources)?.isActive ?? false);

  bool get requestsIsActive => (getByType(ModuleType.requests)?.isActive ?? false);

  bool get groupChatIsActive => (getByType(ModuleType.conversation)?.isActive ?? false);

  bool get smsIsActive => (getByType(ModuleType.sms)?.isActive ?? false);

  bool get cloudCallIsActive => (getByType(ModuleType.cloudCall)?.isActive ?? false);

  bool get employmentIsActive => (getByType(ModuleType.employment)?.isActive ?? false);

  bool get marketingIsActive => (getByType(ModuleType.marketing)?.isActive ?? false);

  bool get planningIsActive => (getByType(ModuleType.planning)?.isActive ?? false);

  bool get lettersIsActive => (getByType(ModuleType.letters)?.isActive ?? false);

  bool get legalIsActive => (getByType(ModuleType.legal)?.isActive ?? false);
}
