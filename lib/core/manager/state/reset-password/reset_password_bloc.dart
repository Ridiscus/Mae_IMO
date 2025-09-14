import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maelys_imo/core/domain/requests/index.dart';
import 'package:maelys_imo/core/services/reset_password_service.dart';
import 'package:maelys_imo/core/utils/toast/notification_toast.dart';
import 'package:toastification/toastification.dart';

import '../../../utils/index.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final ResetPasswordService _service;

  ResetPasswordBloc({
    required ResetPasswordService service,
  }) : _service = service,
      super(ResetPasswordInitial()) {
    on<ForgotPasswordEvent>(_onForgotPasswordEvent);
  }

  Future<void> _onForgotPasswordEvent(
    ForgotPasswordEvent event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _service.forgotPassword(dto: event.dto);
      if (result.success) {
        showToast(
          msg: result.message!,
          type: ToastificationType.success,
        );
        emit(
          state.copyWith(
            isLoading: false,
            emailSent: true,
          ),
        );
      } else {
        showToast(msg: result.message!);
        emit(
          state.copyWith(
            isLoading: false,
            emailSent: false,
            failure: Failure(message: result.message!),
          ),
        );
      }
    } catch (e) {
      showToast(msg: "Erreur lors de l'envoi du lien de réinitialisation");
      emit(state.copyWith(isLoading: false, emailSent: false));
      if (kDebugMode) {
        rethrow;
      }
    }
  }
}
