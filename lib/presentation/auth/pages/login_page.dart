import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/presentation/agent/pages/home_agent_page.dart';
import 'package:maelys_imo/presentation/tenant/pages/home_tenant_page.dart';
import 'package:maelys_imo/shared/widgets/index.dart';

import '../../tenant/pages/dashboard_tenant_page.dart';
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
    return FormWithHeaderLayout(
      headerTitle: 'Connexion',
      content: _buildLoginForm(),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bienvenue',
          style:
              TextStyle(
                fontSize: 24.r,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
        ),
        CustomSpacer(space: .5),
        Text(
          'Entrez vos informations de connexion',
          style:
              TextStyle(
                fontSize: 14.r,
                color: Colors.grey[700],
              ).sourceSansProRegular,
        ),
        CustomSpacer(space: 2),

        _buildInputField(
          label: 'Identifiant',
          controller: _usernameController,
          hintText: 'Identifiant de connexion',
        ),
        CustomSpacer(),
        _buildPasswordField(),
        CustomSpacer(space: .5),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // Navigate to forgot password page
              context.pushNamed(ForgetPasswordPage.routeName);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Mot de passe oublié',
              style:
                  TextStyle(
                    fontSize: 14.r,
                    color: Colors.blueGrey[700],
                  ).sourceSansProRegular,
            ),
          ),
        ),
        Spacer(), // Push login button to bottom
        _buildLoginButton(),
        SpacerPlatform(),
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

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mot de passe',
          style:
              TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ).sourceSansProSemiBold,
        ),
        SizedBox(height: 8.h),
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
        if (_usernameController.text.trim().toLowerCase() == 'agent') {
          context.goNamed(HomeAgentPage.routeName);
        } else {
          // context.goNamed(HomeAgentPage.routeName);
          context.goNamed(DashboardTenantPage.routeName);
        }
      },
      buttonVariant: ButtonVariant.primary,
    );
  }
}
