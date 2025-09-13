part of 'index.dart';

class CoreHelper {
  static String fullLink(String? name) {
    if(name == null) return '';
    return name.startsWith('http') || name.startsWith('https')
        ? name
        : "https://maelysimo.com/storage/$name";
  }
}
