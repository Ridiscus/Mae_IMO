part of 'payment_bloc.dart';

class PaymentState extends Equatable {
  final List<PaymentHistoryModel>? paymentHistoryModel;
  final bool isLoading;
  final bool? paymentSuccess;
  final Failure? failure;

  const PaymentState({
    this.paymentHistoryModel,
    this.isLoading = false,
    this.paymentSuccess,
    this.failure,
  });

  PaymentState copyWith({
    List<PaymentHistoryModel>? paymentHistoryModel,
    bool? isLoading,
    bool? paymentSuccess,
    Failure? failure,
  }) => PaymentState(
    isLoading: isLoading ?? this.isLoading,
    paymentSuccess: paymentSuccess,
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
  List<Object?> get props => [isLoading, paymentSuccess, failure, paymentHistoryModel];
}

final class PaymentInitial extends PaymentState {
  @override
  List<Object> get props => [];
}
