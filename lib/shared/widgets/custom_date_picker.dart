part of 'index.dart';

/// Un widget de sélection de date personnalisé qui respecte le design de maelys_imo
/// avec le même style visuel que les CustomInputText
class CustomDatePicker extends StatelessWidget {
  /// La date actuellement sélectionnée
  final String displayText;
  
  /// Fonction appelée quand une date est sélectionnée
  final Function(DateTime) onDateSelected;
  
  /// Date initiale à afficher dans le picker
  final DateTime? initialDate;
  
  /// Date minimale sélectionnable
  final DateTime? firstDate;
  
  /// Date maximale sélectionnable
  final DateTime? lastDate;
  
  /// Le texte indicatif quand aucune date n'est sélectionnée
  final String? hintText;
  
  /// Le texte d'étiquette (label) pour le sélecteur
  final String? labelText;
  
  /// Si le sélecteur doit prendre toute la largeur disponible
  final bool isExpanded;

  /// Crée un [CustomDatePicker] avec le style de l'application.
  const CustomDatePicker({
    super.key,
    required this.displayText,
    required this.onDateSelected,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.hintText,
    this.labelText,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showDatePicker(context),
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        width: isExpanded ? double.infinity : null,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: Colors.black.withValues(alpha: .1),
            width: 1.w,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (labelText != null) ...[
              Text(
                labelText!,
                style: GoogleFonts.sourceSans3(
                  fontSize: 12.sp,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 4.h),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  displayText,
                  style: GoogleFonts.sourceSans3(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.grey[600],
                  size: 20.r,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Affiche le sélecteur de date natif
  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: firstDate ?? DateTime(now.year - 10),
      lastDate: lastDate ?? DateTime(now.year + 10),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light().copyWith(
              primary: AppColors.primary,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    ) ?? (initialDate ?? now);
    
    onDateSelected(selected);
  }
}

/// Fabrique pour créer des CustomDatePicker
class CustomDatePickerFactory {
  /// Crée un sélecteur de date avec le style standard de l'application
  static Widget createDatePicker({
    required String displayText,
    required Function(DateTime) onDateSelected,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String? hintText,
    String? labelText,
    bool isExpanded = true,
  }) {
    return CustomDatePicker(
      displayText: displayText,
      onDateSelected: onDateSelected,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      hintText: hintText,
      labelText: labelText,
      isExpanded: isExpanded,
    );
  }
}
