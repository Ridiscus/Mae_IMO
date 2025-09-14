part of 'index.dart';

class CoreHelper {
  static String fullLink(String? name) {
    if (name == null) return '';
    return name.startsWith('http')
        ? name
        : "https://maelysimo.com/storage/$name";
  }

  static Future<bool> launchLink(String? link) {
    try {
      return launchUrl(Uri.parse(link ?? ""));
    } catch (e) {
      showToast(msg: "Impossible de lancé le lien !");
      return Future.value(false);
    }
  }
}
