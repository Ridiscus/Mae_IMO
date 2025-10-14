part of 'tenant_bloc.dart';

sealed class TenantEvent extends Equatable {
  const TenantEvent();
}

class FetchTenantsByStatusEvent extends TenantEvent {
  final String status;

  const FetchTenantsByStatusEvent({required this.status});

  @override
  List<Object?> get props => [status];
}

class ShowTenantEvent extends TenantEvent {
  final dynamic id;

  const ShowTenantEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class FetchPropertyInspectionsEvent extends TenantEvent {
  const FetchPropertyInspectionsEvent();

  @override
  List<Object?> get props => [];
}
