part of 'index.dart';

class DocumentModel {
  final String text;
  final String link;
  final String? iconData;

  DocumentModel({
    required this.text,
    required this.link,
    this.iconData,
  });

}

