part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final TenantDashboardModel? tenantDashboardModel;
  final AgentDashboardModel? agentDashboardModel;
  final bool? isLoading;
  final bool? mailSent;
  final Failure? failure;

  const DashboardState({
    this.tenantDashboardModel,
    this.agentDashboardModel,
    this.isLoading = false,
    this.mailSent = false,
    this.failure,
  });

  DashboardState copyWith({
    TenantDashboardModel? tenantDashboardModel,
    AgentDashboardModel? agentDashboardModel,
    bool isLoading = false,
    bool mailSent = false,
    Failure? failure,
  }) => DashboardState(
    tenantDashboardModel: tenantDashboardModel ?? this.tenantDashboardModel,
    agentDashboardModel: agentDashboardModel ?? this.agentDashboardModel,
    isLoading: isLoading,
    failure: failure,
    mailSent: mailSent,
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
      isLoading: map['isLoading'],
    );
  }

  Map<String, dynamic> toJson() => {
    'tenantDashboard': tenantDashboardModel?.toJson(),
    'agentDashboard': agentDashboardModel?.toJson(),
    'isLoading': isLoading,
  };

  @override
  List<Object?> get props => [
    tenantDashboardModel,
    isLoading,
    mailSent,
    agentDashboardModel,
  ];
}

final class DashboardInitial extends DashboardState {
  @override
  List<Object> get props => [];
}
