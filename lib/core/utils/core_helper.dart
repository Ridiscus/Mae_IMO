part of 'index.dart';

class CoreHelper {
  static String fullLink(String? name) {
    if (name == null) return '';
    return name.startsWith('http')
        ? name
        : "https://maelysimo.com/storage/$name";
  }

  static Future<bool> launchLink(
    String? link, {
    LaunchMode launchMode = LaunchMode.platformDefault,
    bool showTitle = false,
    Map<String, String> headers = const {},
  }) {
    try {
      return launchUrl(
        Uri.parse(link ?? ""),
        browserConfiguration: BrowserConfiguration(showTitle: showTitle),
        mode: launchMode,
        webViewConfiguration: WebViewConfiguration(
          enableDomStorage: true,
          enableJavaScript: true,
          headers: headers,
        ),
      );
    } catch (e) {
      showToast(msg: "Impossible de lancé le lien !");
      return Future.value(false);
    }
  }
}
