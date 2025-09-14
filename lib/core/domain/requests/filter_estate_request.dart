part of 'index.dart';

class FilterEstateRequest extends Dto {
  final String? type;
  final String? commune;
  final int? prixMax;
  final int? perPage;

  FilterEstateRequest({
    this.type,
    this.commune,
    this.prixMax,
    this.perPage = 70,
  });

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      "type": type,
      "commune": commune,
      "prix_max": prixMax,
      "per_page": perPage,
    };

    json.removeWhere(
      (key, value) => value == null || value.toString().trim().isEmpty,
    );
    return json;
  }
}
