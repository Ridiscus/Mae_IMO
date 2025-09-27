import 'dart:async';
import 'dart:developer' as console;

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:maelys_imo/core/domain/models/responses/Inventorie_model_response.dart';
import 'package:maelys_imo/core/services/Inventorie_service.dart';
import 'package:maelys_imo/core/utils/toast/notification_toast.dart';

import '../../../domain/models/index.dart';
import '../../../utils/index.dart';

part 'inventories_event.dart';
part 'inventories_state.dart';

class InventoriesBloc extends HydratedBloc<InventoriesEvent, InventoriesState> {
  final InventorieService _service;

  InventoriesBloc({required InventorieService service})
    : _service = service,
      super(InventoriesInitial()) {
    on<FetchInventoriesEvent>(_onFetchInventoriesEvent);
    on<FetchOneInventoriesEvent>(_onFetchOneInventoriesEvent);
  }

  @override
  InventoriesState? fromJson(Map<String, dynamic> json) {
    return InventoriesState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(InventoriesState state) {
    return state.toJson();
  }

  Future<void> _onFetchInventoriesEvent(
    FetchInventoriesEvent event,
    Emitter<InventoriesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _service.inventorieList();
      if (result.success) {
        emit(state.copyWith(isLoading: false, inventories: result.data));
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
        name: "catch _onFetchInventoriesEvent",
      );
      emit(state.copyWith(isLoading: false));
      if (kDebugMode) rethrow;
    }
  }

  FutureOr<void> _onFetchOneInventoriesEvent(
    FetchOneInventoriesEvent event,
    Emitter<InventoriesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _service.inventorieDetail(id: event.id);
      if (result.success) {
        emit(state.copyWith(isLoading: false, inventoryDetail: result.data));
      } else {
        showToast(msg: "Donnée non accéssible !");
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
        name: "catch _onFetchOneInventoriesEvent",
      );
      emit(state.copyWith(isLoading: false));
      if (kDebugMode) rethrow;
    }
  }
}
