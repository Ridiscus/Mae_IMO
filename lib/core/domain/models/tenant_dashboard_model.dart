part of 'index.dart';

class TenantDashboardModel {
  final TenantModel? locataire;
  final dynamic qrCode;

  TenantDashboardModel({this.locataire, this.qrCode});

  TenantDashboardModel copyWith({TenantModel? locataire, dynamic qrCode}) =>
      TenantDashboardModel(
        locataire: locataire ?? this.locataire,
        qrCode: qrCode ?? this.qrCode,
      );

  factory TenantDashboardModel.fromJson(String str) =>
      TenantDashboardModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TenantDashboardModel.fromMap(Map<String, dynamic> json) =>
      TenantDashboardModel(
        locataire:
            json["locataire"] == null
                ? null
                : TenantModel.fromMap(json["locataire"]),
        qrCode: json["qr_code"],
      );

  Map<String, dynamic> toMap() => {
    "locataire": locataire?.toMap(),
    "qr_code": qrCode,
  };
}

