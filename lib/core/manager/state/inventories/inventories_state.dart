part of 'inventories_bloc.dart';

class InventoriesState extends Equatable {
  final bool? isLoading;
  final Failure? failure;
  final InventoryModelResponse? inventories;
  final InventoryDetailModel? inventoryDetail;
  final bool? codeGenerated;
  final bool? codeVerified;
  final bool? estateLocationSaved;

  const InventoriesState({
    this.inventoryDetail,
    this.isLoading,
    this.inventories,
    this.failure,
    this.codeGenerated,
    this.codeVerified,
    this.estateLocationSaved,
  });

  InventoriesState copyWith({
    bool? isLoading,
    InventoryModelResponse? inventories,
    InventoryDetailModel? inventoryDetail,
    Failure? failure,
    bool? codeGenerated,
    bool? codeVerified,
    bool? estateLocationSaved,
  }) {
    return InventoriesState(
      isLoading: isLoading ?? this.isLoading,
      inventories: inventories ?? this.inventories,
      inventoryDetail: inventoryDetail ?? this.inventoryDetail,
      failure: failure,
      codeGenerated: codeGenerated,
      codeVerified: codeVerified,
      estateLocationSaved: estateLocationSaved,
    );
  }

  factory InventoriesState.fromJson(Map<String, dynamic> json) {
    return InventoriesState(
      isLoading: json['isLoading'],
      inventories:
          json['inventories'] != null
              ? InventoryModelResponse.fromJson(json['inventories'])
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'isLoading': isLoading,
    'inventories': inventories?.toJson(),
  };

  @override
  List<Object?> get props => [
    isLoading,
    inventoryDetail,
    inventories,
    codeGenerated,
    codeVerified,
    estateLocationSaved,
  ];
}

final class InventoriesInitial extends InventoriesState {
  @override
  List<Object> get props => [];
}
