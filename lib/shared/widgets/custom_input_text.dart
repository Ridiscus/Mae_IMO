part of 'index.dart';

/// Un widget de champ de texte personnalisé qui respecte le design de maelys_imo
class CustomInputText extends StatelessWidget {
  /// Le contrôleur du champ de texte
  final TextEditingController? controller;

  /// Le texte indicatif quand le champ est vide
  final String? hintText;

  /// Le texte d'étiquette (label) pour le champ
  final String? labelText;

  /// L'icône à afficher sur la gauche du champ
  final IconData? prefixIcon;

  /// L'icône à afficher sur la droite du champ
  final IconData? suffixIcon;

  /// La fonction appelée quand on clique sur l'icône de suffixe
  final VoidCallback? onSuffixIconTap;

  /// La fonction appelée quand le contenu du champ change
  final ValueChanged<String>? onChanged;

  /// La fonction appelée quand le champ perd le focus
  final ValueChanged<String>? onSubmitted;

  /// Le type de clavier à afficher
  final TextInputType? keyboardType;

  /// Si le champ est pour un mot de passe (true) ou non (false)
  final bool isPassword;

  /// Si le champ est en lecture seule (true) ou non (false)
  final bool readOnly;

  /// Le validateur pour la validation du champ
  final FormFieldValidator<String>? validator;

  /// Les formateurs de texte pour le champ
  final List<TextInputFormatter>? inputFormatters;

  /// Le nombre maximum de lignes pour le champ
  final int? maxLines;

  /// Si le champ est obligatoire (true) ou non (false)
  final bool isRequired;

  /// Le texte initial du champ
  final String? initialValue;

  /// Si le texte doit être centré (true) ou non (false)
  final bool centerText;

  /// Les actions du clavier
  final TextInputAction? textInputAction;

  /// Le focus node pour le champ
  final FocusNode? focusNode;

  const CustomInputText({
    Key? key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
    this.maxLines = 1,
    this.isPassword = false,
    this.readOnly = false,
    this.labelText,
    this.isRequired = false,
    this.initialValue,
    this.centerText = false,
    this.textInputAction,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      textAlign: centerText ? TextAlign.center : TextAlign.start,
      style: GoogleFonts.sourceSans3(
        fontSize: 16.sp,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        labelText: labelText,
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
        prefixIcon:
            prefixIcon != null
                ? Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 8.w),
                  child: Icon(prefixIcon, color: Colors.black),
                )
                : null,
        suffixIcon:
            suffixIcon != null
                ? GestureDetector(
                  onTap: onSuffixIconTap,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.w, left: 8.w),
                    child: Icon(suffixIcon, color: Colors.black),
                  ),
                )
                : null,
      ),
      obscureText: isPassword,
      readOnly: readOnly,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      validator: validator ?? (isRequired ? _requiredValidator : null),
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
    );
  }

  /// Validateur par défaut pour les champs obligatoires
  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est obligatoire';
    }
    return null;
  }
}

/// Fabrique pour créer différents types de CustomInputText
class CustomInputTextFactory {
  /// Crée un champ de texte standard
  static CustomInputText createTextInput({
    TextEditingController? controller,
    String? hintText,
    String? labelText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    VoidCallback? onSuffixIconTap,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    FormFieldValidator<String>? validator,
    bool isRequired = false,
    String? initialValue,
    bool readOnly = false,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
    TextInputType? keyboardType,
  }) {
    return CustomInputText(
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      onSuffixIconTap: onSuffixIconTap,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator,
      isRequired: isRequired,
      initialValue: initialValue,
      readOnly: readOnly,
      textInputAction: textInputAction,
      focusNode: focusNode,
      keyboardType: keyboardType,
    );
  }

  static Widget createTextNumberInput({
    TextEditingController? controller,
    String? hintText,
    String? labelText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    VoidCallback? onSuffixIconTap,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    FormFieldValidator<String>? validator,
    bool isRequired = false,
    String? initialValue,
    bool readOnly = false,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
    TextInputType? keyboardType,
  }) {
    return IOSKeyboardAction(
      focusNode: focusNode ?? FocusNode(),
      backgroundColor: Colors.white,
      textColor: Colors.black,
      focusActionType: FocusActionType.done,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: CustomInputText(
        controller: controller,
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        onSuffixIconTap: onSuffixIconTap,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        validator: validator,
        isRequired: isRequired,
        initialValue: initialValue,
        readOnly: readOnly,
        textInputAction: textInputAction,
        focusNode: focusNode,
        keyboardType: keyboardType ?? TextInputType.number,
      ),
    );
  }

  static CustomInputText createTextAreaInput({
    TextEditingController? controller,
    String? hintText,
    String? labelText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    VoidCallback? onSuffixIconTap,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    FormFieldValidator<String>? validator,
    bool isRequired = false,
    String? initialValue,
    bool readOnly = false,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
  }) {
    return CustomInputText(
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      onSuffixIconTap: onSuffixIconTap,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator,
      isRequired: isRequired,
      initialValue: initialValue,
      readOnly: readOnly,
      textInputAction: textInputAction,
      focusNode: focusNode,
      maxLines: 4,
    );
  }

  /// Crée un champ pour les mots de passe
  static CustomInputText createPasswordInput({
    TextEditingController? controller,
    String? hintText,
    String? labelText,
    IconData prefixIcon = Icons.key_outlined,
    bool showPassword = false,
    VoidCallback? onTogglePasswordVisibility,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    FormFieldValidator<String>? validator,
    bool isRequired = true,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
  }) {
    return CustomInputText(
      controller: controller,
      hintText: hintText ?? 'Mot de passe',
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon:
          showPassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
      onSuffixIconTap: onTogglePasswordVisibility,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      isPassword: !showPassword,
      keyboardType: TextInputType.visiblePassword,
      validator: validator,
      isRequired: isRequired,
      textInputAction: textInputAction,
      focusNode: focusNode,
    );
  }

  /// Crée un champ pour les emails
  static CustomInputText createEmailInput({
    TextEditingController? controller,
    String? hintText,
    String? labelText,
    IconData prefixIcon = Icons.email_outlined,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    FormFieldValidator<String>? validator,
    bool isRequired = true,
    String? initialValue,
    bool readOnly = false,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
  }) {
    return CustomInputText(
      controller: controller,
      hintText: hintText ?? 'Email',
      labelText: labelText,
      prefixIcon: prefixIcon,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      keyboardType: TextInputType.emailAddress,
      validator: validator ?? _emailValidator,
      isRequired: isRequired,
      initialValue: initialValue,
      readOnly: readOnly,
      textInputAction: textInputAction,
      focusNode: focusNode,
    );
  }

  /// Crée un champ pour les numéros de téléphone
  static CustomInputText createPhoneInput({
    TextEditingController? controller,
    String? hintText,
    String? labelText,
    IconData prefixIcon = Icons.phone_outlined,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    FormFieldValidator<String>? validator,
    bool isRequired = true,
    String? initialValue,
    bool readOnly = false,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
  }) {
    return CustomInputText(
      controller: controller,
      hintText: hintText ?? 'Téléphone',
      labelText: labelText,
      prefixIcon: prefixIcon,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: validator ?? _phoneValidator,
      isRequired: isRequired,
      initialValue: initialValue,
      readOnly: readOnly,
      textInputAction: textInputAction,
      focusNode: focusNode,
    );
  }

  /// Crée un champ pour la recherche
  static CustomInputText createSearchInput({
    TextEditingController? controller,
    String? hintText,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    VoidCallback? onClear,
    bool isRequired = false,
    FocusNode? focusNode,
  }) {
    return CustomInputText(
      controller: controller,
      hintText: hintText ?? 'Rechercher...',
      prefixIcon: Icons.search,
      suffixIcon: Icons.close,
      onSuffixIconTap: onClear,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      isRequired: isRequired,
      textInputAction: TextInputAction.search,
      focusNode: focusNode,
    );
  }

  /// Validateur pour les emails
  static String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre adresse email';
    }

    // Expression régulière simple pour vérifier le format de l'email
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Veuillez entrer une adresse email valide';
    }

    return null;
  }

  /// Validateur pour les numéros de téléphone
  static String? _phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre numéro de téléphone';
    }

    // Vérifier que le numéro a au moins 8 chiffres
    if (value.length < 8) {
      return 'Le numéro de téléphone doit avoir au moins 8 chiffres';
    }

    return null;
  }
}
