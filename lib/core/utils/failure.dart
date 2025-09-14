part of 'index.dart';
class Failure {
  final String message;
  final String? code;
  final String? details;

  Failure({required this.message, this.code, this.details});


  factory Failure.fromJson(Map<String, dynamic> json) {
    return Failure(
      message: json['message'] as String,
      code: json['code'] as String?,
      details: json['details'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'code': code,
      'details': details,
    };
  }
}