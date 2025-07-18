import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/shared/widgets/index.dart';

class ForgetPasswordPage extends StatefulWidget {
  static const routeName = 'forgetPassword';
  static const routePath = '/forget-password';

  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormWithHeaderLayout(
      headerTitle: 'Réinitialisation du mot de passe',
      content: _buildResetForm(),
    );
  }

  Widget _buildResetForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mot de passe oublié',
          style:
              TextStyle(
                fontSize: 24.r,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
        ),
        SizedBox(height: 8.r),
        Text(
          'Renseignez votre email pour la réinitialisation',
          style:
              TextStyle(
                fontSize: 14.r,
                color: Colors.grey[700],
              ).sourceSansProRegular,
        ),
        SizedBox(height: 32.r),
        _buildInputField(
          label: 'Adresse email',
          controller: _emailController,
          hintText: 'Entrez votre adresse email de connexion',
        ),
        Spacer(),
        _buildSendLinkButton(),
        SizedBox(height: 24.r),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ).sourceSansProSemiBold,
        ),
       SizedBox(height: 8.h),
        CustomInputTextFactory.createTextInput(
          controller: controller,
          hintText: hintText,
          validator: (value) {
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSendLinkButton() {
    return CustomButton(
      text: 'Envoyer le lien',
      showArrow: true,
      onPressed: () {
        // Handle password reset
      },
      buttonVariant: ButtonVariant.primary,
      textStyle:
          TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ).sourceSansProBold,
    );
  }
}
