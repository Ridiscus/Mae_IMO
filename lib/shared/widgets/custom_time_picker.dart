part of 'index.dart';

/// Un widget de sélection d'heure personnalisé qui respecte le design de maelys_imo
/// avec le même style visuel que les CustomInputText et CustomDatePicker
class CustomTimePicker extends StatelessWidget {
  /// L'heure actuellement sélectionnée à afficher
  final String displayText;

  /// Fonction appelée quand une heure est sélectionnée
  final Function(TimeOfDay) onTimeSelected;

  /// Heure initiale à afficher dans le picker
  final TimeOfDay? initialTime;

  /// Le texte indicatif quand aucune heure n'est sélectionnée
  final String? hintText;

  /// Le texte d'étiquette (label) pour le sélecteur
  final String? labelText;

  /// Si le sélecteur doit prendre toute la largeur disponible
  final bool isExpanded;

  /// Crée un [CustomTimePicker] avec le style de l'application.
  const CustomTimePicker({
    super.key,
    required this.displayText,
    required this.onTimeSelected,
    this.initialTime,
    this.hintText,
    this.labelText,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showTimePicker(context),
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
                  displayText.isEmpty
                      ? (hintText ?? 'Sélectionnez une heure')
                      : displayText,
                  style: GoogleFonts.sourceSans3(
                    fontSize: 16.sp,
                    color:
                        displayText.isEmpty ? Colors.grey[600] : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.access_time_outlined,
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

  /// Affiche le sélecteur d'heure natif
  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay now = TimeOfDay.now();
    final TimeOfDay? selected = await showTimePicker(
      context: context,

      initialTime: initialTime ?? now,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light().copyWith(
              primary: AppColors.primary,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (selected != null) {
      onTimeSelected(selected);
    }
  }
}

/// Fabrique pour créer des CustomTimePicker
class CustomTimePickerFactory {
  /// Crée un sélecteur d'heure avec le style standard de l'application
  static Widget createTimePicker({
    required String displayText,
    required Function(TimeOfDay) onTimeSelected,
    TimeOfDay? initialTime,
    String? hintText,
    String? labelText,
    bool isExpanded = true,
  }) {
    return CustomTimePicker(
      displayText: displayText,
      onTimeSelected: onTimeSelected,
      initialTime: initialTime,
      hintText: hintText,
      labelText: labelText,
      isExpanded: isExpanded,
    );
  }

  /// Formate un TimeOfDay en string lisible
  static String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
