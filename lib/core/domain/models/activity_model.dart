part of 'index.dart';

enum ActivityType { agency, owner, property }

class ActivityModel {
  final int id;
  final String codeId;
  final String title;
  final String description;
  final ActivityType type;
  final DateTime date;
  final dynamic relatedObject;

  ActivityModel({
    required this.id,
    required this.codeId,
    required this.title,
    required this.description,
    required this.type,
    required this.date,
    this.relatedObject,
  });

  String get typeLabel {
    switch (type) {
      case ActivityType.agency:
        return 'Agence';
      case ActivityType.owner:
        return 'Propriétaire';
      case ActivityType.property:
        return 'Bien Immobilier';
    }
  }

  IconData get icon {
    switch (type) {
      case ActivityType.agency:
        return Icons.business_outlined;
      case ActivityType.owner:
        return Icons.person_outline;
      case ActivityType.property:
        return Icons.home_work_outlined;
    }
  }
}
