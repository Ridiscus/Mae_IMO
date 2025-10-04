import 'dart:async';
import 'dart:developer' as console;

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:maelys_imo/core/domain/models/index.dart';
import 'package:maelys_imo/core/services/payment_service.dart';
import 'package:maelys_imo/core/utils/index.dart';
import 'package:maelys_imo/core/utils/toast/notification_toast.dart';
import 'package:toastification/toastification.dart';

import '../../../domain/requests/index.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends HydratedBloc<PaymentEvent, PaymentState> {
  final PaymentService _service;

  PaymentBloc({required PaymentService service})
    : _service = service,
      super(PaymentInitial()) {
    on<FetchHistoryPaymentEvent>(_onFetchHistoryPaymentEvent);
    on<MakePaymentEvent>(_onMakePaymentEvent);
  }

  FutureOr<void> _onFetchHistoryPaymentEvent(
    FetchHistoryPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _service.paymentHistory(tenantId: event.tenantId);
      if (result.success) {
        emit(
          state.copyWith(isLoading: false, paymentHistoryModel: result.data),
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
      console.log(
        "ERROR:: ${e.toString()}",
        name: "catch _onFetchHistoryPaymentEvent",
      );
      emit(state.copyWith(isLoading: false));

      if (kDebugMode) {
        rethrow;
      }
    }
  }

  Future<void> _onMakePaymentEvent(
    MakePaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _service.makePayment(
        tenantId: event.tenantId,
        request: event.dto,
      );
      if (result.success) {
        if (result.data != null) {
          emit(
            state.copyWith(
              isLoading: false,
              paymentSuccess: true,
              cinetpayData: result.data?.cinetpayData,
              initPaymentModel: result.data,
            ),
          );
        }

        if (result.data?.paiement != null) {
          showToast(
            msg: result.message ?? 'Paiement effectué avec succès',
            type: ToastificationType.success,
          );
          emit(state.copyWith(isLoading: false, paymentSuccess: true));
          add(FetchHistoryPaymentEvent(tenantId: event.tenantId));
        }
      } else {
        showToast(msg: result.message!);
        emit(
          state.copyWith(
            isLoading: false,
            paymentSuccess: false,
            failure: Failure(message: result.message!),
          ),
        );
      }
    } catch (e) {
      console.log("ERROR:: ${e.toString()}", name: "catch _onMakePaymentEvent");
      showToast(msg: 'Erreur lors du paiement');
      emit(state.copyWith(isLoading: false, paymentSuccess: false));

      if (kDebugMode) {
        rethrow;
      }
    }
  }

  @override
  PaymentState? fromJson(Map<String, dynamic> json) {
    return PaymentState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(PaymentState state) {
    return state.toJson();
  }
}
