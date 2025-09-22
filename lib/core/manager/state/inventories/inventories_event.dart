part of 'inventories_bloc.dart';

sealed class InventoriesEvent extends Equatable {
  const InventoriesEvent();
}

class FetchInventoriesEvent extends InventoriesEvent {
  @override
  List<Object?> get props => [];
}
