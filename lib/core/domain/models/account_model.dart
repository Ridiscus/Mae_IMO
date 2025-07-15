part of 'index.dart';

class AccountModel {
  final String? id;

  AccountModel({this.id});

  AccountModel copyWith({String? id}) => AccountModel(id: id ?? this.id);

  factory AccountModel.fromJson(String str) =>
      AccountModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AccountModel.fromMap(Map<String, dynamic> json) =>
      AccountModel(id: json["id"]);

  Map<String, dynamic> toMap() => {"id": id};
}
