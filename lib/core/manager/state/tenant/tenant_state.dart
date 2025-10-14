part of 'tenant_bloc.dart';

class TenantState extends Equatable {
  final List<TenantItemModel>? tenants;
  final TenantDetailModel? tenant;
  final EstateLocationResponseModel? propertyInspections;
  final bool? isLoading;
  final String? currentStatus;
  final Failure? failure;

  const TenantState({
    this.tenants,
    this.tenant,
    this.propertyInspections,
    this.isLoading = false,
    this.currentStatus,
    this.failure,
  });

  TenantState copyWith({
    List<TenantItemModel>? tenants,
    TenantDetailModel? tenant,
    EstateLocationResponseModel? propertyInspections,
    bool isLoading = false,
    String? currentStatus,
    Failure? failure,
  }) => TenantState(
    tenants: tenants ?? this.tenants,
    tenant: tenant,
    propertyInspections: propertyInspections ?? this.propertyInspections,
    isLoading: isLoading,
    currentStatus: currentStatus ?? this.currentStatus,
    failure: failure,
  );

  factory TenantState.fromMap(Map<String, dynamic> map) {
    return TenantState(
      // tenants:
      //     map['tenants'] != null
      //         ? (map['tenants'] as List)
      //             .map((item) => TenantItemModel.fromMap(item))
      //             .toList()
      //         : null,
      // isLoading: map['isLoading'],
      currentStatus: map['currentStatus'],
    );
  }

  Map<String, dynamic> toJson() => {
    // 'tenants': tenants?.map((tenant) => tenant.toMap()).toList(),
    // 'isLoading': isLoading,
    'currentStatus': currentStatus,
  };

  @override
  List<Object?> get props => [
    tenants,
    tenant,
    propertyInspections,
    isLoading,
    currentStatus,
    failure,
  ];
}

final class TenantInitial extends TenantState {
  @override
  List<Object> get props => [];
}
