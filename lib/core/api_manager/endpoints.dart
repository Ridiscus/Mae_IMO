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
  static String inventories = "/agent/etats-lieu/warning";

  static String inventoriesShow(String id) => "/agent/etats-lieu/$id/details";

  static String tenantByStatus(String status) => "/agent/locataires/$status";

  static String paymentsHistory(int tenantId) => "/tenant/$tenantId/paiements";

  static String makePayment(int tenantId) => "/tenant/$tenantId/paiements";

  static String showDetailTenant(dynamic id) => "/agent/locataire/$id/details";

  static const String generateCashCode = "/agent/paiement/generer-code-especes";
  static const String validateCashCode = "/paiement/verifier-code-especes";
}
