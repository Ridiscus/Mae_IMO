part of 'index.dart';

class SaveEstateLocationRequest extends Dto {
  @override
  Map<String, dynamic> toJson() {
    return {
      "locataire_id": 1,
      "bien_id": 1,
      "type_bien": "Appartement",
      "commune_bien": "Paris 15e",
      "presence_partie": "oui",
      "parties_communes": {
        "sol": "Propre",
        "observation_sol": "Petite rayure près de l'entrée",
        "murs": "Propres",
        "observation_murs": "RAS",
        "plafond": "Propre",
        "observation_plafond": "RAS",
        "porte_entre": "Fonctionnelle",
        "observation_porte_entre": "Serrure un peu dure",
        "interrupteur": "Fonctionnel",
        "observation_interrupteur": "RAS",
        "robinet": "Fonctionnel",
        "observation_robinet": "Petite fuite",
        "lavabo": "Propre",
        "observation_lavabo": "Égratignure sur le bord",
        "douche": "Fonctionnelle",
        "observation_douche": "RAS",
      },
      "chambres": [
        {
          "nom": "Chambre principale",
          "sol": "Propre",
          "observation_sol": "Parquet en bon état",
          "murs": "Propres",
          "observation_murs": "Petite tache près de la fenêtre",
          "plafond": "Propre",
          "observation_plafond": "RAS",
        },
        {
          "nom": "Chambre d'amis",
          "sol": "Propre",
          "observation_sol": "RAS",
          "murs": "Propres",
          "observation_murs": "RAS",
          "plafond": "Propre",
          "observation_plafond": "RAS",
        },
      ],
      "nombre_cle": 2,
    };
  }
}
