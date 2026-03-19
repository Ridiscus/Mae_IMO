part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final TenantDashboardModel? tenantDashboardModel;
  final AgentDashboardModel? agentDashboardModel;
  final CommercialDashboardModel? commercialDashboardModel;
  final bool? isLoading;
  final bool? mailSent;
  final Failure? failure;
  final List<AgencyModel>? agencies;
  final List<OwnerModel>? owners;
  final List<PropertyModel>? properties;
  final bool isCreatingAgency;
  final bool agencyCreated;
  final bool isCreatingOwner;
  final bool ownerCreated;
  final bool isCreatingProperty;
  final bool propertyCreated;
  final bool isUpdatingProperty;
  final bool propertyUpdated;
  final bool isUpdatingAgency;
  final bool agencyUpdated;
  final bool isUpdatingOwner;
  final bool ownerUpdated;
  final bool isDeletingProperty;
  final bool propertyDeleted;
  final bool isDeletingAgency;
  final bool agencyDeleted;
  final bool isDeletingOwner;
  final bool ownerDeleted;
  final Map<String, dynamic>? formErrors;

  const DashboardState({
    this.tenantDashboardModel,
    this.agentDashboardModel,
    this.commercialDashboardModel,
    this.agencies,
    this.owners,
    this.properties,
    this.isLoading = false,
    this.mailSent = false,
    this.isCreatingAgency = false,
    this.agencyCreated = false,
    this.isCreatingOwner = false,
    this.ownerCreated = false,
    this.isCreatingProperty = false,
    this.propertyCreated = false,
    this.isUpdatingProperty = false,
    this.propertyUpdated = false,
    this.isUpdatingAgency = false,
    this.agencyUpdated = false,
    this.isUpdatingOwner = false,
    this.ownerUpdated = false,
    this.isDeletingProperty = false,
    this.propertyDeleted = false,
    this.isDeletingAgency = false,
    this.agencyDeleted = false,
    this.isDeletingOwner = false,
    this.ownerDeleted = false,
    this.formErrors,
    this.failure,
  });

  DashboardState copyWith({
    TenantDashboardModel? tenantDashboardModel,
    AgentDashboardModel? agentDashboardModel,
    CommercialDashboardModel? commercialDashboardModel,
    List<AgencyModel>? agencies,
    List<OwnerModel>? owners,
    List<PropertyModel>? properties,
    bool isLoading = false,
    bool mailSent = false,
    bool isCreatingAgency = false,
    bool agencyCreated = false,
    bool isCreatingOwner = false,
    bool ownerCreated = false,
    bool isCreatingProperty = false,
    bool propertyCreated = false,
    bool isUpdatingProperty = false,
    bool propertyUpdated = false,
    bool isUpdatingAgency = false,
    bool agencyUpdated = false,
    bool isUpdatingOwner = false,
    bool ownerUpdated = false,
    bool isDeletingProperty = false,
    bool propertyDeleted = false,
    bool isDeletingAgency = false,
    bool agencyDeleted = false,
    bool isDeletingOwner = false,
    bool ownerDeleted = false,
    Map<String, dynamic>? formErrors,
    Failure? failure,
  }) => DashboardState(
    tenantDashboardModel: tenantDashboardModel ?? this.tenantDashboardModel,
    agentDashboardModel: agentDashboardModel ?? this.agentDashboardModel,
    commercialDashboardModel:
        commercialDashboardModel ?? this.commercialDashboardModel,
    agencies: agencies ?? this.agencies,
    owners: owners ?? this.owners,
    properties: properties ?? this.properties,
    isLoading: isLoading,
    mailSent: mailSent,
    isCreatingAgency: isCreatingAgency,
    agencyCreated: agencyCreated,
    isCreatingOwner: isCreatingOwner,
    ownerCreated: ownerCreated,
    isCreatingProperty: isCreatingProperty,
    propertyCreated: propertyCreated,
    isUpdatingProperty: isUpdatingProperty,
    propertyUpdated: propertyUpdated,
    isUpdatingAgency: isUpdatingAgency,
    agencyUpdated: agencyUpdated,
    isUpdatingOwner: isUpdatingOwner,
    ownerUpdated: ownerUpdated,
    isDeletingProperty: isDeletingProperty,
    propertyDeleted: propertyDeleted,
    isDeletingAgency: isDeletingAgency,
    agencyDeleted: agencyDeleted,
    isDeletingOwner: isDeletingOwner,
    ownerDeleted: ownerDeleted,
    formErrors: formErrors ?? this.formErrors,
    failure: failure,
  );

  factory DashboardState.fromMap(Map<String, dynamic> map) {
    return DashboardState(
      tenantDashboardModel:
          map['tenantDashboard'] != null
              ? TenantDashboardModel.fromJson(map['tenantDashboard'])
              : null,
      agentDashboardModel:
          map['agentDashboard'] != null
              ? AgentDashboardModel.fromJson(map['agentDashboard'])
              : null,
      commercialDashboardModel:
          map['commercialDashboard'] != null
              ? CommercialDashboardModel.fromMap(map['commercialDashboard'])
              : null,
      agencies:
          map['agencies'] != null
              ? List<AgencyModel>.from(
                map['agencies'].map((x) => AgencyModel.fromMap(x)),
              )
              : null,
      owners:
          map['owners'] != null
              ? List<OwnerModel>.from(
                map['owners'].map((x) => OwnerModel.fromMap(x)),
              )
              : null,
      properties:
          map['properties'] != null
              ? List<PropertyModel>.from(
                map['properties'].map((x) => PropertyModel.fromMap(x)),
              )
              : null,
      isLoading: map['isLoading'],
    );
  }

  Map<String, dynamic> toJson() => {
    'tenantDashboard': tenantDashboardModel?.toJson(),
    'agentDashboard': agentDashboardModel?.toJson(),
    'commercialDashboard': commercialDashboardModel?.toMap(),
    'agencies': agencies?.map((x) => x.toMap()).toList(),
    'owners': owners?.map((x) => x.toMap()).toList(),
    'properties': properties?.map((x) => x.toMap()).toList(),
    'isLoading': isLoading,
  };

  @override
  List<Object?> get props => [
    tenantDashboardModel,
    isLoading,
    mailSent,
    agentDashboardModel,
    commercialDashboardModel,
    agencies,
    owners,
    properties,
    isCreatingAgency,
    agencyCreated,
    isCreatingOwner,
    ownerCreated,
    isCreatingProperty,
    propertyCreated,
    isUpdatingProperty,
    propertyUpdated,
    isUpdatingAgency,
    agencyUpdated,
    isUpdatingOwner,
    ownerUpdated,
    formErrors,
    failure,
  ];
}

final class DashboardInitial extends DashboardState {
  @override
  List<Object> get props => [];
}
