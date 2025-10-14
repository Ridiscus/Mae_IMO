part of 'index.dart';

class ComptableInfoModel {
  final int id;
  final String name;
  final String email;
  final String contact;

  ComptableInfoModel({
    required this.id,
    required this.name,
    required this.email,
    required this.contact,
  });

  factory ComptableInfoModel.fromJson(Map<String, dynamic> json) {
    return ComptableInfoModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      contact: json['contact'] ?? '',
    );
  }


  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'contact': contact,
  };
}
