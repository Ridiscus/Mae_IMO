part of 'index.dart';

extension CinetpayDataExt on CinetpayData {
  get configData => <String, dynamic>{
    'apikey': apiKey,
    'site_id': siteId,
    'notify_url': notifyUrl,
  };

  get paymentData => <String, dynamic>{
    'transaction_id': transactionId,
    'amount': amount,
    'currency': currency,
    'channels': channels,
    'description': description,
    "customer_name": customerName,
    "customer_surname": customerSurname,
    "customer_phone_number": customerPhoneNumber,
    "metadata": metadata?.toMap().toString(),
  };
}
