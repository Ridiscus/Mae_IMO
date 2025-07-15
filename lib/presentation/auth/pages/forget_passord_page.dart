import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maelys_imo/core/extensions/text_style_ext.dart';
import 'package:maelys_imo/shared/widgets/custom_button.dart';

import '../../../shared/widgets/custom_input_text.dart';

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
    return Scaffold(
      body: Column(
        children: [_buildHeader(), Expanded(child: _buildResetForm())],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16.r,
        right: 16.r,
        bottom: 24.r,
      ),
      width: double.infinity,
      color: Color(0xFF0A2342),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.r),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.chevron_left, color: Colors.white, size: 30.r),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
          SizedBox(height: 16.r),
          Text(
            'Réinitialisation du mot\nde passe',
            style: TextStyle(
              fontSize: 28.r,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ).sourceSansProBold,
          ),
        ],
      ),
    );
  }

  Widget _buildResetForm() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      margin: EdgeInsets.only(top: 20.r),
      padding: EdgeInsets.all(24.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mot de passe oublié',
            style: TextStyle(
              fontSize: 24.r,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ).sourceSansProBold,
          ),
          SizedBox(height: 8.r),
          Text(
            'Renseignez votre email pour la réinitialisation',
            style: TextStyle(
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
      ),
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
          style: TextStyle(
            fontSize: 16.r,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ).sourceSansProSemiBold,
        ),
        SizedBox(height: 8.r),
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
      textStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ).sourceSansProBold,
    );
  }
}
