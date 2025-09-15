import 'dart:async';
import 'dart:developer' as console;

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:maelys_imo/core/domain/models/index.dart';
import 'package:maelys_imo/core/domain/requests/index.dart';
import 'package:maelys_imo/core/services/dashboard_service.dart';
import 'package:maelys_imo/core/utils/toast/notification_toast.dart';
import 'package:toastification/toastification.dart';

import '../../../utils/index.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends HydratedBloc<DashboardEvent, DashboardState> {
  final DashboardService _service;

  DashboardBloc({required DashboardService service})
    : _service = service,
      super(DashboardInitial()) {
    on<FetchTenantDashboardEvent>(_onFetchTenantDashboardEvent);
    on<ContactAgencyEvent>(_onContactAgencyEvent);
    on<FetchAgentDashboardEvent>(_onFetchAgentDashboardEvent);
  }

  @override
  DashboardState? fromJson(Map<String, dynamic> json) {
    return DashboardState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(DashboardState state) {
    return state.toJson();
  }

  FutureOr<void> _onFetchTenantDashboardEvent(
    FetchTenantDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _service.tenantDashboard();
      if (result.success) {
        emit(
          state.copyWith(isLoading: false, tenantDashboardModel: result.data),
        );
      } else {
        showToast(msg: result.message ?? "Données non disponible !");
        emit(
          state.copyWith(
            isLoading: false,
            failure: Failure(message: result.message!),
          ),
        );
      }
    } catch (e) {
      console.log(
        "ERROR:: ${e.toString()}",
        name: "_onFetchTenantDashboardEvent",
      );
      emit(state.copyWith(isLoading: false));
      if (kDebugMode) {
        rethrow;
      }
    }
  }

  FutureOr<void> _onContactAgencyEvent(
    ContactAgencyEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _service.contactAgency(dto: event.dto);
      if (result.success) {
        showToast(
          msg: result.message ?? "Message envoyé avec succès",
          type: ToastificationType.success,
        );
        emit(state.copyWith(isLoading: false, mailSent: true));
      } else {
        showToast(msg: result.message ?? "Message non envoyé");
        emit(
          state.copyWith(
            isLoading: false,
            mailSent: false,
            failure: Failure(message: result.message!),
          ),
        );
      }
    } catch (e) {
      console.log("ERROR:: ${e.toString()}", name: "_onContactAgencyEvent");
      showToast(msg: "Echèc Message non envoyé");
      emit(state.copyWith(isLoading: false, mailSent: false));
      if (kDebugMode) {
        rethrow;
      }
    }
  }

  FutureOr<void> _onFetchAgentDashboardEvent(
    FetchAgentDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _service.agentDashboard();
      if (result.success) {
        emit(
          state.copyWith(isLoading: false, agentDashboardModel: result.data),
        );
      } else {
        showToast(msg: result.message ?? "Données non disponible !");
        emit(
          state.copyWith(
            isLoading: false,
            failure: Failure(message: result.message!),
          ),
        );
      }
    } catch (e) {
      console.log(
        "ERROR:: ${e.toString()}",
        name: "_onFetchAgentDashboardEvent",
      );
      emit(state.copyWith(isLoading: false));
      if (kDebugMode) {
        rethrow;
      }
    }
  }
}
