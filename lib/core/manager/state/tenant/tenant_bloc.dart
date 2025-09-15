import 'dart:async';
import 'dart:developer' as console;

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:maelys_imo/core/domain/models/index.dart';
import 'package:maelys_imo/core/services/tenant_service.dart';
import 'package:maelys_imo/core/utils/toast/notification_toast.dart';

import '../../../utils/index.dart';

part 'tenant_event.dart';
part 'tenant_state.dart';

class TenantBloc extends HydratedBloc<TenantEvent, TenantState> {
  final TenantService _service;

  TenantBloc({required TenantService service})
    : _service = service,
      super(TenantInitial()) {
    on<FetchTenantsByStatusEvent>(_onFetchTenantsByStatusEvent);
    on<ShowTenantEvent>(_onShowTenantEvent);
  }

  @override
  TenantState? fromJson(Map<String, dynamic> json) {
    return TenantState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(TenantState state) {
    return state.toJson();
  }

  FutureOr<void> _onFetchTenantsByStatusEvent(
    FetchTenantsByStatusEvent event,
    Emitter<TenantState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, currentStatus: event.status));
    try {
      final result = await _service.tenantByStatus(status: event.status);
      if (result.success) {
        emit(
          state.copyWith(
            isLoading: false,
            tenants: result.data,
            currentStatus: event.status,
          ),
        );
      } else {
        showToast(msg: result.message ?? "Données non disponibles !");
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
        name: "_onFetchTenantsByStatusEvent",
      );
      emit(state.copyWith(isLoading: false));
      if (kDebugMode) {
        rethrow;
      }
    }
  }

  FutureOr<void> _onShowTenantEvent(
    ShowTenantEvent event,
    Emitter<TenantState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _service.showDetailTenant(id: event.id);
      if (result.success) {
        emit(state.copyWith(isLoading: false, tenant: result.data));
      } else {
        showToast(msg: result.message ?? "Données non disponibles !");
        emit(
          state.copyWith(
            isLoading: false,
            failure: Failure(message: result.message!),
          ),
        );
      }
    } catch (e) {
      console.log("ERROR:: ${e.toString()}", name: "_onShowTenantEvent");
      emit(state.copyWith(isLoading: false));
      if (kDebugMode) {
        rethrow;
      }
    }
  }
}
