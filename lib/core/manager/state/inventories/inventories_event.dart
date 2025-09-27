part of 'inventories_bloc.dart';

sealed class InventoriesEvent extends Equatable {
  const InventoriesEvent();
}

class FetchInventoriesEvent extends InventoriesEvent {
  @override
  List<Object?> get props => [];
}

class FetchOneInventoriesEvent extends InventoriesEvent {
  final String id;

  const FetchOneInventoriesEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
