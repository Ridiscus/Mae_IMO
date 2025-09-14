part of 'payment_bloc.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();
}

class FetchHistoryPaymentEvent extends PaymentEvent {
  final int tenantId;

  const FetchHistoryPaymentEvent({required this.tenantId});

  @override
  List<Object?> get props => [tenantId];
}

final class MakePaymentEvent extends PaymentEvent {
  final int tenantId;
  final MakePaymentRequest dto;

  const MakePaymentEvent({
    required this.tenantId,
    required this.dto,
  });

  @override
  List<Object> get props => [tenantId, dto];
}
