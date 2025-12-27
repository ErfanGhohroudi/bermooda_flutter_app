import 'package:equatable/equatable.dart';

class ProjectSettingsEntity extends Equatable {
  const ProjectSettingsEntity({
    this.startDate,
    this.dueDate,
    this.budget,
    // this.currency,
  });

  final String? startDate;
  final String? dueDate;
  final String? budget;
  // final CurrencyUnitReadDto? currency;

  @override
  List<Object?> get props => [
        startDate,
        dueDate,
        budget,
        // currency,
      ];
}
