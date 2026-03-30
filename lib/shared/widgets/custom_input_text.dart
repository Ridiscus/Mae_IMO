part of 'index.dart';

/// Un widget de champ de texte personnalisé qui respecte le design de maelys_imo
class CustomInputText extends StatefulWidget {
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

  /// Un widget personnalisé à afficher sur la droite du champ (prioritaire sur suffixIcon)
  final Widget? suffixWidget;

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

  /// Le texte d'erreur provenant de l'API
  final String? errorText;

  /// Le focus node pour le champ
  final FocusNode? focusNode;

  const CustomInputText({
    Key? key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixWidget,
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
    this.errorText,
  }) : super(key: key);

  @override
  State<CustomInputText> createState() => _CustomInputTextState();
}

class _CustomInputTextState extends State<CustomInputText> {
  String? _validationError;

  @override
  Widget build(BuildContext context) {
    final String? displayError = widget.errorText ?? _validationError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          focusNode: widget.focusNode,
          textAlign: widget.centerText ? TextAlign.center : TextAlign.start,
          style:
              const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ).sourceSansProSemiBold,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: widget.hintText,
            labelText: widget.labelText,
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
            // On cache le message d'erreur par défaut pour utiliser notre propre Row
            errorStyle: const TextStyle(height: 0, fontSize: 0),
            prefixIcon:
                widget.prefixIcon != null
                    ? Padding(
                      padding: EdgeInsets.only(left: 16.w, right: 8.w),
                      child: Icon(widget.prefixIcon, color: Colors.black),
                    )
                    : null,
            suffixIcon:
                widget.suffixWidget != null
                    ? Padding(
                      padding: EdgeInsets.only(right: 16.w, left: 8.w),
                      child: widget.suffixWidget,
                    )
                    : (widget.suffixIcon != null
                        ? GestureDetector(
                          onTap: widget.onSuffixIconTap,
                          child: Padding(
                            padding: EdgeInsets.only(right: 16.w, left: 8.w),
                            child: Icon(widget.suffixIcon, color: Colors.black),
                          ),
                        )
                        : null),
          ),
          obscureText: widget.isPassword,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          validator: (value) {
            final error = (widget.validator ??
                    (widget.isRequired ? _requiredValidator : null))
                ?.call(value);
            if (_validationError != error) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) setState(() => _validationError = error);
              });
            }
            return error != null
                ? ''
                : null; // On retourne une chaîne vide pour indiquer qu'il y a une erreur sans afficher le texte par défaut
          },
          inputFormatters: widget.inputFormatters,
          textInputAction: widget.textInputAction,
        ),
        if (displayError != null && displayError.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 6.h, left: 12.w),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red[700], size: 14.sp),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    displayError,
                    style:
                        TextStyle(
                          color: Colors.red[700],
                          fontSize: 12.sp,
                          height: 1.2,
                        ).sourceSansProRegular,
                  ),
                ),
              ],
            ),
          ),
      ],
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
    String? errorText,
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
      errorText: errorText,
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
    String? errorText,
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
        errorText: errorText,
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
    String? errorText,
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
      errorText: errorText,
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
    String? errorText,
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
      errorText: errorText,
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
    String? errorText,
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
      errorText: errorText,
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
    String? errorText,
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
      errorText: errorText,
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
