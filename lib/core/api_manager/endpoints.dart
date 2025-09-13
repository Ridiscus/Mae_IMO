class Endpoints {
  static const String baseUrl = "https://maelysimo.com/api";
  static const String estateType = "/biens/all";
  static const String estatesAvailable = "/biens/available";
  static  String estatesDetail(int id) => "/biens/$id";
  static String sendVisiteEstates = "/visit/store";

  static const String profile = "/users/profile";
  static const String login = "/auth/login";
  static String register = "/auth/client/register";


}
