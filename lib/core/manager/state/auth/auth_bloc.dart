import 'dart:async';

import 'package:equatable/equatable.dart';
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

    on<LogoutEvent>(_onLogout);
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
    emit(state.copyWith(loading: true, failure: null));
    try {
      final result = await _service.signIn(dto: event.dto);
      if (result.success) {
        emit(state.copyWith(loading: false));
      } else {
        showToast(msg: result.message ?? "");
        emit(
          state.copyWith(
            loading: false,
            failure: Failure(message: result.message!),
          ),
        );
      }
    } catch (e) {
      showToast(msg: "Connexion échouée");
      emit(state.copyWith(loading: false, failure: null));
    }
  }
}
