part of 'payment_bloc.dart';

class PaymentState extends Equatable {
  final List<PaymentHistoryModel>? paymentHistoryModel;
  final CinetpayData? cinetpayData;
  final bool isLoading;
  final bool? paymentSuccess;
  final Failure? failure;

  const PaymentState({
    this.paymentHistoryModel,
    this.cinetpayData,
    this.isLoading = false,
    this.paymentSuccess,
    this.failure,
  });

  PaymentState copyWith({
    List<PaymentHistoryModel>? paymentHistoryModel,
    CinetpayData? cinetpayData,
    bool? isLoading,
    bool? paymentSuccess,
    Failure? failure,
  }) => PaymentState(
    isLoading: isLoading ?? this.isLoading,
    paymentSuccess: paymentSuccess,
    cinetpayData: cinetpayData,
    failure: failure,
    paymentHistoryModel: paymentHistoryModel ?? this.paymentHistoryModel,
  );

  factory PaymentState.fromJson(Map<String, dynamic> json) {
    return PaymentState(
      paymentHistoryModel:
          json['paymentHistoryModel'] != null
              ? (json['paymentHistoryModel'] as List)
                  .map((e) => PaymentHistoryModel.fromJson(e))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentHistoryModel':
          paymentHistoryModel?.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [isLoading, paymentSuccess, failure, paymentHistoryModel, cinetpayData];
}

final class PaymentInitial extends PaymentState {
  @override
  List<Object> get props => [];
}
