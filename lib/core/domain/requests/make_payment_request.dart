part of 'index.dart';

class MakePaymentRequest extends Dto {
  final String moisCouvert;
  final String methodePaiement;
  final String? transactionId;
  final MultipartFile? proofFile;

  MakePaymentRequest({
    required this.moisCouvert,
    required this.methodePaiement,
    this.transactionId,
    this.proofFile,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'mois_couvert': moisCouvert,
      'methode_paiement': methodePaiement,
    };

    if (transactionId != null) {
      data['transaction_id'] = transactionId!;
    }

    if (proofFile != null) {
      data['proof_file'] = proofFile!.clone();
    }

    return data;
  }

  FormData toMultipart() {
    return FormData.fromMap(toJson());
  }
}
