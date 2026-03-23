part of 'index.dart';

class CommercialDashboardModel {
  final CommercialModel? commercial;
  final CommercialStatisticsModel? statistics;
  final List<RecentActivityResponseModel>? recentActivities;

  CommercialDashboardModel({
    this.commercial,
    this.statistics,
    this.recentActivities,
  });

  factory CommercialDashboardModel.fromMap(Map<String, dynamic> json) =>
      CommercialDashboardModel(
        commercial:
            json["commercial"] != null
                ? CommercialModel.fromMap(json["commercial"])
                : null,
        statistics:
            json["statistics"] != null
                ? CommercialStatisticsModel.fromMap(json["statistics"])
                : null,
        recentActivities:
            json["recent_activities"] != null
                ? List<RecentActivityResponseModel>.from(
                  json["recent_activities"].map(
                    (x) => RecentActivityResponseModel.fromMap(x),
                  ),
                )
                : null,
      );

  Map<String, dynamic> toMap() => {
    "commercial": commercial?.toMap(),
    "statistics": statistics?.toMap(),
    "recent_activities":
        recentActivities != null
            ? List<dynamic>.from(recentActivities!.map((x) => x.toMap()))
            : null,
  };
}

class CommercialStatisticsModel {
  final int totalAgences;
  final int totalProprietaires;
  final int totalBiens;

  CommercialStatisticsModel({
    required this.totalAgences,
    required this.totalProprietaires,
    required this.totalBiens,
  });

  factory CommercialStatisticsModel.fromMap(Map<String, dynamic> json) =>
      CommercialStatisticsModel(
        totalAgences: json["total_agences"] ?? 0,
        totalProprietaires: json["total_proprietaires"] ?? 0,
        totalBiens: json["total_biens"] ?? 0,
      );

  Map<String, dynamic> toMap() => {
    "total_agences": totalAgences,
    "total_proprietaires": totalProprietaires,
    "total_biens": totalBiens,
  };
}

class RecentActivityResponseModel {
  final String type;
  final String name;
  final String description;
  final String date;
  final String rawDate;
  final String status;
  final String? createdAt;
  final String? updatedAt;

  RecentActivityResponseModel({
    required this.type,
    required this.name,
    required this.description,
    required this.date,
    required this.rawDate,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory RecentActivityResponseModel.fromMap(Map<String, dynamic> json) =>
      RecentActivityResponseModel(
        type: json["type"] ?? "",
        name: json["name"] ?? "",
        description: json["description"] ?? "",
        date: json["date"] ?? "",
        rawDate: json["raw_date"] ?? "",
        status: json["status"] ?? "",
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toMap() => {
    "type": type,
    "name": name,
    "description": description,
    "date": date,
    "raw_date": rawDate,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };

  ActivityModel toActivityModel() {
    String richTitle = name;
    if (type.toLowerCase().contains('agence')) {
      richTitle = "Agence: $name";
    } else if (type.toLowerCase().contains('propriétaire')) {
      richTitle = "Propriétaire: $name";
    } else if (type.toLowerCase().contains('bien') ||
        type.toLowerCase().contains('immobilier')) {
      richTitle = "Bien: $name";
    }

    String richDescription = description;
    final created = DateTime.tryParse(createdAt ?? "");
    final updated = DateTime.tryParse(updatedAt ?? "");

    bool isModified = false;
    if (created != null && updated != null) {
      if (updated.isAfter(created)) {
        isModified = true;
      }
    }

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    bool isToday = rawDate.startsWith(today);

    if (isModified) {
      richDescription =
          "Les informations ont été modifiées" + (isToday ? " aujourd'hui" : "");
    } else {
      String wording = "Nouveau $type ajouté";
      if (type.toLowerCase().contains('agence')) {
        wording = "Nouvelle agence ajoutée";
      } else if (type.toLowerCase().contains('propriétaire')) {
        wording = "Nouveau propriétaire ajouté";
      } else if (type.toLowerCase().contains('bien')) {
        wording = "Nouveau bien ajouté";
      }
      richDescription = wording + (isToday ? " aujourd'hui" : "");
    }

    return ActivityModel(
      id: 0,
      codeId: "",
      title: richTitle,
      description: richDescription,
      type: activityType,
      date: DateTime.tryParse(rawDate) ?? DateTime.now(),
    );
  }

  ActivityType get activityType {
    switch (type.toLowerCase()) {
      case 'agence':
        return ActivityType.agency;
      case 'propriétaire':
      case 'proprietaire':
        return ActivityType.owner;
      case 'bien':
      case 'bien immobilier':
      case 'immobilier':
        return ActivityType.property;
      default:
        return ActivityType.agency;
    }
  }

  IconData get icon {
    switch (activityType) {
      case ActivityType.agency:
        return Icons.business_outlined;
      case ActivityType.owner:
        return Icons.person_outline;
      case ActivityType.property:
        return Icons.home_work_outlined;
    }
  }
}
