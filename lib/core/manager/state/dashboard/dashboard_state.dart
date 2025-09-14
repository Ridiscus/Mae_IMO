part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final TenantDashboardModel? tenantDashboardModel;
  final bool? isLoading;
  final bool? mailSent;
  final Failure? failure;

  const DashboardState({
    this.tenantDashboardModel,
    this.isLoading = false,
    this.mailSent = false,
    this.failure,
  });

  DashboardState copyWith({
    TenantDashboardModel? tenantDashboardModel,
    bool isLoading = false,
    bool mailSent = false,
    Failure? failure,
  }) => DashboardState(
    tenantDashboardModel: tenantDashboardModel ?? this.tenantDashboardModel,
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
      isLoading: map['isLoading'],
    );
  }

  Map<String, dynamic> toJson() => {
    'tenantDashboard': tenantDashboardModel?.toJson(),
    'isLoading': isLoading,
  };

  @override
  List<Object?> get props => [tenantDashboardModel, isLoading, mailSent];
}

final class DashboardInitial extends DashboardState {
  @override
  List<Object> get props => [];
}
