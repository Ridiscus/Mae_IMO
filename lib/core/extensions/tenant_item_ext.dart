part of 'index.dart';

extension TenantItemExt on TenantItemModel {

  String get title => [typeBien, communeBien].join(' / ').trim();
  String get fullName => "${nom ?? ''} ${prenom ?? ''}";
}
