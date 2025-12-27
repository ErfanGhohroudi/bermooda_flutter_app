import 'package:equatable/equatable.dart';

/// A generic class to represent an item in a Kanban board.
/// It holds an ID and generic data.
class Item<T> extends Equatable {
  final String id;
  final String slug;
  final T data;
  const Item({required this.id, this.slug = '', required this.data});

  @override
  List<Object?> get props => [id];
}