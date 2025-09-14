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

  static String paymentsHistory(int tenantId) => "/tenant/$tenantId/paiements";
}
