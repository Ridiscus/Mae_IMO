import 'dart:async';
import 'dart:developer' as console;

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:maelys_imo/core/api_manager/api_paginate_response.dart';
import 'package:maelys_imo/core/services/estate_service.dart';
import 'package:maelys_imo/core/utils/toast/notification_toast.dart';
import 'package:toastification/toastification.dart';

import '../../../domain/models/index.dart';
import '../../../domain/requests/index.dart';
import '../../../utils/index.dart';

part 'estate_event.dart';
part 'estate_state.dart';

class EstateBloc extends HydratedBloc<EstateEvent, EstateState> {
  final EstateService _service;

  EstateBloc({required EstateService service})
    : _service = service,
      super(EstateInitial()) {
    on<FetchEstateTypesEvent>(_onFetchEstateTypesEvent);
    on<FetchEstateEvent>(_onFetchEstateEvent);
    on<FetchDetailEstateEvent>(_onFetchDetailEstateEvent);
    on<SendVisiteRequestEstateEvent>(_onSendVisiteRequestEstateEvent);
  }

  @override
  EstateState? fromJson(Map<String, dynamic> json) {
    return EstateState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(EstateState state) {
    return state.toJson();
  }

  FutureOr<void> _onFetchEstateTypesEvent(
    FetchEstateTypesEvent event,
    Emitter<EstateState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _service.estatesType();
      if (result.success) {
        emit(state.copyWith(isLoading: false, estatesType: result.data));
      } else {
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
        name: "catch _onFetchEstateTypesEvent",
      );
      emit(state.copyWith(isLoading: false));
    }
  }

  FutureOr<void> _onFetchEstateEvent(
    FetchEstateEvent event,
    Emitter<EstateState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _service.estatesAvailable(dto: event.dto);

      if (result.success) {
        emit(
          state.copyWith(
            isLoading: false,
            estates: result.data?.data ?? [],
            paginate: result.data,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            failure: Failure(message: result.message!),
          ),
        );
      }
    } catch (e) {
      console.log(e.toString(), name: "catch _onFetchEstateEvent");
      emit(state.copyWith(isLoading: false));
    }
  }

  FutureOr<void> _onFetchDetailEstateEvent(
    FetchDetailEstateEvent event,
    Emitter<EstateState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _service.estatesDetail(id: event.id);

      if (result.success) {
        emit(state.copyWith(isLoading: false, estate: result.data));
      } else {
        showToast(
          msg: result.message ?? "Impossible de charger les données",
          type: ToastificationType.error,
        );
        emit(
          state.copyWith(
            isLoading: false,
            failure: Failure(message: result.message!),
          ),
        );
      }
    } catch (e) {
      console.log(e.toString(), name: "catch _onFetchEstateEvent");
      emit(state.copyWith(isLoading: false));
    }
  }

  FutureOr<void> _onSendVisiteRequestEstateEvent(
    SendVisiteRequestEstateEvent event,
    Emitter<EstateState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _service.sendVisiteEstates(dto: event.dto);
      if (result.success) {
        emit(
          state.copyWith(
            isLoading: false,
            messageResult: "Demande de visite enregistrée avec succès",
          ),
        );
      } else {
        showToast(
          msg: result.message ?? "Demande de visite non enregistrée",
          type: ToastificationType.error,
        );
        emit(state.copyWith(isLoading: false, messageResult: null));
      }
    } catch (e) {
      console.log(e.toString(), name: "catch _onFetchEstateEvent");
      emit(state.copyWith(isLoading: false));
    }
  }
}
