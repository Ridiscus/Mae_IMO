part of 'index.dart';

extension TenantItemExt on TenantItemModel {
  String get fullName => "$name $prenom";
}