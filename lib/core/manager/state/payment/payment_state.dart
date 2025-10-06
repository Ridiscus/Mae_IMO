part of 'payment_bloc.dart';

class PaymentState extends Equatable {
  final List<PaymentHistoryModel>? paymentHistoryModel;
  final CinetpayData? cinetpayData;
  final InitPaymentModel? initPaymentModel;
  final bool isLoading;
  final bool? paymentSuccess;
  final Failure? failure;
  final String? generatedCode;
  final bool? codeGenerated;
  final bool? codeValidated;
  final DateTime? lastCodeGenerationTime;

  const PaymentState({
    this.paymentHistoryModel,
    this.cinetpayData,
    this.isLoading = false,
    this.paymentSuccess,
    this.initPaymentModel,
    this.failure,
    this.generatedCode,
    this.codeGenerated,
    this.codeValidated,
    this.lastCodeGenerationTime,
  });

  PaymentState copyWith({
    List<PaymentHistoryModel>? paymentHistoryModel,
    CinetpayData? cinetpayData,
    bool? isLoading,
    bool? paymentSuccess,
    InitPaymentModel? initPaymentModel,
    Failure? failure,
    String? generatedCode,
    bool? codeGenerated,
    bool? codeValidated,
    DateTime? lastCodeGenerationTime,
  }) => PaymentState(
    isLoading: isLoading ?? this.isLoading,
    paymentSuccess: paymentSuccess,
    initPaymentModel: initPaymentModel,
    cinetpayData: cinetpayData,
    failure: failure,
    paymentHistoryModel: paymentHistoryModel ?? this.paymentHistoryModel,
    generatedCode: generatedCode,
    codeGenerated: codeGenerated,
    codeValidated: codeValidated,
    lastCodeGenerationTime: lastCodeGenerationTime,
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
  List<Object?> get props => [
    isLoading, 
    paymentSuccess, 
    failure, 
    paymentHistoryModel, 
    cinetpayData, 
    initPaymentModel,
    generatedCode,
    codeGenerated,
    codeValidated,
    lastCodeGenerationTime,
  ];
}

final class PaymentInitial extends PaymentState {
  @override
  List<Object> get props => [];
}
