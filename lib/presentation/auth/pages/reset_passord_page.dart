import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/domain/requests/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/core/manager/state/reset-password/reset_password_bloc.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:toastification/toastification.dart';

import '../../../core/utils/toast/notification_toast.dart';
import '../../../di_container.dart';
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
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool showPassword = false;
  
  // Paramètres du deeplink
  String? token;
  String? codeId;
  String? type;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  void _extractDeepLinkParams() {
    // Extraire les paramètres du deeplink depuis GoRouter
    try {
      final state = GoRouterState.of(context);
      token = state.uri.queryParameters['token'];
      codeId = state.uri.queryParameters['code_id'];
      type = state.uri.queryParameters['type'];
      
      // Log pour debug
      print('Reset Password Params from GoRouter:');
      print('- Token: $token');
      print('- CodeId: $codeId');
      print('- Type: $type');
      print('- Full URI: ${state.uri}');
      
      // Fallback vers des valeurs par défaut pour les tests si aucun paramètre n'est fourni
      if (token == null || codeId == null || type == null) {
        print('Aucun paramètre de deeplink trouvé, utilisation des valeurs de test');
        token = "sample_token";
        codeId = "sample_code_id"; 
        type = "tenant";
      }
    } catch (e) {
      // En cas d'erreur, utiliser des valeurs par défaut pour les tests
      print('Erreur lors de l\'extraction des paramètres: $e');
      token = "sample_token";
      codeId = "sample_code_id"; 
      type = "tenant";
    }
    
    // Log final pour debug
    print('Final Reset Password Params - Token: $token, CodeId: $codeId, Type: $type');
  }

  String? _validatePassword(String password) {
    if (password.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères';
    }
    
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Le mot de passe doit contenir au moins une lettre majuscule';
    }
    
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Le mot de passe doit contenir au moins une lettre minuscule';
    }
    
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Le mot de passe doit contenir au moins un chiffre';
    }
    
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Le mot de passe doit contenir au moins un caractère spécial';
    }
    
    return null; // Password is valid
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
            style: TextStyle(
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

  Widget _buildRequirementItem(String requirement) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16.r,
            color: Colors.grey[600],
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              requirement,
              style: TextStyle(
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
    return BlocProvider(
      create: (context) => getIt<ResetPasswordBloc>(),
      child: FormWithHeaderLayout(
        headerTitle: 'Réinitialiser le mot de passe',
        content: _buildResetForm(),
      ),
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

  Widget _buildResetButton() {
    return BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
      listenWhen: (previous, current) => 
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
      buildWhen: (previous, current) => 
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

            if (_passwordController.text != _confirmPasswordController.text) {
              showToast(msg: 'Les mots de passe ne correspondent pas');
              return;
            }

            // Validation avancée du mot de passe
            final passwordValidation = _validatePassword(_passwordController.text);
            if (passwordValidation != null) {
              showToast(msg: passwordValidation);
              return;
            }

            // Vérifier que les paramètres du deeplink sont disponibles
            if (token == null || codeId == null || type == null) {
              showToast(msg: 'Paramètres de réinitialisation manquants');
              return;
            }

            // Déclencher l'événement de réinitialisation avec token
            context.read<ResetPasswordBloc>().add(
              ResetPasswordWithTokenEvent(
                dto: ResetPasswordRequest(
                  token: token!,
                  codeId: codeId!,
                  type: type!,
                  password: _passwordController.text,
                  passwordConfirmation: _confirmPasswordController.text,
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
}
