import 'package:equatable/equatable.dart';
import 'package:u/utilities.dart';

import 'item_view_model.dart';

/// Represents a section (column) in the Kanban board.
/// Contains a title, color, and a list of `Item` objects.
/// [I] is the [Item] type. example: [Section<String>()]
class Section<S, I> extends Equatable {
  final String slug;
  int currentPage;
  int? nextPage;
  S? data;
  final RxList<Item<I>> children;
  final bool isAddSectionPage;
  bool isVisible;

  Section({
    required this.slug,
    this.currentPage = 1,
    this.nextPage,
    this.data,
    final List<Item<I>>? children,
    this.isAddSectionPage = false,
    this.isVisible = true,
  }) : children = RxList(children ?? []);

  factory Section.fromJson(final String str, {
    required final S Function(dynamic x) sectionFromMap,
    required final List<Item<I>> Function(dynamic x) itemListFromMap,
  }) => Section<S, I>.fromMap(json.decode(str), sectionFromMap: sectionFromMap, itemListFromMap: itemListFromMap);

  factory Section.fromMap(
    final Map<String, dynamic> json, {
    required final S Function(Map<String, dynamic> x) sectionFromMap,
    required final List<Item<I>> Function(List<dynamic> x) itemListFromMap,
  }) {

    return Section<S, I>(
      slug: json["slug"] ?? "pendingList",
      currentPage: json["cards"]?["current_page"] ?? 1,
      nextPage: json["cards"]?["next"],
      data: json["related_obj"]?["data"] == null ? null : sectionFromMap(json["related_obj"]["data"]),
      children: json["cards"]?["results"] == null ? [] : itemListFromMap(json["cards"]["results"]),
    );
  }

  @override
  List<Object?> get props => [slug];
}
