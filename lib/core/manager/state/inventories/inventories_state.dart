part of 'inventories_bloc.dart';

class InventoriesState extends Equatable {
  final bool? isLoading;
  final Failure? failure;
  final InventorieModelResponse? inventories;

  const InventoriesState({this.isLoading, this.inventories, this.failure});

  InventoriesState copyWith({
    bool? isLoading,
    InventorieModelResponse? inventories,
    Failure? failure,
  }) {
    return InventoriesState(
      isLoading: isLoading ?? this.isLoading,
      inventories: inventories ?? this.inventories,
      failure: failure,
    );
  }

  factory InventoriesState.fromJson(Map<String, dynamic> json) {
    return InventoriesState(
      isLoading: json['isLoading'],
      inventories:
          json['inventories'] != null
              ? InventorieModelResponse.fromJson(json['inventories'])
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'isLoading': isLoading,
    'inventories': inventories?.toJson(),
  };

  @override
  List<Object?> get props => [isLoading, inventories];
}

final class InventoriesInitial extends InventoriesState {
  @override
  List<Object> get props => [];
}
