import 'package:flutter/services.dart';

class MoneyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Si le texte est vide, on retourne tel quel
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // On ne garde que les chiffres
    final cleanText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // On inverse la chaîne pour faciliter l'ajout des espaces
    final reversed = cleanText.split('').reversed.join('');

    // On ajoute un espace tous les 3 chiffres
    final chunks = <String>[];
    for (var i = 0; i < reversed.length; i += 3) {
      final end = i + 3;
      chunks.add(
        reversed.substring(i, end > reversed.length ? reversed.length : end),
      );
    }

    // On reconstruit la chaîne dans le bon sens
    final formatted = chunks.join('.').split('').reversed.join('');

    // On calcule la nouvelle position du curseur
    final newCursorPosition =
        formatted.length - (cleanText.length - newValue.selection.end);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: newCursorPosition.clamp(0, formatted.length),
      ),
    );
  }
}
