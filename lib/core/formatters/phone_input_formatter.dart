import 'package:flutter/services.dart';

class PhoneNumberFormatter extends TextInputFormatter {
 @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    // Supprimer les espaces existants
    newText = newText.replaceAll(' ', '');

    // Ne traiter que les dix premiers chiffres
    String firstTenDigits = newText.substring(0, newText.length > 10 ? 10 : newText.length);
    String remainingText = newText.length > 10 ? newText.substring(10) : '';

    // Ajouter un espace tous les deux chiffres dans les dix premiers chiffres
    String formattedText = '';
    for (int i = 0; i < firstTenDigits.length; i++) {
      if (i > 0 && i % 2 == 0) {
        formattedText += ' ';
      }
      formattedText += firstTenDigits[i];
    }

    // Ajouter les caractères restants après les dix chiffres sans modification
    formattedText += remainingText;

    // Retourner la valeur formatée en conservant la position du curseur
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(
        offset: formattedText.length,
      ),
    );
  }
}