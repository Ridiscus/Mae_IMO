part of 'index.dart';

/// Un widget de dropdown personnalisé qui respecte le design de maelys_imo
/// avec le même style visuel que les CustomInputText
class CustomDropdown<T> extends StatelessWidget {
  /// La valeur actuellement sélectionnée
  final T value;

  /// La liste des options disponibles
  final List<T> items;

  /// Fonction appelée quand une nouvelle option est sélectionnée
  final void Function(T?) onChanged;

  /// Fonction pour construire les libellés des options
  final String Function(T) itemLabelBuilder;

  /// Le texte indicatif quand aucune option n'est sélectionnée
  final String? hintText;

  /// Le texte d'étiquette (label) pour le dropdown
  final String? labelText;

  /// Si le dropdown doit prendre toute la largeur disponible
  final bool isExpanded;

  /// Crée un [CustomDropdown] avec le style de l'application.
  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.itemLabelBuilder,
    this.hintText,
    this.labelText,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T>(
      width: isExpanded ? MediaQuery.of(context).size.width - 32.w : null,
      initialSelection: value,
      enableFilter: false,
      enableSearch: false,
      leadingIcon: null,
      trailingIcon: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.grey[600],
        size: 24.r,
      ),
      label: labelText != null ? Text(labelText!) : null,
      hintText: hintText,
      textStyle: GoogleFonts.sourceSans3(
        fontSize: 16.sp,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(
          fontSize: 16.sp,
          color: Colors.black38,
          letterSpacing: -.2,
        ),
        labelStyle: GoogleFonts.sourceSans3(
          fontSize: 16.sp,
          color: Colors.black,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r), // Forme très arrondie
          borderSide: BorderSide(
            color: Colors.black.withValues(alpha: .1),
            width: 1.w,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(
            color: Colors.black.withValues(alpha: .1),
            width: 1.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(
            color: Colors.black.withValues(alpha: .1),
            width: 1.w,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: Colors.red, width: 1.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: Colors.red, width: 1.w),
        ),
      ),
      onSelected: onChanged,
      dropdownMenuEntries: items.map<DropdownMenuEntry<T>>((T item) {
        return DropdownMenuEntry<T>(
          value: item,
          label: itemLabelBuilder(item),
          style: ButtonStyle(
            textStyle: MaterialStateProperty.all(
              GoogleFonts.sourceSans3(
                fontSize: 16.r,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Fabrique pour créer des CustomDropdown
class CustomDropdownFactory {
  /// Crée un dropdown avec le style standard de l'application
  static Widget createDropdown<T>({
    required T value,
    required List<T> items,
    required void Function(T?) onChanged,
    required String Function(T) itemLabelBuilder,
    String? hintText,
    String? labelText,
    bool isExpanded = true,
  }) {
    return CustomDropdown<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      itemLabelBuilder: itemLabelBuilder,
      hintText: hintText,
      labelText: labelText,
      isExpanded: isExpanded,
    );
  }
}
