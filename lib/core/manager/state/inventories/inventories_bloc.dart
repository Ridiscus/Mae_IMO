import 'dart:async';
import 'dart:developer' as console;

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:maelys_imo/core/domain/models/responses/Inventorie_model_response.dart';
import 'package:maelys_imo/core/domain/requests/index.dart';
import 'package:maelys_imo/core/services/Inventorie_service.dart';
import 'package:maelys_imo/core/utils/toast/notification_toast.dart';
import 'package:toastification/toastification.dart';

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
    on<GenerateCodeEtatLieuxEvent>(_onGenerateCodeEtatLieuxEvent);
    on<VerifyCodeEtatLieuxEvent>(_onVerifyCodeEtatLieuxEvent);
    on<SaveEstateLocationEvent>(_onSaveEstateLocationEvent);
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

  FutureOr<void> _onGenerateCodeEtatLieuxEvent(
    GenerateCodeEtatLieuxEvent event,
    Emitter<InventoriesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, codeGenerated: null));
    try {
      final request = GenerateCodeEtatLieuxRequest(
        locataireId: event.locataireId,
      );
      final result = await _service.generateCodeEtatLieux(request);
      if (result.success) {
        emit(state.copyWith(isLoading: false, codeGenerated: true));
        showToast(
          msg: "Code OTP généré et envoyé au locataire",
          type: ToastificationType.success,
        );
      } else {
        emit(state.copyWith(isLoading: false, codeGenerated: false));
        showToast(
          msg: result.message ?? "Échec de la génération du code",
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      console.log(
        "ERROR:: ${e.toString()}",
        name: "catch _onGenerateCodeEtatLieuxEvent",
      );
      emit(state.copyWith(isLoading: false, codeGenerated: false));
      showToast(
        msg: "Erreur lors de la génération du code",
        type: ToastificationType.error,
      );
      if (kDebugMode) rethrow;
    }
  }

  FutureOr<void> _onVerifyCodeEtatLieuxEvent(
    VerifyCodeEtatLieuxEvent event,
    Emitter<InventoriesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, codeVerified: null));
    try {
      final request = VerifyCodeEtatLieuxRequest(
        locataireId: event.locataireId,
        verificationCode: event.verificationCode,
      );
      final result = await _service.verifyCodeEtatLieux(request);
      if (result.success) {
        emit(state.copyWith(isLoading: false, codeVerified: true));
        showToast(
          msg: "Code vérifié avec succès",
          type: ToastificationType.success,
        );
      } else {
        emit(state.copyWith(isLoading: false, codeVerified: false));
        showToast(
          msg: result.message ?? "Code invalide",
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      console.log(
        "ERROR:: ${e.toString()}",
        name: "catch _onVerifyCodeEtatLieuxEvent",
      );
      emit(state.copyWith(isLoading: false, codeVerified: false));
      showToast(
        msg: "Erreur lors de la vérification du code",
        type: ToastificationType.error,
      );
      if (kDebugMode) rethrow;
    }
  }

  FutureOr<void> _onSaveEstateLocationEvent(
    SaveEstateLocationEvent event,
    Emitter<InventoriesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, estateLocationSaved: null));
    try {
      final result = await _service.saveEstateLocation(event.request);
      if (result.success) {
        emit(state.copyWith(isLoading: false, estateLocationSaved: true));
        showToast(
          msg: "État des lieux enregistré avec succès",
          type: ToastificationType.success,
        );
      } else {
        emit(state.copyWith(isLoading: false, estateLocationSaved: false));
        showToast(
          msg: result.message ?? "Échec de l'enregistrement",
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      console.log(
        "ERROR:: ${e.toString()}",
        name: "catch _onSaveEstateLocationEvent",
      );
      emit(state.copyWith(isLoading: false, estateLocationSaved: false));
      showToast(
        msg: "Erreur lors de l'enregistrement",
        type: ToastificationType.error,
      );
      if (kDebugMode) rethrow;
    }
  }
}
