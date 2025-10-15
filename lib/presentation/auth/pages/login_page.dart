import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/domain/requests/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/core/manager/state/auth/auth_bloc.dart';
import 'package:maelys_imo/core/manager/state/tenant/tenant_bloc.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:toastification/toastification.dart';

import '../../../core/manager/state/dashboard/dashboard_bloc.dart';
import '../../../core/manager/state/payment/payment_bloc.dart';
import '../../../core/utils/toast/notification_toast.dart';
import '../../agent/pages/home_agent_page.dart';
import '../../tenant/pages/dashboard_tenant_page.dart';
import '../pages/forget_password_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = 'login';
  static const routePath = '/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController(
    text: kDebugMode ? "MA407898-AGT227811" : "",
  );
  final TextEditingController _passwordController = TextEditingController(
    text: "azertyui",
  );
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
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen:
          (previous, current) =>
              current.userModel != null &&
              current.isLoading == false &&
              current.failure == null,
      listener: (context, state) {
        if (state.userModel!.isCollectionAgent) {
          context.read<DashboardBloc>().add(FetchAgentDashboardEvent());
          context.goNamed(HomeAgentPage.routeName);
          return;
        }

        if (state.userModel!.isTenant) {
          context.read<DashboardBloc>().add(FetchTenantDashboardEvent());
          context.read<PaymentBloc>().add(
            FetchHistoryPaymentEvent(tenantId: state.userModel!.id!),
          );
          context.read<TenantBloc>().add(FetchPropertyInspectionsEvent());
          
          context.goNamed(DashboardTenantPage.routeName);
          return;
        }

        if (state.userModel!.isUnknownType) {
          showToast(
            msg: "Ce type de compte n'est pas pris en charge !",
            type: ToastificationType.warning,
          );
        }
      },
      builder: (context, state) {
        return CustomButton(
          text: 'Se connecter',
          isLoading: state.isLoading ?? false,
          isDisabled: state.isLoading ?? false,
          showArrow: true,
          onPressed: () {
            if (_usernameController.text.isEmpty) {
              showToast(msg: "Veuillez entrer un identifiant");
              return;
            }
            if (_passwordController.text.isEmpty) {
              showToast(msg: "Votre mot de passe est incorrect");
              return;
            }

            context.read<AuthBloc>().add(
              UserSignInEvent(
                dto: LoginRequest(
                  codeId: _usernameController.text,
                  password: _passwordController.text,
                ),
              ),
            );

            // if (_usernameController.text.trim().toLowerCase() == 'agent') {
            //   context.goNamed(HomeAgentPage.routeName);
            // } else {
            //   // context.goNamed(HomeAgentPage.routeName);
            //   context.goNamed(DashboardTenantPage.routeName);
            // }
          },
          buttonVariant: ButtonVariant.primary,
        );
      },
    );
  }
}
