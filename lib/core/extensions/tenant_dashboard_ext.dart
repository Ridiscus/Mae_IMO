part of 'index.dart';


extension TenantDashboardModelExt on TenantDashboardModel {
  List<DocumentModel> get documents {
    final List<DocumentModel> documents = [];
    if (locataire?.contrat != null) {
      documents.add(DocumentModel(text: 'Contrat de bail', link: CoreHelper.fullLink(locataire?.contrat)));
    }

    if (locataire?.piece != null) {
      documents.add(DocumentModel(text: 'Ma Pièce', link: CoreHelper.fullLink(locataire?.piece)));
    }

    if (locataire?.agency?.rib != null) {
      documents.add(DocumentModel(text: "RIB de l'agence", link: CoreHelper.fullLink(locataire?.agency?.rib)));
    }

    return documents;
  }

}
