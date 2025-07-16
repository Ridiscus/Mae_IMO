import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import '../pages/forget_passord_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = 'login';
  static const routePath = '/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildLoginForm(),
          ),
        ],
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
            icon: Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: 30.r,
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
          SizedBox(height: 16.r),
          Text(
            'Connexion',
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

  Widget _buildLoginForm() {
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
            'Bienvenue',
            style: TextStyle(
              fontSize: 24.r,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ).sourceSansProBold,
          ),
          SizedBox(height: 8.r),
          Text(
            'Entrez vos informations de connexion',
            style: TextStyle(
              fontSize: 14.r,
              color: Colors.grey[700],
            ).sourceSansProRegular,
          ),
          SizedBox(height: 32.r),
          _buildInputField(
            label: 'Identifiant',
            controller: _usernameController,
            hintText: 'Identifiant de connexion',
          ),
          SizedBox(height: 24.r),
          _buildPasswordField(),
          SizedBox(height: 8.r),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Navigate to forgot password page
                context.goNamed(ForgetPasswordPage.routeName);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Mot de passe oublié',
                style: TextStyle(
                  fontSize: 14.r,
                  color: Colors.blueGrey[700],
                ).sourceSansProRegular,
              ),
            ),
          ),
          Spacer(),
          _buildLoginButton(),
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

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mot de passe',
          style: TextStyle(
            fontSize: 16.r,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ).sourceSansProSemiBold,
        ),
        SizedBox(height: 8.r),
        CustomInputTextFactory.createPasswordInput(
          controller: _passwordController,
          hintText: 'Mot de passe de connexion',
          onTogglePasswordVisibility: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          showPassword: _obscureText,
          validator: (value) {
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return CustomButton(
      text: 'Se connecter',
      showArrow: true,
      onPressed: () {
        // Handle login
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
