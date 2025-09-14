part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class FetchTenantDashboardEvent extends DashboardEvent {
  @override
  List<Object?> get props => [];
}

class ContactAgencyEvent extends DashboardEvent {
  final ContactAgencyRequest dto;

  const ContactAgencyEvent({required this.dto});

  @override
  List<Object?> get props => [dto];
}
