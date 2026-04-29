class Endpoints {
  static const String baseUrl = "https://maelysimo.com/api";
  static const String estateType = "/biens/all";
  static const String estatesAvailable = "/biens/available";

  static String estatesDetail(int id) => "/biens/$id";
  static String sendVisiteEstates = "/visit/store";
  static const String login = "/login";
  static const String tenantDashboard = "/tenant/dashboard";
  static const String contactAgency = "/tenant/contact/agency";

  static const String updateEmail = "/tenant/profile/update-email";
  static const String updatePassword = "/tenant/profile/update-password";
  static const String updateProfileImage = "/tenant/profile/photo";
  static const String forgotPassword = "/password/forgot";
  static const String resetPassword = "/password/reset";

  static String agentDashboard = "/agent/dashboard";
  static String commercialDashboard = "/commercial/dashboard";
  static String commercialAgences = "/commercial/agences";
  static String commercialAgencyProperties(String agenceId) =>
      "/commercial/agences/$agenceId/biens";
  static String commercialOwnerProperties(String ownerId) =>
      "/commercial/proprietaires/$ownerId/biens";
  static String commercialOwners = "/commercial/proprietaires";
  static String commercialProperties = "/commercial/biens";
  static String updateProperty(dynamic id) => "/commercial/biens/$id/update";
  static String updateAgency(dynamic id) => "/commercial/agences/$id/update";
  static String updateOwner(dynamic id) =>
      "/commercial/proprietaires/$id/update";

  static String deleteProperty(dynamic id) => "/commercial/biens/$id";
  static String deleteOwner(dynamic id) => "/commercial/proprietaires/$id";
  static String deleteAgency(dynamic id) => "/commercial/agences/$id";

  static String inventories = "/agent/etats-lieu/warning";

  static String inventoriesShow(String id) => "/agent/etats-lieu/$id/details";
  static String tenantByStatus(String status) => "/agent/locataires/$status";
  static String paymentsHistory(int tenantId) => "/tenant/$tenantId/paiements";
  static String makePayment(int tenantId) => "/tenant/$tenantId/paiements";
  static String showDetailTenant(dynamic id) => "/agent/locataire/$id/details";

  static const String generateCashCode = "/agent/paiement/generer-code-especes";
  static const String validateCashCode = "/paiement/verifier-code-especes";
  static const String generateCodeEtatLieux = "/agent/generate";
  static const String verifyCodeEtatLieux = "/agent/verify";
  static const String saveEstateLocation = "/agent/etat-lieux";
  static const String tenantPropertyInspections = "/tenant/etat-lieu/all";

  // Url de stockage des fichiers
  static String storageUrl(String? path) {
    if (path == null || path.isEmpty) return "";
    if (path.startsWith('http')) return path;
    const String storageURL = "https://maelysimo.com/storage/";
    return "$storageURL${path.startsWith('/') ? path.substring(1) : path}";
  }
}
