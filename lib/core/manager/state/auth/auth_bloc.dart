import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:maelys_imo/core/services/auth_service.dart';
import 'package:toastification/toastification.dart';

import '../../../domain/models/index.dart';
import '../../../domain/requests/index.dart';
import '../../../utils/index.dart';
import '../../../utils/toast/notification_toast.dart';
import '../../token_manager.dart';

part 'auth_event.dart';
part 'auth_state.dart';

final String TAG = "AuthBloc";

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  final AuthService _service;

  AuthBloc({required AuthService service})
    : _service = service,
      super(AuthInitial()) {
    on<UserSignInEvent>(_onUserSignIn);
    on<UpdateEmailEvent>(_onUpdateEmailEvent);
    on<UpdatePasswordEvent>(_onUpdatePasswordEvent);
    on<LogoutEvent>(_onLogout);
    on<UpdateProfileImagEvent>(_onUpdateProfileImagEvent);
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    return AuthState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return state.toJson();
  }

  FutureOr<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    // Réinitialiser l'état à son état initial (sans utilisateur connecté)
    emit(AuthInitial());
    TokenManager().removeUserToken();
    showToast(
      msg: "Vous avez été déconnecté ! à bientôt",
      type: ToastificationType.success,
    );
  }

  Future<void> _onUserSignIn(
    UserSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, failure: null));
    try {
      final result = await _service.signIn(dto: event.dto);
      if (result.success) {
        emit(state.copyWith(isLoading: false, userModel: result.data));
      } else {
        showToast(msg: result.message ?? "Connexion échouée");
        emit(
          state.copyWith(
            isLoading: false,
            failure: Failure(message: result.message!),
          ),
        );
      }
    } catch (e) {
      showToast(msg: "Connexion échouée");
      emit(state.copyWith(isLoading: false, failure: null));
      if (kDebugMode) {
        rethrow;
      }
    }
  }

  Future<void> _onUpdateEmailEvent(
    UpdateEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _service.updateEmail(dto: event.dto);
      if (result.success) {
        showToast(msg: result.message!, type: ToastificationType.success);

        emit(
          state.copyWith(
            isLoading: false,
            updatedEmail: true,
            userModel: state.userModel!.asTenant()!.copyWith(
              email: result.data,
            ),
          ),
        );
      } else {
        showToast(msg: result.message!);
        emit(
          state.copyWith(
            isLoading: false,
            updatedEmail: false,
            failure: Failure(message: result.message!),
          ),
        );
      }
    } catch (e) {
      showToast(msg: "Echèc de la mise à jour de l'email");
      emit(state.copyWith(isLoading: false, updatedEmail: false));
      if (kDebugMode) {
        rethrow;
      }
    }
  }

  Future<void> _onUpdatePasswordEvent(
    UpdatePasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _service.updatePassword(dto: event.dto);
      if (result.success) {
        showToast(msg: result.message!, type: ToastificationType.success);
        emit(state.copyWith(isLoading: false, updatedPassword: true));
      } else {
        showToast(msg: result.message!);
        emit(
          state.copyWith(
            isLoading: false,
            updatedPassword: false,
            failure: Failure(message: result.message!),
          ),
        );
      }
    } catch (e) {
      showToast(msg: "Echèc de la mise à jour du mot de passe");
      emit(state.copyWith(isLoading: false, updatedPassword: false));
      if (kDebugMode) {
        rethrow;
      }
    }
  }

  FutureOr<void> _onUpdateProfileImagEvent(
    UpdateProfileImagEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _service.updateProfileImage(dto: event.dto);
      if (result.success) {
        showToast(msg: result.message!, type: ToastificationType.success);
        emit(
          state.copyWith(
            isLoading: false,
            updatedImage: true,
            userModel: state.userModel!.asTenant()!.copyWith(
              profileImage: result.data,
            ),
          ),
        );
      } else {
        showToast(msg: result.message!);
        emit(
          state.copyWith(
            isLoading: false,
            updatedImage: false,
            failure: Failure(message: result.message!),
          ),
        );
      }
    } catch (e) {
      showToast(msg: "Echèc de la mise à jour photo de profil");
      emit(state.copyWith(isLoading: false, updatedImage: false));
      if (kDebugMode) {
        rethrow;
      }
    }
  }
}
