import 'package:flutter/material.dart' show protected;

/// Classe utilitaire qui fournit des valeurs de dimensionnement standardisées pour l'application.
/// Permettant d'avoir des espaces uniformes dans l'application
/// Cela inclut les valeurs de padding, de border radius et d'espacement.
class AppSize {

  static const AppPadding padding = AppPadding();

  static const AppRadius radius = AppRadius();

  static const AppSpacing spacing = AppSpacing();
}

/// Définit un ensemble de valeurs de padding standard pour un espacement UI cohérent.
@protected
class AppPadding {
  const AppPadding();

  final double sm = 2;
  final double md = 5;
  final double lg = 6;
  final double xl = 8;
}

/// Définit un ensemble de valeurs de border radius standard pour des coins UI cohérents.
@protected
class AppRadius {
  const AppRadius();

  final double sm = 12;
  final double md = 14;
  final double lg = 16;
  final double xl = 20;
}

/// Définit un ensemble de valeurs d'espacement standard pour des écarts cohérents entre les éléments UI.
@protected
class AppSpacing {
  const AppSpacing();

  final double sm = 0.5;
  final double md = 1.5;
  final double lg = 4;
  final double xl = 6;
}
