part of 'payment_bloc.dart';

class PaymentState extends Equatable {
  final List<PaymentHistoryModel>? paymentHistoryModel;
  final bool isLoading;
  final Failure? failure;

  const PaymentState({
    this.paymentHistoryModel,
    this.isLoading = false,
    this.failure,
  });

  const PaymentState.loading() : this(isLoading: true);

  PaymentState copyWith({
    List<PaymentHistoryModel>? paymentHistoryModel,
    bool? isLoading,
    Failure? failure,
  }) => PaymentState(
    isLoading: isLoading ?? this.isLoading,
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
  List<Object?> get props => [isLoading, paymentHistoryModel];
}

final class PaymentInitial extends PaymentState {
  @override
  List<Object> get props => [];
}
