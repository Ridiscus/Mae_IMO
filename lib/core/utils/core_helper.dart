part of 'index.dart';

class CoreHelper {
  static String fullLink(String name) {
    return name.startsWith('http') || name.startsWith('https')
        ? name
        : "https://maelysimo.com/storage/$name";
  }
}
