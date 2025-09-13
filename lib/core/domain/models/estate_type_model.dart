part of 'index.dart';

class EstateTypeModel {
  final int? id;
  final String? type;

  EstateTypeModel({this.id, this.type});

  EstateTypeModel copyWith({int? id, String? type}) =>
      EstateTypeModel(id: id ?? this.id, type: type ?? this.type);

  factory EstateTypeModel.fromJson(String str) =>
      EstateTypeModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EstateTypeModel.fromMap(Map<String, dynamic> json) =>
      EstateTypeModel(id: json["id"], type: json["type"]);

  Map<String, dynamic> toMap() => {"id": id, "type": type};
}
