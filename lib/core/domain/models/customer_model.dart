part of 'index.dart';

class CustomerModel {
  final String? id;

  CustomerModel copyWith({String? id}) => CustomerModel(id: id ?? this.id);

  factory CustomerModel.fromJson(String str) =>
      CustomerModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CustomerModel.fromMap(Map<String, dynamic> json) =>
      CustomerModel(id: json["id"]);

  CustomerModel({required this.id});

  Map<String, dynamic> toMap() => {"id": id};
}
