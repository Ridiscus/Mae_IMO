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

  /// Le texte d'erreur à afficher
  final String? errorText;

  /// Si le chargement est en cours
  final bool isLoading;

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
    this.errorText,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownMenu<T>(
          width: isExpanded ? MediaQuery.of(context).size.width - 40.w : null,
          initialSelection: value,
          enableFilter: false,
          enableSearch: false,
          leadingIcon: null,
          trailingIcon:
              isLoading
                  ? SizedBox(
                    height: 20.r,
                    width: 20.r,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                  : Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                    size: 24.r,
                  ),
          label: labelText != null ? Text(labelText!) : null,
          hintText: hintText,
          textStyle:
              const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ).sourceSansProSemiBold,
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            hintStyle:
                const TextStyle(
                  fontSize: 16,
                  color: Colors.black38,
                  letterSpacing: -.2,
                ).sourceSansProRegular,
            labelStyle:
                const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ).sourceSansProRegular,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 16.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide(
                color:
                    hasError ? Colors.red : Colors.black.withValues(alpha: .1),
                width: 1.w,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide(
                color:
                    hasError ? Colors.red : Colors.black.withValues(alpha: .1),
                width: 1.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide(
                color:
                    hasError ? Colors.red : Colors.black.withValues(alpha: .1),
                width: 1.w,
              ),
            ),
          ),
          onSelected: onChanged,
          dropdownMenuEntries:
              items.map<DropdownMenuEntry<T>>((T item) {
                return DropdownMenuEntry<T>(
                  value: item,
                  label: itemLabelBuilder(item),
                  style: ButtonStyle(
                    textStyle: WidgetStateProperty.all(
                      const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w400,
                      ).sourceSansProRegular,
                    ),
                  ),
                );
              }).toList(),
        ),
        if (hasError) ...[
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 14.sp),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    errorText!,
                    style:
                        TextStyle(
                          color: Colors.red,
                          fontSize: 12.sp,
                        ).sourceSansProRegular,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
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
    String? errorText,
  }) {
    return CustomDropdown<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      itemLabelBuilder: itemLabelBuilder,
      hintText: hintText,
      labelText: labelText,
      isExpanded: isExpanded,
      errorText: errorText,
    );
  }
}
