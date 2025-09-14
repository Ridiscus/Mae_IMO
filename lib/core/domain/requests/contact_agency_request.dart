part of 'index.dart';

class ContactAgencyRequest extends Dto {
  final String subject;
  final String message;
  final String agencyEmail;

  ContactAgencyRequest({
    required this.subject,
    required this.message,
    required this.agencyEmail,
  });

  @override
  Map<String, dynamic> toJson() => {
    "subject": this.subject,
    "message": this.message,
    "agency_email": this.agencyEmail,
  };
}
