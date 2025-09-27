import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/domain/requests/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/core/manager/state/reset-password/reset_password_bloc.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:pinput/pinput.dart';
import 'package:toastification/toastification.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/toast/notification_toast.dart';
import 'login_page.dart';

class ResetPasswordPage extends StatefulWidget {
  static const routeName = 'resetPassword';
  static const routePath = '/reset-password';

  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _pinController = TextEditingController();

  final TextEditingController _codeIdController = TextEditingController();

  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    _extractDeepLinkParams();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _extractDeepLinkParams();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _extractDeepLinkParams() {
    // Extraire les paramètres du deeplink depuis GoRouter
    try {
      final state = GoRouterState.of(context);
      var codeId = state.uri.queryParameters['code_id'];
      if ((codeId ?? "").isNotEmpty) {
        setState(() {
          _codeIdController.text = codeId!;
        });
      }
      // Log pour debug
    } catch (e) {
      // En cas d'erreur, utiliser des valeurs par défaut pour les tests
      print('Erreur lors de l\'extraction des paramètres: $e');
    }
  }

  String? _validatePassword(String password) {
    if (password.trim().length < 4) {
      return 'Le mot de passe doit contenir au moins 8 caractères';
    }

    // if (!password.contains(RegExp(r'[A-Z]'))) {
    //   return 'Le mot de passe doit contenir au moins une lettre majuscule';
    // }

    // // if (!password.contains(RegExp(r'[a-z]'))) {
    // //   return 'Le mot de passe doit contenir au moins une lettre minuscule';
    // // }
    // //
    // // if (!password.contains(RegExp(r'[0-9]'))) {
    // //   return 'Le mot de passe doit contenir au moins un chiffre';
    // // }
    //
    // if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    //   return 'Le mot de passe doit contenir au moins un caractère spécial';
    // }

    return null; // Password is valid
  }

  Widget _buildRequirementItem(String requirement) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, size: 16.r, color: Colors.grey[600]),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              requirement,
              style:
                  TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ).sourceSansProRegular,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormWithHeaderLayout(
      headerTitle: 'Réinitialiser le mot de passe',
      content: _buildResetForm(),
    );
  }

  Widget _buildResetForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nouveau mot de passe',
          style:
              TextStyle(
                fontSize: 24.r,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
        ),
        SizedBox(height: 8.r),
        Text(
          'Veuillez saisir votre nouveau mot de passe',
          style:
              TextStyle(
                fontSize: 14.r,
                color: Colors.grey[700],
              ).sourceSansProRegular,
        ),
        SizedBox(height: 32.r),
        _buildInputIdField(),
        CustomSpacer(),
        _buildPinInput(),
        CustomSpacer(),
        _buildNewPasswordField(),
        // SizedBox(height: 16.r),
        // _buildPasswordRequirements(),
        CustomSpacer(),
        _buildConfirmPasswordField(),
        Spacer(),
        _buildResetButton(),
        SizedBox(height: 24.r),
      ],
    );
  }

  Widget _buildInputIdField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Identifiant",
          style:
              TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
        ),
        SizedBox(height: 8.h),
        CustomInputTextFactory.createTextInput(
          controller: _codeIdController,
          hintText: 'Entrez votre identifiant de connexion',
          readOnly: true,
        ),
      ],
    );
  }

  Widget _buildNewPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nouveau mot de passe',
          style:
              TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
        ),
        SizedBox(height: 8.h),
        CustomInputTextFactory.createPasswordInput(
          controller: _passwordController,
          hintText: 'Saisissez votre nouveau mot de passe',
          showPassword: showPassword,
          onTogglePasswordVisibility: () {
            setState(() {
              showPassword = !showPassword;
            });
          },
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirmer le mot de passe',
          style:
              TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
        ),
        SizedBox(height: 8.h),
        CustomInputTextFactory.createPasswordInput(
          controller: _confirmPasswordController,
          hintText: 'Confirmez votre nouveau mot de passe',
          showPassword: showPassword,
          onTogglePasswordVisibility: () {
            setState(() {
              showPassword = !showPassword;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPinInput() {
    final defaultPinTheme = PinTheme(
      width: 60.w,
      height: 60.w,
      textStyle:
          TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ).sourceSansProBold,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.primary),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: Colors.red),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Saisissez le code de validation',
          style:
              TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
        ),
        CustomSpacer(),
        Pinput(
          controller: _pinController,
          length: 6,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          errorPinTheme: errorPinTheme,
          obscureText: false,
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          pinputAutovalidateMode: PinputAutovalidateMode.disabled,
        ),
      ],
    );
  }

  Widget _buildResetButton() {
    return BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
      listenWhen:
          (previous, current) =>
              current.passwordReset != null || current.failure != null,
      listener: (context, state) {
        if (state.passwordReset == true) {
          // Rediriger vers la page de connexion après succès
          showToast(
            msg: 'Mot de passe réinitialisé avec succès !',
            type: ToastificationType.success,
          );
          context.goNamed(LoginPage.routeName);
        } else if (state.failure != null) {
          // Afficher l'erreur si la réinitialisation a échoué
          showToast(
            msg: state.failure!.message,
            type: ToastificationType.error,
          );
        }
      },
      buildWhen:
          (previous, current) =>
              current.passwordReset != null ||
              current.isLoading != previous.isLoading ||
              current.failure != previous.failure,
      builder: (context, state) {
        return CustomButton(
          text: 'Réinitialiser le mot de passe',
          isLoading: state.isLoading,
          showArrow: true,
          onPressed: () {
            if (_passwordController.text.isEmpty) {
              showToast(msg: 'Veuillez saisir votre nouveau mot de passe');
              return;
            }

            if (_confirmPasswordController.text.isEmpty) {
              showToast(msg: 'Veuillez confirmer votre mot de passe');
              return;
            }
            if (_pinController.text.isEmpty) {
              showToast(msg: 'Veuillez saisir le code de confirmation');
              return;
            }

            if (_passwordController.text != _confirmPasswordController.text) {
              showToast(msg: 'Les mots de passe ne correspondent pas');
              return;
            }

            // Validation avancée du mot de passe
            final passwordValidation = _validatePassword(
              _passwordController.text,
            );
            if (passwordValidation != null) {
              showToast(msg: passwordValidation);
              return;
            }

            // Déclencher l'événement de réinitialisation avec token
            context.read<ResetPasswordBloc>().add(
              ResetPasswordWithTokenEvent(
                dto: ResetPasswordRequest(
                  codeId: _codeIdController.text,
                  password: _passwordController.text,
                  otp: _pinController.text,
                ),
              ),
            );
          },
          buttonVariant: ButtonVariant.primary,
          textStyle:
              TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ).sourceSansProBold,
        );
      },
    );
  }

  Widget _buildPasswordRequirements() {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exigences du mot de passe :',
            style:
                TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ).sourceSansProSemiBold,
          ),
          SizedBox(height: 8.h),
          _buildRequirementItem('Au moins 8 caractères'),
          _buildRequirementItem('Au moins une lettre majuscule (A-Z)'),
          _buildRequirementItem('Au moins une lettre minuscule (a-z)'),
          _buildRequirementItem('Au moins un chiffre (0-9)'),
          _buildRequirementItem('Au moins un caractère spécial (!@#\$%^&*...)'),
        ],
      ),
    );
  }
}
