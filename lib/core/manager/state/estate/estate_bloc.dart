import 'dart:async';
import 'dart:developer' as console;

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
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
    final String type = event.dto?.type ?? 'all';
    final String commune = event.dto?.commune ?? '';
    final String cacheKey = "${type}_$commune";

    // Si les données sont déjà en cache, on les affiche instantanément
    if (state.cache?.containsKey(cacheKey) ?? false) {
      emit(state.copyWith(isLoading: false, estates: state.cache![cacheKey]));
    } else {
      emit(state.copyWith(isLoading: true));
    }

    try {
      final result = await _service.estatesAvailable(dto: event.dto);

      if (result.success) {
        final List<EstateModel> newEstates = result.data?.data ?? [];

        // Mise à jour du cache
        final Map<String, List<EstateModel>> updatedCache =
            Map<String, List<EstateModel>>.from(state.cache ?? {});
        updatedCache[cacheKey] = newEstates;

        emit(
          state.copyWith(
            isLoading: false,
            estates: newEstates,
            paginate: result.data,
            cache: updatedCache,
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
      emit(
        state.copyWith(
          isLoading: false,
          failure: Failure(message: "Erreur technique : ${e.toString()}"),
        ),
      );
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
      console.log(e.toString(), name: "catch _onFetchDetailEstateEvent");
      emit(state.copyWith(isLoading: false));
      rethrow;
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
      if (kDebugMode) {
        rethrow;
      }
      emit(state.copyWith(isLoading: false));
    }
  }
}
